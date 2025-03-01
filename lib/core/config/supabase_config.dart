import 'dart:developer';

import 'package:helpnest/core/config/secrets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> initializeApp() async {
    try {
      await Supabase.initialize(
          url: AppSecrets.SUPABASE_URL, anonKey: AppSecrets.SUPABASE_ANON_KEY);
    } catch (e) {
      log("SUPABASE_INIT_ERROR: $e");
    }
  }
}
