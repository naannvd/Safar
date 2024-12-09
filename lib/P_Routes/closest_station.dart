import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safar/P_Routes/Services/directions_service.dart';
import 'package:safar/P_Routes/Services/distance_calculator.dart';
import 'package:safar/P_Routes/Services/location_service.dart';
import 'package:safar/P_Routes/Services/stations_repository.dart';
import 'package:safar/P_Routes/route_displayer.dart';
import 'package:safar/P_Routes/station_info.dart';

class ClosestStation extends StatefulWidget {
  final LocationService locationService;
  final StationsRepository stationsRepository;
  final DirectionsService directionsService;

  const ClosestStation({
    super.key,
    required this.locationService,
    required this.stationsRepository,
    required this.directionsService,
  });

  @override
  State<ClosestStation> createState() => _ClosestStationState();
}

class _ClosestStationState extends State<ClosestStation> {
  LatLng? _userLocation;
  Map<String, dynamic>? _nearestStation;
  List<LatLng> _routePoints = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _findAndDisplayNearestStation();
  }

  Future<void> _findAndDisplayNearestStation() async {
    setState(() => _isLoading = true);
    try {
      final position = await widget.locationService.getUserLocation();
      _userLocation = LatLng(position.latitude, position.longitude);

      final stations = await widget.stationsRepository.fetchStations();
      _nearestStation = _findNearestStation(stations, _userLocation!);

      if (_nearestStation != null) {
        _routePoints = await widget.directionsService.getRoutePolyline(
          _userLocation!.latitude,
          _userLocation!.longitude,
          _nearestStation!['latitude'],
          _nearestStation!['longitude'],
        );
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Map<String, dynamic>? _findNearestStation(
      List<Map<String, dynamic>> stations, LatLng userLoc) {
    double minDistance = double.infinity;
    Map<String, dynamic>? nearest;
    for (var station in stations) {
      final dist = DistanceCalculator.haversineDistance(userLoc.latitude,
          userLoc.longitude, station['latitude'], station['longitude']);

      if (dist < minDistance) {
        minDistance = dist;
        nearest = station;
      }
    }
    return nearest;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(_errorMessage!)),
      );
    }

    if (_userLocation == null || _nearestStation == null) {
      return const Scaffold(
        body: Center(child: Text('No location or station data available.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Nearest Station Route')),
      body: Column(
        children: [
          Expanded(
            child: RouteDisplayWidget(
              userLocation: _userLocation!,
              stationLocation: LatLng(
                  _nearestStation!['latitude'], _nearestStation!['longitude']),
              routePoints: _routePoints,
            ),
          ),
          StationInfoWidget(station: _nearestStation!),
        ],
      ),
    );
  }
}
