import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConstants {
  static const String supabaseUrl = 'https://gvbhlgqrlscsmxptpszk.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd2YmhsZ3FybHNjc214cHRwc3prIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM5Nzk4MjQsImV4cCI6MjA0OTU1NTgyNH0.uNIEkQIlFymLHngrvX3yxvuLIGoG-18CxOQVf4UZD6c';
  static final SupabaseClient client = SupabaseClient(supabaseUrl, anonKey);
}
