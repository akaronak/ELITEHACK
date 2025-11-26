import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/daily_log.dart';
import '../services/api_service.dart';

class DailyLogScreen extends StatefulWidget {
  final String userId;

  const DailyLogScreen({super.key, required this.userId});

  @override
  State<DailyLogScreen> createState() => _DailyLogScreenState();
}

class _DailyLogScreenState extends State<DailyLogScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  String _selectedMood = 'Happy';
  final List<String> _selectedSymptoms = [];
  double _waterIntake = 8.0;
  final TextEditingController _weightController = TextEditingController();

  final List<String> _moodOptions = [
    'Happy',
    'Calm',
    'Anxious',
    'Tired',
    'Energetic',
    'Stressed',
    'Excited',
  ];

  final List<String> _symptomOptions = [
    'Nausea',
    'Fatigue',
    'Headache',
    'Back Pain',
    'Leg Cramps',
    'Heartburn',
    'Constipation',
    'Swelling',
    'Insomnia',
    'Braxton Hicks',
  ];

  Future<void> _submitLog() async {
    if (_formKey.currentState!.validate()) {
      final log = DailyLog(
        userId: widget.userId,
        date: DateTime.now(),
        mood: _selectedMood,
        symptoms: _selectedSymptoms,
        water: _waterIntake,
        weight: double.tryParse(_weightController.text) ?? 0.0,
      );

      final success = await _apiService.addDailyLog(log);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Log saved successfully!')),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error saving log')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBar(
        title: const Text('Daily Health Log'),
        backgroundColor: const Color(0xFFDDA0DD),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Mood Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'How are you feeling today?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: _moodOptions.map((mood) {
                          return ChoiceChip(
                            label: Text(mood),
                            selected: _selectedMood == mood,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() => _selectedMood = mood);
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Symptoms
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Any symptoms today?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: _symptomOptions.map((symptom) {
                          final isSelected = _selectedSymptoms.contains(
                            symptom,
                          );
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
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Water Intake
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Water Intake: ${_waterIntake.toInt()} glasses',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Slider(
                        value: _waterIntake,
                        min: 0,
                        max: 15,
                        divisions: 15,
                        label: _waterIntake.toInt().toString(),
                        onChanged: (value) {
                          setState(() => _waterIntake = value);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Weight
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Weight (lbs)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Enter your weight',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your weight';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _submitLog,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: const Color(0xFFDDA0DD),
                ),
                child: const Text('Save Log', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }
}
