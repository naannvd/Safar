import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safar/P_Routes/Services/directions_service.dart';
import 'package:safar/P_Routes/Services/location_service.dart';
import 'package:safar/P_Routes/Services/stations_repository.dart';
import 'package:safar/P_Routes/closest_station.dart';
import 'package:safar/P_Routes/route_card.dart';

// Create instances of your services here.
// Make sure you have a valid API key for DirectionsService and set up Firebase first.
final locationService = LocationService();
final stationsRepository = StationsRepository(
  firestore: FirebaseFirestore.instance,
);
final directionsService =
    DirectionsService(apiKey: 'AIzaSyD4KSX8nkp7JTb7WqOFk_HU1Cn-lXH9lrg');

class RoutesMain extends StatelessWidget {
  const RoutesMain({super.key});

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
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: AnimatedButton(
              height: 50,
              width: 200,
              text: 'Nearest Station?',
              isReverse: true,
              selectedTextColor: const Color(0xFF042F42),
              transitionType: TransitionType.LEFT_TO_RIGHT,
              textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
              backgroundColor: const Color(0xFFA1CA73),
              borderColor: Colors.white,
              borderRadius: 50,
              borderWidth: 2,
              onPress: () {
                // Navigate to the ClosestStation screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClosestStation(
                      locationService: locationService,
                      stationsRepository: stationsRepository,
                      directionsService: directionsService,
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: FutureBuilder<List<String>>(
              future: getRoutes(),
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
                  const double cardHeight = 150;
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
