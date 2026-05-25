import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class SupabaseConstants {
  static String get url => dotenv.env['SUPABASE_URL'] ?? '';
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  static void validate() {
    if (url.isEmpty || anonKey.isEmpty) {
      throw StateError(
        'Missing Supabase config in .env. Add SUPABASE_URL and SUPABASE_ANON_KEY.',
      );
    }
  }
}
