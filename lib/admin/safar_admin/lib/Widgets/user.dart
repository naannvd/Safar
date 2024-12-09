import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  Future<Map<String, double>> fetchRouteUsage() async {
    try {
      // Fetch all tickets
      final snapshot =
          await FirebaseFirestore.instance.collection('tickets').get();

      // Group tickets by routeName
      final routeCounts = <String, int>{};
      for (var doc in snapshot.docs) {
        final routeName = doc.data()['routeName'] ?? 'Unknown';
        routeCounts[routeName] = (routeCounts[routeName] ?? 0) + 1;
      }

      // Calculate percentages
      final totalTickets =
          routeCounts.values.fold(0, (sum, count) => sum + count);
      final routePercentages = routeCounts.map(
        (route, count) => MapEntry(route, (count / totalTickets) * 100),
      );

      return routePercentages;
    } catch (e) {
      print("Error fetching route usage: $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Statistics',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, double>>(
        future: fetchRouteUsage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No data available or an error occurred."),
            );
          }

          final routePercentages = snapshot.data!;
          final routeLabels = routePercentages.keys.toList();
          final routeValues = routePercentages.values.toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Route Usage Percentage',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: routeLabels.asMap().entries.map((entry) {
                        final index = entry.key;
                        final routeName = entry.value;
                        final percentage = routeValues[index];

                        return PieChartSectionData(
                          color: _getRouteColor(routeName),
                          value: percentage,
                          title: '${percentage.toStringAsFixed(1)}%',
                          radius: 80,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                      sectionsSpace: 4,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Route Legends
                Column(
                  children: routeLabels.map((routeName) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: _getRouteColor(routeName),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          routeName,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper to assign colors to each route
  Color _getRouteColor(String routeName) {
    switch (routeName) {
      case 'Blue-Line':
        return Colors.blue;
      case 'Green-Line':
        return Colors.green;
      case 'Orange-Line':
        return Colors.orange;
      case 'Red-Line':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
