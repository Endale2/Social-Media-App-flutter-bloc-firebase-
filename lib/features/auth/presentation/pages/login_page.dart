import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/auth/presentation/components/my_button.dart';
import 'package:socialx/features/auth/presentation/components/my_text_field.dart';
import 'package:socialx/features/auth/presentation/cubits/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    final String email = emailController.text;
    final String password = passwordController.text;
    //cubit
    final authCubit = context.read<AuthCubit>();

    //check if it is not empty
    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.login(email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("please enter both email and password")));
    }
  }

  @override
  void dipose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

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
              MyButton(onTap: login, text: "Login"),
              //not registered yet?
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not a member? ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                  GestureDetector(
                    onTap: widget.togglePages,
                    child: Text("Register now",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
