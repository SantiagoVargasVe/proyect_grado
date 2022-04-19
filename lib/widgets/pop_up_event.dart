import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_community.dart';
import '../models/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PopUpEvent extends StatefulWidget {
  final String communityId;

  const PopUpEvent({
    Key? key,
    required this.communityId,
  }) : super(key: key);

  @override
  State<PopUpEvent> createState() => _PopUpEventState();
}

class _PopUpEventState extends State<PopUpEvent> {
  XFile? _imageFile;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  final _bodyController = TextEditingController();

  String? validateBody(String? value) {
    if (value == null || value.isEmpty) {
      return 'El campo es requerido';
    }

    return null;
  }

  void uploadToFirebase() async {
    String downloadUrl = "";

    final postRef = firestore
        .collection('comunidades')
        .doc(widget.communityId)
        .collection('posts')
        .withConverter<PostCommunity>(
            fromFirestore: (snapshot, _) =>
                PostCommunity.fromJson(snapshot.data()!),
            toFirestore: (post, _) => post.toJson());

    final currentUser = auth.currentUser;
    final userFirestore =
        await firestore.collection('users').doc(currentUser!.uid).get();
    final userPost = UserData(
        email: userFirestore['email'],
        name: userFirestore['nombre'],
        photoUrl: userFirestore['avatar']);

    if (_imageFile != null) {
      var file = File(_imageFile!.path);
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child(
              'comunidades/${widget.communityId}/eventos/${_imageFile?.name}')
          .putFile(file);
      downloadUrl = await snapshot.ref.getDownloadURL();

      postRef.add(PostCommunity(
          body: _bodyController.text,
          publishTime: Timestamp.now(),
          user: userPost,
          imageUrl: downloadUrl));
    } else {
      postRef.add(PostCommunity(
        body: _bodyController.text,
        publishTime: Timestamp.now(),
        user: userPost,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      (_imageFile != null)
                          ? GestureDetector(
                              child: Image.file(
                                File(_imageFile!.path),
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                              ),
                              onTap: () {
                                uploadImage();
                              })
                          : OutlinedButton(
                              onPressed: uploadImage,
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Subir una imagen es opcional",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.deepPurple),
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Colors.deepPurple,
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                      const SizedBox(height: 10),
                      TextFormField(
                        minLines: 4,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        controller: _bodyController,
                        validator: validateBody,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Descripción del evento",
                        ),
                      ),
                    ],
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'Cancel');
                              },
                              child: const Text('Cancelar')),
                          TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                uploadToFirebase();
                                Navigator.pop(context, 'Ok');
                              }
                            },
                            child: const Text('Subir'),
                          ),
                        ],
                      ))
                ],
              )),
        ),
      ),
    );
  }
}
