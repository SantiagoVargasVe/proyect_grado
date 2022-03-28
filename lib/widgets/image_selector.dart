import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:math';

class ImageSelector extends StatefulWidget {
  const ImageSelector({Key? key}) : super(key: key);

  @override
  State<ImageSelector> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  // firebase_storage.FirebaseStorage storage =
  //     firebase_storage.FirebaseStorage.instance.ref("avatars");

  var urls = <String>[];
  var _currentImageIndex = 0;
  var _loadingImages = true;
  Random random = Random();
  Future<void> listExample() async {
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref("avatars")
        .listAll();

    for (firebase_storage.Reference ref in result.items) {
      var url = (await ref.getDownloadURL()).toString();
      urls.add(url);
    }
    setState(() {
      _loadingImages = false;
      _currentImageIndex = random.nextInt(urls.length);
    });
  }

  @override
  void initState() {
    super.initState();
    listExample();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        child: _loadingImages
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GestureDetector(
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(urls[_currentImageIndex]),
                ),
                onTap: () {
                  setState(() {
                    _currentImageIndex = random.nextInt(urls.length);
                  });
                },
              ),
      ),
    );
  }
}
