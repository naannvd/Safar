import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safar/Screens/routeMap.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Define start and end LatLng locations
            LatLng startLocation =
                LatLng(33.6799499, 73.2479871); // San Francisco
            LatLng endLocation = LatLng(33.6811542, 73.2149807); // Los Angeles

            // Navigate to RouteMapScreen and pass LatLng values
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RouteMapScreen(
                  startLocation: startLocation,
                  endLocation: endLocation,
                ),
              ),
            );
          },
          child: Text('Show Route on Map'),
        ),
      ),
    );
  }
}
