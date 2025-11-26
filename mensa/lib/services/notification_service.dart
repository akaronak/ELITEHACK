import 'package:firebase_messaging/firebase_messaging.dart';

// Top-level function for background message handling
// MUST be top-level or static
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  print('Message data: ${message.data}');
  print('Message notification: ${message.notification?.title}');
}

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission for iOS and Android 13+
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ User granted notification permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('⚠️ User granted provisional notification permission');
    } else {
      print('❌ User declined or has not accepted notification permission');
    }

    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    print('📱 FCM Token: $token');
    print('📋 Copy this token to test notifications from Firebase Console');
    // TODO: Send this token to your backend server

    // Listen for token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print('🔄 FCM Token refreshed: $newToken');
      // TODO: Send updated token to your backend server
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📨 Got a message in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('📬 Notification: ${message.notification!.title}');
        print('📝 Body: ${message.notification!.body}');
        // Notification will be displayed by the system automatically
      }
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🔔 Notification tapped! Opening app...');
      print('Message data: ${message.data}');
      // TODO: Navigate to specific screen based on message data
    });

    // Check if app was opened from a terminated state via notification
    RemoteMessage? initialMessage = await _firebaseMessaging
        .getInitialMessage();
    if (initialMessage != null) {
      print('🚀 App opened from terminated state via notification');
      print('Message data: ${initialMessage.data}');
      // TODO: Navigate to specific screen based on message data
    }
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Subscribe to topic for group notifications
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print('✅ Subscribed to topic: $topic');
  }

  // Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print('❌ Unsubscribed from topic: $topic');
  }
}
