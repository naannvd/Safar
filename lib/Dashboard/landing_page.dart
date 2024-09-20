import 'package:safar/Widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:safar/Widgets/starting_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // body: StartingPage()
      bottomNavigationBar: RoundedNavBar(),
    );
  }
}
