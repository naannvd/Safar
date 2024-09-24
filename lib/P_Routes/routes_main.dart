import 'package:flutter/material.dart';
import 'package:safar/P_Routes/route_card.dart';

class RoutesMain extends StatelessWidget {
  const RoutesMain({super.key});

  @override
  Widget build(BuildContext context) {
    final routes = [
      'Red-Line',
      'Orange-Line',
      'Green-Line',
      'Blue-Line',
    ];

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50), // Example for spacing at the top
          const Text(
            'Metro Routes',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            // Use Expanded to give ListView remaining space
            child: ListView.builder(
              itemCount: routes.length,
              itemBuilder: (context, index) {
                return RouteCard(routeName: routes[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
