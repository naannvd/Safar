import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RewardsCatalog extends StatelessWidget {
  const RewardsCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards Catalog'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('rewards').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          var rewards = snapshot.data!.docs;

          return ListView.builder(
            itemCount: rewards.length,
            itemBuilder: (context, index) {
              var reward = rewards[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(reward['name']),
                subtitle: Text('Points required: ${reward['point_cost']}'),
                onTap: () {
                  // Logic to redeem reward
                },
              );
            },
          );
        },
      ),
    );
  }
}
