import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class RoutesScreen extends StatefulWidget {
  const RoutesScreen({super.key});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  final List<Map<String, dynamic>> metroLines = [
    {'name': 'Blue-Line', 'color': Colors.blue, 'icon': Icons.train},
    {'name': 'Green-Line', 'color': Colors.green, 'icon': Icons.directions_bus},
    {'name': 'Orange-Line', 'color': Colors.orange, 'icon': Icons.subway},
    {'name': 'Red-Line', 'color': Colors.red, 'icon': Icons.directions_railway},
  ];
  final Map<String, bool> expandedState = {};
  final TextEditingController _fareController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize all expanded states to false
    for (var line in metroLines) {
      expandedState[line['name']] = false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchStations(String lineName) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('routes')
          .doc(lineName)
          .get();

      if (snapshot.exists) {
        final stations = snapshot.data()?['stations'] as List<dynamic>? ?? [];
        return stations.map<Map<String, dynamic>>((station) {
          if (station is Map<String, dynamic>) {
            return station;
          } else {
            return {'station_name': 'Unknown Station'};
          }
        }).toList();
      }
      return [];
    } catch (e) {
      print("Error fetching stations for $lineName: $e");
      return [];
    }
  }

  Future<void> deleteStation(String lineName, String stationName) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('routes')
          .doc(lineName)
          .get();

      if (snapshot.exists) {
        final stations = snapshot.data()?['stations'] as List<dynamic>? ?? [];
        stations.removeWhere((station) =>
            station is Map<String, dynamic> &&
            station['station_name'] == stationName);

        await FirebaseFirestore.instance
            .collection('routes')
            .doc(lineName)
            .update({'stations': stations});
        setState(() {}); // Refresh the UI
      }
    } catch (e) {
      print("Error deleting station: $e");
    }
  }

  Future<void> addStation(
      String lineName, Map<String, dynamic> newStation) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('routes')
          .doc(lineName)
          .get();

      if (snapshot.exists) {
        final stations = snapshot.data()?['stations'] as List<dynamic>? ?? [];
        stations.add(newStation);

        await FirebaseFirestore.instance
            .collection('routes')
            .doc(lineName)
            .update({'stations': stations});
        setState(() {}); // Refresh the UI
      }
    } catch (e) {
      print("Error adding station: $e");
    }
  }

  Future<void> updateFare(String lineName, double newFare) async {
    try {
      await FirebaseFirestore.instance
          .collection('routes')
          .doc(lineName)
          .update({'fare': newFare});
      setState(() {}); // Refresh the UI
    } catch (e) {
      print("Error updating fare: $e");
    }
  }

  void showAddStationDialog(String lineName) {
    final TextEditingController stationNameController = TextEditingController();
    final TextEditingController latitudeController = TextEditingController();
    final TextEditingController longitudeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Station'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: stationNameController,
                decoration: const InputDecoration(labelText: 'Station Name'),
              ),
              TextField(
                controller: latitudeController,
                decoration: const InputDecoration(labelText: 'Latitude'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: longitudeController,
                decoration: const InputDecoration(labelText: 'Longitude'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final stationName = stationNameController.text.trim();
                final latitude =
                    double.tryParse(latitudeController.text.trim());
                final longitude =
                    double.tryParse(longitudeController.text.trim());

                if (stationName.isNotEmpty &&
                    latitude != null &&
                    longitude != null) {
                  addStation(lineName, {
                    'station_name': stationName,
                    'latitude': latitude,
                    'longitude': longitude,
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid input!')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void showEditFareDialog(String lineName, double currentFare) {
    _fareController.text = currentFare.toString();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Fare'),
          content: TextField(
            controller: _fareController,
            decoration: const InputDecoration(labelText: 'Fare'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newFare = double.tryParse(_fareController.text.trim());
                if (newFare != null) {
                  updateFare(lineName, newFare);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid fare!')),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Routes',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
      ),
      body: ListView.builder(
        itemCount: metroLines.length,
        itemBuilder: (context, index) {
          final line = metroLines[index];
          final lineName = line['name'];
          final lineColor = line['color'];
          final lineIcon = line['icon'];

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ExpansionTile(
              leading: Icon(lineIcon, color: lineColor),
              title: Text(lineName,
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold, color: lineColor)),
              children: [
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('routes')
                      .doc(lineName)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError ||
                        !snapshot.hasData ||
                        !snapshot.data!.exists) {
                      return const Center(
                          child: Text('Error or no data available.'));
                    }

                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final fare = data['fare'] ?? 0.0;
                    final stations = data['stations'] as List<dynamic>? ?? [];

                    return Column(
                      children: [
                        ...stations.map((station) {
                          final stationName = (station
                                  as Map<String, dynamic>)['station_name'] ??
                              '';
                          return ListTile(
                            title: Text(
                              stationName,
                              style: GoogleFonts.montserrat(),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  deleteStation(lineName, stationName),
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => showAddStationDialog(lineName),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Add Station',
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => showEditFareDialog(lineName, fare),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Fare: $fare',
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
