import 'package:flutter/material.dart';

class AuthenticatingScreen extends StatelessWidget {
  late String message;


  AuthenticatingScreen(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(message),
      ),
    );
  }
}
