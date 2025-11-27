import 'package:flutter/material.dart';
import '../../models/user_pregnancy.dart';
import '../../services/api_service.dart';
import '../dashboard_screen.dart';
import 'pregnancy_setup_screen.dart';

class PregnancyHome extends StatefulWidget {
  final String userId;
  final VoidCallback? onTrackerChanged;

  const PregnancyHome({super.key, required this.userId, this.onTrackerChanged});

  @override
  State<PregnancyHome> createState() => _PregnancyHomeState();
}

class _PregnancyHomeState extends State<PregnancyHome> {
  final ApiService _apiService = ApiService();
  UserPregnancy? _profile;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final profile = await _apiService.getPregnancyProfile(widget.userId);
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFF5F7),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.pink[300]),
              const SizedBox(height: 16),
              const Text('Loading your pregnancy profile...'),
            ],
          ),
        ),
      );
    }

    // If no profile exists, show setup screen
    if (_profile == null || _error != null) {
      return PregnancySetupScreen(
        userId: widget.userId,
        onSetupComplete: () {
          _loadProfile();
        },
      );
    }

    // Show the main dashboard
    return DashboardScreen(
      userId: widget.userId,
      onTrackerChanged: widget.onTrackerChanged,
    );
  }
}
