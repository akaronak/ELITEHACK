import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user_profile.dart';
import 'onboarding/initial_onboarding_screen.dart';
import 'menstruation/menstruation_home.dart';
import 'menopause/menopause_home.dart';
import 'pregnancy/pregnancy_home.dart';

class MainAppScreen extends StatefulWidget {
  final String userId;

  const MainAppScreen({super.key, required this.userId});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  bool _isLoading = true;
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  Future<void> _checkProfile() async {
    try {
      final apiService = ApiService();
      final profileData = await apiService.getUserProfile(widget.userId);

      setState(() {
        if (profileData != null) {
          _userProfile = UserProfile.fromJson(profileData);
        }
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error checking profile: $e');
      setState(() {
        _userProfile = null;
        _isLoading = false;
      });
    }
  }

  void _refreshProfile() {
    setState(() => _isLoading = true);
    _checkProfile();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFFB6C1)),
        ),
      );
    }

    // Show onboarding if no profile
    if (_userProfile == null) {
      return InitialOnboardingScreen(userId: widget.userId);
    }

    // Route to appropriate home screen based on tracker type
    Widget homeScreen;
    switch (_userProfile!.trackerType) {
      case 'pregnancy':
        homeScreen = PregnancyHome(
          userId: widget.userId,
          onTrackerChanged: _refreshProfile,
        );
        break;
      case 'menopause':
        homeScreen = MenopauseHome(
          userId: widget.userId,
          onTrackerChanged: _refreshProfile,
        );
        break;
      case 'menstruation':
      default:
        homeScreen = MenstruationHome(
          userId: widget.userId,
          onTrackerChanged: _refreshProfile,
        );
        break;
    }

    return homeScreen;
  }
}
