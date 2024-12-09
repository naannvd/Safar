import 'package:flutter/material.dart';
import 'package:safar_admin/Widgets/dashboard.dart';
import 'package:safar_admin/Widgets/feedbacks.dart';
import 'package:safar_admin/Widgets/inbox.dart';
import 'package:safar_admin/Widgets/notification.dart';
import 'package:safar_admin/Widgets/reports.dart';
import 'package:safar_admin/Widgets/settings.dart';
import 'package:safar_admin/Widgets/trip.dart';
import 'package:safar_admin/Widgets/user.dart';
<<<<<<< HEAD
=======
import 'package:safar_admin/dashboard/login_screen.dart';
>>>>>>> backup2
import 'package:safar_admin/dashboard/sidebar.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;
<<<<<<< HEAD

  // List of tab titles
=======
>>>>>>> backup2
  final List<String> tabs = [
    'Dashboard',
    'Routes',
    'User',
    'Trip',
    'Notifications',
    'Inbox',
    'Feedback',
    'Reports',
<<<<<<< HEAD
    'Settings'
  ];

  // List of corresponding screens for each tab
=======
    'Settings',
    'Logout'
  ];
>>>>>>> backup2
  final List<Widget> screens = [
    const DashboardScreen(),
    const TripScreen(),
    const UserScreen(),
    const TripScreen(),
<<<<<<< HEAD
    const NotificationsScreen(),
=======
    const TicketsScreen(),
>>>>>>> backup2
    const InboxScreen(),
    const FeedbackScreen(),
    const ReportsScreen(),
    const SettingsScreen(),
<<<<<<< HEAD
  ];

=======
    const LoginScreen(),
  ];

  void logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

>>>>>>> backup2
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
<<<<<<< HEAD
                selectedIndex = index;
              });
            },
          ),
          // Main Content dynamically updates based on the selected tab
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: screens[selectedIndex], // Display the selected screen
=======
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
>>>>>>> backup2
            ),
          ),
        ],
      ),
    );
  }
}
