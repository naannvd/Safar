import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  Future<Map<String, double>> fetchRouteUsage() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('tickets').get();

      final routeCounts = <String, int>{};
      for (var doc in snapshot.docs) {
        final routeName = doc.data()['routeName'] ?? 'Unknown';
        routeCounts[routeName] = (routeCounts[routeName] ?? 0) + 1;
      }

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

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

  void deleteUser(String userId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: FutureBuilder<Map<String, double>>(
        future: fetchRouteUsage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'User Statistics',
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections:
                                  routeLabels.asMap().entries.map((entry) {
                                final index = entry.key;
                                final routeName = entry.value;
                                final percentage = routeValues[index];

                                return PieChartSectionData(
                                  color: _getRouteColor(routeName),
                                  value: percentage,
                                  title: '${percentage.toStringAsFixed(1)}%',
                                  radius: 100,
                                  titleStyle: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              }).toList(),
                              sectionsSpace: 2,
                              centerSpaceRadius: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Route Legends
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Metro Lines',
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: routeLabels.map((routeName) {
                              return Row(
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
                                    style: GoogleFonts.montserrat(fontSize: 16),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'User Data',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: fetchUsers(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (userSnapshot.hasError ||
                          !userSnapshot.hasData ||
                          userSnapshot.data!.isEmpty) {
                        return const Center(
                          child:
                              Text("No users available or an error occurred."),
                        );
                      }

                      final users = userSnapshot.data!;

                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[200],
                                radius: 30,
                                child: ClipOval(
                                  child: Image.network(
                                    user['image_url'] ?? '',
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person,
                                        color: Colors.grey[500],
                                        size: 40,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              title: Text(
                                user['fullName'] ?? 'Unknown User',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                user['email'] ?? 'No Email',
                                style: GoogleFonts.montserrat(fontSize: 14),
                              ),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    deleteUser(user['id'], context),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

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
