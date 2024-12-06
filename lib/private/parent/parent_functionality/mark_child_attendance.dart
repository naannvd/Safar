import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MarkChildAttendance extends StatefulWidget {
  final List<Map<String, dynamic>> children;

  final Map<String, dynamic> rideData;

  const MarkChildAttendance(
      {super.key, required this.children, required this.rideData});

  @override
  State<MarkChildAttendance> createState() => _MarkChildAttendanceState();
}

class _MarkChildAttendanceState extends State<MarkChildAttendance> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.children.map(
        (child) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return ListTile(
                            title: Text(child['child_name']),
                            subtitle: Text(
                                'Status: ${child['is_present'] ? "Going" : "Not Going"}'),
                            trailing: Text(
                              child['is_present'] ? 'Going' : 'Not Going',
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
                    IconButton(
                      onPressed: () {
                        bool newStatus = !child['is_present'];
                        FirebaseFirestore.instance
                            .collection('childs')
                            .doc(child['child_id'])
                            .update({'is_present': newStatus}).then((_) {
                          setState(() {
                            child['is_present'] = newStatus;
                          });
                          if (newStatus) {
                            FirebaseFirestore.instance
                                .collection('rides')
                                .where('ride_id',
                                    isEqualTo: widget.rideData['ride_id'])
                                .get()
                                .then((querySnapshot) {
                              for (var doc in querySnapshot.docs) {
                                doc.reference.update({
                                  'students':
                                      FieldValue.arrayUnion([child['child_id']])
                                });
                              }
                            });
                          } else {
                            FirebaseFirestore.instance
                                .collection('rides')
                                .where('ride_id',
                                    isEqualTo: widget.rideData['ride_id'])
                                .get()
                                .then(
                              (querySnapshot) {
                                for (var doc in querySnapshot.docs) {
                                  doc.reference.update(
                                    {
                                      'students': FieldValue.arrayRemove(
                                          [child['child_id']])
                                    },
                                  );
                                }
                              },
                            );
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Status updated successfully')));
                        }).catchError(
                          (error) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('Failed to update status: $error')));
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
        },
      ).toList(),
    );
  }
}
