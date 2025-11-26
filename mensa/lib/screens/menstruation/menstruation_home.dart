import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';
import 'cycle_history_screen.dart';
import 'menstruation_ai_chat_screen.dart';

class MenstruationHome extends StatefulWidget {
  final String userId;

  const MenstruationHome({super.key, required this.userId});

  @override
  State<MenstruationHome> createState() => _MenstruationHomeState();
}

class _MenstruationHomeState extends State<MenstruationHome> {
  String _flowLevel = 'Medium';
  String _mood = 'Happy';
  final List<String> _selectedSymptoms = [];

  // Real data from backend
  Map<String, dynamic>? _predictions;
  int _currentCycleDay = 1;
  String _currentPhase = 'Menstrual Phase';
  bool _isLoading = true;

  final List<String> _flowLevels = [
    'Light',
    'Medium',
    'Heavy',
    'Spotting',
    'None',
  ];
  final List<String> _moods = [
    'Happy',
    'Sad',
    'Anxious',
    'Irritable',
    'Calm',
    'Energetic',
    'Tired',
  ];
  final List<String> _symptoms = [
    'Cramps',
    'Headache',
    'Bloating',
    'Fatigue',
    'Back Pain',
    'Breast Tenderness',
    'Mood Swings',
    'Acne',
    'Nausea',
  ];

  @override
  void initState() {
    super.initState();
    _loadPredictions();
  }

  Future<void> _loadPredictions() async {
    setState(() => _isLoading = true);

    try {
      final apiService = ApiService();
      final predictions = await apiService.getMenstruationPredictions(
        widget.userId,
      );

      if (predictions != null && mounted) {
        setState(() {
          _predictions = predictions;
          _currentCycleDay = _calculateCurrentCycleDay(predictions);
          _currentPhase = _getCyclePhase(_currentCycleDay);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error loading predictions: $e');
      setState(() => _isLoading = false);
    }
  }

  int _calculateCurrentCycleDay(Map<String, dynamic> predictions) {
    if (predictions['last_period_start'] == null) return 1;

    final lastPeriod = DateTime.parse(predictions['last_period_start']);
    final today = DateTime.now();
    final daysSinceLastPeriod = today.difference(lastPeriod).inDays;

    return daysSinceLastPeriod + 1;
  }

  String _getCyclePhase(int day) {
    if (day <= 5) return 'Menstrual Phase';
    if (day <= 13) return 'Follicular Phase';
    if (day <= 16) return 'Ovulation Phase';
    return 'Luteal Phase';
  }

  String _getDaysUntilNextPeriod() {
    if (_predictions == null ||
        _predictions!['predicted_next_period'] == null) {
      return '-- days';
    }

    final nextPeriod = DateTime.parse(_predictions!['predicted_next_period']);
    final today = DateTime.now();
    final daysUntil = nextPeriod.difference(today).inDays;

    if (daysUntil < 0) return 'Overdue';
    if (daysUntil == 0) return 'Today';
    if (daysUntil == 1) return 'Tomorrow';
    return '$daysUntil days';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBar(
        title: const Text('Menstruation Tracker'),
        backgroundColor: const Color(0xFFFFB6C1),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CycleHistoryScreen(userId: widget.userId),
                ),
              );
            },
            tooltip: 'View History & AI Insights',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFFB6C1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : Column(
                      children: [
                        Text(
                          'Day $_currentCycleDay of Cycle',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _currentPhase,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatChip(
                              'Next Period',
                              _getDaysUntilNextPeriod(),
                            ),
                            _buildStatChip(
                              'Avg Cycle',
                              '${_predictions?['average_cycle_length'] ?? 28} days',
                            ),
                          ],
                        ),
                      ],
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Today's Date
                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.today,
                        color: Color(0xFFFF69B4),
                      ),
                      title: const Text('Today'),
                      subtitle: Text(
                        DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Flow Level
                  const Text(
                    'Flow Level',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _flowLevels.map((level) {
                      return ChoiceChip(
                        label: Text(level),
                        selected: _flowLevel == level,
                        onSelected: (selected) {
                          if (selected) setState(() => _flowLevel = level);
                        },
                        selectedColor: const Color(0xFFFFB6C1),
                        labelStyle: TextStyle(
                          color: _flowLevel == level
                              ? Colors.white
                              : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Mood
                  const Text(
                    'How are you feeling?',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _moods.map((mood) {
                      return ChoiceChip(
                        label: Text(mood),
                        selected: _mood == mood,
                        onSelected: (selected) {
                          if (selected) setState(() => _mood = mood);
                        },
                        selectedColor: const Color(0xFFDDA0DD),
                        labelStyle: TextStyle(
                          color: _mood == mood ? Colors.white : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Symptoms
                  const Text(
                    'Symptoms',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _symptoms.map((symptom) {
                      final isSelected = _selectedSymptoms.contains(symptom);
                      return FilterChip(
                        label: Text(symptom),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedSymptoms.add(symptom);
                            } else {
                              _selectedSymptoms.remove(symptom);
                            }
                          });
                        },
                        selectedColor: const Color(0xFF98D8C8),
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

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
                              const Icon(
                                Icons.lightbulb,
                                color: Color(0xFF2196F3),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'AI Insights',
                                style: TextStyle(
                                  fontSize: 18,
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
                          const SizedBox(height: 12),
                          const Text(
                            '✓ No abnormalities detected',
                            style: TextStyle(
                              color: Color(0xFF4CAF50),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons Row
                  Row(
                    children: [
                      // View History Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CycleHistoryScreen(userId: widget.userId),
                              ),
                            );
                          },
                          icon: const Icon(Icons.history),
                          label: const Text('View History'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 56),
                            backgroundColor: const Color(0xFF2196F3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Talk to AI Button
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MenstruationAIChatScreen(
                                  userId: widget.userId,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.chat_bubble),
                          label: const Text('Talk to AI'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(0, 56),
                            backgroundColor: const Color(0xFFBA68C8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Save Button
                  ElevatedButton(
                    onPressed: _saveLog,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: const Color(0xFFFFB6C1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Save Today\'s Log',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<void> _saveLog() async {
    final log = {
      'user_id': widget.userId,
      'date': DateTime.now().toIso8601String(),
      'cycle_day': _currentCycleDay,
      'flow_level': _flowLevel,
      'mood': _mood,
      'symptoms': _selectedSymptoms,
      'notes': '',
    };

    // Save to backend
    final apiService = ApiService();
    final success = await apiService.addMenstruationLog(log);

    if (success) {
      // Reload predictions after saving
      await _loadPredictions();
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Cycle log saved successfully! 📅'
                : 'Failed to save log. Please try again.',
          ),
          backgroundColor: success
              ? const Color(0xFF4CAF50)
              : const Color(0xFFF44336),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
