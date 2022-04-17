class UserData {
  final String email;
  final String name;
  final String photoUrl;

  UserData({required this.email, required this.name, required this.photoUrl});

  UserData.fromJson(Map<String, dynamic> json)
      : email = json['email'] as String,
        name = json['nombre'] as String,
        photoUrl = json['avatar'] as String;

  Map<String, Object?> toJson() {
    return {'email': email, 'nombre': name, 'avatar': photoUrl};
  }
}
