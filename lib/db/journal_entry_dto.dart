class JournalEntryDTO {
  String title;
  String body;
  int rating;
  String date;

  get getEntries {
    return 'Entries: $title, $body, $rating, $date';
  }
}