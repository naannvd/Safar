import 'package:flutter/material.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  @override
  Widget build(BuildContext Context) {
    return const Scaffold(
      body: Center(
        child: Text("Parent"),
      ),
    );
  }
}
