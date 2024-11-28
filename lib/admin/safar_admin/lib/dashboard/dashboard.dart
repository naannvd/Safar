import 'package:flutter/material.dart';
import 'package:safar_admin/dashboard/main_content.dart';
// import 'package:safar_admin/dashboard/sidebar_select.dart';
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
    'Reports',
    'Settings'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Sidebar(
            selectedIndex: selectedIndex,
            tabs: tabs,
            onTabSelected: (index) {
              setState(
                () {
                  selectedIndex = index;
                },
              );
            },
          ),
          // Main Content
          Expanded(child: MainContent(selectedTab: tabs[selectedIndex])),
        ],
      ),
    );
  }
}
