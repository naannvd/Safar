import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:safar/Screens/routeMap.dart'; // Make sure you import your RouteMapScreen

class RouteDetails extends StatelessWidget {
  const RouteDetails({super.key, required this.routeName});

  final String routeName;

  Future<List<Map<String, dynamic>>> getStations(String routeName) async {
    try {
      final routeStations = await FirebaseFirestore.instance
          .collection('routes')
          .doc(routeName)
          .get();

      if (routeStations.exists) {
        final stationList =
            List<Map<String, dynamic>>.from(routeStations['stations'] as List);
        return stationList;
      } else {
        return [];
      }
    } catch (e) {
      print('error $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getStations(routeName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading stations'),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final stations = snapshot.data!;
            var colorVal = routeName == 'Red-Line'
                ? const Color(0xFFCC3636)
                : routeName == 'Orange-Line'
                    ? const Color(0xFFE06236)
                    : routeName == 'Green-Line'
                        ? const Color(0xFFA1CA73)
                        : const Color(0xFF3E7C98);

            return ListView.builder(
              itemCount: stations.length,
              itemBuilder: (context, index) {
                final station = stations[index];
                final stationName =
                    station['station_name'] as String? ?? 'Unknown Station';
                final longitude = station['longitude'] as double? ?? 0.0;
                final latitude = station['latitude'] as double? ?? 0.0;

                // Hardcoded start location
                final LatLng startLocation = LatLng(33.6811542, 73.2149807);

                // Station location as the end location
                final LatLng endLocation = LatLng(latitude, longitude);

                return TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY:
                      0.05, // Adjust this to increase or decrease the margin
                  isFirst: index == 0,
                  isLast: index == stations.length - 1,
                  indicatorStyle: IndicatorStyle(
                    width: 20,
                    color: colorVal,
                  ),
                  beforeLineStyle: const LineStyle(
                    color: Color(0xFF042F40),
                    thickness: 3,
                  ),
                  afterLineStyle: const LineStyle(
                    color: Color(0xFF042F40),
                    thickness: 3,
                  ),
                  startChild: Container(
                    margin: const EdgeInsets.only(right: 10),
                    // Adjust for larger left margin
                    width:
                        50, // Set this to control the width of the left margin
                    color: Colors
                        .transparent, // Transparent background to visually separate it
                  ),
                  endChild: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                stationName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Longitude: $longitude',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'Latitude: $latitude',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No stations found'),
            );
          }
        },
      ),
    );
  }
}
