import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          children: [
            //icon
            Icon(Icons.lock_open_rounded,
                size: 80, color: Theme.of(context).colorScheme.primary)

            //welcome back message

            //email
            //password
            //login button
            //not registered yet?
          ],
        ),
      ),
    ));
  }
}
