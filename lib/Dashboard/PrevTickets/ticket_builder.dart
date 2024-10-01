import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TicketBuilder extends StatelessWidget {
  const TicketBuilder({
    super.key,
    required this.month,
    required this.day,
    required this.fromStation,
    required this.toStation,
    required this.isReversed,
  });

  final String month;
  final String day;
  final String fromStation;
  final String toStation;
  final bool isReversed;

  @override
  Widget build(BuildContext context) {
    // Colors depending on whether the card is reversed
    final backgroundColor = isReversed ? Colors.white : const Color(0xFFA1CA73);
    final foregroundColor = isReversed ? const Color(0xFFA1CA73) : Colors.white;

    return SizedBox(
      width: 180,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 10,
        color: backgroundColor, // Background changes based on `isReversed`
        margin: const EdgeInsets.only(top: 10, left: 20, right: 0, bottom: 10),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 8, top: 17, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                month,
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color:
                      foregroundColor, // Foreground changes based on `isReversed`
                ),
              ),
              const SizedBox(height: 8),
              Text(
                day,
                style: GoogleFonts.montserrat(
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                  color: foregroundColor,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.radio_button_unchecked,
                    size: 9,
                    color: foregroundColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    fromStation,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: foregroundColor,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 1,
                    height: 30,
                    color:
                        foregroundColor, // White dotted line changes to foreground color
                    margin:
                        const EdgeInsets.only(left: 4), // Center it with dots
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 9,
                    color: foregroundColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    toStation,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: foregroundColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
