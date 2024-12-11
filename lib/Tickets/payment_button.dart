import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentButton extends StatelessWidget {
  const PaymentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // _completeTicket(context);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const LandingPage()),
        // );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: const BoxDecoration(
          color: Color(0xFF042F42),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text(
            'Complete Ticket',
            style: GoogleFonts.montserrat(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
