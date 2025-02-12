import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialx/app.dart';
import 'package:socialx/config/firebase_options.dart';
import 'package:socialx/config/supabase_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socialx/short_time_ago_messages.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await SupabaseConfig().initialize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  timeago.setLocaleMessages('en_short', ShortTimeAgoMessages());

  runApp(MyApp());
}
