import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HuggingFaceStreamNlpWidget extends StatelessWidget {
  const HuggingFaceStreamNlpWidget({super.key});

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
    const apiKey =
        "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"; // Replace with your Hugging Face API token
    const apiUrl =
        "https://api-inference.huggingface.co/models/distilbert-base-uncased-finetuned-sst-2-english";

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
        print("API Response: $decodedResponse");

        if (decodedResponse.isNotEmpty && decodedResponse[0] is List<dynamic>) {
          // Extract the highest-scoring prediction
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: fetchFeedbacksStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
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

            return FutureBuilder<Map<String, dynamic>>(
              future: analyzeFeedbackWithHuggingFace(feedbackText),
              builder: (context, analysisSnapshot) {
                if (analysisSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Card(
                    elevation: 4,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                if (analysisSnapshot.hasError ||
                    analysisSnapshot.data == null) {
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 4.0),
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

                return Card(
                  elevation: 4,
                  color: sentiment == "POSITIVE"
                      ? Colors.green[100]
                      : sentiment == "NEGATIVE"
                          ? Colors.red[100]
                          : Colors.orange[100],
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Feedback Message
                        Text(
                          "Feedback: $feedbackText",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Sentiment
                        Row(
                          children: [
                            const Text(
                              'Sentiment: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(sentiment),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Confidence
                        Row(
                          children: [
                            const Text(
                              'Confidence: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("$confidence%"),
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
    );
  }
}
