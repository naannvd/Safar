import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safar/Widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<String> fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    // try {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return userData['fullName'];
    // } catch (e) {}
  }

  Future<String> fetchEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return userData['email'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: fetchUsername(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          AssetImage('assets/profile_placeholder.jpg'),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${snapshot.data}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FutureBuilder(
                        future: fetchEmail(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text('${snapshot.data}',
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  color: const Color(0xFF042F40),
                                  fontWeight: FontWeight.w500));
                        },
                      ),
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          _buildProfileOption(
                            Icons.edit,
                            'Edit Profile',
                            () {},
                            const Color(0xFF042F40),
                          ),
                          _buildProfileOption(
                            Icons.discount,
                            'Discount',
                            () {},
                            const Color(0xFF042F40),
                          ),
                          _buildProfileOption(
                            Icons.support,
                            'Support',
                            () {},
                            const Color(0xFF042F40),
                          ),
                          _buildProfileOption(
                            Icons.settings,
                            'Setting',
                            () {},
                            const Color(0xFF042F40),
                          ),
                          _buildProfileOption(Icons.logout, 'Logout', () {
                            FirebaseAuth.instance.signOut();
                          }, Colors.red),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
      bottomNavigationBar: const RoundedNavBar(currentTab: 'Profile'),
    );
  }

  Widget _buildProfileOption(
      IconData icon, String title, VoidCallback onTap, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFA1CA73),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: Icon(icon, color: color),
          title: Text(
            title,
            style: GoogleFonts.montserrat(
                color: color, fontWeight: FontWeight.w500, fontSize: 16),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: color,
            size: 15,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
