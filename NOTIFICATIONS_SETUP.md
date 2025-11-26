# Notifications Setup ✅

## What's Working Now

### ✅ Firebase Cloud Messaging (FCM)
- **Background notifications** - Work when app is closed
- **Foreground notifications** - Display when app is open
- **Notification taps** - Handle user interactions
- **Token management** - FCM tokens generated and logged

### ✅ Local Notifications
- **Scheduled notifications** - Set reminders for future dates
- **Immediate notifications** - Show notifications instantly
- **Custom channels** - Android notification channels configured
- **iOS support** - DarwinNotifications configured

## How to Test Notifications

### 1. Test Button in App
- Open the menstruation tracker
- Tap the **bell icon** in the top right
- A test notification will be scheduled for 5 seconds later
- You'll see a snackbar confirmation

### 2. Send from Firebase Console
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `smensa-c9679`
3. Go to **Cloud Messaging**
4. Click **Send your first message**
5. Fill in:
   - **Notification title**: "Period Reminder"
   - **Notification text**: "Your period is coming soon"
   - **Target**: Select your app
6. Click **Send**

### 3. Get Your FCM Token
When you run the app, check the console/logs for:
```
📱 FCM Token: [your-token-here]
📋 Copy this token to test notifications from Firebase Console
```

Use this token to send targeted notifications from Firebase Console.

## Notification Types

### 1. Period Reminders
```dart
await notificationService.scheduleNotification(
  title: '🌸 Period Reminder',
  body: 'Your next period is expected in 3 days',
  scheduledDate: DateTime.now().add(Duration(days: 3)),
);
```

### 2. Symptom Tracking Reminders
```dart
await notificationService.scheduleNotification(
  title: '📝 Daily Log Reminder',
  body: 'Don\'t forget to log your symptoms today!',
  scheduledDate: DateTime.now().add(Duration(hours: 12)),
);
```

### 3. Health Tips
```dart
await notificationService.scheduleNotification(
  title: '💡 Health Tip',
  body: 'Stay hydrated! Drink at least 8 glasses of water today.',
  scheduledDate: DateTime.now().add(Duration(hours: 2)),
);
```

## Features Implemented

### Notification Service
**File**: `mensa/lib/services/notification_service.dart`

**Methods:**
- `initialize()` - Sets up FCM and local notifications
- `scheduleNotification()` - Schedule a notification for future
- `subscribeToTopic()` - Subscribe to notification topics
- `unsubscribeFromTopic()` - Unsubscribe from topics
- `cancelAllNotifications()` - Cancel all scheduled notifications
- `getToken()` - Get FCM device token

### Foreground Notifications
When app is open, notifications are displayed using `flutter_local_notifications`:
- Custom notification channel
- High priority
- Sound and vibration
- Tap handling

### Background Notifications
Handled by Firebase automatically:
- System tray notifications
- Tap opens app
- Data payload support

### Notification Channels
**Android Channel:**
- ID: `pregnancy_tracker_channel`
- Name: `Pregnancy Tracker Notifications`
- Importance: High
- Sound: Enabled

## Configuration Files

### 1. AndroidManifest.xml
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

<service
    android:name="com.google.firebase.messaging.FirebaseMessagingService"
    android:exported="false">
    <intent-filter>
        <action android:name="com.google.firebase.MESSAGING_EVENT" />
    </intent-filter>
</service>

<meta-data
    android:name="com.google.firebase.messaging.default_notification_channel_id"
    android:value="pregnancy_tracker_channel" />
```

### 2. google-services.json
Located at: `mensa/android/app/google-services.json`
- Contains Firebase project configuration
- Required for FCM to work

### 3. pubspec.yaml
```yaml
dependencies:
  firebase_core: ^2.32.0
  firebase_messaging: ^14.7.10
  flutter_local_notifications: ^17.0.0
  timezone: ^0.9.4
```

## Notification Flow

### Foreground (App Open)
1. FCM receives notification
2. `FirebaseMessaging.onMessage` listener triggered
3. `_showLocalNotification()` displays it locally
4. User sees notification in app

### Background (App Closed)
1. FCM receives notification
2. System displays notification automatically
3. User taps notification
4. `FirebaseMessaging.onMessageOpenedApp` triggered
5. App opens and handles navigation

### Scheduled
1. App schedules notification with date/time
2. `flutter_local_notifications` stores it
3. At scheduled time, notification displays
4. Works even if app is closed

## Testing Checklist

- ✅ Foreground notifications display
- ✅ Background notifications display
- ✅ Notification tap opens app
- ✅ Scheduled notifications work
- ✅ FCM token generated
- ✅ Notification channels created
- ✅ Permissions requested
- ✅ iOS notifications configured

## Troubleshooting

### Notifications Not Showing?

1. **Check Permissions**
   - Android 13+: POST_NOTIFICATIONS permission required
   - iOS: User must grant permission

2. **Check FCM Token**
   - Look for token in console logs
   - Token should be printed on app start

3. **Check Notification Channel**
   - Android: Channel must be created before notifications
   - Check `pregnancy_tracker_channel` exists

4. **Check Firebase Configuration**
   - `google-services.json` must be in correct location
   - Firebase project must be set up correctly

5. **Check App State**
   - Foreground: Local notifications should show
   - Background: System notifications should show

### Common Issues

**Issue**: Notifications not showing in foreground
**Solution**: Local notifications are now implemented ✅

**Issue**: Background notifications not working
**Solution**: Check `google-services.json` and Firebase setup

**Issue**: Scheduled notifications not firing
**Solution**: Check timezone initialization and permissions

## Next Steps

### Automatic Period Reminders
Add logic to automatically schedule notifications:
```dart
// When user logs period start
final nextPeriodDate = calculateNextPeriod();
await notificationService.scheduleNotification(
  title: '🌸 Period Coming Soon',
  body: 'Your period is expected tomorrow',
  scheduledDate: nextPeriodDate.subtract(Duration(days: 1)),
);
```

### Daily Symptom Reminders
```dart
// Schedule daily reminder at 8 PM
final reminderTime = DateTime.now().copyWith(hour: 20, minute: 0);
await notificationService.scheduleNotification(
  title: '📝 Daily Check-in',
  body: 'How are you feeling today?',
  scheduledDate: reminderTime,
);
```

### Ovulation Reminders
```dart
// Notify during fertile window
final ovulationDate = calculateOvulation();
await notificationService.scheduleNotification(
  title: '🌟 Fertile Window',
  body: 'You\'re in your fertile window',
  scheduledDate: ovulationDate,
);
```

## Status
🟢 **FULLY WORKING** - Notifications are now functional!

- Foreground notifications: ✅
- Background notifications: ✅
- Scheduled notifications: ✅
- Test button: ✅
- FCM integration: ✅
