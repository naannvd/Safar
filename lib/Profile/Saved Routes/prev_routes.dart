import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class PrevRoutes extends StatelessWidget {
  const PrevRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA1CA73),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA1CA73),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('saved_routes')
            .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  'Recent Trips',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF042F42),
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var route = snapshot.data!.docs[index];
                    String routeId = route.id; // Unique document ID
                    Map<String, dynamic> routeData =
                        route.data() as Map<String, dynamic>; // Route details

                    return Dismissible(
                      key: Key(routeId),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        padding: const EdgeInsets.only(right: 20),
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) async {
                        // Remove route from Firestore
                        await FirebaseFirestore.instance
                            .collection('saved_routes')
                            .doc(routeId)
                            .delete();

                        // Show Snackbar with undo option
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Route removed!'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () async {
                                // Restore route to Firestore
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
                              bottom: BorderSide(color: Colors.grey.shade300),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            title: Row(
                              children: [
                                Text(
                                  route['fromStation'],
                                  style: GoogleFonts.montserrat(fontSize: 15),
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_forward, size: 24),
                                const Spacer(),
                                Text(
                                  route['toStation'],
                                  style: GoogleFonts.montserrat(fontSize: 15),
                                )
                              ],
                            ),
                            subtitle: Text(
                              route['route_name'],
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                color: () {
                                  switch (
                                      route['route_name']?.substring(0, 1)) {
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
                              // Handle route tap
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
      ),
    );
  }
}
