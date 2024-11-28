import 'package:flutter/material.dart';

class MainContent extends StatelessWidget {
  final String selectedTab;

  const MainContent({
    super.key,
    required this.selectedTab,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Ensure full width
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: double.infinity),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: Container(
                      height: 200,
                      padding: const EdgeInsets.all(16),
                      child: Center(child: Text("$selectedTab Placeholder")),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: Container(
                      height: 200,
                      padding: const EdgeInsets.all(16),
                      child: const Center(child: Text("Calendar Placeholder")),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: double.infinity),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: Container(
                      height: 150,
                      padding: const EdgeInsets.all(16),
                      child: const Center(
                          child: Text("Recent Tickets Placeholder")),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    elevation: 4,
                    child: Container(
                      height: 150,
                      padding: const EdgeInsets.all(16),
                      child: const Center(
                          child: Text("Recent Feedback Placeholder")),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 4,
                  child: Container(
                    height: 100,
                    padding: const EdgeInsets.all(16),
                    child: const Center(child: Text("Contacts Placeholder")),
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
