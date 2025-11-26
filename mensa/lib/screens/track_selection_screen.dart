import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'menstruation/menstruation_dashboard.dart';
import 'menopause/menopause_dashboard.dart';
import 'pregnancy/pregnancy_onboarding_screen.dart';

class TrackSelectionScreen extends StatelessWidget {
  final String userId;

  const TrackSelectionScreen({super.key, required this.userId});

  Future<void> _selectTrack(BuildContext context, String track) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_track', track);

    if (!context.mounted) return;

    switch (track) {
      case 'menstruation':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MenstruationDashboard(userId: userId),
          ),
        );
        break;
      case 'menopause':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MenopauseDashboard(userId: userId),
          ),
        );
        break;
      case 'pregnancy':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PregnancyOnboardingScreen(userId: userId),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Welcome to Mensa',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF69B4),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your complete women\'s health companion',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 48),
              const Text(
                'Choose your health journey:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    _buildTrackCard(
                      context,
                      'Menstruation Tracker',
                      'Track your cycle, flow, and symptoms',
                      Icons.calendar_today,
                      const Color(0xFFFFB6C1),
                      'menstruation',
                    ),
                    const SizedBox(height: 16),
                    _buildTrackCard(
                      context,
                      'Menopause Tracker',
                      'Manage symptoms and track your journey',
                      Icons.favorite,
                      const Color(0xFFDDA0DD),
                      'menopause',
                    ),
                    const SizedBox(height: 16),
                    _buildTrackCard(
                      context,
                      'Pregnancy Tracker',
                      'Week-by-week pregnancy monitoring',
                      Icons.child_care,
                      const Color(0xFF98D8C8),
                      'pregnancy',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    String trackId,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _selectTrack(context, trackId),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.7), color],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 40, color: Colors.white),
              ),
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
                      description,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
