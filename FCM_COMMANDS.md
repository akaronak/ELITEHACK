# 🔔 FCM Quick Commands Reference

## 🚀 Setup Commands

### Initial Setup
```bash
# 1. Install dependencies
cd mensa
flutter pub get

# 2. Clean build (if needed)
flutter clean

# 3. Run app
flutter run
```

### Verify FCM Token
Look for this in console output:
```
✅ User granted notification permission
📱 FCM Token: [your-token-here]
```

---

## 🧪 Testing Commands

### Test from Firebase Console
1. Copy FCM token from app console
2. Go to: https://console.firebase.google.com
3. Navigate to: Cloud Messaging → Send test message
4. Paste token → Click "Test"

### Test with cURL (using FCM HTTP v1 API)
```bash
# Get access token first (requires service account)
curl -X POST https://fcm.googleapis.com/v1/projects/YOUR_PROJECT_ID/messages:send \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "message": {
      "token": "YOUR_DEVICE_TOKEN",
      "notification": {
        "title": "Test Notification",
        "body": "Hello from cURL!"
      }
    }
  }'
```

### Test with Legacy FCM API
```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "YOUR_DEVICE_TOKEN",
    "notification": {
      "title": "Test",
      "body": "Hello!"
    },
    "data": {
      "screen": "dashboard"
    }
  }'
```

---

## 🔧 Backend Commands

### Install Firebase Admin SDK
```bash
cd server
npm install firebase-admin
```

### Send Notification from Node.js
```javascript
const admin = require('firebase-admin');

// Initialize (once)
const serviceAccount = require('./firebase-service-account.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// Send notification
const message = {
  notification: {
    title: 'Daily Reminder',
    body: 'Time to log your health!'
  },
  data: {
    screen: 'daily_log',
    type: 'reminder'
  },
  token: 'USER_FCM_TOKEN'
};

admin.messaging().send(message)
  .then(response => console.log('✅ Sent:', response))
  .catch(error => console.error('❌ Error:', error));
```

### Send to Multiple Devices
```javascript
const message = {
  notification: {
    title: 'Weekly Update',
    body: 'Check your progress!'
  },
  tokens: ['token1', 'token2', 'token3']
};

admin.messaging().sendMulticast(message)
  .then(response => {
    console.log(`✅ ${response.successCount} sent successfully`);
    console.log(`❌ ${response.failureCount} failed`);
  });
```

### Send to Topic
```javascript
const message = {
  notification: {
    title: 'Announcement',
    body: 'New feature available!'
  },
  topic: 'all_users'
};

admin.messaging().send(message)
  .then(response => console.log('✅ Topic message sent:', response));
```

---

## 📱 Flutter Commands

### Get FCM Token in App
```dart
import 'package:firebase_messaging/firebase_messaging.dart';

final token = await FirebaseMessaging.instance.getToken();
print('FCM Token: $token');
```

### Subscribe to Topic
```dart
await FirebaseMessaging.instance.subscribeToTopic('daily_reminders');
```

### Unsubscribe from Topic
```dart
await FirebaseMessaging.instance.unsubscribeFromTopic('daily_reminders');
```

### Request Permissions
```dart
NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
  alert: true,
  badge: true,
  sound: true,
);
```

---

## 🐛 Debugging Commands

### Check if Firebase is Initialized
```dart
// In your app
print('Firebase initialized: ${Firebase.apps.isNotEmpty}');
```

### Check Notification Permissions
```dart
NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();
print('Authorization status: ${settings.authorizationStatus}');
```

### View FCM Logs (Android)
```bash
# View logcat for FCM messages
adb logcat | grep -i "fcm\|firebase\|notification"
```

### Clear App Data (Android)
```bash
# If notifications stop working, clear app data
adb shell pm clear com.example.mensa
```

### Reinstall App
```bash
flutter clean
flutter pub get
flutter run
```

---

## 🔍 Verification Commands

### Check google-services.json
```bash
# Verify file exists
ls -la mensa/android/app/google-services.json

# View file content (check it's not demo)
cat mensa/android/app/google-services.json
```

### Check Build Configuration
```bash
# Verify Google Services plugin is applied
cat mensa/android/app/build.gradle.kts | grep "google-services"
```

### Check Dependencies
```bash
# List Flutter dependencies
cd mensa
flutter pub deps | grep firebase
```

---

## 📊 Monitoring Commands

### Firebase Console URLs
```bash
# Project overview
https://console.firebase.google.com/project/YOUR_PROJECT_ID/overview

# Cloud Messaging
https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification

# Analytics (if enabled)
https://console.firebase.google.com/project/YOUR_PROJECT_ID/analytics
```

### Check Notification Delivery
```bash
# Firebase Console → Cloud Messaging → Reports
# View delivery rates, open rates, etc.
```

---

## 🔄 Scheduled Notifications (Node-Cron)

### Install Node-Cron
```bash
cd server
npm install node-cron
```

### Daily Reminder (9 AM)
```javascript
const cron = require('node-cron');

cron.schedule('0 9 * * *', async () => {
  console.log('📅 Sending daily reminders...');
  // Send notifications
});
```

### Weekly Update (Monday 10 AM)
```javascript
cron.schedule('0 10 * * 1', async () => {
  console.log('📅 Sending weekly updates...');
  // Send notifications
});
```

### Hourly Reminder
```javascript
cron.schedule('0 * * * *', async () => {
  console.log('⏰ Hourly check...');
  // Send notifications
});
```

---

## 🚨 Troubleshooting Commands

### Problem: No FCM Token
```bash
# Solution 1: Check internet
ping google.com

# Solution 2: Verify Firebase initialization
# Check main.dart has Firebase.initializeApp()

# Solution 3: Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Problem: Notifications Not Received
```bash
# Check device settings
adb shell dumpsys notification_listener

# Check battery optimization
adb shell dumpsys deviceidle whitelist

# Force stop and restart app
adb shell am force-stop com.example.mensa
flutter run
```

### Problem: Build Errors
```bash
# Clean everything
cd mensa
flutter clean
rm -rf build/
rm -rf .dart_tool/

# Reinstall dependencies
flutter pub get

# Rebuild
flutter run
```

---

## 📝 Quick Test Script

### Complete Test Flow
```bash
#!/bin/bash

echo "🔔 FCM Test Script"
echo "=================="

# 1. Get FCM token from app logs
echo "1. Run app and copy FCM token from console"
flutter run &
sleep 10

# 2. Send test notification
echo "2. Sending test notification..."
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=$FCM_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"to\": \"$FCM_TOKEN\",
    \"notification\": {
      \"title\": \"Test\",
      \"body\": \"Automated test notification\"
    }
  }"

echo "3. Check your device for notification!"
```

---

## 🎯 Production Deployment Commands

### Build Release APK
```bash
cd mensa
flutter build apk --release
```

### Build App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### Sign APK
```bash
# Generate keystore (first time only)
keytool -genkey -v -keystore mensa-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias mensa

# Build signed APK
flutter build apk --release
```

---

## 📚 Useful Links

```bash
# Firebase Console
https://console.firebase.google.com

# FCM Documentation
https://firebase.google.com/docs/cloud-messaging

# Flutter Firebase Messaging
https://pub.dev/packages/firebase_messaging

# Test FCM with Postman
# Import FCM collection from Firebase docs
```

---

## ✅ Quick Checklist Commands

```bash
# Run all checks
echo "Checking Firebase setup..."

# 1. Check file exists
[ -f "mensa/android/app/google-services.json" ] && echo "✅ google-services.json exists" || echo "❌ Missing google-services.json"

# 2. Check dependencies
flutter pub deps | grep firebase_messaging && echo "✅ firebase_messaging installed" || echo "❌ Missing firebase_messaging"

# 3. Check build config
grep "google-services" mensa/android/app/build.gradle.kts && echo "✅ Google Services plugin applied" || echo "❌ Plugin not applied"

# 4. Run app
flutter run && echo "✅ App running" || echo "❌ Build failed"
```

---

**Keep this handy for quick FCM operations! 🚀**
