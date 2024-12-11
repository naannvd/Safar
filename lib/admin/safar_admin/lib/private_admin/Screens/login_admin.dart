import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safar_admin/public_admin/dashboard/main_screen.dart';
import 'package:safar_admin/public_admin/Screens/signup_admin.dart';

class AdminLoginPage extends StatelessWidget {
  const AdminLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            margin: const EdgeInsets.all(320),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome Admin',
                  style: GoogleFonts.montserrat(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFA1CA73), // Primary color
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Login to your account',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: const Color(0xFF042F42),
                  ),
                ),
                const SizedBox(height: 32),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Color(0xFF042F42)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF042F42)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Security Code',
                      prefixIcon:
                          Icon(Icons.security, color: Color(0xFF042F42)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Forgot password action
                    },
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.montserrat(
                          color: const Color(0xFF042F42)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Login action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA1CA73),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: GestureDetector(
                    child: Text(
                      'Login',
                      style: GoogleFonts.montserrat(
                          fontSize: 18,
                          color: const Color(0xFF042F42),
                          fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdminDashboard()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminSignUpPage()),
                    );
                  },
                  child: Text(
                    "Don't have an account? Sign Up",
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
