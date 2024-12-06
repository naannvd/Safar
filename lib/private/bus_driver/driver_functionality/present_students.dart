import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PresentStudents extends StatelessWidget {
  final String rideId;

  const PresentStudents({super.key, required this.rideId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('rides')
          .where('ride_id', isEqualTo: rideId)
          .snapshots(),
      builder: (context, snapshot) {
        try {
          // print("RideStudentsList: Checking stream for ride_id = $rideId");

          if (snapshot.connectionState == ConnectionState.waiting) {
            // print("RideStudentsList: Stream is loading...");
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // print("RideStudentsList: Error in stream: ${snapshot.error}");
            throw Exception("Error fetching ride data: ${snapshot.error}");
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // print("RideStudentsList: No ride found for ride_id = $rideId");
            return const Center(
              child: Text("No ride data found for this Ride ID."),
            );
          }

          // Get the first document that matches the ride ID
          final rideData =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;
          // print("RideStudentsList: Ride data fetched: $rideData");

          final List<dynamic> studentIds = rideData['students'] ?? [];
          // print("RideStudentsList: Students array: $studentIds");

          if (studentIds.isEmpty) {
            // print("RideStudentsList: No students found in the ride.");
            return const Center(
              child: Text("No students found for this ride."),
            );
          }

          // Fetch the details of each student in the students array
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: studentIds.length,
              itemBuilder: (context, index) {
                String studentId = studentIds[index];
                // print(
                //     "RideStudentsList: Fetching data for student_id = $studentId");

                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('childs')
                      .doc(studentId)
                      .snapshots(),
                  builder: (context, studentSnapshot) {
                    try {
                      if (studentSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        // print(
                        //     "StudentStream: Loading data for student_id = $studentId");
                        return const ListTile(
                          title: Text("Loading student details..."),
                        );
                      }

                      if (studentSnapshot.hasError) {
                        // print(
                        //     "StudentStream: Error fetching student_id = $studentId, ${studentSnapshot.error}");
                        throw Exception(
                            "Error fetching student data: ${studentSnapshot.error}");
                      }

                      if (!studentSnapshot.hasData ||
                          !studentSnapshot.data!.exists) {
                        // print(
                        //     "StudentStream: Student not found for student_id = $studentId");
                        return ListTile(
                          title: Text("Student not found: $studentId"),
                        );
                      }

                      final studentData =
                          studentSnapshot.data!.data() as Map<String, dynamic>;
                      // print(
                      //     "StudentStream: Data for student_id = $studentId: $studentData");

                      return Card(
                        child: ListTile(
                          title: Text(
                              studentData['child_name'] ?? "Unnamed Student"),
                          subtitle: Text("ID: $studentId"),
                          trailing: studentData['is_present'] == true
                              ? const Icon(Icons.check_circle,
                                  color: Colors.green)
                              : const Icon(Icons.cancel, color: Colors.red),
                        ),
                      );
                    } catch (e) {
                      // print(
                      //     "StudentStream: Error processing student_id = $studentId, $e");
                      return const ListTile(
                        title: Text("Error processing student data."),
                      );
                    }
                  },
                );
              },
            ),
          );
        } catch (e) {
          // print("RideStudentsList: General error: $e");
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "An error occurred: $e",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
      },
    );
  }
}
