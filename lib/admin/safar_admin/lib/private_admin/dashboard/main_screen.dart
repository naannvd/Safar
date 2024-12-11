import 'package:flutter/material.dart';
import 'package:safar_admin/private_admin/Widgets/dashboard.dart';
import 'package:safar_admin/private_admin/Widgets/user.dart';
import 'package:safar_admin/private_admin/dashboard/sidebar.dart';
import 'package:safar_admin/private_admin/Widgets/settings.dart';
import 'package:safar_admin/login_screen.dart';

class PrivateDashboard extends StatefulWidget {
  const PrivateDashboard({super.key});

  @override
  State<PrivateDashboard> createState() => _PrivateDashboardState();
}

class _PrivateDashboardState extends State<PrivateDashboard> {
  int selectedIndex = 0;

  // List of tab titles
  final List<String> tabs = ['Dashboard', 'User', 'Settings', 'Logout'];

  // List of corresponding screens for each tab
  final List<Widget> screens = [
    const DashboardScreen(),
    const UserScreen(),
    const SettingsScreen(),
  ];

  void handleTabSelection(int index) {
    if (tabs[index] == 'Logout') {
      // Navigate back to the Login Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      // Update selected index for other tabs
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Sidebar for navigation
          Sidebar(
            selectedIndex: selectedIndex,
            tabs: tabs,
            onTabSelected: handleTabSelection, // Handle tab selection
          ),
          // Main Content dynamically updates based on the selected tab
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: selectedIndex < screens.length
                  ? screens[selectedIndex]
                  : Container(), // Display the selected screen
            ),
          ),
        ],
      ),
    );
  }
}
