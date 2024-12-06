import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChildList extends StatelessWidget {
  final String parentId;

  const ChildList({super.key, required this.parentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('childs')
            .where('parent_id', isEqualTo: parentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No children found'));
          }
          final children = snapshot.data!.docs;
          return ListView.builder(
            itemCount: children.length,
            itemBuilder: (context, index) {
              var child = children[index];
              return Card(
                child: ListTile(
                  title: Text(child['child_name']),
                  // subtitle: Text('Age: ${child['age']}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
