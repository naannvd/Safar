import 'package:flutter/material.dart';
import 'package:safar_admin/Widgets/dashboard.dart';
import 'package:safar_admin/Widgets/feedbacks.dart';
import 'package:safar_admin/Widgets/inbox.dart';
import 'package:safar_admin/Widgets/notification.dart';
import 'package:safar_admin/Widgets/reports.dart';
import 'package:safar_admin/Widgets/settings.dart';
import 'package:safar_admin/Widgets/trip.dart';
import 'package:safar_admin/Widgets/user.dart';
import 'package:safar_admin/dashboard/sidebar.dart';

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
    'Notifications',
    'Inbox',
    'Feedback',
    'Reports',
    'Settings'
  ];

  // List of corresponding screens for each tab
  final List<Widget> screens = [
    const DashboardScreen(),
    const TripScreen(),
    const UserScreen(),
    const TripScreen(),
    const NotificationsScreen(),
    const InboxScreen(),
    const FeedbackScreen(),
    const ReportsScreen(),
    const SettingsScreen(),
  ];

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
            onTabSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          // Main Content dynamically updates based on the selected tab
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: screens[selectedIndex], // Display the selected screen
            ),
          ),
        ],
      ),
    );
  }
}
