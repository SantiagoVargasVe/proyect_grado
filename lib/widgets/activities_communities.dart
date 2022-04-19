import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_grado/widgets/activity_card.dart';
import '../models/activity.dart';

class ActivitiesComunnities extends StatelessWidget {
  ActivitiesComunnities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final Stream<QuerySnapshot<Activity>> _activitiesStream = FirebaseFirestore
        .instance
        .collection('comunidades')
        .doc(args['id'] ?? "")
        .collection('actividades')
        .orderBy('fecha', descending: true)
        .withConverter<Activity>(
            fromFirestore: (snapshot, _) => Activity.fromJson(snapshot.data()!),
            toFirestore: (activity, _) => activity.toJson())
        .snapshots();

    return StreamBuilder<QuerySnapshot<Activity>>(
        stream: _activitiesStream,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Activity>> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Algo salio mal'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: snapshot.data!.docs
                  .map((DocumentSnapshot<Activity> document) {
                return ActivityCard(activity: document.data()!);
              }).toList());
        });
  }
}
