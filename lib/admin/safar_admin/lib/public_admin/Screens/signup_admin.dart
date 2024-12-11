import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminSignUpPage extends StatelessWidget {
  const AdminSignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            margin: const EdgeInsets.all(350),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Create Account',
                  style: GoogleFonts.montserrat(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFA1CA73), // Primary color
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon:
                        const Icon(Icons.person, color: Color(0xFF042F42)),
                    labelStyle:
                        GoogleFonts.montserrat(color: const Color(0xFF042F42)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon:
                        const Icon(Icons.email, color: Color(0xFF042F42)),
                    labelStyle:
                        GoogleFonts.montserrat(color: const Color(0xFF042F42)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon:
                        const Icon(Icons.lock, color: Color(0xFF042F42)),
                    labelStyle:
                        GoogleFonts.montserrat(color: const Color(0xFF042F42)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon:
                        const Icon(Icons.lock, color: Color(0xFF042F42)),
                    labelStyle:
                        GoogleFonts.montserrat(color: const Color(0xFF042F42)),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Sign-up action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA1CA73),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text('Sign Up',
                      style: GoogleFonts.montserrat(
                          fontSize: 18, color: const Color(0xFF042F42))),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Already have an account? Login",
                    style:
                        GoogleFonts.montserrat(color: const Color(0xFF042F42)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
