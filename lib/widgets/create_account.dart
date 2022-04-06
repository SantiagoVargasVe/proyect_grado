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
  final _nameController = TextEditingController();

  var _showPassword = false;
  var _showConfirmPassword = false;

  var _selectedImage = "";

  void changeSelectedImage(String image) {
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

  String? validateName(String? value) {
    if (value == null) {
      return 'El campo es requerido';
    }

    final RegExp nameExp = RegExp(r'^[a-zA-Z]+$');
    if (!nameExp.hasMatch(value)) {
      return 'El nombre no es válido';
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

      addUser();

      Navigator.of(ctx).pop();
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
        content: Text('Usuario creado'),
        backgroundColor: Colors.green,
      ));
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

  Future<void> addUser() async {
    await users.doc(auth.currentUser!.uid).set({
      'email': _emailController.text,
      'avatar': _selectedImage,
      'nombre': _nameController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ImageSelector(
                  changeSelectedImage: changeSelectedImage,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 250,
                  child: Column(
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
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nombre',
                          hintText: "Seneca",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: validateName,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Contraseña',
                          hintText: "*********",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                          ),
                        ),
                        validator: validatePassword,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_showConfirmPassword,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Confirmar contraseña',
                          hintText: "*********",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _showConfirmPassword = !_showConfirmPassword;
                              });
                            },
                          ),
                        ),
                        validator: validateConfirmPassword,
                      ),
                      const SizedBox(height: 20),
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
          )),
    );
  }
}
