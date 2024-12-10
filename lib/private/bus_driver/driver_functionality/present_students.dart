import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PresentStudents extends StatefulWidget {
  final String rideId;

  const PresentStudents({super.key, required this.rideId});

  @override
  _PresentStudentsState createState() => _PresentStudentsState();
}

class _PresentStudentsState extends State<PresentStudents> {
  String? championStudentId;

  Future<void> assignChampion(String studentId) async {
    try {
      QuerySnapshot rideSnapshot = await FirebaseFirestore.instance
          .collection('rides')
          .where('ride_id', isEqualTo: widget.rideId)
          .get();

      if (rideSnapshot.docs.isNotEmpty) {
        final rideDocRef = rideSnapshot.docs.first.reference;

        if (championStudentId != null) {
          await FirebaseFirestore.instance
              .collection('childs')
              .doc(championStudentId)
              .update({'is_champion': false});
        }

        await FirebaseFirestore.instance
            .collection('childs')
            .doc(studentId)
            .update({'is_champion': true});

        await rideDocRef.update({'champion_student': studentId});

        setState(() {
          championStudentId = studentId;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error assigning champion: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rides')
            .where('ride_id', isEqualTo: widget.rideId)
            .snapshots(),
        builder: (context, rideSnapshot) {
          if (rideSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!rideSnapshot.hasData || rideSnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No ride data found for this Ride ID."),
            );
          }

          final rideData =
              rideSnapshot.data!.docs.first.data() as Map<String, dynamic>;
          final List<dynamic> studentIds = rideData['students'] ?? [];

          if (studentIds.isEmpty) {
            return const Center(
              child: Text("No students found for this ride."),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: studentIds.length,
            itemBuilder: (context, index) {
              final studentId = studentIds[index];

              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('childs')
                    .doc(studentId)
                    .snapshots(),
                builder: (context, studentSnapshot) {
                  if (studentSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const ListTile(
                      title: Text("Loading student details..."),
                    );
                  }

                  if (!studentSnapshot.hasData ||
                      !studentSnapshot.data!.exists) {
                    return ListTile(
                      title: Text("Student not found: $studentId"),
                    );
                  }

                  final studentData =
                      studentSnapshot.data!.data() as Map<String, dynamic>;
                  final isChampion = studentData['is_champion'] ?? false;
                  final isBoarded = studentData['is_boarded'] ?? false;

                  return Card(
                    color: const Color(0xFFA1CA73),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name
                                Text(
                                  studentData['child_name'] ??
                                      "Unnamed Student",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF042F40),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Boarded/Not Boarded
                                Text(
                                  isBoarded ? "Boarded" : "Not Boarded",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF042F40),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // ID
                                Text(
                                  "ID: $studentId",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF042F40),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Assign Champion Button
                          ElevatedButton(
                            onPressed: isChampion
                                ? null
                                : () => assignChampion(studentId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isChampion
                                  ? Colors.red
                                  : const Color(0xFF042F40),
                              textStyle: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            child: Text(
                              isChampion ? "Champion" : "Assign Champion",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
