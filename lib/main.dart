import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialx/features/auth/presentation/pages/login_page.dart';
import 'package:socialx/features/auth/presentation/pages/register_page.dart';
import 'package:socialx/firebase_options.dart';
import 'package:socialx/themes/light_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: lightMode,
        debugShowCheckedModeBanner: false,
        home: RegisterPage());
  }
}
