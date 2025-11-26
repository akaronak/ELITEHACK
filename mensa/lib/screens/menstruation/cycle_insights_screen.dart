import 'package:flutter/material.dart';

class CycleInsightsScreen extends StatelessWidget {
  final String userId;

  const CycleInsightsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBar(
        title: const Text('Cycle Insights'),
        backgroundColor: const Color(0xFFFFB6C1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Insights Card
            Card(
              color: const Color(0xFFE8F4F8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Color(0xFF2196F3)),
                        const SizedBox(width: 8),
                        const Text(
                          'AI Insights',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your cycle has been regular for the past 3 months. '
                      'Based on your patterns, your next period is expected in 14 days.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Symptom Patterns
            const Text(
              'Symptom Patterns',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildSymptomCard('Cramps', 'Most common on Day 1-2', 'High'),
            _buildSymptomCard('Mood Swings', 'Common on Day 24-28', 'Medium'),
            _buildSymptomCard('Fatigue', 'Occasional throughout cycle', 'Low'),

            const SizedBox(height: 20),

            // Recommendations
            Card(
              color: const Color(0xFFFFF3CD),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.tips_and_updates,
                          color: Color(0xFFF57C00),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Recommendations',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildRecommendation('Stay hydrated during your period'),
                    _buildRecommendation('Light exercise can help with cramps'),
                    _buildRecommendation(
                      'Track your symptoms for better insights',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Alert Section
            Card(
              color: const Color(0xFFFFEBEE),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.warning_amber,
                          color: Color(0xFFD32F2F),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Health Alerts',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No abnormalities detected. Your cycle appears healthy and regular.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomCard(String symptom, String pattern, String severity) {
    Color severityColor;
    switch (severity) {
      case 'High':
        severityColor = Colors.red;
        break;
      case 'Medium':
        severityColor = Colors.orange;
        break;
      default:
        severityColor = Colors.green;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(symptom),
        subtitle: Text(pattern),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: severityColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            severity,
            style: TextStyle(color: severityColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendation(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 20, color: Color(0xFF4CAF50)),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
