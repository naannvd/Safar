import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class LoyaltyScreen extends StatelessWidget {
  const LoyaltyScreen({super.key});

  Stream<List<Map<String, dynamic>>> fetchLoyaltyProgramsStream() async* {
    final loyaltyStream =
        FirebaseFirestore.instance.collection('loyalty_programs').snapshots();

    await for (var snapshot in loyaltyStream) {
      yield snapshot.docs
          .map((doc) => {'id': doc.id, 'data': doc.data()})
          .toList();
    }
  }

  void deleteLoyaltyProgram(String loyaltyId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('loyalty_programs')
          .doc(loyaltyId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Loyalty program deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete loyalty program: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Loyalty Programs",
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: fetchLoyaltyProgramsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child:
                  Text("No loyalty programs available or an error occurred."),
            );
          }

          final loyaltyPrograms = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: loyaltyPrograms.length,
            itemBuilder: (context, index) {
              final loyalty = loyaltyPrograms[index];
              final title = loyalty['data']['title'] ?? 'Untitled';
              final description =
                  loyalty['data']['description'] ?? 'No Description';

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Heading of the card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          title,
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    // Body of the card
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description",
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  deleteLoyaltyProgram(loyalty['id'], context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
