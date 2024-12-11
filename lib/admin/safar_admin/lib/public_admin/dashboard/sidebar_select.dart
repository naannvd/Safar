import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SidebarTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const SidebarTile({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 17, 32, 57)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          leading: Icon(icon,
              color: isSelected ? const Color(0xFFA1CA73) : Colors.white),
          title: Text(
            title,
            style: GoogleFonts.montserrat(
              color: isSelected ? const Color(0xFFA1CA73) : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          tileColor:
              isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          onTap: onTap,
        ),
      ),
    );
  }
}
