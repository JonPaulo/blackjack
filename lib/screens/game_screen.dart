import 'package:blackjack/widgets/card_visual.dart';
import 'package:flutter/material.dart';
import 'package:blackjack/models/playing_card.dart';

import 'dart:math';

import 'package:blackjack/models/player.dart';

class GameScreen extends StatefulWidget {
  static final routeName = '/';

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<CardModel> deck = [];

  Player player1 = Player();
  Player player2 = Player();

  Random random = Random();

  String gameText = "";

  @override
  void initState() {
    super.initState();
    createCards(deck);
    calculateInitialCards();
  }

  @override
  Widget build(BuildContext context) {
    print("player 1: ${player1.playerCards.length}");
    print("player 2: ${player2.playerCards.length}");
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
          playerHand(player1.playerCards),
          playerHand(player2.playerCards),
          actionButtons(),
        ],
      ),
    );
  }

  void resetDeck() {
    print("Cards left: ${deck.length}");
    deck.clear();
    createCards(deck);
    player1.resetPlayer();
    player2.resetPlayer();
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

  void calculateInitialCards() {
    addCardsToHand(player1);
    addCardsToHand(player2);
  }

  Widget playerHand(List<CardModel> playerCards) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var card in playerCards) PlayingCard(cardModel: card),
      ],
    );
  }

  void addCardsToHand(Player player) {
    for (var i = 0; i < player.cardsNeeded; i++) {
      int cardLocation = random.nextInt(deck.length);
      CardModel card = deck[cardLocation];
      player.playerCards.add(card);
      deck.removeAt(cardLocation);
    }
    player.cardsNeeded = 0;
  }

  Widget actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RaisedButton(
          child: Text("Hit"),
          onPressed: () {
            player2.cardsNeeded += 1;
            addCardsToHand(player2);
            setState(() {});
          },
          elevation: 5,
        ),
        RaisedButton(
          child: Text("Stand"),
          onPressed: () => calculateWinner(player1, player2),
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

  void calculateWinner(Player player1, Player player2) {
    print("Player 1's hand: ${player1.handValue}");
    print("Player 2's hand: ${player2.handValue}");

    if (player2.handValue > 21) {
      gameText = "The dealer wins";
    } else if (player1.handValue > player2.handValue) {
      gameText = "The dealer wins";
    } else if (player2.handValue > player1.handValue) {
      gameText = "You win!";
    } else {
      gameText = "It's a tie!";
    }
    setState(() {});
  }
}
