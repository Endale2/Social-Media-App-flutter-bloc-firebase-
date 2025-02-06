import 'package:flutter/material.dart';
import 'package:socialx/features/auth/presentation/components/my_button.dart';
import 'package:socialx/features/auth/presentation/components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //icon
              Icon(Icons.lock_open_rounded,
                  size: 80, color: Theme.of(context).colorScheme.primary),

              const SizedBox(height: 50),

              //welcome back message
              Text(
                "Welcome back we missed you!",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary, fontSize: 16),
              ),

              const SizedBox(height: 25),
              //name
              MyTextField(
                  controller: nameController,
                  hintText: "name",
                  obscureText: false),

              const SizedBox(height: 10),
              //email
              MyTextField(
                  controller: emailController,
                  hintText: "email",
                  obscureText: false),

              const SizedBox(height: 10),
              //password
              MyTextField(
                  controller: passwordController,
                  hintText: "password",
                  obscureText: true),
              //login button
              const SizedBox(height: 25),
              MyButton(onTap: () {}, text: "Register"),
              //not registered yet?
              const SizedBox(height: 25),
              Text("Already have an account? Login now",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary))
            ],
          ),
        ),
      ),
    ));
  }
}
