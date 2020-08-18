import 'playing_card.dart';

class Player {
  int cardsNeeded = 2;
  List<CardModel> playerCards = [];

  int get handValue {
    int total = 0;
    playerCards.forEach((card) {
      total += card.cardValue;
    });
    return total;
  }

  bool get hasBusted {
    return handValue > 21 ? true : false;
  }

  void resetPlayer() {
    cardsNeeded = 2;
    playerCards.clear();
  }
}
