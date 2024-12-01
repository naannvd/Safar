import 'package:flutter/material.dart';
import 'package:safar/private/parent/add_child.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  @override
  Widget build(BuildContext Context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Add Child"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddChildDashboard()));
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Create Child"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddChildDashboard()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
