import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('assets/images/avatar.png', width: 200, height: 200),
              SizedBox(
                width: 250,
                height: 236,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: "seneca@uniandes.edu.co",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: validateEmail,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contraseña',
                        hintText: "*********",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: validateEmail,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirmar contraseña',
                        hintText: "*********",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: validateEmail,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Crear cuenta"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(300, 40),
                ),
              ),
            ],
          ),
        ));
  }
}
