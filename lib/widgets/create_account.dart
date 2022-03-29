import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_grado/widgets/image_selector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var _selectedImage = "";

  void changeSelectedImage(String image) {
    print(image);
    setState(() {
      _selectedImage = image;
    });
  }

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
      return 'Se necesita al menos 6 caracteres';
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null) {
      return 'El campo es requerido';
    }

    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  void validateForm(BuildContext ctx) {
    if (_formKey.currentState!.validate()) {
      registerUser(ctx);
    }
  }

  void registerUser(BuildContext ctx) async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      ScaffoldMessenger.of(ctx)
          .showSnackBar(const SnackBar(content: Text('Usuario creado')));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
            content: Text('Contraseña muy débil'),
            backgroundColor: Colors.red));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
            content: Text('El email ya está en uso'),
            backgroundColor: Colors.red));
      }
    } catch (e) {
      print(e);
    }
  }

  void addUser() {
    users.doc(auth.currentUser!.uid).set({
      'email': _emailController.text,
      'avatar': _selectedImage,
    });
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
              ImageSelector(
                changeSelectedImage: changeSelectedImage,
              ),
              SizedBox(
                width: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: "seneca@uniandes.edu.co",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Contraseña',
                        hintText: "*********",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: validatePassword,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirmar contraseña',
                        hintText: "*********",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      validator: validateConfirmPassword,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  validateForm(context);
                },
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
