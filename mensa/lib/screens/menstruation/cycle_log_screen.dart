import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CycleLogScreen extends StatefulWidget {
  final String userId;

  const CycleLogScreen({super.key, required this.userId});

  @override
  State<CycleLogScreen> createState() => _CycleLogScreenState();
}

class _CycleLogScreenState extends State<CycleLogScreen> {
  DateTime _selectedDate = DateTime.now();
  String _flowLevel = 'Medium';
  String _mood = 'Happy';
  final List<String> _selectedSymptoms = [];

  final List<String> _flowLevels = ['Light', 'Medium', 'Heavy', 'Spotting'];
  final List<String> _moods = [
    'Happy',
    'Sad',
    'Anxious',
    'Irritable',
    'Calm',
    'Energetic',
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBar(
        title: const Text('Log Your Cycle'),
        backgroundColor: const Color(0xFFFFB6C1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Selection
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.calendar_today,
                  color: Color(0xFFFFB6C1),
                ),
                title: const Text('Date'),
                subtitle: Text(
                  DateFormat('MMMM dd, yyyy').format(_selectedDate),
                ),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 90),
                    ),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => _selectedDate = date);
                  }
                },
              ),
            ),

            const SizedBox(height: 20),

            // Flow Level
            const Text(
              'Flow Level',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _flowLevels.map((level) {
                return ChoiceChip(
                  label: Text(level),
                  selected: _flowLevel == level,
                  onSelected: (selected) {
                    if (selected) setState(() => _flowLevel = level);
                  },
                  selectedColor: const Color(0xFFFFB6C1),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Mood
            const Text(
              'How are you feeling?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _moods.map((mood) {
                return ChoiceChip(
                  label: Text(mood),
                  selected: _mood == mood,
                  onSelected: (selected) {
                    if (selected) setState(() => _mood = mood);
                  },
                  selectedColor: const Color(0xFFDDA0DD),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Symptoms
            const Text(
              'Symptoms',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
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
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Save Button
            ElevatedButton(
              onPressed: _saveLog,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: const Color(0xFFFFB6C1),
              ),
              child: const Text('Save Log', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  void _saveLog() {
    // TODO: Save to backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cycle log saved successfully!')),
    );
  }
}
