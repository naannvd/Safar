import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safar/private/Private_Dashboards/child_dashboard.dart';
import 'package:safar/private/Private_Dashboards/driver_dashboard.dart';
import 'package:safar/private/Private_Dashboards/parent_dashboard.dart';
import 'package:safar/private/Private_Dashboards/schoolauth_dashboard.dart';
import 'package:safar/Login/forgot_password.dart';
import 'package:safar/Widgets/custom_scaffold.dart';
import 'package:safar/private/bus_driver/driver_dashboard.dart';
import 'package:safar/private/child/child_dashboard.dart';
import 'package:safar/private/parent/dashboard.dart';

class PrivateLoginScreen extends StatefulWidget {
  const PrivateLoginScreen({super.key});

  @override
  State<PrivateLoginScreen> createState() => _PrivateLoginScreenState();
}

class _PrivateLoginScreenState extends State<PrivateLoginScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool rememberPassword = true;
  String _selectedUserType = 'Parent'; // Default user type

  // Method to sign in the user
  Future<void> _signInUser() async {
    if (_formSignInKey.currentState!.validate()) {
      try {
        // Authenticate user with Firebase
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Get the UID of the authenticated user
        String uid = userCredential.user!.uid;

        // Check the user's role in Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection(
                "${_selectedUserType.toLowerCase()}s") // Dynamically fetch collection
            .doc(uid) // Match the UID with the document ID
            .get();

        if (userDoc.exists && userDoc['role'] == _selectedUserType) {
          // Navigate to the respective dashboard
          Widget dashboard;
          if (_selectedUserType == 'Parent') {
            dashboard = const ParentDashboard();
          } else if (_selectedUserType == 'Child') {
            dashboard = const ChildDashboard();
          } else if (_selectedUserType == 'School Authority') {
            dashboard = const SchoolAuthDashboardScreen();
          } else {
            dashboard = const DriverDashboard();
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => dashboard,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'You are not authorized to log in as the selected category.'),
            ),
          );

          // Sign out the user since the role doesn't match
          await FirebaseAuth.instance.signOut();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user found for that email.')),
          );
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wrong password provided.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.message}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25, 50, 25, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Form(
                key: _formSignInKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10.0),
                      const Text(
                        'Welcome!\n',
                        style: TextStyle(
                          color: Color(0xFF042F40),
                          fontSize: 35.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      // User Type Dropdown
                      DropdownButtonFormField<String>(
                        dropdownColor: Colors.white,
                        value: _selectedUserType,
                        items: [
                          DropdownMenuItem(
                            value: 'Parent',
                            child:
                                Text('Parent', style: GoogleFonts.montserrat()),
                          ),
                          DropdownMenuItem(
                            value: 'Child',
                            child:
                                Text('Child', style: GoogleFonts.montserrat()),
                          ),
                          DropdownMenuItem(
                            value: 'Driver',
                            child:
                                Text('Driver', style: GoogleFonts.montserrat()),
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: 'User Type',
                          labelStyle: const TextStyle(fontFamily: 'Montserrat'),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                          ),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedUserType = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text(
                            'Email',
                            style: TextStyle(fontFamily: 'Montserrat'),
                          ),
                          hintText: 'Enter Email',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                            fontFamily: 'Montserrat',
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        obscuringCharacter: "*",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text(
                            'Password',
                            style: TextStyle(fontFamily: 'Montserrat'),
                          ),
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                            fontFamily: 'Montserrat',
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberPassword,
                                onChanged: (bool? value) {
                                  setState(() {
                                    rememberPassword = value!;
                                  });
                                },
                                activeColor: Colors.blue.shade800,
                              ),
                              const Text(
                                'Remember me',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontFamily: 'Montserrat',
                                ),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordScreen()),
                              );
                            },
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      Visibility(
                        visible: MediaQuery.of(context).viewInsets.bottom == 0,
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFA1CA73),
                              ),
                            ),
                            onPressed: _signInUser, // Call the sign-in method
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
