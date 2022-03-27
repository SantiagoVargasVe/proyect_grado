import 'package:flutter/material.dart';
import '../widgets/create_account.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const routeName = '/register';
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  final widgets = [CreateAccount()];
  var actual_widget_index = 0;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgets[actual_widget_index],
      ),
    );
  }
}
