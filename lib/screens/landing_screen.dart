import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final _formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;

  String? validateEmail(String? value) {
    if (value == null) {
      return 'El campo es requerido';
    }

    final RegExp emailExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    if (!emailExp.hasMatch(value)) {
      return 'El email no es válido';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null) {
      return 'El campo es requerido';
    }

    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }

    return null;
  }

  void goToRegisterScreen() {
    Navigator.of(context).pushNamed(RegisterScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Image(
              image: AssetImage('assets/images/landing_logo.png'),
              width: 200,
              height: 200,
            ),
            SizedBox(
              width: 250,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    validator: validateEmail,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Contraseña',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    validator: validateEmail,
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {},
                    child: const Text('¿Olvidaste tu contraseña?'),
                  )
                ],
              ),
            ),
            SizedBox(
              child: Column(
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(300, 40),
                      ),
                      onPressed: () {},
                      child: const Text('Iniciar sesión')),
                  TextButton(
                      onPressed: goToRegisterScreen,
                      child: const Text('Crear cuenta')),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
