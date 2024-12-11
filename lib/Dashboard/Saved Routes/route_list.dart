import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'route_builder.dart'; // Make sure you have RouteBuilder defined properly

class SavedRoutesList extends StatefulWidget {
  const SavedRoutesList({super.key});

  @override
  State<SavedRoutesList> createState() => _SavedRoutesListState();
}

class _SavedRoutesListState extends State<SavedRoutesList> {
  Stream<List<Map<String, dynamic>>> fetchSavedRoutes(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    return FirebaseFirestore.instance
        .collection('saved_routes')
        .where('user_id', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'fromStation': data['fromStation'],
          'toStation': data['toStation'],
          'route_name': data['route_name'],
        };
      }).toList();
    });
  }

  Future<double> getFare(String routeName) async {
    final routeDoc = await FirebaseFirestore.instance
        .collection('routes')
        .doc(routeName)
        .get();

    if (!routeDoc.exists) {
      throw Exception("Route not found");
    }

    final data = routeDoc.data();
    if (data == null || !data.containsKey('fare')) {
      throw Exception("Fare information not available");
    }

    // Convert int fare to double
    return (data['fare'] as int).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: fetchSavedRoutes(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No saved routes.'));
        }

        final savedRoutes = snapshot.data!;

        return ListView.builder(
          itemCount: savedRoutes.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final routeData = savedRoutes[index];
            final fromStation = routeData['fromStation'] ?? 'Unknown';
            final toStation = routeData['toStation'] ?? 'Unknown';
            final routeName = routeData['route_name'];
            final futureFare = getFare(routeData['route_name']);

            return RouteBuilder(
              fromStation: fromStation,
              toStation: toStation,
              imagePath: 'assets/images/station.jpeg',
              routeName: routeName,
              fare: futureFare,
            );
          },
        );
      },
    );
  }
}
