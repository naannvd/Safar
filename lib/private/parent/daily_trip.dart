import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
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
        for (var ride in rides) {
          var rideData = ride.data() as Map<String, dynamic>;
          print('Ride ID: ${rideData['ride_id']}');
        }

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

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children.map((child) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: StatefulBuilder(
                                      builder: (context, setState) {
                                        return ListTile(
                                          title: Text(child['child_name']),
                                          subtitle: Text(
                                              'Status: ${child['is_present'] ? "Going" : "Not Going"}'),
                                          trailing: Text(
                                            child['is_present']
                                                ? 'Going'
                                                : 'Not Going',
                                            style: TextStyle(
                                              color: child['is_present']
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  // IconButton(
                                  //   onPressed: () {
                                  //     bool newStatus = !child['is_present'];
                                  //     FirebaseFirestore.instance
                                  //         .collection('childs')
                                  //         .doc(child['child_id'])
                                  //         .update({
                                  //       'is_present': newStatus
                                  //     }).then((_) {
                                  //       setState(() {
                                  //         child['is_present'] = newStatus;
                                  //       });
                                  //       ScaffoldMessenger.of(context)
                                  //           .showSnackBar(const SnackBar(
                                  //               content: Text(
                                  //                   'Status updated successfully')));
                                  //     }).catchError(
                                  //       (error) {
                                  //         ScaffoldMessenger.of(context)
                                  //             .showSnackBar(SnackBar(
                                  //                 content: Text(
                                  //                     'Failed to update status: $error')));
                                  //       },
                                  //     );
                                  //   },
                                  //   icon: const Icon(Icons.check),
                                  // ),
                                  IconButton(
                                    onPressed: () {
                                      bool newStatus = !child['is_present'];
                                      FirebaseFirestore.instance
                                          .collection('childs')
                                          .doc(child['child_id'])
                                          .update({
                                        'is_present': newStatus
                                      }).then((_) {
                                        setState(() {
                                          child['is_present'] = newStatus;
                                        });
                                        if (newStatus) {
                                          FirebaseFirestore.instance
                                              .collection('rides')
                                              .where('ride_id',
                                                  isEqualTo:
                                                      rideData['ride_id'])
                                              .get()
                                              .then((querySnapshot) {
                                            for (var doc
                                                in querySnapshot.docs) {
                                              doc.reference.update({
                                                'students':
                                                    FieldValue.arrayUnion(
                                                        [child['child_id']])
                                              });
                                            }
                                          });
                                        } else {
                                          FirebaseFirestore.instance
                                              .collection('rides')
                                              .where('ride_id',
                                                  isEqualTo:
                                                      rideData['ride_id'])
                                              .get()
                                              .then(
                                            (querySnapshot) {
                                              for (var doc
                                                  in querySnapshot.docs) {
                                                doc.reference.update(
                                                  {
                                                    'students':
                                                        FieldValue.arrayRemove(
                                                            [child['child_id']])
                                                  },
                                                );
                                              }
                                            },
                                          );
                                        }

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Status updated successfully')));
                                      }).catchError(
                                        (error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Failed to update status: $error')));
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.check),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
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
