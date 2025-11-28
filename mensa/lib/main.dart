import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/main_app_screen.dart';
import 'screens/auth/login_screen.dart';
import 'services/notification_service.dart';

// Top-level background message handler - MUST be at top level
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Register background message handler ONCE at app startup
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Check if user is logged in
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
  final userId = prefs.getString('user_id');

  debugPrint('🔐 Login status: $isLoggedIn, User ID: $userId');

  runApp(MensaApp(isLoggedIn: isLoggedIn, userId: userId));
}

class MensaApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? userId;

  const MensaApp({super.key, required this.isLoggedIn, this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mensa - Women\'s Health',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFFF5F7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB6C1),
          primary: const Color(0xFFFFB6C1),
        ),
        useMaterial3: true,
      ),
      home: isLoggedIn && userId != null
          ? MainAppScreen(userId: userId!)
          : const LoginScreen(),
    );
  }
}
