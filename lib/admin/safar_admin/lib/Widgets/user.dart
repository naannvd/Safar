import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
<<<<<<< HEAD
=======
import 'package:google_fonts/google_fonts.dart';
>>>>>>> backup2

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  Future<Map<String, double>> fetchRouteUsage() async {
    try {
<<<<<<< HEAD
      // Fetch all tickets
      final snapshot =
          await FirebaseFirestore.instance.collection('tickets').get();

      // Group tickets by routeName
=======
      final snapshot =
          await FirebaseFirestore.instance.collection('tickets').get();

>>>>>>> backup2
      final routeCounts = <String, int>{};
      for (var doc in snapshot.docs) {
        final routeName = doc.data()['routeName'] ?? 'Unknown';
        routeCounts[routeName] = (routeCounts[routeName] ?? 0) + 1;
      }

<<<<<<< HEAD
      // Calculate percentages
=======
>>>>>>> backup2
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

<<<<<<< HEAD
=======
  Future<void> deleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      print("User with ID $userId deleted successfully");
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

>>>>>>> backup2
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
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
=======
        title: Text(
          'User Statistics',
          style:
              GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<Map<String, double>>(
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

                  return Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: PieChart(
                              PieChartData(
                                sections: routeLabels.asMap().entries.map(
                                  (entry) {
                                    final index = entry.key;
                                    final routeName = entry.value;
                                    final percentage = routeValues[index];

                                    return PieChartSectionData(
                                      color: _getRouteColor(routeName),
                                      value: percentage,
                                      title:
                                          '${percentage.toStringAsFixed(1)}%',
                                      radius: 80,
                                      titleStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ).toList(),
                                sectionsSpace: 0,
                                centerSpaceRadius: 0,
                                borderData: FlBorderData(show: false),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: routeLabels.map((routeName) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      color: _getRouteColor(routeName),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Text(
                                    routeName,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'User Data',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(
                      child: Text("Error fetching user data."),
                    );
                  }

                  final users = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final userName = user['fullName'] ?? 'Unknown';
                      final userEmail = user['email'] ?? 'Unknown';
                      final createdAt = user['createdAt'] != null
                          ? (user['createdAt'] as Timestamp).toDate()
                          : null;

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          title: Text(
                            userName,
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userEmail),
                              Text(
                                createdAt != null
                                    ? 'Created: ${createdAt.toLocal()}'
                                    : 'Creation Date: Unknown',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await deleteUser(user.id);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
>>>>>>> backup2
      ),
    );
  }

<<<<<<< HEAD
  // Helper to assign colors to each route
=======
>>>>>>> backup2
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
