import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialx/app.dart';
import 'package:socialx/config/firebase_options.dart';
import 'package:socialx/config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SupabaseConfig().initialize();
  runApp(MyApp());
}
