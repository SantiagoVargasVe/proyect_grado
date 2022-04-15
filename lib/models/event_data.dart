class EventData {
  String title;
  DateTime? date;
  List<dynamic> students;
  bool isParticipating = false;
  EventData({required this.title, this.date, required this.students});
}
