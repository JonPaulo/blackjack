import 'playing_card.dart';

class Player {
  int playerCardCount = 2;
  List<CardModel> playerCards = [];
  int handValue = 0;

  void resetPlayer() {
    playerCardCount = 2;
    handValue = 0;
    playerCards.clear();
  }
}