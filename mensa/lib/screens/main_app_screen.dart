import 'package:flutter/material.dart';
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
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      MenstruationHome(userId: widget.userId),
      MenopauseHome(userId: widget.userId),
      PregnancyHome(userId: widget.userId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFFFF69B4),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            activeIcon: Icon(Icons.calendar_today, size: 28),
            label: 'Menstruation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            activeIcon: Icon(Icons.favorite, size: 28),
            label: 'Menopause',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.child_care),
            activeIcon: Icon(Icons.child_care, size: 28),
            label: 'Pregnancy',
          ),
        ],
      ),
    );
  }
}
