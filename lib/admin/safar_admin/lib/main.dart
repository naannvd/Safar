import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:safar_admin/login_screen.dart';
import 'package:safar_admin/public_admin/dashboard/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyAKMoEkOamGbcX3naG0cO7q_l4hmZtfWBc",
          appId: "1:1048390334337:web:35ef0a77449c4656289a80",
          messagingSenderId: "1048390334337",
          projectId: "safar-6b838",
        ),
      );
      print("Firebase initialized for Web.");
    } else {
      await Firebase.initializeApp();
      print("Firebase initialized for Mobile/Other platforms.");
    }
  } catch (e) {
    print("Firebase initialization failed: $e");
  }
  runApp(const SafarAdminDashboard());
}

class SafarAdminDashboard extends StatelessWidget {
  const SafarAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safar Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AdminDashboard(),
    );
  }
}
