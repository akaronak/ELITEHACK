import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/user_profile.dart';
import '../../services/api_service.dart';

class RantingAIScreen extends StatefulWidget {
  final String userId;

  const RantingAIScreen({super.key, required this.userId});

  @override
  State<RantingAIScreen> createState() => _RantingAIScreenState();
}

class _RantingAIScreenState extends State<RantingAIScreen> {
  final ApiService _apiService = ApiService();
  UserProfile? _userProfile;
  bool _isLoadingProfile = true;
  bool _isCallActive = false;

  // Soft, calming colors
  static const Color _primaryPink = Color(0xFFE8C4C4);
  static const Color _lightPink = Color(0xFFF5E6E6);
  static const Color _accentPink = Color(0xFFD4A5A5);
  static const Color _darkPink = Color(0xFFA67C7C);
  static const Color _backgroundColor = Color(0xFFFAF5F5);
  static const Color _purpleAccent = Color(0xFFD4C4E8);

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profileData = await _apiService.getUserProfile(widget.userId);
      if (profileData != null) {
        setState(() {
          _userProfile = UserProfile.fromJson(profileData);
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
      setState(() => _isLoadingProfile = false);
    }
  }

  Future<void> _startVoiceCall() async {
    setState(() => _isCallActive = true);

    try {
      // Launch Agora voice call interface
      final url = Uri.parse('https://10.0.2.2:3002/');
      await launchUrl(url, mode: LaunchMode.externalApplication);

      // Keep the call active state for a moment
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isCallActive = false);
      }
    } catch (e) {
      debugPrint('Error starting voice call: $e');
      if (mounted) {
        setState(() => _isCallActive = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not open Voice AI. Please make sure the server is running.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _purpleAccent.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mic, color: _purpleAccent, size: 20),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ranting AI',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'I\'m here to listen',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: _isLoadingProfile
          ? const Center(child: CircularProgressIndicator(color: _accentPink))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [_primaryPink, _lightPink],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: _primaryPink.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: _darkPink,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Hi ${_userProfile?.name ?? 'there'}! 💕',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'I\'m here to listen to you',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // What I Do Section
                    const Text(
                      'What I Do',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildFeatureCard(
                      icon: Icons.hearing,
                      title: 'I Listen',
                      description:
                          'Share your feelings, frustrations, and concerns without judgment',
                      color: _purpleAccent,
                    ),
                    const SizedBox(height: 12),

                    _buildFeatureCard(
                      icon: Icons.favorite_border,
                      title: 'I Understand',
                      description:
                          'I recognize your emotions and validate your experiences',
                      color: _accentPink,
                    ),
                    const SizedBox(height: 12),

                    _buildFeatureCard(
                      icon: Icons.spa,
                      title: 'I Comfort',
                      description:
                          'Provide emotional support and help you feel safe and heard',
                      color: _primaryPink,
                    ),
                    const SizedBox(height: 12),

                    _buildFeatureCard(
                      icon: Icons.lightbulb_outline,
                      title: 'I Suggest',
                      description:
                          'Offer coping strategies and gentle guidance when you need it',
                      color: const Color(0xFFF7E8C8),
                    ),

                    const SizedBox(height: 32),

                    // How It Works Section
                    const Text(
                      'How It Works',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildStepCard(
                      step: 1,
                      title: 'Start a Voice Call',
                      description:
                          'Click the button below to begin a voice conversation',
                    ),
                    const SizedBox(height: 12),

                    _buildStepCard(
                      step: 2,
                      title: 'Share Your Feelings',
                      description:
                          'Talk about anything on your mind - I\'m here to listen',
                    ),
                    const SizedBox(height: 12),

                    _buildStepCard(
                      step: 3,
                      title: 'Get Support',
                      description:
                          'Receive empathetic responses and emotional support',
                    ),

                    const SizedBox(height: 32),

                    // Important Notes
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Colors.orange,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'I provide emotional support and listening. For medical concerns, please consult your healthcare provider.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Start Call Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isCallActive ? null : _startVoiceCall,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _darkPink,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isCallActive)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            else
                              const Icon(Icons.mic, size: 24),
                            const SizedBox(width: 12),
                            Text(
                              _isCallActive
                                  ? 'Starting...'
                                  : 'Start Voice Call',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Info Text
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _lightPink,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Your privacy is important. All conversations are confidential and designed to provide you with a safe space to express yourself.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required int step,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: _darkPink, shape: BoxShape.circle),
            child: Center(
              child: Text(
                '$step',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
