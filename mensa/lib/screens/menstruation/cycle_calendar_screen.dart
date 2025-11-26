import 'package:flutter/material.dart';

class CycleCalendarScreen extends StatelessWidget {
  final String userId;

  const CycleCalendarScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBar(
        title: const Text('Cycle Calendar'),
        backgroundColor: const Color(0xFFFFB6C1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Current Cycle Info
            Card(
              color: const Color(0xFFFFE4E1),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Day 14 of Cycle',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ovulation Phase',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoChip('Next Period', '14 days'),
                        _buildInfoChip('Avg Cycle', '28 days'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Calendar placeholder
            Card(
              child: Container(
                height: 300,
                padding: const EdgeInsets.all(16),
                child: const Center(
                  child: Text(
                    'Calendar View\n(To be implemented with calendar package)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Quick Stats
            const Text(
              'Cycle Statistics',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildStatCard(
              'Average Cycle Length',
              '28 days',
              Icons.calendar_month,
            ),
            _buildStatCard('Last Period', '14 days ago', Icons.event),
            _buildStatCard(
              'Cycle Regularity',
              '95% Regular',
              Icons.check_circle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF69B4),
          ),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFFFB6C1)),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF69B4),
          ),
        ),
      ),
    );
  }
}
