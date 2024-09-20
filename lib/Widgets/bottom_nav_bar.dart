import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoundedNavBar extends StatefulWidget {
  const RoundedNavBar({super.key});

  @override
  State<RoundedNavBar> createState() => _RoundedNavBarState();
}

class _RoundedNavBarState extends State<RoundedNavBar> {
  String activeTab = 'Home';

  final List<Map<String, dynamic>> navItems = [
    {'name': 'Home', 'icon': FontAwesomeIcons.house},
    {'name': 'Ticket', 'icon': FontAwesomeIcons.ticket},
    {'name': 'Profile', 'icon': FontAwesomeIcons.user},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF042F40), // Dark blue background
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(
          bottom: 30, left: 20, right: 20), // Adjust for symmetry
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.map((item) {
          bool isActive = activeTab == item['name'];
          return GestureDetector(
            onTap: () {
              setState(() {
                activeTab = item['name'];
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                horizontal:
                    isActive ? 20 : 0, // Add horizontal padding for active tab
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFFA1CA73)
                    : Colors
                        .transparent, // Green for active, transparent for inactive
                borderRadius: BorderRadius.circular(30), // Rounded pill shape
              ),
              child: Row(
                children: [
                  FaIcon(
                    item['icon'],
                    color: isActive
                        ? const Color(
                            0xFF042F40) // Dark blue icon for active tab
                        : const Color(
                            0xFFA1CA73), // Green icon for inactive tabs
                    size: 20,
                  ),
                  if (isActive) ...[
                    const SizedBox(
                        width: 8), // Space between icon and text in active tab
                    Text(item['name'],
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
