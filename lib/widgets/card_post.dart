import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_data.dart';

class CardPost extends StatelessWidget {
  final String body;
  final Timestamp publicationTime;
  final String? imageUrl;
  final UserData user;
  const CardPost(
      {Key? key,
      required this.body,
      required this.publicationTime,
      this.imageUrl,
      required this.user})
      : super(key: key);

  String getPublicationDateTime(Timestamp publicationDateTime) {
    final today = DateTime.now();
    final publicationDate = publicationDateTime.toDate();
    final difference = today.difference(publicationDate);
    if (difference.inDays > 0) {
      return '${difference.inDays} días';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} horas';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutos';
    } else {
      return '${difference.inSeconds} segundos';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name),
                      SizedBox(height: 5),
                      Text(getPublicationDateTime(publicationTime)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      height: MediaQuery.of(context).size.height * 0.3,
                    )
                  : const SizedBox(height: 1),
              const SizedBox(height: 10),
              Text(
                body,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
