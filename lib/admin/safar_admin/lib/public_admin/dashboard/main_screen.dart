import 'package:flutter/material.dart';
import 'package:safar_admin/login_screen.dart';
import 'package:safar_admin/public_admin/Widgets/dashboard.dart';
import 'package:safar_admin/public_admin/Widgets/feedbacks.dart';
import 'package:safar_admin/public_admin/Widgets/inbox.dart';
import 'package:safar_admin/public_admin/Widgets/loyalty_program.dart';
import 'package:safar_admin/public_admin/Widgets/reports.dart';
import 'package:safar_admin/public_admin/Widgets/routes.dart';
import 'package:safar_admin/public_admin/Widgets/trip.dart';
import 'package:safar_admin/public_admin/Widgets/user.dart';
import 'package:safar_admin/public_admin/dashboard/sidebar.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;

  // List of tab titles
  final List<String> tabs = [
    'Dashboard',
    'Routes',
    'User',
    'Trip',
    'Loyalty',
    'Inbox',
    'Feedback',
    'Reports',
    'Logout'
  ];

  // List of corresponding screens for each tab
  final List<Widget> screens = [
    const DashboardScreen(),
    const RoutesScreen(),
    const UserScreen(),
    const TripScreen(),
    const LoyaltyScreen(),
    const InboxScreen(),
    const FeedbackScreen(),
    const ReportsScreen(),
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
