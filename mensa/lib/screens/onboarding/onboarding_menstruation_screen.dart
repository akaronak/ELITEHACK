import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/user_profile.dart';
import '../../services/api_service.dart';

class OnboardingMenstruationScreen extends StatefulWidget {
  final String userId;
  final VoidCallback onComplete;
  final Map<String, dynamic>? initialData;

  const OnboardingMenstruationScreen({
    super.key,
    required this.userId,
    required this.onComplete,
    this.initialData,
  });

  @override
  State<OnboardingMenstruationScreen> createState() =>
      _OnboardingMenstruationScreenState();
}

class _OnboardingMenstruationScreenState
    extends State<OnboardingMenstruationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentPage = 0;

  // Form fields
  DateTime? _lastPeriodDate;
  int _cycleLengthDays = 28;
  int _periodDurationDays = 5;

  // Medical information
  bool? _hasPCOS;

  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_lastPeriodDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your last period start date'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final apiService = ApiService();

      // Get initial data
      final initialData = widget.initialData ?? {};
      final medications =
          initialData['medications']?.toString().trim().isEmpty ?? true
          ? <String>[]
          : initialData['medications']
                .toString()
                .trim()
                .split(',')
                .map((e) => e.trim())
                .toList();

      final profile = UserProfile(
        userId: widget.userId,
        name: initialData['name']?.toString() ?? 'User',
        age: initialData['age'] as int? ?? 25,
        height: initialData['height'] as double? ?? 160.0,
        weight: initialData['weight'] as double? ?? 60.0,
        trackerType: 'menstruation',
        medicalConditions: List<String>.from(
          initialData['medical_conditions'] ?? [],
        ),
        allergies: List<String>.from(initialData['allergies'] ?? []),
        medications: medications,
      );

      final profileSuccess = await apiService.saveUserProfile(profile);

      // Save initial cycle data
      final cycleLog = {
        'user_id': widget.userId,
        'date': _lastPeriodDate!.toIso8601String(),
        'flow': 'medium',
        'symptoms': <String>[],
        'mood': 'normal',
        'notes': 'Initial setup - last period start',
        'cycle_length': _cycleLengthDays,
        'period_duration': _periodDurationDays,
      };

      final cycleSuccess = await apiService.addMenstruationLog(cycleLog);

      if (profileSuccess && cycleSuccess && mounted) {
        widget.onComplete();
      } else {
        throw Exception('Failed to save profile');
      }
    } catch (e) {
      debugPrint('Error saving profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save profile. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  void _nextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _saveProfile();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF5FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Progress indicator
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: List.generate(2, (index) {
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 4,
                            decoration: BoxDecoration(
                              color: index <= _currentPage
                                  ? const Color(0xFFBA68C8)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // Pages
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (page) {
                          setState(() => _currentPage = page);
                        },
                        children: [
                          _buildPCOSQuestionPage(),
                          _buildCycleInfoPage(),
                        ],
                      ),
                    ),
                  ),

                  // Navigation buttons
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        if (_currentPage > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _previousPage,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: const BorderSide(
                                  color: Color(0xFFBA68C8),
                                ),
                              ),
                              child: const Text('Back'),
                            ),
                          ),
                        if (_currentPage > 0) const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFBA68C8),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              _currentPage < 1 ? 'Next' : 'Complete Setup',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCycleInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFBA68C8), Color(0xFFCE93D8)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFBA68C8).withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.event_note, size: 48, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'Cycle Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Help us track your menstrual cycle',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today, color: Color(0xFFBA68C8)),
            title: const Text('Last Period Start Date *'),
            subtitle: Text(
              _lastPeriodDate == null
                  ? 'Tap to select date'
                  : '${_lastPeriodDate!.day}/${_lastPeriodDate!.month}/${_lastPeriodDate!.year}',
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(const Duration(days: 7)),
                firstDate: DateTime.now().subtract(const Duration(days: 60)),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                setState(() => _lastPeriodDate = date);
              }
            },
          ),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Average Cycle Length',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Slider(
            value: _cycleLengthDays.toDouble(),
            min: 21,
            max: 35,
            divisions: 14,
            label: '$_cycleLengthDays days',
            activeColor: const Color(0xFFBA68C8),
            onChanged: (value) {
              setState(() => _cycleLengthDays = value.toInt());
            },
          ),
          Text(
            '$_cycleLengthDays days',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Text(
            'Typical Period Duration',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Slider(
            value: _periodDurationDays.toDouble(),
            min: 3,
            max: 7,
            divisions: 4,
            label: '$_periodDurationDays days',
            activeColor: const Color(0xFFBA68C8),
            onChanged: (value) {
              setState(() => _periodDurationDays = value.toInt());
            },
          ),
          Text(
            '$_periodDurationDays days',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPCOSQuestionPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFBA68C8), Color(0xFFCE93D8)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFBA68C8).withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.favorite, size: 48, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'PCOS Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Help us personalize your experience',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Have you been diagnosed with PCOS?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildOptionCard(
            title: 'Yes, I have PCOS',
            description: 'I\'ve been diagnosed by a healthcare provider',
            icon: Icons.check_circle,
            isSelected: _hasPCOS == true,
            onTap: () => setState(() => _hasPCOS = true),
          ),
          const SizedBox(height: 12),
          _buildOptionCard(
            title: 'No, I don\'t have PCOS',
            description: 'I have regular menstrual cycles',
            icon: Icons.cancel,
            isSelected: _hasPCOS == false,
            onTap: () => setState(() => _hasPCOS = false),
          ),
          const SizedBox(height: 12),
          _buildOptionCard(
            title: 'Not sure / Not diagnosed',
            description: 'I\'m not certain about my PCOS status',
            icon: Icons.help_outline,
            isSelected:
                _hasPCOS == null && _hasPCOS != true && _hasPCOS != false,
            onTap: () => setState(() => _hasPCOS = null),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'PCOS affects 1 in 10 women and can cause irregular periods, weight gain, and other symptoms. We\'ll provide specialized tracking if you have PCOS.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue.shade900,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFBA68C8).withValues(alpha: 0.1)
              : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFFBA68C8) : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFBA68C8)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? const Color(0xFFBA68C8)
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFFBA68C8),
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
