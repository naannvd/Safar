import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';

class RouteMapScreen extends StatefulWidget {
  final LatLng startLocation;
  final LatLng endLocation;

  const RouteMapScreen(
      {super.key, required this.startLocation, required this.endLocation});

  @override
  _RouteMapScreenState createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  // API Key for Google Maps (set it in your native configuration or here)
  String googleApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  @override
  void initState() {
    super.initState();
    _getPolyline();
  }

  _getPolyline() async {
    double originLatitude = widget.startLocation.latitude;
    double originLongitude = widget.startLocation.longitude;
    double destLatitude = widget.endLocation.latitude;
    double destLongitude = widget.endLocation.longitude;

    // Create a request for the polyline
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(originLatitude, originLongitude),
        destination: PointLatLng(destLatitude, destLongitude),
        mode: TravelMode.driving, // You can choose driving, walking, etc.
      ),
    );

    if (result.points.isNotEmpty) {
      // Convert result points to LatLng and add them to the polyline
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      setState(() {
        _polylines.add(Polyline(
          polylineId: const PolylineId('route'),
          color: Colors.blue,
          width: 5,
          points: polylineCoordinates,
        ));
      });
    } else {
      print(result.errorMessage);
    }
  }

  // Function to show the map in a dialog
  void _showMapDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(
              10), // Customize padding to control the dialog size
          child: SizedBox(
            height: 400, // Set the height of the dialog
            width: double.infinity,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: widget.startLocation,
                    zoom: 10.0,
                  ),
                  polylines: _polylines,
                  markers: {
                    Marker(
                      markerId: const MarkerId('start'),
                      position: widget.startLocation,
                      infoWindow: const InfoWindow(title: 'Start Location'),
                    ),
                    Marker(
                      markerId: const MarkerId('end'),
                      position: widget.endLocation,
                      infoWindow: const InfoWindow(title: 'End Location'),
                    ),
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Call this method to show the map in a dialog
        _showMapDialog(context);
      },
      child: const Text('Show Map'),
    );
  }
}
