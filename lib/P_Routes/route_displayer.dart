import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteDisplayWidget extends StatefulWidget {
  final LatLng userLocation;
  final LatLng stationLocation;
  final List<LatLng> routePoints;

  const RouteDisplayWidget(
      {super.key,
      required this.userLocation,
      required this.stationLocation,
      required this.routePoints});

  @override
  State<RouteDisplayWidget> createState() => _RouteDisplayWidgetState();
}

class _RouteDisplayWidgetState extends State<RouteDisplayWidget> {
  GoogleMapController? _mapController;

  Set<Marker> get _markers => {
        Marker(
          markerId: const MarkerId('user'),
          position: widget.userLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
        Marker(
          markerId: const MarkerId('station'),
          position: widget.stationLocation,
          icon: BitmapDescriptor.defaultMarker,
        ),
      };

  Set<Polyline> get _polylines => {
        Polyline(
          polylineId: const PolylineId('route'),
          color: Colors.blue,
          width: 5,
          points: widget.routePoints,
        ),
      };

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.userLocation,
        zoom: 14.0,
      ),
      markers: _markers,
      polylines: _polylines,
      onMapCreated: (controller) {
        _mapController = controller;
      },
    );
  }
}
