import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final _formKey = GlobalKey<FormState>();

  FirebaseAuth auth = FirebaseAuth.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _showPassword = false;

  String? validateEmail(String? value) {
    if (value == null) {
      return 'El campo es requerido';
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

  void login(BuildContext ctx) async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text + '@noexiste.com',
          password: _passwordController.text);

      Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.routeName, (Route<dynamic> route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          content: Text('No se encontro el usuario'),
          backgroundColor: Colors.orange,
        ));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          content: Text('Email o contraseña incorrectos'),
          backgroundColor: Colors.orange,
        ));
      }
    }
  }

  void validateForm(BuildContext ctx) {
    if (_formKey.currentState!.validate()) {
      login(ctx);
    }
  }

  void goToRegisterScreen() {
    Navigator.of(context).pushNamed(RegisterScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
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
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nombre de usuario',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: validateEmail,
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
                          onPressed: () {
                            validateForm(context);
                          },
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
