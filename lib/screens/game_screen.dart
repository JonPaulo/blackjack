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
    for (var i = 0; i < player.playerCardCount; i++) {
      int cardLocation = random.nextInt(deck.length);
      CardModel card = deck[cardLocation];
      player.playerCards.add(card);
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
    if (player1.handValue > player2.handValue) {
      gameText = "Player 1 wins!";
    } else if (player2.handValue > player1.handValue) {
      gameText = "Player 2 wins!";
    } else {
      gameText = "It's a tie!";
    }
    setState(() {});
  }
}
