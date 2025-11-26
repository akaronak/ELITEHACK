import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/user_pregnancy.dart';
import '../services/api_service.dart';
import '../services/date_calculator_service.dart';
import 'dashboard_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final String userId;

  const OnboardingScreen({super.key, required this.userId});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _lmpDate;
  DateTime? _dueDate;
  bool _useLMP = true;
  final List<String> _selectedAllergies = [];
  final List<String> _selectedPreferences = [];

  final List<String> _allergyOptions = [
    'Lactose',
    'Dairy',
    'Eggs',
    'Fish',
    'Shellfish',
    'Nuts',
    'Tree Nuts',
    'Peanuts',
    'Gluten',
    'Wheat',
    'Soy',
  ];

  final List<String> _preferenceOptions = [
    'Vegetarian',
    'Vegan',
    'Pescatarian',
    'Halal',
    'Kosher',
  ];

  final ApiService _apiService = ApiService();

  Future<void> _selectDate(BuildContext context, bool isLMP) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 60)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isLMP) {
          _lmpDate = picked;
          _dueDate = DateCalculatorService.calculateDueDateFromLMP(picked);
        } else {
          _dueDate = picked;
          _lmpDate = DateCalculatorService.calculateLMPFromDueDate(picked);
        }
      });
    }
  }

  Future<void> _submitProfile() async {
    if (_formKey.currentState!.validate()) {
      if (_lmpDate == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select a date')));
        return;
      }

      final profile = UserPregnancy(
        userId: widget.userId,
        lmpDate: _lmpDate!,
        dueDate: _dueDate!,
        allergies: _selectedAllergies,
        preferences: _selectedPreferences,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final success = await _apiService.createOrUpdatePregnancyProfile(profile);

      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(userId: widget.userId),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error saving profile. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBar(
        title: const Text('Pregnancy Tracker Setup'),
        backgroundColor: const Color(0xFFFFB6C1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to Your Pregnancy Journey!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Date Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Calculate Your Due Date',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Last Period'),
                              value: true,
                              groupValue: _useLMP,
                              onChanged: (value) =>
                                  setState(() => _useLMP = value!),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text('Due Date'),
                              value: false,
                              groupValue: _useLMP,
                              onChanged: (value) =>
                                  setState(() => _useLMP = value!),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      ElevatedButton.icon(
                        onPressed: () => _selectDate(context, _useLMP),
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          _useLMP
                              ? (_lmpDate == null
                                    ? 'Select Last Period Date'
                                    : 'LMP: ${DateFormat('MMM dd, yyyy').format(_lmpDate!)}')
                              : (_dueDate == null
                                    ? 'Select Due Date'
                                    : 'Due: ${DateFormat('MMM dd, yyyy').format(_dueDate!)}'),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),

                      if (_dueDate != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE4E1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Estimated Due Date: ${DateFormat('MMM dd, yyyy').format(_dueDate!)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Current Week: ${DateCalculatorService.calculateCurrentWeek(_lmpDate!)}',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Allergies
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Food Allergies',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _allergyOptions.map((allergy) {
                          final isSelected = _selectedAllergies.contains(
                            allergy,
                          );
                          return FilterChip(
                            label: Text(allergy),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedAllergies.add(allergy);
                                } else {
                                  _selectedAllergies.remove(allergy);
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

              const SizedBox(height: 20),

              // Dietary Preferences
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dietary Preferences',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _preferenceOptions.map((pref) {
                          final isSelected = _selectedPreferences.contains(
                            pref,
                          );
                          return FilterChip(
                            label: Text(pref),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedPreferences.add(pref);
                                } else {
                                  _selectedPreferences.remove(pref);
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

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _submitProfile,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: const Color(0xFFFFB6C1),
                ),
                child: const Text(
                  'Start My Journey',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
