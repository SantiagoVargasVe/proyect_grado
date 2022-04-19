import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Activity {
  final String title;
  final String place;
  final Timestamp date;
  final Timestamp timeStart;
  final Timestamp timeEnd;

  Activity({
    required this.title,
    required this.place,
    required this.date,
    required this.timeStart,
    required this.timeEnd,
  }) {
    initializeDateFormatting();
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      title: json['titulo'] as String,
      place: json['lugar'] as String,
      date: json['fecha'] as Timestamp,
      timeStart: json['hora_inicio'] as Timestamp,
      timeEnd: json['hora_fin'] as Timestamp,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'titulo': title,
      'lugar': place,
      'fecha': date,
      'hora_inicio': timeStart,
      'hora_fin': timeEnd,
    };
  }

  String getDate() {
    return DateFormat.yMMMd('es').format(date.toDate());
  }

  String getTimeStart() {
    return DateFormat.Hm('es').format(timeStart.toDate());
  }

  String getTimeEnd() {
    return DateFormat.Hm('es').format(timeEnd.toDate());
  }
}
