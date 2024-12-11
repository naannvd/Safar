import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safar_admin/private_admin/dashboard/sidebar_select.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final List<String> tabs;
  final Function(int) onTabSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.tabs,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Fixed width for sidebar
      decoration: const BoxDecoration(color: Color(0xFF2a4574)),
      child: Column(
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50,
                  child: Text("SA"),
                ),
                const SizedBox(height: 16),
                Text(
                  "Syed Areeb",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                      right: 12.0, left: 12.0, bottom: 5, top: 8),
                  child: Divider(),
                )
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                return SidebarTile(
                  icon: getIconForTab(index),
                  title: tabs[index],
                  isSelected: selectedIndex == index,
                  onTap: () {
                    onTabSelected(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Get appropriate icon for each tab
  IconData getIconForTab(int index) {
    switch (index) {
      case 0:
        return Icons.dashboard;
      case 1:
        return Icons.people;
      case 2:
        return Icons.settings;
      case 3:
        return Icons.logout;
      default:
        return Icons.dashboard;
    }
  }
}
