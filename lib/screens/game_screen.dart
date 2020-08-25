import 'package:blackjack/widgets/card_visual.dart';
import 'package:flutter/material.dart';
import 'package:blackjack/models/playing_card.dart';

import 'dart:math';

import 'package:blackjack/models/player.dart';

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

  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  void initState() {
    super.initState();
    createDeck(deck);
    calculateInitialCards();
  }

  @override
  Widget build(BuildContext context) {
    dealerHand = CurrentHand(cards: dealer.playerCards, hidden: true);
    playerHand = CurrentHand(cards: player.playerCards);
    return Scaffold(
      backgroundColor: Colors.green[600],
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: Text('Blackjack', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            child: Text(
              gameText,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
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
    if (deck.length < 26) {
      deck.clear();
      createDeck(deck);
    }
    dealer.resetPlayer();
    player.resetPlayer();
    calculateInitialCards();
    gameText = '';
    dealerHand = CurrentHand(cards: dealer.playerCards, hidden: true);
    playerHand = CurrentHand(cards: player.playerCards);
    cardKey.currentState.controller.reset();
    setState(() {});
  }

  void createDeck(List deck) {
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

  // Widget CurrentHand(List<CardModel> playerCards,
  //     {bool hidden = false, Key key}) {
  //   if (hidden == true) {
  //     return Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         PlayingCard(cardModel: playerCards[0], hidden: true),
  //         for (var i = 1; i < playerCards.length; i++)
  //           PlayingCard(cardModel: playerCards[i])
  //       ],
  //     );
  //   }
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       for (var card in playerCards) PlayingCard(cardModel: card),
  //     ],
  //   );
  // }

  void addCardsToHand(Player player) {
    for (var i = 0; i < player.cardsNeeded; i++) {
      if (player.cardCount < 5) {
        int cardLocation = random.nextInt(deck.length);
        CardModel card = deck[cardLocation];
        player.playerCards.add(card);
        deck.removeAt(cardLocation);
      }
    }
    playerHand = CurrentHand(cards: player.playerCards);
    player.cardsNeeded = 0;
  }

  Widget actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RaisedButton(
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
          child: Text("Stand"),
          onPressed: () => calculateWinner(player, dealer),
          elevation: 5,
          color: Colors.white,
        ),
        RaisedButton(
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
  }

  void calculateWinner(Player player, Player dealer) {
    while (dealer.handValue < 17) {
      dealer.cardsNeeded += 1;
      addCardsToHand(dealer);
    }
    playerHand = CurrentHand(cards: player.playerCards);
    cardKey.currentState.controller.forward();
    // dealerHand = currentHand(dealer.playerCards);

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
    setState(() {});
  }
}

class CurrentHand extends StatefulWidget {
  final List<CardModel> cards;
  final bool hidden;

  CurrentHand({this.cards, this.hidden});

  @override
  _CurrentHandState createState() => _CurrentHandState();
}

class _CurrentHandState extends State<CurrentHand> {
  List cardList = [];

  @override
  Widget build(BuildContext context) {
    List<PlayingCard> cardList = [
      PlayingCard(cardModel: widget.cards[0], hidden: true),
      for (var i = 1; i < widget.cards.length; i++)
        PlayingCard(cardModel: widget.cards[i])
    ];
    if (widget.hidden == true) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: cardList,
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (var card in widget.cards) PlayingCard(cardModel: card),
      ],
    );
  }

  add(PlayingCard card) {
    cardList.add(card);
  }
}
