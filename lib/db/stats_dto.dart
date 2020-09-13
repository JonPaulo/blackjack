class StatsDTO {
  int id;
  int playerWins;
  int computerWins;
  int roundsPlayed;

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