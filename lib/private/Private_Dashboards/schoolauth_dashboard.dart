import 'package:flutter/material.dart';

class SchoolAuthDashboardScreen extends StatefulWidget {
  const SchoolAuthDashboardScreen({super.key});

  @override
  State<SchoolAuthDashboardScreen> createState() =>
      _SchoolAuthDashboardScreenState();
}

class _SchoolAuthDashboardScreenState extends State<SchoolAuthDashboardScreen> {
  @override
  Widget build(BuildContext Context) {
    return const Scaffold(
      body: Center(
        child: Text("School Authority"),
      ),
    );
  }
}
