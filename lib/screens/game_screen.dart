import 'dart:math';

import 'package:flutter/material.dart';
import 'package:blackjack/models/player.dart';
import 'package:blackjack/models/playing_card.dart';
import 'package:blackjack/widgets/current_hand.dart';

import 'package:flip_card/flip_card.dart';

class GameScreen extends StatefulWidget {
  static final routeName = '/';

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  List<CardModel> deck = [];

  Player player = Player();
  Player dealer = Player();

  CurrentHand playerHand;
  CurrentHand dealerHand;

  Random random = Random();

  String gameText = "";
  Widget playerActions;

  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  @override
  void initState() {
    super.initState();
    createDeck(deck);
    dealInitialHand();
    playerActions = actionButtons(roundEnd: false);
  }

  @override
  Widget build(BuildContext context) {
    dealerHand = CurrentHand(cards: dealer.playerCards, hidden: true);
    playerHand = CurrentHand(cards: player.playerCards);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.green[600],
        // appBar: AppBar(
        //   backgroundColor: Colors.green[900],
        //   title: Text('Blackjack', style: TextStyle(color: Colors.white)),
        // ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  'BLACKJACK',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 3.0,
                        ),
                      ]),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Text(
                    gameText,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            dealerHand,
            playerHand,
            Text(playerTotal,
                style: TextStyle(color: Colors.white, fontSize: 20)),
            playerActions,
          ],
        ),
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
    if (deck.length < 26) {
      deck.clear();
      createDeck(deck);
    }
    playerActions = actionButtons(roundEnd: false);
    dealer.resetPlayer();
    player.resetPlayer();
    dealInitialHand();
    gameText = '';
    dealerHand = CurrentHand(cards: dealer.playerCards, hidden: true);
    playerHand = CurrentHand(cards: player.playerCards);
    cardKey.currentState.controller.reset();

    determineBlackjack();
    setState(() {});
  }

  void createDeck(List deck) {
    CardSuit.values.forEach((suit) {
      CardNumber.values.forEach((number) {
        deck.add(CardModel(cardNumber: number, cardSuit: suit));
      });
    });
  }

  void dealInitialHand() {
    addCardsToHand(player);
    addCardsToHand(dealer);
    determineBlackjack();
  }

  void addCardsToHand(Player player) {
    for (var i = 0; i < player.cardsNeeded; i++) {
      // if (player.cardCount < 5) {
      int cardLocation = random.nextInt(deck.length);
      CardModel card = deck[cardLocation];
      player.playerCards.add(card);
      deck.removeAt(cardLocation);
      // }
    }
    playerHand = CurrentHand(cards: player.playerCards);
    player.cardsNeeded = 0;
    if (player.hasBusted) {
      playerActions = actionButtons(roundEnd: true);
      setState(() {});
    }
  }

  Widget actionButtons({bool roundEnd}) {
    if (!roundEnd) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RaisedButton(
            shape: Border.all(width: 0.5),
            child: Text("Hit", style: TextStyle(color: Colors.white)),
            onPressed: () {
              player.cardsNeeded += 1;
              addCardsToHand(player);
              setState(() {});
            },
            elevation: 5,
            color: Colors.blue[800],
          ),
          RaisedButton(
            shape: Border.all(width: 0.5),
            child: Text("Stand"),
            onPressed: () => calculateWinner(player, dealer, blackjack: 0),
            elevation: 5,
            color: Colors.white,
          ),
          RaisedButton(
            shape: Border.all(width: 0.5),
            child: Text(
              "Reset Deck",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: resetDeck,
            elevation: 5,
            color: Colors.red,
          ),
        ],
      );
    } else {
      return RaisedButton(
        shape: Border.all(width: 0.5),
        child: Text(
          "New Game",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: resetDeck,
        elevation: 5,
        color: Colors.red,
      );
    }
  }

  void determineBlackjack() {
    if (player.handValue == 21 && dealer.handValue == 21) {
      calculateWinner(player, dealer, blackjack: 3);
    } else if (player.handValue == 21) {
      calculateWinner(player, dealer, blackjack: 1);
    } else if (dealer.handValue == 21) {
      calculateWinner(player, dealer, blackjack: 2);
    }
  }

  void calculateWinner(Player player, Player dealer, {int blackjack}) {
    while (dealer.handValue < 17 && blackjack < 1) {
      dealer.cardsNeeded += 1;
      addCardsToHand(dealer);
    }
    playerHand = CurrentHand(cards: player.playerCards);
    cardKey.currentState.controller.forward();

    playerActions = actionButtons(roundEnd: true);

    print("The dealer's hand: ${dealer.handValue}");
    print("Your hand: ${player.handValue}");

    if (player.hasBusted) {
      gameText = "The dealer wins.\n\nDealer's Total: ${dealer.handValue}";
    } else if (!player.hasBusted && dealer.hasBusted) {
      gameText =
          "The dealer busted. You win!\n\nDealer's Total: ${dealer.handValue}";
    } else if (dealer.handValue > player.handValue) {
      gameText = "The dealer wins\n\nDealer's Total: ${dealer.handValue}";
    } else if (player.handValue > dealer.handValue) {
      gameText = "You win!\n\nDealer's Total: ${dealer.handValue}";
    } else {
      gameText = "It's a tie!\n\nDealer's Total: ${dealer.handValue}";
    }

    switch (blackjack) {
      case 1:
        gameText = "BLACKJACK. YOU WIN";
        break;
      case 2:
        gameText = "DEALER HAS BLACKJACK. YOU LOSE";
        break;
      case 3:
        gameText = "PUSH";
        break;
      default:
        break;
    }
    setState(() {});
  }
}

class ActionButton extends StatelessWidget {
  final text;
  final textColor;
  final Function onPressed;
  final buttonColor;

  ActionButton({this.text, this.textColor, this.onPressed, this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: Border.all(width: 0.5),
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      onPressed: onPressed,
      elevation: 5,
      color: buttonColor,
    );
  }
}
