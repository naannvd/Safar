import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safar/Dashboard/landing_page.dart';
import 'package:safar/Screens/ticket.dart';
import 'package:safar/Screens/welcome_screen.dart';
// import 'package:flutter/widgets.dart';
import 'package:safar/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'package:safar/Widgets/starting_page.dart';
import 'package:google_fonts/google_fonts.dart';

final font = GoogleFonts.montserrat();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
          displayLarge: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Color(0xFF042F42),
            ),
          ),
          bodyMedium: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF042F42),
            ),
          ),
          displayMedium: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF042F42),
            ),
          ),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            return const WelcomeScreen();
          }
          return const WelcomeScreen();
        },
      ),
    );
  }
}
