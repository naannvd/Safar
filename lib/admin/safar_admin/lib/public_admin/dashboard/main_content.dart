import 'package:flutter/material.dart';
import 'package:safar_admin/public_admin/Widgets/nlpanalysis.dart';
// import 'package:safar_admin/Widgets/nlpanalysis.dart';

class MainContent extends StatelessWidget {
  final String selectedTab;

  const MainContent({
    super.key,
    required this.selectedTab,
    required Widget content,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Two equal-sized columns
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Dashboard and Recent Tickets (separate cards)
              Expanded(
                child: Column(
                  children: [
                    // Dashboard Card
                    Card(
                      elevation: 4,
                      child: Container(
                        height: 180,
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            "$selectedTab Placeholder",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16), // Space between cards
                    // Recent Tickets Card
                    Card(
                      elevation: 4,
                      child: Container(
                        height: 180,
                        padding: const EdgeInsets.all(16),
                        child: const Center(
                          child: Text(
                            "Recent Tickets Placeholder",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16), // Space between columns
              // Right Column: Feedbacks
              Expanded(
                child: Card(
                  elevation: 4,
                  child: Container(
                    height: 400, // Matches the combined height of left cards
                    padding: const EdgeInsets.all(16),
                    // child: const FeedbacksSection(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Contacts Placeholder
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 4,
                  child: Container(
                    height: 400, // Adjusted to accommodate the NLP Widget
                    padding: const EdgeInsets.all(16),
                    child:
                        const HuggingFaceStreamNlpWidget(), // Add the NLP Widget here
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
