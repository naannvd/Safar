import 'package:flutter/material.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  @override
  Widget build(BuildContext Context) {
    return const Scaffold(
      body: Center(
        child: Text("Parent"),
      ),
    );
  }
}
