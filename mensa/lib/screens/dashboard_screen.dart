import 'package:flutter/material.dart';
import '../models/user_pregnancy.dart';
import '../services/api_service.dart';
import '../services/date_calculator_service.dart';
import 'daily_log_screen.dart';
import 'nutrition_screen.dart';
import 'checklist_screen.dart';
import 'ai_chat_screen.dart';
import 'breathing_game_screen.dart';
import 'weekly_progress_screen.dart';

class DashboardScreen extends StatefulWidget {
  final String userId;

  const DashboardScreen({super.key, required this.userId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  UserPregnancy? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _apiService.getPregnancyProfile(widget.userId);
    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_profile == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Unable to load profile'),
              ElevatedButton(
                onPressed: _loadProfile,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final currentWeek = _profile!.currentWeek;
    final trimester = _profile!.trimester;
    final daysUntilDue = DateCalculatorService.daysUntilDueDate(
      _profile!.dueDate,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBar(
        title: const Text('Pregnancy Tracker'),
        backgroundColor: const Color(0xFFFFB6C1),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadProfile),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Card
            Card(
              color: const Color(0xFFFFE4E1),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good ${_getTimeOfDay()}, Mensa! 💕',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Week $currentWeek • ${DateCalculatorService.getTrimesterName(trimester)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      '$daysUntilDue days until your due date',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Quick Actions Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildDashboardCard(
                  'Weekly Progress',
                  Icons.calendar_today,
                  const Color(0xFFFFB6C1),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeeklyProgressScreen(
                        userId: widget.userId,
                        currentWeek: currentWeek,
                      ),
                    ),
                  ),
                ),
                _buildDashboardCard(
                  'Daily Log',
                  Icons.edit_note,
                  const Color(0xFFDDA0DD),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DailyLogScreen(userId: widget.userId),
                    ),
                  ),
                ),
                _buildDashboardCard(
                  'Nutrition',
                  Icons.restaurant,
                  const Color(0xFF98D8C8),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NutritionScreen(
                        userId: widget.userId,
                        profile: _profile!,
                      ),
                    ),
                  ),
                ),
                _buildDashboardCard(
                  'Checklist',
                  Icons.checklist,
                  const Color(0xFFF7DC6F),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChecklistScreen(
                        userId: widget.userId,
                        currentWeek: currentWeek,
                      ),
                    ),
                  ),
                ),
                _buildDashboardCard(
                  'AI Assistant',
                  Icons.chat_bubble,
                  const Color(0xFF85C1E9),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AIChatScreen(
                        userId: widget.userId,
                        currentWeek: currentWeek,
                      ),
                    ),
                  ),
                ),
                _buildDashboardCard(
                  'Breathing Exercise',
                  Icons.spa,
                  const Color(0xFFAED6F1),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BreathingGameScreen(userId: widget.userId),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.7), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }
}
