import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'event_slider.dart';
import '../models/event_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunitiesFeed extends StatelessWidget {
  // final Stream<QuerySnapshot> communities = FirebaseFirestore.instance
  //     .collection('comunidades')
  //     .snapshots(includeMetadataChanges: true);

  final Stream<QuerySnapshot> communities = FirebaseFirestore.instance
      .collection('comunidades')
      .snapshots(includeMetadataChanges: true);

  final user = FirebaseAuth.instance.currentUser;
  CommunitiesFeed({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text("Tus comunidades",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headline6),
          ),
        ),
        const SizedBox(height: 20),
        StreamBuilder<QuerySnapshot>(
            stream: communities,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              List<EventData> data = snapshot.data!.docs
                  .map((e) {
                    return EventData(
                        title: e.id,
                        date: (e.data() as Map<String, dynamic>)['date'],
                        students:
                            (e.data() as Map<String, dynamic>)['estudiantes'] ??
                                []);
                  })
                  .toList()
                  .where((element) {
                    element.isParticipating = true;
                    return element.students.contains(user!.uid);
                  })
                  .toList();

              return EventSlider(key: UniqueKey(), events: data);
            }),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text("Te pueden gustar",
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headline6),
          ),
        ),
        const SizedBox(height: 20),
        StreamBuilder<QuerySnapshot>(
            stream: communities,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<EventData> data = snapshot.data!.docs
                  .map((e) {
                    return EventData(
                        title: e.id,
                        date: (e.data() as Map<String, dynamic>)['date'],
                        students:
                            (e.data() as Map<String, dynamic>)['estudiantes'] ??
                                []);
                  })
                  .toList()
                  .where((element) {
                    return !element.students.contains(user!.uid);
                  })
                  .toList();

              return EventSlider(key: UniqueKey(), events: data);
            }),
      ],
    );
  }
}
