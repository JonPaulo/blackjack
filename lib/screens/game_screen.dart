import 'package:blackjack/widgets/card_visual.dart';
import 'package:flutter/material.dart';
import 'package:blackjack/models/playing_card.dart';

import 'dart:math';

class GameScreen extends StatefulWidget {
  static final routeName = '/';

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<CardModel> deck = [];

  int playerCardCount = 2;

  int player1Hand = 0;
  int player2Hand = 0;

  CardModel cardModel1;
  CardModel cardModel2;
  CardModel cardModel3;
  CardModel cardModel4;
  List<CardModel> playerCards = [];

  String gameText = "";

  var random = Random();

  @override
  void initState() {
    super.initState();
    createCards(deck);
    calculateInitialCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[600],
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: Text('Blackjack', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            gameText,
            style: TextStyle(color: Colors.white),
          ),
          playerHand(cardModel1, cardModel2),
          playerHand(cardModel3, cardModel4),
          actionButtons(),
        ],
      ),
    );
  }

  void resetDeck() {
    print("Cards left: ${deck.length}");
    deck.clear();
    createCards(deck);
    cardModel1 = null;
    cardModel2 = null;
    cardModel3 = null;
    cardModel4 = null;
    player1Hand = 0;
    player2Hand = 0;
    calculateInitialCards();
    gameText = '';
    setState(() {});
  }

  void createCards(List deck) {
    CardSuit.values.forEach((suit) {
      CardNumber.values.forEach((number) {
        deck.add(CardModel(cardNumber: number, cardSuit: suit));
      });
    });
  }

  Widget renderCards(List deck) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[for (var card in deck) PlayingCard(cardModel: card)],
      ),
    );
  }

  void calculateInitialCards() async {
    int card1Location = random.nextInt(deck.length);
    cardModel1 = deck[card1Location];
    deck.removeAt(card1Location);

    int card2Location = random.nextInt(deck.length);
    cardModel2 = deck[card2Location];
    deck.removeAt(card2Location);

    player1Hand += cardModel1.cardValue;
    player1Hand += cardModel2.cardValue;
    print("Player 1's hand: $player1Hand");

    int card3Location = random.nextInt(deck.length);
    cardModel3 = deck[card3Location];
    deck.removeAt(card3Location);

    int card4Location = random.nextInt(deck.length);
    cardModel4 = deck[card4Location];
    deck.removeAt(card4Location);

    player2Hand += cardModel3.cardValue;
    player2Hand += cardModel4.cardValue;
    print("Player 2's hand: $player2Hand");
  }

  Widget playerHand(CardModel cardModel1, CardModel cardModel2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PlayingCard(cardModel: cardModel1),
        PlayingCard(cardModel: cardModel2)
      ],
    );
  }

  Widget extraCards() {
    for (var i = 0; i < playerCardCount; i++) {
      int cardLocation = random.nextInt(deck.length);
      playerCards.add(deck[cardLocation]);
      deck.removeAt(cardLocation);
    }
  }

  Widget actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RaisedButton(
          child: Text("Hit"),
          onPressed: () {
            setState(() {});
          },
          elevation: 5,
        ),
        RaisedButton(
          child: Text("Stand"),
          onPressed: calculateWinner,
          elevation: 5,
        ),
        RaisedButton(
          child: Text("Reset Deck"),
          onPressed: resetDeck,
          elevation: 5,
        ),
      ],
    );
  }

  void calculateWinner() {
    print("Player 1's hand: $player1Hand");
    print("Player 2's hand: $player2Hand");
    if (player1Hand > player2Hand) {
      gameText = "Player 1 wins!";
    } else if (player2Hand > player1Hand) {
      gameText = "Player 2 wins!";
    } else {
      gameText = "It's a tie!";
    }
    setState(() {});
  }
}
