import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  Stream<List<Map<String, dynamic>>> fetchFeedbacksStream() async* {
    final feedbackStream = FirebaseFirestore.instance
        .collection('feedback')
        .orderBy('createdAt', descending: true)
        .snapshots();

    await for (var snapshot in feedbackStream) {
      yield snapshot.docs
          .map((doc) => {'id': doc.id, 'data': doc.data()})
          .toList();
    }
  }

  Future<Map<String, dynamic>> analyzeFeedbackWithHuggingFace(
      String text) async {
    const apiKey = "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";
    const apiUrl =
        "https://api-inference.huggingface.co/models/cardiffnlp/twitter-roberta-base-sentiment-latest";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode({"inputs": text}),
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body) as List<dynamic>;
        if (decodedResponse.isNotEmpty) {
          final predictions = decodedResponse[0] as List<dynamic>;
          final bestPrediction = predictions.reduce((a, b) =>
              (a['score'] as double) > (b['score'] as double) ? a : b);

          return {
            "label": bestPrediction['label'],
            "score": bestPrediction['score'],
          };
        }
        return {"label": "Unknown", "score": 0.0};
      } else {
        print("Error from Hugging Face API: ${response.body}");
        return {"label": "Error", "score": 0.0};
      }
    } catch (e) {
      print("Error during API call: $e");
      return {"label": "Error", "score": 0.0};
    }
  }

  Future<Map<String, dynamic>> fetchTicketDetails(String ticketId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('tickets')
          .where('ticketId', isEqualTo: ticketId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      } else {
        return {};
      }
    } catch (e) {
      print("Error fetching ticket details: $e");
      return {};
    }
  }

  Color getRouteColor(String routeName) {
    switch (routeName) {
      case 'Blue-Line':
        return Colors.blue;
      case 'Green-Line':
        return Colors.green;
      case 'Orange-Line':
        return Colors.orange;
      case 'Red-Line':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feedbacks',
          style:
              GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: fetchFeedbacksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No feedback available or an error occurred."),
            );
          }

          final feedbacks = snapshot.data!;

          return ListView.builder(
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              final feedback = feedbacks[index];
              final feedbackText = feedback['data']['message'] ?? 'No Message';
              final userName = feedback['data']['userName'] ?? 'Unknown';
              final createdAt = feedback['data']['createdAt'] != null
                  ? DateFormat('dd/MM/yyyy hh:mm a').format(
                      (feedback['data']['createdAt'] as Timestamp).toDate())
                  : 'Unknown Date';
              final ticketId = feedback['data']['ticketId'] ?? 'Unknown';

              return FutureBuilder<Map<String, dynamic>>(
                future: analyzeFeedbackWithHuggingFace(feedbackText),
                builder: (context, analysisSnapshot) {
                  return FutureBuilder<Map<String, dynamic>>(
                    future: fetchTicketDetails(ticketId),
                    builder: (context, ticketSnapshot) {
                      if (analysisSnapshot.connectionState ==
                              ConnectionState.waiting ||
                          ticketSnapshot.connectionState ==
                              ConnectionState.waiting) {
                        return const Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        );
                      }

                      if (analysisSnapshot.hasError ||
                          analysisSnapshot.data == null ||
                          ticketSnapshot.hasError ||
                          ticketSnapshot.data == null) {
                        return const Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text("Error analyzing feedback."),
                          ),
                        );
                      }

                      final analysis = analysisSnapshot.data!;
                      final sentiment =
                          analysis["label"]?.toUpperCase() ?? "UNKNOWN";
                      final confidence =
                          ((analysis["score"] ?? 0.0) * 100).toStringAsFixed(2);

                      final ticketData = ticketSnapshot.data!;
                      final routeName = ticketData['routeName'] ?? 'Unknown';
                      final fromStation = ticketData['fromStation'] ?? 'N/A';
                      final toStation = ticketData['toStation'] ?? 'N/A';
                      final routeColor = getRouteColor(routeName);

                      Color sentimentColor;
                      if (sentiment.contains("POSITIVE")) {
                        sentimentColor = Colors.green;
                      } else if (sentiment.contains("NEGATIVE")) {
                        sentimentColor = Colors.red;
                      } else if (sentiment.contains("NEUTRAL")) {
                        sentimentColor = Colors.yellow[700]!;
                      } else {
                        sentimentColor = Colors.grey;
                      }

                      return Card(
                        color: Colors.white,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    feedbackText,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: const Color(0xFF042F40),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "By: $userName",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    createdAt,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      color: Colors.black45,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: routeColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "$fromStation  <----->  $toStation",
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Color(0xFF042F40),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: const Color.fromARGB(255, 45, 56, 59),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 12.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: sentimentColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      sentiment,
                                      style: GoogleFonts.montserrat(
                                        color: sentimentColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Confidence: $confidence%",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
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
              );
            },
          );
        },
      ),
    );
  }
}
