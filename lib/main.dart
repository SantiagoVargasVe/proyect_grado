import 'package:flutter/material.dart';
import 'package:proyecto_grado/screens/home_screen.dart';
import 'screens/event_description_screen.dart';
import 'screens/landing_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        canvasColor: const Color.fromRGBO(208, 188, 255, 1),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
          ),
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
            headline5: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(28, 27, 31, 1)),
            headline6: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(28, 27, 31, 1)),
            bodyText1: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(28, 27, 31, 1),
            )),
      ),
      home: LandingScreen(),
      routes: {
        RegisterScreen.routeName: (context) => RegisterScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        EventDescriptionScreen.routeName: (context) => EventDescriptionScreen(),
      },
    );
  }
}
