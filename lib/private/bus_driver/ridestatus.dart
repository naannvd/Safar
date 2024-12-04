import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RideStatusScreen extends StatefulWidget {
  final String rideId;

  const RideStatusScreen({super.key, required this.rideId});

  @override
  State<RideStatusScreen> createState() => _RideStatusScreenState();
}

class _RideStatusScreenState extends State<RideStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Status'),
        backgroundColor: const Color(0xFF042F42),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Ride Status Header
            Text(
              "Ride ID: ${widget.rideId}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Placeholder for Map
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Center(
                child: Text(
                  "Map Placeholder",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // StreamBuilder for List of Students
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('rides')
                    .doc(widget.rideId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error: ${snapshot.error}"),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data?.data() == null) {
                    return const Center(
                      child: Text(
                        "No ride data found.",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  final rideData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  final students = List<Map<String, dynamic>>.from(
                      rideData['students'] ?? []);

                  if (students.isEmpty) {
                    return const Center(
                      child: Text(
                        "No students found for this ride.",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(student['name'] ?? 'Unknown'),
                          subtitle: Text(
                            student['is_boarded'] == true
                                ? "Status: Boarded"
                                : "Status: Not Boarded",
                          ),
                          trailing: student['is_champion'] == true
                              ? const Icon(Icons.star, color: Colors.amber)
                              : null,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
