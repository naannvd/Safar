import 'package:flutter/material.dart';

class RewardRedemptionScreen extends StatelessWidget {
  const RewardRedemptionScreen(
      {super.key, required this.rewardName, required this.pointCost});

  final String rewardName;
  final int pointCost;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Redemption'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Reward: $rewardName'),
            Text('Cost: $pointCost points'),
            ElevatedButton(
              onPressed: () {
                // Confirm reward redemption logic here
              },
              child: const Text('Redeem Reward'),
            ),
          ],
        ),
      ),
    );
  }
}
