import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialx/features/auth/presentation/components/my_button.dart';
import 'package:socialx/features/auth/presentation/components/my_text_field.dart';
import 'package:socialx/features/auth/presentation/cubits/auth_cubit.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;
  const RegisterPage({super.key, required this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void register() {
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;

    //cubit
    final authCubit = context.read<AuthCubit>();
    if (name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        authCubit.register(name, email, password);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("The Password Doesn't Match")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("All Fields Must Be Filled")));
    }
  }

  @override
  void dipose() {
    nameController.dispose();
    confirmPasswordController.dispose();
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
                "Welcome! Lets create an account for you",
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
              //confirm password
              const SizedBox(height: 10),
              MyTextField(
                  controller: passwordController,
                  hintText: "confirm password",
                  obscureText: true),
              //login button
              const SizedBox(height: 25),
              MyButton(onTap: register, text: "Register"),
              //not registered yet?
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                  GestureDetector(
                    onTap: widget.togglePages,
                    child: Text("Login now",
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
