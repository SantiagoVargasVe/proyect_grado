import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Home Screen')),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromRGBO(255, 251, 254, 1),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Ink(
              width: 64,
              height: 32,
              child: const Icon(Icons.dashboard),
              decoration: (_selectedIndex == 0)
                  ? BoxDecoration(
                      color: const Color.fromRGBO(232, 222, 248, 1),
                      borderRadius: BorderRadius.circular(20))
                  : null,
            ),
            label: "Talleres",
          ),
          BottomNavigationBarItem(
            icon: Ink(
              width: 64,
              height: 32,
              child: const Icon(Icons.school),
              decoration: (_selectedIndex == 1)
                  ? BoxDecoration(
                      color: const Color.fromRGBO(232, 222, 248, 1),
                      borderRadius: BorderRadius.circular(20))
                  : null,
            ),
            label: "Comunidades",
          ),
          BottomNavigationBarItem(
            icon: Ink(
              width: 64,
              height: 32,
              child: const Icon(Icons.groups),
              decoration: (_selectedIndex == 2)
                  ? BoxDecoration(
                      color: const Color.fromRGBO(232, 222, 248, 1),
                      borderRadius: BorderRadius.circular(20))
                  : null,
            ),
            label: "Tus talleres",
          ),
          BottomNavigationBarItem(
            icon: Ink(
              width: 64,
              height: 32,
              child: const Icon(Icons.perm_identity),
              decoration: (_selectedIndex == 3)
                  ? BoxDecoration(
                      color: const Color.fromRGBO(232, 222, 248, 1),
                      borderRadius: BorderRadius.circular(20))
                  : null,
            ),
            label: "Perfil",
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
