import 'playing_card.dart';

class Player {
  int cardsNeeded = 2;
  List<CardModel> playerCards = [];

  int get handValue {
    int total = 0;
    playerCards.forEach((card) {
      total += card.cardValue;
    });
    for (var card in playerCards) {
      if (card.cardNumber == CardNumber.ace && total > 21) {
        total -= 10;
      }
    }

    return total;
  }

  bool get hasBusted {
    return handValue > 21 ? true : false;
  }

  int get cardCount {
    return playerCards.length;
  }

  void resetPlayer() {
    cardsNeeded = 2;
    playerCards.clear();
  }
}
