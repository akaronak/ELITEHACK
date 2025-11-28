import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'screens/main_app_screen.dart';
import 'screens/track_selection_screen.dart';
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

  runApp(const MensaApp());
}

class MensaApp extends StatelessWidget {
  const MensaApp({super.key});

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
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (context) =>
                  const MainAppScreen(userId: 'demo_user_123'),
            );
          case '/track-selection':
            // Generate new user ID for fresh start
            final newUserId = 'user_${DateTime.now().millisecondsSinceEpoch}';
            return MaterialPageRoute(
              builder: (context) => TrackSelectionScreen(userId: newUserId),
            );
          default:
            return MaterialPageRoute(
              builder: (context) =>
                  const MainAppScreen(userId: 'demo_user_123'),
            );
        }
      },
    );
  }
}
