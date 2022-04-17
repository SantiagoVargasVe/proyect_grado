import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_data.dart';

class PostCommunity {
  final String body;
  final Timestamp publishTime;
  final String? imageUrl;
  final UserData user;

  PostCommunity({
    required this.body,
    required this.publishTime,
    this.imageUrl,
    required this.user,
  });

  factory PostCommunity.fromJson(Map<String, dynamic> json) {
    return PostCommunity(
      body: json['cuerpo'] as String,
      publishTime: json['hora_publicacion'] as Timestamp,
      imageUrl: json['imagen'] as String?,
      user: UserData.fromJson(json['usuario'] as Map<String, dynamic>),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'cuerpo': body,
      'hora_publicacion': publishTime,
      'imagen': imageUrl,
      'usuario': user.toJson(),
    };
  }
}
