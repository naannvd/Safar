import 'package:flutter/material.dart';
import 'package:safar_admin/Screens/dashboard.dart';

void main() {
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
      home: AdminDashboard(),
    );
  }
}
