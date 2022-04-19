import 'package:flutter/material.dart';
import '../widgets/input_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/message_card.dart';
import '../models/user_data.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static const routeName = '/chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final idCommunity = args['id'] ?? "";

    final Stream<QuerySnapshot> _messagesStream = FirebaseFirestore.instance
        .collection('comunidades')
        .doc(idCommunity)
        .collection("chat")
        .orderBy('hora_publicacion', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(args['id'] ?? "Comunidad")),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color.fromRGBO(169, 133, 255, 1),
              child: StreamBuilder<QuerySnapshot>(
                  stream: _messagesStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Algo salio mal'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> data = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;

                        final message = Message.fromJson(data);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              MessageCard(key: UniqueKey(), message: message),
                        );
                      },
                    );
                  }),
            ),
          ),
          InputBox(communityId: args['id'] ?? "Comunidad"),
        ],
      ),
    );
  }
}
