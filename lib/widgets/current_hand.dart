import 'package:flutter/material.dart';
import 'package:blackjack/models/playing_card.dart';
import 'package:blackjack/widgets/card_visual.dart';

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
