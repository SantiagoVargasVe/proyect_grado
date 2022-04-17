import 'package:flutter/material.dart';
import '../models/user_data.dart';
import '../models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class InputBox extends StatefulWidget {
  final String communityId;
  const InputBox({Key? key, required this.communityId}) : super(key: key);

  @override
  State<InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  FirebaseAuth auth = FirebaseAuth.instance;
  XFile? _imageFile;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _bodyController = TextEditingController();
  uploadImage() async {
    final _imagePicker = ImagePicker();
    XFile? image;
    //Check Permissions
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      image = await _imagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _imageFile = image;
      });
    }
  }

  sendMessage() async {
    String downloadUrl = "";
    final currentUser = auth.currentUser;
    final userFirestore =
        await firestore.collection('users').doc(currentUser!.uid).get();
    final userMessage = UserData(
        email: userFirestore['email'],
        name: userFirestore['nombre'],
        photoUrl: userFirestore['avatar']);

    final chatRef = firestore
        .collection('comunidades')
        .doc(
          widget.communityId,
        )
        .collection('chat')
        .withConverter<Message>(
            fromFirestore: (snapshot, _) => Message.fromJson(snapshot.data()!),
            toFirestore: (message, _) => message.toJson());

    if (_imageFile != null) {
      var file = File(_imageFile!.path);
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('comunidades/${widget.communityId}/chat/${_imageFile?.name}')
          .putFile(file);
      downloadUrl = await snapshot.ref.getDownloadURL();
      chatRef.add(Message(
          body: _bodyController.text,
          publishTime: Timestamp.now(),
          user: userMessage,
          imageUrl: downloadUrl));
    } else {
      chatRef.add(Message(
          body: _bodyController.text,
          publishTime: Timestamp.now(),
          user: userMessage));
    }
    _bodyController.clear();
    setState(() {
      _imageFile = null;
    });

    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(208, 188, 255, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          (_imageFile != null)
              ? Image.file(File(_imageFile!.path), height: 150)
              : const SizedBox(),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextField(
                    controller: _bodyController,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    decoration: InputDecoration(
                      fillColor: const Color.fromRGBO(103, 80, 164, 1),
                      filled: true,
                      suffixIcon: IconButton(
                        color: Colors.white,
                        icon: const Icon(Icons.attach_file),
                        onPressed: uploadImage,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Escribe un mensaje...',
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  sendMessage();
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
