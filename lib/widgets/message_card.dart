import 'package:flutter/material.dart';
import '../models/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/message.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  final currentUser = FirebaseAuth.instance.currentUser;
  MessageCard({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: message.user.email == currentUser?.email
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              textDirection: message.user.email == currentUser?.email
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(message.user.photoUrl),
                ),
                const SizedBox(width: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(143, 58, 152, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      crossAxisAlignment:
                          message.user.email == currentUser?.email
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        Text(message.user.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color.fromARGB(255, 240, 235, 240))),
                        if (message.imageUrl != null)
                          Image.network(
                            message.imageUrl ?? "",
                            fit: BoxFit.cover,
                          ),
                        Text(
                          message.body,
                          textAlign: message.user.email == currentUser?.email
                              ? TextAlign.end
                              : TextAlign.start,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }
}
