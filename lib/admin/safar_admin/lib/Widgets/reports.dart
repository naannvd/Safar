import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int positiveCount = 0;
  int negativeCount = 0;
  Map<String, int> categoryCounts = {};
  List<String> keyPhrases = [];

  Future<void> fetchFeedbacksAndAnalyze() async {
    try {
      final feedbackSnapshot = await FirebaseFirestore.instance
          .collection('feedback')
          .orderBy('createdAt', descending: true)
          .get();

      final feedbacks = feedbackSnapshot.docs.map((doc) => doc.data()).toList();

      int posCount = 0;
      int negCount = 0;
      Map<String, int> categories = {};
      List<String> phrases = [];

      for (var feedback in feedbacks) {
        final feedbackText = feedback['message'] ?? '';

        // Sentiment Analysis
        final sentimentResult =
            await analyzeFeedbackWithHuggingFace(feedbackText, sentiment: true);
        if (sentimentResult['label'] == 'POSITIVE') {
          posCount++;
        } else if (sentimentResult['label'] == 'NEGATIVE') {
          negCount++;
        }

        // Text Categorization
        final categoryResult = await analyzeFeedbackWithHuggingFace(
            feedbackText,
            categorize: true);
        final category = categoryResult['category'] ?? 'Uncategorized';
        categories[category] = (categories[category] ?? 0) + 1;

        // Key Phrase Extraction
        final phrasesResult = await analyzeFeedbackWithHuggingFace(feedbackText,
            extractPhrases: true);
        phrases.addAll(phrasesResult['keyPhrases'] ?? []);
      }

      setState(() {
        positiveCount = posCount;
        negativeCount = negCount;
        categoryCounts = categories;
        keyPhrases = phrases;
      });
    } catch (e) {
      print("Error fetching and analyzing feedbacks: $e");
    }
  }

  Future<Map<String, dynamic>> analyzeFeedbackWithHuggingFace(
    String text, {
    bool sentiment = false,
    bool categorize = false,
    bool extractPhrases = false,
  }) async {
    const apiKey = "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";

    String apiUrl;
    dynamic body;

    if (sentiment) {
      apiUrl =
          "https://api-inference.huggingface.co/models/distilbert-base-uncased-finetuned-sst-2-english";
      body = {"inputs": text};
    } else if (categorize) {
      apiUrl =
          "https://api-inference.huggingface.co/models/facebook/bart-large-mnli";
      body = {
        "inputs": text,
        "parameters": {
          "candidate_labels": [
            "Customer Support",
            "Product Feedback",
            "Complaint"
          ]
        }
      };
    } else if (extractPhrases) {
      apiUrl =
          "https://api-inference.huggingface.co/models/dslim/bert-base-NER";
      body = {"inputs": text};
    } else {
      return {};
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);

        if (sentiment) {
          return decodedResponse[0];
        } else if (categorize) {
          final label = decodedResponse['labels'][0]; // Top category
          final score = decodedResponse['scores'][0]; // Confidence score
          return {'category': label, 'score': score};
        } else if (extractPhrases) {
          final entities = decodedResponse['entities'];
          final phrases = entities.map((e) => e['word']).toList();
          return {'keyPhrases': phrases};
        }
      } else {
        print("Error from Hugging Face API: ${response.body}");
      }
    } catch (e) {
      print("Error during API call: $e");
    }

    return {};
  }

  @override
  void initState() {
    super.initState();
    fetchFeedbacksAndAnalyze();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reports',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Pie Chart for Sentiment Analysis
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: positiveCount.toDouble(),
                      title: 'Positive',
                      color: Colors.green,
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: negativeCount.toDouble(),
                      title: 'Negative',
                      color: Colors.red,
                      radius: 50,
                    ),
                  ],
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Display Key Phrases
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Key Phrases',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      keyPhrases.join(', '),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            // Display Text Categorization
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Text Categorization',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    ...categoryCounts.entries.map((entry) {
                      return Text(
                        '${entry.key}: ${entry.value}',
                        style: const TextStyle(fontSize: 14),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
