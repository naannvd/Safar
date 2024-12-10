import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoyaltyDashboard extends StatefulWidget {
  const LoyaltyDashboard({super.key});

  @override
  State<LoyaltyDashboard> createState() => _LoyaltyDashboardState();
}

class _LoyaltyDashboardState extends State<LoyaltyDashboard> {
  final user = FirebaseAuth.instance.currentUser;

  Future<Map<String, dynamic>> _fetchLoyaltyData() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('loyalty')
        .doc('rewards')
        .get();

    if (!doc.exists) {
      // Initialize the doc if it doesn't exist
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('loyalty')
          .doc('rewards')
          .set({
        'discountAvailable': false,
        'discountPercentage': 0,
        'discountType': null,
        'ticketsCompleted': 0,
        'completionGoal': 10,
        'loyaltyPoints': 0,
      }, SetOptions(merge: true));

      return {
        'discountAvailable': false,
        'discountPercentage': 0,
        'discountType': null,
        'ticketsCompleted': 0,
        'completionGoal': 10,
        'loyaltyPoints': 0,
      };
    }

    return doc.data()!;
  }

  Future<void> _claimLoyaltyReward(int currentPoints) async {
    // Deduct 300 points and apply a 10% discount
    if (currentPoints >= 300) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('loyalty')
          .doc('rewards')
          .update({
        'loyaltyPoints': currentPoints - 300,
        'discountAvailable': true,
        'discountPercentage': 10,
        'discountType': 'loyalty',
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('You claimed a 10% discount on your next ticket!')));
      setState(() {}); // Refresh UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA1CA73),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA1CA73),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchLoyaltyData(),
        builder: (context, loyaltySnapshot) {
          if (loyaltySnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (loyaltySnapshot.hasError) {
            return Center(child: Text('Error: ${loyaltySnapshot.error}'));
          }

          final loyaltyData = loyaltySnapshot.data!;
          final discountAvailable = loyaltyData['discountAvailable'] as bool;
          final ticketsCompleted = loyaltyData['ticketsCompleted'] as int;
          final completionGoal = loyaltyData['completionGoal'] as int;
          final pointsString = loyaltyData['loyalty_points'] as String? ?? '0';
          final loyaltyPoints = int.tryParse(pointsString) ?? 0;

          // For the loyalty points reward:
          // Target: 300 points. Display a linear progress and a claim button.
          const int pointsGoal = 300;
          double progress = (loyaltyPoints / pointsGoal).clamp(0, 1);

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('saved_routes')
                .where('user_id', isEqualTo: user!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      'Loyalty Dashboard',
                      style: GoogleFonts.montserrat(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF042F42),
                      ),
                    ),
                  ),

                  // Existing loyalty progress (ticketsCompleted)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ticket Completion Progress',
                            style: GoogleFonts.montserrat(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: ticketsCompleted / completionGoal,
                                backgroundColor: Colors.white,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text('$ticketsCompleted/$completionGoal',
                                style: GoogleFonts.montserrat(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        if (discountAvailable) ...[
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.card_giftcard,
                                  color: Colors.yellow[700]),
                              const SizedBox(width: 5),
                              Text(
                                'Discount Available! Your next ride is discounted.',
                                style: GoogleFonts.montserrat(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          )
                        ]
                      ],
                    ),
                  ),

                  // New Loyalty Points Reward Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Loyalty Points',
                            style: GoogleFonts.montserrat(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 5),
                        Text(
                            'Earn points for each ride. Collect 300 points to claim a 10% discount!',
                            style: GoogleFonts.montserrat(fontSize: 14)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.white,
                                color: Colors.greenAccent,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text('$loyaltyPoints/$pointsGoal',
                                style: GoogleFonts.montserrat(
                                    fontSize: 14, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: loyaltyPoints >= 300
                                  ? () => _claimLoyaltyReward(loyaltyPoints)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: loyaltyPoints >= 300
                                    ? Colors.blue
                                    : Colors.grey,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                              child: Text(
                                'Claim Reward',
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Recent Trips
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      'Recent Trips',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF042F42),
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var route = snapshot.data!.docs[index];
                        String routeId = route.id;
                        Map<String, dynamic> routeData =
                            route.data() as Map<String, dynamic>;

                        return Dismissible(
                          key: Key(routeId),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            padding: const EdgeInsets.only(right: 20),
                            alignment: Alignment.centerRight,
                            color: Colors.red,
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) async {
                            await FirebaseFirestore.instance
                                .collection('saved_routes')
                                .doc(routeId)
                                .delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Route removed!'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('saved_routes')
                                        .doc(routeId)
                                        .set(routeData);
                                  },
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 5, bottom: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: route['user_id'] != null
                                    ? [
                                        BoxShadow(
                                          color: Colors.grey.shade300,
                                          blurRadius: 5,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 0),
                                        ),
                                      ]
                                    : [],
                                color: Colors.white,
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade300),
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Text(
                                      route['fromStation'],
                                      style:
                                          GoogleFonts.montserrat(fontSize: 15),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.arrow_forward, size: 24),
                                    const Spacer(),
                                    Text(
                                      route['toStation'],
                                      style:
                                          GoogleFonts.montserrat(fontSize: 15),
                                    )
                                  ],
                                ),
                                subtitle: Text(
                                  route['route_name'],
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    color: () {
                                      switch (route['route_name']
                                          ?.substring(0, 1)) {
                                        case 'O':
                                          return const Color(0xFFE06236);
                                        case 'B':
                                          return const Color(0xFF3E7C98);
                                        case 'G':
                                          return const Color(0xFFA1CA73);
                                        case 'R':
                                          return const Color(0xFFCC3636);
                                        default:
                                          return Colors.black;
                                      }
                                    }(),
                                  ),
                                ),
                                onTap: () {
                                  // Handle route tap, maybe navigate to a details page
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
