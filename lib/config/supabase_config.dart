import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static final SupabaseConfig _instance = SupabaseConfig._internal();

  factory SupabaseConfig() {
    return _instance;
  }


  SupabaseConfig._internal();

  Future<void> initialize() async {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? '',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
    );
  }

  SupabaseClient get client => Supabase.instance.client;
}
