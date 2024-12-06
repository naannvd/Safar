import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safar/private/parent/parent_functionality/mark_child_attendance.dart';
import 'package:tap_to_expand/tap_to_expand.dart';

class DailyTrip extends StatefulWidget {
  const DailyTrip({super.key});

  @override
  State<DailyTrip> createState() => _DailyTripState();
}

class _DailyTripState extends State<DailyTrip> {
  Future<List<Map<String, dynamic>>> _fetchChildren(String parentId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('childs')
          .where('parent_id', isEqualTo: parentId)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint('Error fetching children: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('rides')
          .where('status', isEqualTo: 'scheduled')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var rides = snapshot.data!.docs;

        return ListView.builder(
          itemCount: rides.length,
          itemBuilder: (context, index) {
            var rideData = rides[index].data() as Map<String, dynamic>;

            return Card(
              child: TapToExpand(
                backgroundcolor: const Color(0xFFA1CA73),
                content: FutureBuilder<List<Map<String, dynamic>>>(
                  future:
                      _fetchChildren(FirebaseAuth.instance.currentUser!.uid),
                  builder: (context, childSnapshot) {
                    if (childSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!childSnapshot.hasData || childSnapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No children found for this parent.'),
                      );
                    }

                    var children = childSnapshot.data!;

                    return MarkChildAttendance(
                        children: children, rideData: rideData);
                  },
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bus Ride ID: ${rideData['ride_id']}'),
                    Text('Driver: ${rideData['driver_name']}'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
