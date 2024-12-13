import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; 
import 'firebase_messaging_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi Firebase Messaging Service
  FirebaseMessagingService().init();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://gvbhlgqrlscsmxptpszk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd2YmhsZ3FybHNjc214cHRwc3prIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzM5Nzk4MjQsImV4cCI6MjA0OTU1NTgyNH0.uNIEkQIlFymLHngrvX3yxvuLIGoG-18CxOQVf4UZD6c',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
