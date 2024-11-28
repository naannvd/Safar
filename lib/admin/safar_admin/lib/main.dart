import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:safar_admin/dashboard/dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
