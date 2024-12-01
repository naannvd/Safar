import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safar/private/Private_Logins/private_signup.dart';
import 'package:safar/widgets/custom_scaffold.dart';
import 'package:safar/widgets/welcome_button.dart';
import 'package:safar/Login/signin_screen.dart';
import 'package:safar/Login/signup_screen.dart';
import 'package:safar/private/Private_Logins/private_login.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isPublic =
      true; // State to determine whether Public or Private is selected

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Welcome Text
          Flexible(
            flex: 4,
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Welcome!\n',
                      style: GoogleFonts.montserrat(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w600,
                        // fontFamily: 'Montserrat',
                      ),
                    ),
                    TextSpan(
                      text: '\nEnter personal details to your account',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        // fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Toggle Switch
          Flexible(
            flex: 8,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    "Service Type",
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      // fontFamily: 'Montserrat',
                      color: const Color.fromARGB(255, 83, 149, 77),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Custom Toggle Button
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                    color: const Color(0xFF042F40),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Row(
                    children: [
                      // Public Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isPublic = true;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  isPublic ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Public',
                              style: GoogleFonts.montserrat(
                                fontSize: 20.0,
                                fontWeight: isPublic
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                // fontFamily: 'Montserrat',
                                color: isPublic
                                    ? const Color.fromARGB(255, 83, 149, 77)
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Private Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isPublic = false;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  !isPublic ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Private',
                              style: GoogleFonts.montserrat(
                                fontSize: 20.0,
                                fontWeight: !isPublic
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                // fontFamily: 'Montserrat',
                                color: !isPublic
                                    ? const Color.fromARGB(255, 83, 149, 77)
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                  child: WelcomeButton(
                    buttonText: 'Sign In',
                    onTap: () {
                      if (isPublic) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivateLoginScreen(),
                          ),
                        );
                      }
                    },
                    color: Colors.transparent,
                    textColor: Colors.white,
                  ),
                ),
                Expanded(
                  child: WelcomeButton(
                    buttonText: 'Sign Up',
                    onTap: () {
                      if (isPublic) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivateSignUpScreen(),
                          ),
                        );
                      }
                    },
                    color: Colors.white,
                    textColor: const Color(0xFF042F40),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
