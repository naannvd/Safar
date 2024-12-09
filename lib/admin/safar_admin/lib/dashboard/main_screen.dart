import 'package:flutter/material.dart';
import 'package:safar_admin/Widgets/dashboard.dart';
import 'package:safar_admin/Widgets/feedbacks.dart';
import 'package:safar_admin/Widgets/inbox.dart';
import 'package:safar_admin/Widgets/notification.dart';
import 'package:safar_admin/Widgets/reports.dart';
import 'package:safar_admin/Widgets/settings.dart';
import 'package:safar_admin/Widgets/trip.dart';
import 'package:safar_admin/Widgets/user.dart';
import 'package:safar_admin/dashboard/login_screen.dart';
import 'package:safar_admin/dashboard/sidebar.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;
  final List<String> tabs = [
    'Dashboard',
    'Routes',
    'User',
    'Trip',
    'Notifications',
    'Inbox',
    'Feedback',
    'Reports',
    'Settings',
    'Logout'
  ];
  final List<Widget> screens = [
    const DashboardScreen(),
    const TripScreen(),
    const UserScreen(),
    const TripScreen(),
    const TicketsScreen(),
    const InboxScreen(),
    const FeedbackScreen(),
    const ReportsScreen(),
    const SettingsScreen(),
    const LoginScreen(),
  ];

  void logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
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
            onTabSelected: (index) {
              setState(() {
                if (index == tabs.length - 1) {
                  logout(context);
                } else {
                  selectedIndex = index;
                }
              });
            },
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: screens[selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
