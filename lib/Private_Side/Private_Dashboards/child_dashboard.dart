import 'package:flutter/material.dart';

class ChildDashboardScreen extends StatefulWidget {
  const ChildDashboardScreen({super.key});

  @override
  State<ChildDashboardScreen> createState() => _ChildDashboardScreenState();
}

class _ChildDashboardScreenState extends State<ChildDashboardScreen> {
  @override
  Widget build(BuildContext Context) {
    return const Scaffold(
      body: Center(
        child: Text("Child"),
      ),
    );
  }
}
