enum CardSuit {
  clubs,
  spades,
  hearts,
  diamonds,
}

enum CardNumber {
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king,
  ace
}

enum CardColor { red, black }

class CardModel {
  CardSuit cardSuit;
  CardNumber cardNumber;

  bool faceUp;
  CardModel({this.cardNumber, this.cardSuit, this.faceUp});

  CardColor get cardColor {
    if (cardSuit == CardSuit.diamonds || cardSuit == CardSuit.hearts) {
      return CardColor.red;
    } else {
      return CardColor.black;
    }
  }

  int get cardValue {
    switch (cardNumber) {
      case CardNumber.two:
        return 2;
      case CardNumber.three:
        return 3;
      case CardNumber.four:
        return 4;
      case CardNumber.five:
        return 5;
      case CardNumber.six:
        return 6;
      case CardNumber.seven:
        return 7;
      case CardNumber.eight:
        return 8;
      case CardNumber.nine:
        return 9;
      case CardNumber.ten:
        return 10;
      case CardNumber.jack:
        return 10;
      case CardNumber.queen:
        return 10;
      case CardNumber.king:
        return 10;
      case CardNumber.ace:
        return 11;
      default:
        return 0;
    }
  }
}
