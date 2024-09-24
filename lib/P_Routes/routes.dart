import 'package:cloud_firestore/cloud_firestore.dart';

void addRoute() async {
  CollectionReference routes = FirebaseFirestore.instance.collection('routes');

  await routes.doc('route_1').set({
    'routeId': 'route_1',
    'coordinates': [
      {'lat': 33.6844, 'lng': 73.0479}, // Example coordinates for Islamabad
      {'lat': 33.7000, 'lng': 73.0500},
      {'lat': 33.7100, 'lng': 73.0600}
    ]
  }).then((_) {
    print("Route Added!");
  }).catchError((error) {
    print("Failed to add route: $error");
  });
}
