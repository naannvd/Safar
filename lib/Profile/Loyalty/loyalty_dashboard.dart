import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Loyalty1Dashboard extends StatelessWidget {
  const Loyalty1Dashboard({super.key});

  Future<Map<String, dynamic>> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return doc.data()!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Loyalty Dashboard',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          }

          var userData = snapshot.data!;
          var currentPoints = userData['current_points'] ?? 0;
          var tierLevel = userData['tier_level'] ?? 'Bronze';

          return Column(
            children: [
              ListTile(
                title: Text('Current Points: $currentPoints'),
                subtitle: Text('Current Tier: $tierLevel'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Available Rewards',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: RewardsList(currentPoints: currentPoints),
              ),
            ],
          );
        },
      ),
    );
  }
}

class RewardsList extends StatelessWidget {
  final int currentPoints;
  const RewardsList({super.key, required this.currentPoints});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
            var pointCost = reward['point_cost'];

            return ListTile(
              title: Text(reward['reward_name']),
              subtitle: Text('Cost: $pointCost points'),
              trailing: ElevatedButton(
                onPressed: currentPoints >= pointCost
                    ? () {
                        redeemReward(reward['reward_id'], pointCost);
                      }
                    : null,
                child: const Text('Redeem'),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> redeemReward(String rewardId, int cost) async {
    final user = FirebaseAuth.instance.currentUser;
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);
    final userData = await userRef.get();

    int currentPoints = userData['current_points'];
    if (currentPoints >= cost) {
      // Deduct points and add reward
      await userRef.update({
        'current_points': currentPoints - cost,
        'redeemed_rewards': FieldValue.arrayUnion([rewardId]),
      });
    }
  }
}
