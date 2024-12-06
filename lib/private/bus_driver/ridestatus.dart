import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RideStatusScreen extends StatefulWidget {
  final String rideId;

  const RideStatusScreen({super.key, required this.rideId});

  @override
  State<RideStatusScreen> createState() => _RideStatusScreenState();
}

class _RideStatusScreenState extends State<RideStatusScreen> {
  List<Map<String, dynamic>> boardedStudents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBoardedStudents();
  }

  // Fetch students who have boarded
  Future<void> fetchBoardedStudents() async {
    try {
      final rideDoc = await FirebaseFirestore.instance
          .collection('rides')
          .doc(widget.rideId)
          .get();

      if (rideDoc.exists && rideDoc.data() != null) {
        setState(() {
          boardedStudents = List<Map<String, dynamic>>.from(
              rideDoc.data()!['students'] ?? []);
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching students: $e")),
      );
    }
  }

  // Assign a student as a champion
  Future<void> assignChampion(String studentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('rides')
          .doc(widget.rideId)
          .update({
        'students': boardedStudents.map((student) {
          if (student['student_id'] == studentId) {
            student['isChampion'] = true;
          }
          return student;
        }).toList(),
      });

      setState(() {
        boardedStudents = boardedStudents.map((student) {
          if (student['student_id'] == studentId) {
            student['isChampion'] = true;
          }
          return student;
        }).toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Champion assigned successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error assigning champion: $e")),
      );
    }
  }

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

            // List of Boarded Students
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : boardedStudents.isEmpty
                      ? const Center(
                          child: Text(
                            "No students have boarded yet.",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: boardedStudents.length,
                          itemBuilder: (context, index) {
                            final student = boardedStudents[index];
                            return ListTile(
                              title: Text(student['student_id']),
                              subtitle: Text(student['isChampion'] == true
                                  ? "Champion"
                                  : "Not Champion"),
                              trailing: student['isChampion'] == true
                                  ? const Icon(Icons.star, color: Colors.amber)
                                  : ElevatedButton(
                                      onPressed: () {
                                        assignChampion(student['student_id']);
                                      },
                                      child: const Text("Assign Champion"),
                                    ),
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
