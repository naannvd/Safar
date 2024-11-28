import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({
    super.key,
    required this.buttonText,
    required this.onTap,
    required this.color,
    required this.textColor,
  });

  final String buttonText;
  final VoidCallback onTap; // Expect a function to execute on tap
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Call the provided function when the button is tapped
      child: Container(
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
          ),
        ),
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            color: textColor,
          ),
        ),
      ),
    );
  }
}
