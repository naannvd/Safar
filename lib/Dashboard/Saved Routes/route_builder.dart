import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safar/Tickets/ticket_book.dart';

class RouteBuilder extends StatelessWidget {
  final String fromStation;
  final String toStation;
  final String imagePath;
  final String routeName;
  final Future<double> fare;

  const RouteBuilder({
    super.key,
    required this.fromStation,
    required this.toStation,
    required this.imagePath,
    required this.routeName,
    required this.fare,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketBook(
              fromStation: fromStation,
              toStation: toStation,
              selectedLine: routeName,
            ),
          ),
        );
      },
      child: SizedBox(
        width: 320,
        child: Card(
          color: const Color(0xFFFFFFFF),
          margin:
              const EdgeInsets.only(top: 10, left: 20, right: 0, bottom: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 8.0, right: 12, top: 12, bottom: 12),
            child: Row(
              children: [
                // If you had an image, you could include it here.
                // For now, it's commented out:
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FutureBuilder<double>(
                    future: fare,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData) {
                        return const Text('No fare data');
                      }

                      final fareValue = snapshot.data!;

                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    fromStation,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // const Spacer(),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.arrow_forward, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    toStation,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // const Spacer(),
                            const SizedBox(height: 20),
                            Text(
                              'From ',
                              style: GoogleFonts.montserrat(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            // const SizedBox(height: 4),
                            Text(
                              '$fareValue RS',
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
