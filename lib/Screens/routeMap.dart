import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';

class RouteMapScreen extends StatefulWidget {
  final LatLng startLocation;
  final LatLng endLocation;

  RouteMapScreen({required this.startLocation, required this.endLocation});

  @override
  _RouteMapScreenState createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  // API Key for Google Maps (set it in your native configuration or here)
  String googleApiKey = 'AIzaSyD4KSX8nkp7JTb7WqOFk_HU1Cn-lXH9lrg';

  @override
  void initState() {
    super.initState();
    _getPolyline();
  }

  _getPolyline() async {
    // Make sure to replace _originLatitude and _originLongitude with actual variables from your widget
    double _originLatitude = widget.startLocation.latitude;
    double _originLongitude = widget.startLocation.longitude;
    double _destLatitude = widget.endLocation.latitude;
    double _destLongitude = widget.endLocation.longitude;

    // Create a request for the polyline
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(_originLatitude, _originLongitude),
        destination: PointLatLng(_destLatitude, _destLongitude),
        mode: TravelMode.driving, // You can choose driving, walking, etc.
        // wayPoints: [
        //   // Add waypoints if needed (optional)
        //   PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")
        // ],
      ),
    );

    // Check if the result contains points
    if (result.points.isNotEmpty) {
      // Convert result points to LatLng and add them to the polyline
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      // Update state with the new polyline
      setState(() {
        _polylines.add(Polyline(
          polylineId: PolylineId('route'),
          color: Colors.blue,
          width: 5,
          points: polylineCoordinates,
        ));
      });
    } else {
      // Handle the case where no points are found (e.g., error in API call)
      print(result.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.startLocation,
          zoom: 6.0,
        ),
        polylines: _polylines,
        markers: {
          Marker(
            markerId: MarkerId('start'),
            position: widget.startLocation,
            infoWindow: InfoWindow(title: 'Start Location'),
          ),
          Marker(
            markerId: MarkerId('end'),
            position: widget.endLocation,
            infoWindow: InfoWindow(title: 'End Location'),
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
