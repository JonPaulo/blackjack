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

  Player player = Player();
  Player dealer = Player();

  Widget playerHand;
  Widget dealerHand;

  Random random = Random();

  String gameText = "";

  @override
  void initState() {
    super.initState();
    createCards(deck);
    calculateInitialCards();
    dealerHand = currentHand(dealer.playerCards, hidden: true);
    playerHand = currentHand(player.playerCards);
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
          dealerHand,
          playerHand,
          Text(playerTotal, style: TextStyle(color: Colors.white)),
          actionButtons(),
        ],
      ),
    );
  }

  String get playerTotal {
    return player.handValue > 21
        ? "Total: ${player.handValue} BUST"
        : "Total: ${player.handValue}";
  }

  void resetDeck() {
    print("Cards left: ${deck.length}");
    deck.clear();
    createCards(deck);
    dealer.resetPlayer();
    player.resetPlayer();
    calculateInitialCards();
    gameText = '';
    dealerHand = currentHand(dealer.playerCards, hidden: true);
    playerHand = currentHand(player.playerCards);
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
    addCardsToHand(player);
    addCardsToHand(dealer);
  }

  Widget currentHand(List<CardModel> playerCards, {bool hidden = false}) {
    if (hidden == true) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PlayingCard(cardModel: playerCards[0], hidden: true),
          for (var i = 1; i < playerCards.length; i++)
            PlayingCard(cardModel: playerCards[i])
        ],
      );
    }
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
    playerHand = currentHand(player.playerCards);
    player.cardsNeeded = 0;
  }

  Widget actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RaisedButton(
          child: Text("Hit"),
          onPressed: () {
            player.cardsNeeded += 1;
            addCardsToHand(player);
            setState(() {});
          },
          elevation: 5,
        ),
        RaisedButton(
          child: Text("Stand"),
          onPressed: () => calculateWinner(player, dealer),
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

  void calculateWinner(Player player, Player dealer) {
    while (dealer.handValue < 17) {
      dealer.cardsNeeded += 1;
      addCardsToHand(dealer);
    }
    playerHand = currentHand(player.playerCards);
    dealerHand = currentHand(dealer.playerCards);

    print("The dealer's hand: ${dealer.handValue}");
    print("Your hand: ${player.handValue}");

    if (player.hasBusted) {
      gameText = "The dealer wins";
    } else if (!player.hasBusted && dealer.hasBusted) {
      gameText = "The dealer has busted. You win!";
    } else if (dealer.handValue > player.handValue) {
      gameText = "The dealer wins";
    } else if (player.handValue > dealer.handValue) {
      gameText = "You win!";
    } else {
      gameText = "It's a tie!";
    }
    setState(() {});
  }
}
