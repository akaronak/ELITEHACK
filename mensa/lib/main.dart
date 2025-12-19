import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'screens/main_app_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/notification_service.dart';
import 'providers/theme_provider.dart';
import 'providers/localization_provider.dart';

// Top-level background message handler - MUST be at top level
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling background message: ${message.messageId}');
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

  // Check if user is logged in and onboarding completed
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
  final userId = prefs.getString('user_id');
  final savedLanguage = prefs.getString('app_language') ?? 'en';
  final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

  debugPrint('🔐 Login status: $isLoggedIn, User ID: $userId');
  debugPrint('📱 Onboarding completed: $onboardingCompleted');

  runApp(
    MensaApp(
      isLoggedIn: isLoggedIn,
      userId: userId,
      initialLanguage: savedLanguage,
      onboardingCompleted: onboardingCompleted,
    ),
  );
}

class MensaApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? userId;
  final String initialLanguage;
  final bool onboardingCompleted;

  const MensaApp({
    super.key,
    required this.isLoggedIn,
    this.userId,
    required this.initialLanguage,
    required this.onboardingCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => LocalizationProvider(initialLanguage),
        ),
      ],
      child: Consumer2<ThemeProvider, LocalizationProvider>(
        builder: (context, themeProvider, localizationProvider, _) {
          return MaterialApp(
            title: 'Mensa - Women\'s Health',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.getLightTheme(),
            darkTheme: themeProvider.getDarkTheme(),
            themeMode: themeProvider.themeMode,
            locale: Locale(localizationProvider.language),
            home: !onboardingCompleted
                ? const OnboardingScreen()
                : (isLoggedIn && userId != null
                      ? MainAppScreen(userId: userId!)
                      : const LoginScreen()),
          );
        },
      ),
    );
  }
}
