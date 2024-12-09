import 'package:flutter/material.dart';

<<<<<<< HEAD
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
=======
class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});
>>>>>>> backup2

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NotificationScreen'),
      ),
      body: const Center(
        child: Text(
          'NotificationScreen',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
