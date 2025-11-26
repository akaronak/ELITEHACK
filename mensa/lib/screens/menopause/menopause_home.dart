import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MenopauseHome extends StatefulWidget {
  final String userId;

  const MenopauseHome({super.key, required this.userId});

  @override
  State<MenopauseHome> createState() => _MenopauseHomeState();
}

class _MenopauseHomeState extends State<MenopauseHome> {
  String _mood = 'Calm';
  int _hotFlashesCount = 0;
  int _sleepQuality = 7;
  final List<String> _selectedSymptoms = [];

  final List<String> _moods = [
    'Happy',
    'Calm',
    'Anxious',
    'Irritable',
    'Sad',
    'Energetic',
    'Tired',
  ];
  final List<String> _symptoms = [
    'Hot Flashes',
    'Night Sweats',
    'Mood Swings',
    'Fatigue',
    'Sleep Problems',
    'Weight Gain',
    'Memory Issues',
    'Joint Pain',
    'Headaches',
    'Anxiety',
    'Depression',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBar(
        title: const Text('Menopause Tracker'),
        backgroundColor: const Color(0xFFDDA0DD),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.assessment),
            onPressed: _generateReport,
            tooltip: 'Generate Health Report',
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
                color: Color(0xFFDDA0DD),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Good Morning, Mensa! 💜',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Managing your menopause journey',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatChip('Days Tracked', '45'),
                      _buildStatChip('Avg Symptoms', '3/day'),
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
                        color: Color(0xFFBA68C8),
                      ),
                      title: const Text('Today'),
                      subtitle: Text(
                        DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Hot Flashes Counter
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hot Flashes Today',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (_hotFlashesCount > 0) {
                                    setState(() => _hotFlashesCount--);
                                  }
                                },
                                icon: const Icon(Icons.remove_circle),
                                iconSize: 40,
                                color: const Color(0xFFFF5252),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                '$_hotFlashesCount',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFBA68C8),
                                ),
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                onPressed: () =>
                                    setState(() => _hotFlashesCount++),
                                icon: const Icon(Icons.add_circle),
                                iconSize: 40,
                                color: const Color(0xFF4CAF50),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sleep Quality
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sleep Quality: $_sleepQuality/10',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Slider(
                            value: _sleepQuality.toDouble(),
                            min: 0,
                            max: 10,
                            divisions: 10,
                            label: _sleepQuality.toString(),
                            activeColor: const Color(0xFFBA68C8),
                            onChanged: (value) {
                              setState(() => _sleepQuality = value.toInt());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

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
                        selectedColor: const Color(0xFFBA68C8),
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
                    color: const Color(0xFFE8D5F2),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.lightbulb,
                                color: Color(0xFF7B1FA2),
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
                            'Your hot flashes have decreased by 20% this week. '
                            'Sleep quality is improving. Keep up with your wellness routine!',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Save Button
                  ElevatedButton(
                    onPressed: _saveLog,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: const Color(0xFFDDA0DD),
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

  void _saveLog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Health log saved successfully! 💜'),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _generateReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.assessment, color: Color(0xFFBA68C8)),
            SizedBox(width: 8),
            Text('Generate Health Report'),
          ],
        ),
        content: const Text(
          'AI will analyze your health data from the past 30 days and generate '
          'a comprehensive report with insights and recommendations.\n\n'
          'This may take a few moments.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Generating report... Check back in a few minutes!',
                  ),
                  backgroundColor: const Color(0xFFBA68C8),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDDA0DD),
            ),
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }
}
