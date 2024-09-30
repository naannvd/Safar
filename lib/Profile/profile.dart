// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safar/Widgets/bottom_nav_bar.dart'; // Import your RoundedNavBar file

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Screen')),
      bottomNavigationBar: const RoundedNavBar(
          currentTab: 'Profile'), // Pass 'Profile' as currentTab
    );
  }
}
