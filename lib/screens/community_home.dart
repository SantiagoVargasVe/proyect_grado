import 'package:flutter/material.dart';
import 'package:proyecto_grado/widgets/mural_communities.dart';

class CommunityHome extends StatefulWidget {
  static const routeName = '/community_home';
  const CommunityHome({Key? key}) : super(key: key);

  @override
  State<CommunityHome> createState() => _CommunityHomeState();
}

class _CommunityHomeState extends State<CommunityHome> {
  final pages = [
    MuralCommunities(),
    Text("chat"),
    Text("Actividades"),
  ];

  int _selectedIndex = 0;

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
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {},
          ),
        ],
        title: Text(args['id'] ?? "Comunidad"),
      ),
      body: Center(
        child: pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(255, 251, 254, 1),
        items: [
          BottomNavigationBarItem(
            icon: Ink(
              width: 64,
              height: 32,
              child: const Icon(Icons.feed),
              decoration: (_selectedIndex == 0)
                  ? BoxDecoration(
                      color: const Color.fromRGBO(232, 222, 248, 1),
                      borderRadius: BorderRadius.circular(20))
                  : null,
            ),
            label: "Mural",
          ),
          BottomNavigationBarItem(
            icon: Ink(
              width: 64,
              height: 32,
              child: const Icon(Icons.chat),
              decoration: (_selectedIndex == 1)
                  ? BoxDecoration(
                      color: const Color.fromRGBO(232, 222, 248, 1),
                      borderRadius: BorderRadius.circular(20))
                  : null,
            ),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Ink(
              width: 64,
              height: 32,
              child: const Icon(Icons.event),
              decoration: (_selectedIndex == 2)
                  ? BoxDecoration(
                      color: const Color.fromRGBO(232, 222, 248, 1),
                      borderRadius: BorderRadius.circular(20))
                  : null,
            ),
            label: "Actividades",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
