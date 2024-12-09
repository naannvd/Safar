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
<<<<<<< HEAD
<<<<<<< HEAD
    const apiKey = "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";
    const apiUrl =
        "https://api-inference.huggingface.co/models/cardiffnlp/twitter-roberta-base-sentiment-latest";
=======
    const apiKey =
        "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"; // Replace with your Hugging Face API token
    const apiUrl =
        "https://api-inference.huggingface.co/models/distilbert-base-uncased-finetuned-sst-2-english";
>>>>>>> 35e4a5838ee0d8e2109d4bd483c51fba98531cf0
=======
    const apiKey = "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";
    const apiUrl =
        "https://api-inference.huggingface.co/models/cardiffnlp/twitter-roberta-base-sentiment-latest";
>>>>>>> backup2

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
<<<<<<< HEAD
        final decodedResponse = json.decode(response.body) as List<dynamic>;
        print("API Response: $decodedResponse");

<<<<<<< HEAD
        if (decodedResponse.isNotEmpty) {
=======
        if (decodedResponse.isNotEmpty && decodedResponse[0] is List<dynamic>) {
>>>>>>> 35e4a5838ee0d8e2109d4bd483c51fba98531cf0
          final predictions = decodedResponse[0] as List<dynamic>;
          final bestPrediction = predictions.reduce((a, b) =>
              (a['score'] as double) > (b['score'] as double) ? a : b);

          return {
            "label": bestPrediction['label'],
            "score": bestPrediction['score'],
          };
        }
=======
        // Decode the response
        final decodedResponse = json.decode(response.body);

        print("API Response: $decodedResponse");

        // Ensure the response is in the expected structure
        if (decodedResponse is List && decodedResponse.isNotEmpty) {
          // Extract predictions (assumes the first item is relevant)
          final predictions = decodedResponse[0] as List<dynamic>;
          if (predictions.isNotEmpty) {
            final bestPrediction = predictions.reduce((a, b) =>
                (a['score'] as double) > (b['score'] as double) ? a : b);

            // Return the label and score
            return {
              "label": bestPrediction['label'] as String,
              "score": bestPrediction['score'] as double,
            };
          }
        }

        // Fallback if structure is unexpected
>>>>>>> backup2
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

              return FutureBuilder<Map<String, dynamic>>(
                future: analyzeFeedbackWithHuggingFace(feedbackText),
                builder: (context, analysisSnapshot) {
                  if (analysisSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Card(
                      elevation: 4,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }

                  if (analysisSnapshot.hasError ||
                      analysisSnapshot.data == null) {
                    return const Card(
                      elevation: 4,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("Error analyzing feedback."),
                      ),
                    );
                  }

                  final analysis = analysisSnapshot.data!;
                  final sentiment = analysis["label"] ?? "Unknown";
                  final confidence =
                      ((analysis["score"] ?? 0.0) * 100).toStringAsFixed(2);

                  // Determine sentiment label color
<<<<<<< HEAD
<<<<<<< HEAD
                  Color sentimentColor;
                  if (sentiment == "POSITIVE") {
                    sentimentColor = Colors.green;
                  } else if (sentiment == "NEGATIVE") {
=======
                  Color sentimentColor;
                  if (sentiment.toUpperCase() == "POSITIVE") {
                    sentimentColor = Colors.green;
                  } else if (sentiment.toUpperCase() == "NEGATIVE") {
>>>>>>> backup2
                    sentimentColor = Colors.red;
                  } else {
                    sentimentColor = Colors.yellow[700]!;
                  }
<<<<<<< HEAD
=======
                  final sentimentColor = sentiment == "POSITIVE"
                      ? Colors.green
                      : sentiment == "NEGATIVE"
                          ? Colors.red
                          : Colors.orange;
>>>>>>> 35e4a5838ee0d8e2109d4bd483c51fba98531cf0
=======
>>>>>>> backup2

                  return Card(
                    color: Colors.white,
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 12.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
<<<<<<< HEAD
<<<<<<< HEAD
=======
                          // Feedback details
>>>>>>> 35e4a5838ee0d8e2109d4bd483c51fba98531cf0
=======
>>>>>>> backup2
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  feedbackText,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
<<<<<<< HEAD
<<<<<<< HEAD
                                    color: const Color(0xFF042F40),
=======
                                    color: Color(0xFF042F40),
>>>>>>> 35e4a5838ee0d8e2109d4bd483c51fba98531cf0
=======
                                    color: const Color(0xFF042F40),
>>>>>>> backup2
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
                              ],
                            ),
                          ),
<<<<<<< HEAD
<<<<<<< HEAD
=======
                          // Sentiment and confidence labels
>>>>>>> 35e4a5838ee0d8e2109d4bd483c51fba98531cf0
=======
>>>>>>> backup2
                          Column(
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
                              const SizedBox(height: 8),
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
                        ],
                      ),
                    ),
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
