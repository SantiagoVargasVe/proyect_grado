import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_grado/widgets/card_post.dart';

class MuralCommunities extends StatelessWidget {
  const MuralCommunities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final idCommunity = args['id'] ?? "";
    final Stream<QuerySnapshot> _postsStream = FirebaseFirestore.instance
        .collection('comunidades')
        .doc(idCommunity)
        .collection('posts')
        .orderBy('hora_publicacion', descending: true)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: _postsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Algo salio mal'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return CardPost(
                  body: data["cuerpo"],
                  publicationTime: data['hora_publicacion'],
                  imageUrl: data['imagen'],
                  user: data["usuario"]);
            }).toList(),
          );
        });
  }
}
