import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:safar/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';

import 'package:safar/Dashboard/landing_page.dart';
// import 'package:safar/Widgets/starting_page.dart';
import 'package:google_fonts/google_fonts.dart';

final font = GoogleFonts.montserrat();
void main() async {
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(
            0xFFA1CA73,
          ),
        ),
        textTheme: TextTheme(
          bodyLarge: GoogleFonts.montserrat(
            textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Color(0xFF042F42),
                letterSpacing: 1.5),
          ),
          titleLarge: const TextStyle(
              fontFamily: "TitleFont",
              fontSize: 73,
              fontWeight: FontWeight.bold,
              color: Color(0xFF042F42),
              letterSpacing: 3.9),
          bodyMedium: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF042F42),
            ),
          ),
        ),
      ),
      home: const LandingPage(),
    );
  }
}
