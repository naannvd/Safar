import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final Set<Polyline> _polylines = {};
  final List<LatLng> _routeCoordinates = [];

  @override
  void initState() {
    super.initState();
    _fetchRouteData();
  }

  void _fetchRouteData() async {
    // Fetch the route data from Firestore
    FirebaseFirestore.instance
        .collection('routes')
        .doc('route_1') // Example route ID
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        List<dynamic> coordinates = data['coordinates'];

        // Convert the coordinates into a list of LatLng
        for (var coord in coordinates) {
          _routeCoordinates.add(LatLng(coord['lat'], coord['lng']));
        }

        setState(() {
          // Create a polyline from the route coordinates
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route_1'),
              points: _routeCoordinates,
              color: Colors.blue,
              width: 5,
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(33.6844, 73.0479), // Initial position
          zoom: 12,
        ),
        polylines: _polylines,
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
