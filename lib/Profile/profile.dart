import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safar/Widgets/bottom_nav_bar.dart'; // Import your RoundedNavBar file

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(child: const Text('Profile Screen')),
      bottomNavigationBar:
          RoundedNavBar(currentTab: 'Profile'), // Pass 'Profile' as currentTab
    );
  }
}
