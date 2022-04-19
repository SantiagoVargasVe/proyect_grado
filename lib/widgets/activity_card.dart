import 'package:flutter/material.dart';
import '../models/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      tileColor: Colors.white,
      title: Text(activity.title),
      subtitle: Text(
          ' ${activity.place} - ${activity.getDate()} / ${activity.getTimeStart()}-${activity.getTimeEnd()}'),
    );
  }
}
