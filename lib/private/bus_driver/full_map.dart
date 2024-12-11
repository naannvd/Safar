import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class FullMapScreen extends StatefulWidget {
  final String rideId;

  const FullMapScreen({super.key, required this.rideId});

  @override
  State<FullMapScreen> createState() => _FullMapScreenState();
}

class _FullMapScreenState extends State<FullMapScreen> {
  LocationData? _currentLocation;
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final String _googleApiKey = "AIzaSyD4KSX8nkp7JTb7WqOFk_HU1Cn-lXH9lrg";

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
    _fetchParentsLocations();
  }

  Future<void> _fetchCurrentLocation() async {
    final location = Location();
    try {
      final currentLocation = await location.getLocation();
      setState(() {
        _currentLocation = currentLocation;
      });
      if (_mapController != null &&
          currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(currentLocation.latitude!, currentLocation.longitude!),
            14.0,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching location: $e')),
      );
    }
  }

  Future<void> _fetchParentsLocations() async {
    final List<LatLng> parentLocations = [];

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('childs')
          .where('is_present', isEqualTo: true)
          .get();

      for (var doc in querySnapshot.docs) {
        final parentId = doc['parent_id'];
        final parentDoc = await FirebaseFirestore.instance
            .collection('parents')
            .doc(parentId)
            .get();

        if (parentDoc.exists) {
          final lat = parentDoc['latitude'];
          final lng = parentDoc['longitude'];

          if (lat != null && lng != null) {
            final location = LatLng(lat, lng);
            if (!parentLocations.contains(location)) {
              parentLocations.add(location);
              _markers.add(
                Marker(
                  markerId: MarkerId(parentId),
                  position: location,
                  infoWindow: const InfoWindow(title: 'Parent Location'),
                ),
              );
            }
          }
        }
      }

      if (_currentLocation != null) {
        await _createPolylines(_currentLocation!, parentLocations);
      }

      setState(() {}); // Refresh the map with markers and polylines
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching parent locations: $e')),
      );
    }
  }

  Future<void> _createPolylines(
      LocationData driverLocation, List<LatLng> parentLocations) async {
    final driverLatLng =
        LatLng(driverLocation.latitude!, driverLocation.longitude!);

    for (var parentLatLng in parentLocations) {
      try {
        final polylinePoints =
            await _getPolylinePoints(driverLatLng, parentLatLng);
        _polylines.add(
          Polyline(
            polylineId: PolylineId('polyline_${parentLatLng.hashCode}'),
            points: polylinePoints,
            color: Colors.blue,
            width: 4,
          ),
        );
      } catch (e) {
        print("Error creating polyline: $e");
      }
    }
  }

  Future<List<LatLng>> _getPolylinePoints(LatLng start, LatLng end) async {
    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$_googleApiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final points = data['routes'][0]['overview_polyline']['points'];
      return _decodePolyline(points);
    } else {
      throw Exception("Failed to fetch directions");
    }
  }

  List<LatLng> _decodePolyline(String polyline) {
    final List<LatLng> points = [];
    int index = 0;
    int len = polyline.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int shift = 0;
      int result = 0;
      int b;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dLat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dLng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _currentLocation != null
          ? GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentLocation!.latitude!,
                  _currentLocation!.longitude!,
                ),
                zoom: 14.0,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
