import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:safar/P_Routes/route_card.dart';

class RoutesMain extends StatelessWidget {
  const RoutesMain({super.key});

  // Function to get routes from Firestore
  Future<List<String>> getRoutes() async {
    try {
      final routesSnapshot =
          await FirebaseFirestore.instance.collection('routes').get();
      return routesSnapshot.docs
          .map((doc) => doc['route_name'] as String)
          .toList();
    } catch (e) {
      print('Error fetching routes: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 100), // Spacing at the top
          Text(
            'Metro Routes',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 80),
          // Using FutureBuilder to dynamically get routes
          Expanded(
            child: FutureBuilder<List<String>>(
              future: getRoutes(), // Call the function that fetches the routes
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting for the data, show a loading indicator
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error loading routes'),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final routes = snapshot.data!;
                  final double cardHeight = 150;
                  final double containerHeight = cardHeight * routes.length;

                  return SizedBox(
                    height: containerHeight,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: routes.length,
                      itemBuilder: (context, index) {
                        return RouteCard(
                          routeName: routes[index],
                          index: index,
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('No routes available'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
