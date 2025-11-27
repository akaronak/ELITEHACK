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
  final List<String> _selectedMoods = [];
  final List<String> _selectedSymptoms = [];

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Flow Level',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () =>
                      _showAddCustomDialog('Flow Level', _flowLevels),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFFFB6C1),
                  ),
                ),
              ],
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
                  backgroundColor: const Color(0xFFFFF0F5),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Mood (Multiple Selection)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'How are you feeling?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => _showAddCustomDialog('Mood', _moods),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFDDA0DD),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _moods.map((mood) {
                final isSelected = _selectedMoods.contains(mood);
                return FilterChip(
                  label: Text(mood),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedMoods.add(mood);
                      } else {
                        _selectedMoods.remove(mood);
                      }
                    });
                  },
                  selectedColor: const Color(0xFFDDA0DD),
                  backgroundColor: const Color(0xFFFFF0F5),
                  checkmarkColor: Colors.white,
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Symptoms
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Symptoms',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => _showAddCustomDialog('Symptom', _symptoms),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF98D8C8),
                  ),
                ),
              ],
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
                  backgroundColor: const Color(0xFFF0FFF8),
                  checkmarkColor: Colors.white,
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

  void _showAddCustomDialog(String type, List<String> list) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Add Custom $type'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter custom $type',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: const Color(0xFFF0FFF8),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isNotEmpty && !list.contains(value)) {
                setState(() => list.add(value));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added "$value" to $type'),
                    backgroundColor: const Color(0xFF98D8C8),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              } else if (list.contains(value)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$type already exists'),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF98D8C8),
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _saveLog() {
    // TODO: Save to backend
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Cycle log saved!\nFlow: $_flowLevel\nMoods: ${_selectedMoods.join(", ")}\nSymptoms: ${_selectedSymptoms.join(", ")}',
        ),
        backgroundColor: const Color(0xFF98D8C8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
