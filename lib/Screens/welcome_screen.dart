import 'package:flutter/material.dart';
import 'package:safar/widgets/custom_scaffold.dart';
import 'package:safar/widgets/welcome_button.dart';
import 'package:safar/Login/signin_screen.dart';
import 'package:safar/Login/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
            flex: 8,
            child: Container(
              // decoration: BoxDecoration(
              //   gradient: LinearGradient(colors: [
              //     const Color(0x00A1CA73),
              //     const Color(0xD55D9B3B)
              //   ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
              // ),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Welcome!\n',
                        style: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      TextSpan(
                        text: '\nEnter personal details to your account',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Flexible(
            flex: 1,
            child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    Expanded(
                      child: WelcomeButton(
                        buttonText: 'Sign In',
                        onTap: SignInScreen(),
                        color: Colors.transparent,
                        textColor: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: WelcomeButton(
                        buttonText: 'Sign Up',
                        onTap: SignUpScreen(),
                        color: Colors.white,
                        textColor: Colors.red,
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
