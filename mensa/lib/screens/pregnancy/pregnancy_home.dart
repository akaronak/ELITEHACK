import 'package:flutter/material.dart';
import '../dashboard_screen.dart';

class PregnancyHome extends StatelessWidget {
  final String userId;

  const PregnancyHome({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Reuse the existing pregnancy dashboard
    return DashboardScreen(userId: userId);
  }
}
