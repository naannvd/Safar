import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FullMapScreen extends StatefulWidget {
  final String rideId;

  const FullMapScreen({super.key, required this.rideId});

  @override
  State<FullMapScreen> createState() => _FullMapScreenState();
}

class _FullMapScreenState extends State<FullMapScreen> {
  GoogleMapController? _mapController;
  LatLng? _driverLocation;
  Set<Marker> _markers = {};
  final Location _location = Location();

  @override
  void initState() {
    super.initState();
    _fetchDriverLocation();
    _fetchParentLocations();
  }

  Future<void> _fetchDriverLocation() async {
    try {
      final locationData = await _location.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _driverLocation =
              LatLng(locationData.latitude!, locationData.longitude!);

          // Add driver marker
          _markers.add(
            Marker(
              markerId: const MarkerId("driver"),
              position: _driverLocation!,
              infoWindow: const InfoWindow(title: "Driver Location"),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
            ),
          );
        });
      }
    } catch (e) {
      print("Error fetching driver's location: $e");
    }
  }

  Future<void> _fetchParentLocations() async {
    try {
      final rideSnapshot = await FirebaseFirestore.instance
          .collection('rides')
          .doc(widget.rideId)
          .get();

      if (rideSnapshot.exists) {
        final rideData = rideSnapshot.data() as Map<String, dynamic>;
        final List<dynamic> studentIds = rideData['students'] ?? [];

        for (String studentId in studentIds) {
          final studentSnapshot = await FirebaseFirestore.instance
              .collection('childs')
              .doc(studentId)
              .get();

          if (studentSnapshot.exists) {
            final studentData = studentSnapshot.data() as Map<String, dynamic>;
            final parentId = studentData['parent_id'];

            if (parentId != null) {
              final parentSnapshot = await FirebaseFirestore.instance
                  .collection('parent_locations')
                  .doc(parentId)
                  .get();

              if (parentSnapshot.exists) {
                final parentData =
                    parentSnapshot.data() as Map<String, dynamic>;
                final lat = parentData['latitude'];
                final lng = parentData['longitude'];

                if (lat != null && lng != null) {
                  setState(() {
                    _markers.add(
                      Marker(
                        markerId: MarkerId(parentId),
                        position: LatLng(lat, lng),
                        infoWindow: InfoWindow(
                            title: "Parent of ${studentData['child_name']}"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueGreen),
                      ),
                    );
                  });
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print("Error fetching parent locations: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Map View'),
        backgroundColor: const Color(0xFF042F42),
      ),
      body: _driverLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
                if (_driverLocation != null) {
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(_driverLocation!, 14.0),
                  );
                }
              },
              initialCameraPosition: CameraPosition(
                target: _driverLocation ?? LatLng(0, 0),
                zoom: 14.0,
              ),
              markers: _markers,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
            ),
    );
  }
}
