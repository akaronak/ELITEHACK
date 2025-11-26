import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class PregnancySetupScreen extends StatefulWidget {
  final String userId;
  final VoidCallback onSetupComplete;

  const PregnancySetupScreen({
    super.key,
    required this.userId,
    required this.onSetupComplete,
  });

  @override
  State<PregnancySetupScreen> createState() => _PregnancySetupScreenState();
}

class _PregnancySetupScreenState extends State<PregnancySetupScreen> {
  final ApiService _apiService = ApiService();
  DateTime? _selectedDueDate;
  DateTime? _selectedLMP;
  bool _isLoading = false;
  int _setupStep = 0; // 0: welcome, 1: choose method, 2: enter date

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      body: SafeArea(child: _buildStepContent()),
    );
  }

  Widget _buildStepContent() {
    switch (_setupStep) {
      case 0:
        return _buildWelcomeStep();
      case 1:
        return _buildMethodSelectionStep();
      case 2:
        return _buildDateInputStep();
      default:
        return _buildWelcomeStep();
    }
  }

  Widget _buildWelcomeStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pregnant_woman, size: 120, color: Color(0xFFFFB6C1)),
          const SizedBox(height: 32),
          const Text(
            'Welcome to Pregnancy Tracker! 🤰',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF69B4),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Let\'s set up your pregnancy journey.\nWe\'ll track your progress week by week!',
            style: TextStyle(fontSize: 16, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _setupStep = 1;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB6C1),
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Get Started',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodSelectionStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'How would you like to track?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF69B4),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildMethodCard(
            'Due Date',
            'I know my due date',
            Icons.calendar_today,
            () {
              setState(() {
                _setupStep = 2;
                _selectedLMP = null;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildMethodCard(
            'Last Menstrual Period',
            'I know my last period date',
            Icons.event,
            () {
              setState(() {
                _setupStep = 2;
                _selectedDueDate = null;
              });
            },
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () {
              setState(() {
                _setupStep = 0;
              });
            },
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodCard(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                const Color(0xFFFFB6C1).withValues(alpha: 0.7),
                const Color(0xFFFFB6C1),
              ],
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateInputStep() {
    final isUsingDueDate = _selectedLMP == null;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isUsingDueDate
                ? 'When is your due date?'
                : 'When was your last period?',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF69B4),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Icon(
                    isUsingDueDate ? Icons.calendar_today : Icons.event,
                    size: 64,
                    color: const Color(0xFFFFB6C1),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isUsingDueDate
                        ? (_selectedDueDate != null
                              ? '${_selectedDueDate!.day}/${_selectedDueDate!.month}/${_selectedDueDate!.year}'
                              : 'Select Date')
                        : (_selectedLMP != null
                              ? '${_selectedLMP!.day}/${_selectedLMP!.month}/${_selectedLMP!.year}'
                              : 'Select Date'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _selectDate,
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Choose Date'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB6C1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          if ((isUsingDueDate && _selectedDueDate != null) ||
              (!isUsingDueDate && _selectedLMP != null))
            ElevatedButton(
              onPressed: _isLoading ? null : _createProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF69B4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Start Tracking',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
            ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              setState(() {
                _setupStep = 1;
                _selectedDueDate = null;
                _selectedLMP = null;
              });
            },
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final isUsingDueDate = _selectedLMP == null;
    final initialDate = isUsingDueDate
        ? (_selectedDueDate ?? DateTime.now().add(const Duration(days: 280)))
        : (_selectedLMP ?? DateTime.now().subtract(const Duration(days: 14)));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFFB6C1),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isUsingDueDate) {
          _selectedDueDate = picked;
        } else {
          _selectedLMP = picked;
        }
      });
    }
  }

  Future<void> _createProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      DateTime dueDate;
      DateTime lmp;

      if (_selectedDueDate != null) {
        dueDate = _selectedDueDate!;
        lmp = dueDate.subtract(const Duration(days: 280));
      } else {
        lmp = _selectedLMP!;
        dueDate = lmp.add(const Duration(days: 280));
      }

      await _apiService.createPregnancyProfile(widget.userId, lmp, dueDate);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile created successfully! 🎉'),
            backgroundColor: Colors.green,
          ),
        );
        widget.onSetupComplete();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
