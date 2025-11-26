import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/week_data.dart';

class WeeklyProgressScreen extends StatefulWidget {
  final String userId;
  final int currentWeek;

  const WeeklyProgressScreen({
    super.key,
    required this.userId,
    required this.currentWeek,
  });

  @override
  State<WeeklyProgressScreen> createState() => _WeeklyProgressScreenState();
}

class _WeeklyProgressScreenState extends State<WeeklyProgressScreen> {
  List<WeekData> _weekData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeekData();
  }

  Future<void> _loadWeekData() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/week_data.json',
      );
      final List<dynamic> data = json.decode(response);
      setState(() {
        _weekData = data.map((json) => WeekData.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading week data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        title: const Text('Weekly Progress'),
        backgroundColor: const Color(0xFFFFB6C1),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _weekData.length,
              itemBuilder: (context, index) {
                final week = _weekData[index];
                final isCurrentWeek = week.week == widget.currentWeek;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  color: isCurrentWeek ? const Color(0xFFFFE4E1) : null,
                  elevation: isCurrentWeek ? 4 : 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isCurrentWeek
                                    ? const Color(0xFFFF69B4)
                                    : const Color(0xFFFFB6C1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Week ${week.week}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isCurrentWeek) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.star, color: Color(0xFFFF69B4)),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),

                        _buildInfoRow(
                          Icons.child_care,
                          'Baby Growth',
                          week.babyGrowth,
                        ),
                        const SizedBox(height: 8),

                        _buildInfoRow(
                          Icons.favorite,
                          'Body Changes',
                          week.bodyChanges,
                        ),
                        const SizedBox(height: 8),

                        _buildInfoRow(Icons.lightbulb, 'Tips', week.tips),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFFFF69B4)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(content),
            ],
          ),
        ),
      ],
    );
  }
}
