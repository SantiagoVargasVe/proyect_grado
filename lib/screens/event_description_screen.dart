import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_grado/widgets/images_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventDescriptionScreen extends StatelessWidget {
  static const routeName = "/event-description";

  EventDescriptionScreen({Key? key}) : super(key: key);
  CollectionReference communities =
      FirebaseFirestore.instance.collection('comunidades');

  addStudentToCommunity(String? communityId, BuildContext ctx) {
    try {
      communities.doc(communityId).update({
        'estudiantes':
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
      });
      Navigator.pop(ctx);
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: const Text("Se ha producido un error"),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: "OK",
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
          },
        ),
        duration: const Duration(days: 356),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text((args['id'] ?? "")),
      ),
      body: SafeArea(
          child: FutureBuilder<DocumentSnapshot>(
              future: communities.doc(args['id']).get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Algo salio mal"));
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Stack(
                    children: [
                      Column(
                        children: [
                          ImagesSlider(
                            images: data['descripción']['imagenes']
                                .map<String>((e) => e as String)
                                .toList(),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                            child: Text(data['descripción']['cuerpo'],
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                        ],
                      ),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 10, bottom: 10),
                            child: ElevatedButton(
                              child: const Text("Unirse"),
                              onPressed: () {
                                addStudentToCommunity(args['id'], context);
                              },
                            ),
                          ))
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              })),
    );
  }
}
