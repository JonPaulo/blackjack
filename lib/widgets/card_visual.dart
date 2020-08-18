import 'package:flutter/material.dart';
import 'package:blackjack/models/playing_card.dart';
import 'package:flutter_icons/flutter_icons.dart';

class PlayingCard extends StatelessWidget {
  final CardModel cardModel;

  final bool hidden;

  PlayingCard({this.cardModel, this.hidden = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          color: Colors.white,
          boxShadow: [BoxShadow(offset: Offset(2, 2), blurRadius: 3)]),
      height: 80,
      width: 50,
      child: hidden ? sideDown() : sideUp(),
    );
  }

  Widget sideUp() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_cardNumber(), style: TextStyle(color: _cardColor, fontSize: 16)),
        Icon(_cardSuit(), color: _cardColor),
      ],
    );
  }

  Widget sideDown() {
    return Container(
        child: Center(
          child: Text(
            "Face Down",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        color: Colors.black);
  }

  Color get _cardColor {
    if (cardModel.cardColor == CardColor.red) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  String _cardNumber() {
    switch (cardModel.cardNumber) {
      case CardNumber.two:
        return '2';
      case CardNumber.three:
        return '3';
      case CardNumber.four:
        return '4';
      case CardNumber.five:
        return '5';
      case CardNumber.six:
        return '6';
      case CardNumber.seven:
        return '7';
      case CardNumber.eight:
        return '8';
      case CardNumber.nine:
        return '9';
      case CardNumber.ten:
        return '10';
      case CardNumber.jack:
        return 'J';
      case CardNumber.queen:
        return 'Q';
      case CardNumber.king:
        return 'K';
      case CardNumber.ace:
        return 'A';
      default:
        return '';
    }
  }

  IconData _cardSuit() {
    switch (cardModel.cardSuit) {
      case CardSuit.clubs:
        return MaterialCommunityIcons.cards_club;
      case CardSuit.spades:
        return MaterialCommunityIcons.cards_spade;
      case CardSuit.hearts:
        return MaterialCommunityIcons.cards_heart;
      case CardSuit.diamonds:
        return MaterialCommunityIcons.cards_diamond;
      default:
        return null;
    }
  }
}
