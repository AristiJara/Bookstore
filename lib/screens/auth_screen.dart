import 'package:bookshop/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:bookshop/screens/login_screen.dart';

class AuthScreenContent extends StatefulWidget {
  const AuthScreenContent({super.key});

  @override
  State<AuthScreenContent> createState() => _AuthScreenContentState();
}

class _AuthScreenContentState extends State<AuthScreenContent> {
  bool isLogin = true;

  void toggleAuthMode() {
    setState(() => isLogin = !isLogin);
  }

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginScreen(onRegisterPressed: toggleAuthMode)
        : SignupScreen(onLoginPressed: toggleAuthMode);
  }
}
