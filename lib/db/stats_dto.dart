class StatsDTO {
  int id;
  int playerWins;
  int computerWins;
  int roundsPlayed;

  StatsDTO({this.id, this.playerWins, this.computerWins, this.roundsPlayed});

  get getEntries {
    return 'Stats: $roundsPlayed, $playerWins, $computerWins';
  }

    Map<String, dynamic> toMap() {
    return {
      'id': id,
      'playerWins': playerWins,
      'computerWins': computerWins,
      'roundsPlayed': roundsPlayed,
    };
  }
}