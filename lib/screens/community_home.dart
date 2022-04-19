import 'package:flutter/material.dart';
import 'package:proyecto_grado/screens/chat_screen.dart';
import 'package:proyecto_grado/widgets/mural_communities.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/pop_up_event.dart';

class CommunityHome extends StatefulWidget {
  static const routeName = '/community_home';
  const CommunityHome({Key? key}) : super(key: key);

  @override
  State<CommunityHome> createState() => _CommunityHomeState();
}

class _CommunityHomeState extends State<CommunityHome> {
  final pages = [
    MuralCommunities(),
    Text("Actividades"),
  ];

  String? _imageToUpload;
  XFile? _imageFile;
  int _selectedIndex = 0;

  _showUploadDialog(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Crear post"),
            content: PopUpEvent(
              communityId: args['id'] ?? "",
            ),
          );
        });
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
        actions: [
          _selectedIndex == 0
              ? IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    _showUploadDialog(context);
                  },
                )
              : const SizedBox(),
        ],
        title: Text(args['id'] ?? "Comunidad"),
      ),
      body: Center(
        child: pages[_selectedIndex],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, ChatScreen.routeName,
              arguments: {'id': args['id'] ?? ""});
        },
        child: const Icon(Icons.chat),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          color: const Color.fromRGBO(255, 251, 254, 1),
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.feed,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.event,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
              ),
            ],
          )),
    );
  }
}
