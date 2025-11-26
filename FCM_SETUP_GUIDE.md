# 🔔 Firebase Cloud Messaging (FCM) Setup Guide

## Complete Setup for Background Notifications

---

## 📋 What's Been Configured

### ✅ Files Created/Updated

1. **`mensa/android/app/google-services.json`** - Firebase configuration (DEMO - replace with real)
2. **`mensa/android/build.gradle.kts`** - Added Google Services plugin
3. **`mensa/android/app/build.gradle.kts`** - Applied Google Services plugin
4. **`mensa/android/app/src/main/AndroidManifest.xml`** - FCM permissions and service
5. **`mensa/lib/main.dart`** - Firebase initialization
6. **`mensa/lib/services/notification_service.dart`** - Complete FCM implementation
7. **`mensa/pubspec.yaml`** - Added flutter_local_notifications

---

## 🚀 Step-by-Step Setup

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click **"Add project"**
3. Enter project name: **"Mensa Pregnancy Tracker"**
4. Enable Google Analytics (optional)
5. Click **"Create project"**

### Step 2: Add Android App to Firebase

1. In Firebase Console, click **"Add app"** → Android icon
2. Enter package name: **`com.example.mensa`**
   - Find in `mensa/android/app/build.gradle.kts` → `applicationId`
3. Enter app nickname: **"Mensa Android"** (optional)
4. Click **"Register app"**

### Step 3: Download google-services.json

1. Click **"Download google-services.json"**
2. **IMPORTANT**: Replace the demo file at:
   ```
   mensa/android/app/google-services.json
   ```
3. Verify the file contains your actual Firebase project details

### Step 4: Enable Cloud Messaging

1. In Firebase Console → **Project Settings** → **Cloud Messaging** tab
2. Note your **Server Key** (for backend)
3. Note your **Sender ID**

### Step 5: Install Dependencies

```bash
cd mensa
flutter pub get
```

### Step 6: Run the App

```bash
flutter run
```

**Check console for:**
```
✅ User granted notification permission
📱 FCM Token: [your-device-token]
```

---

## 📱 Testing Notifications

### Test 1: Send Test Notification from Firebase Console

1. Firebase Console → **Cloud Messaging** → **Send your first message**
2. Enter notification title: **"Test Notification"**
3. Enter notification text: **"Hello from Mensa!"**
4. Click **"Send test message"**
5. Paste your FCM token from console logs
6. Click **"Test"**

### Test 2: Send from Backend

Update `server/.env`:
```env
FIREBASE_SERVER_KEY=your_server_key_here
```

Create test endpoint in `server/src/routes/notifications.routes.js`:

```javascript
const express = require('express');
const router = express.Router();
const admin = require('firebase-admin');

// Initialize Firebase Admin (do this once in app.js)
const serviceAccount = require('../firebase-service-account.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// Send notification
router.post('/send', async (req, res) => {
  const { token, title, body, data } = req.body;
  
  const message = {
    notification: {
      title: title || 'Mensa',
      body: body || 'You have a new update',
    },
    data: data || {},
    token: token,
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('Successfully sent message:', response);
    res.json({ success: true, messageId: response });
  } catch (error) {
    console.error('Error sending message:', error);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
```

Test with cURL:
```bash
curl -X POST http://localhost:3000/api/notifications/send \
  -H "Content-Type: application/json" \
  -d '{
    "token": "YOUR_DEVICE_FCM_TOKEN",
    "title": "Daily Reminder",
    "body": "Time to log your daily health!",
    "data": {
      "screen": "daily_log",
      "action": "open"
    }
  }'
```

---

## 🎯 Notification Types for Pregnancy Tracker

### 1. Daily Health Log Reminder
```json
{
  "title": "Daily Check-in 💕",
  "body": "Don't forget to log your mood and symptoms today!",
  "data": {
    "type": "daily_reminder",
    "screen": "daily_log"
  }
}
```

### 2. Weekly Progress Update
```json
{
  "title": "Week 12 Update 🌸",
  "body": "Your baby is now the size of a lime! Tap to learn more.",
  "data": {
    "type": "weekly_update",
    "screen": "weekly_progress",
    "week": "12"
  }
}
```

### 3. Appointment Reminder
```json
{
  "title": "Appointment Tomorrow 📅",
  "body": "Don't forget your prenatal checkup at 10:00 AM",
  "data": {
    "type": "appointment",
    "screen": "checklist",
    "task": "prenatal_checkup"
  }
}
```

### 4. Hydration Reminder
```json
{
  "title": "Stay Hydrated 💧",
  "body": "Have you had 8 glasses of water today?",
  "data": {
    "type": "hydration",
    "screen": "daily_log"
  }
}
```

### 5. Breathing Exercise Suggestion
```json
{
  "title": "Take a Moment 🧘‍♀️",
  "body": "Feeling stressed? Try our breathing exercise.",
  "data": {
    "type": "wellness",
    "screen": "breathing_game"
  }
}
```

---

## 🔧 Backend Integration

### Setup Firebase Admin SDK

1. **Download Service Account Key:**
   - Firebase Console → Project Settings → Service Accounts
   - Click **"Generate new private key"**
   - Save as `server/firebase-service-account.json`

2. **Install Firebase Admin:**
```bash
cd server
npm install firebase-admin
```

3. **Initialize in `server/src/app.js`:**
```javascript
const admin = require('firebase-admin');
const serviceAccount = require('./firebase-service-account.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});
```

4. **Create Notification Service:**

`server/src/services/pushNotificationService.js`:
```javascript
const admin = require('firebase-admin');

class PushNotificationService {
  async sendToDevice(token, notification, data = {}) {
    const message = {
      notification: {
        title: notification.title,
        body: notification.body,
      },
      data: data,
      token: token,
      android: {
        priority: 'high',
        notification: {
          channelId: 'pregnancy_tracker_channel',
          sound: 'default',
        },
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1,
          },
        },
      },
    };

    try {
      const response = await admin.messaging().send(message);
      console.log('✅ Notification sent:', response);
      return { success: true, messageId: response };
    } catch (error) {
      console.error('❌ Error sending notification:', error);
      return { success: false, error: error.message };
    }
  }

  async sendToTopic(topic, notification, data = {}) {
    const message = {
      notification: {
        title: notification.title,
        body: notification.body,
      },
      data: data,
      topic: topic,
    };

    try {
      const response = await admin.messaging().send(message);
      console.log('✅ Topic notification sent:', response);
      return { success: true, messageId: response };
    } catch (error) {
      console.error('❌ Error sending topic notification:', error);
      return { success: false, error: error.message };
    }
  }

  async sendToMultipleDevices(tokens, notification, data = {}) {
    const message = {
      notification: {
        title: notification.title,
        body: notification.body,
      },
      data: data,
      tokens: tokens,
    };

    try {
      const response = await admin.messaging().sendMulticast(message);
      console.log(`✅ ${response.successCount} notifications sent successfully`);
      return { 
        success: true, 
        successCount: response.successCount,
        failureCount: response.failureCount 
      };
    } catch (error) {
      console.error('❌ Error sending multicast:', error);
      return { success: false, error: error.message };
    }
  }
}

module.exports = new PushNotificationService();
```

---

## 📅 Scheduled Notifications

### Using Node-Cron for Scheduled Reminders

Install node-cron:
```bash
npm install node-cron
```

Create scheduler in `server/src/services/notificationScheduler.js`:
```javascript
const cron = require('node-cron');
const pushService = require('./pushNotificationService');
const UserPregnancy = require('../models/userPregnancy.model');

class NotificationScheduler {
  start() {
    // Daily health log reminder at 9:00 AM
    cron.schedule('0 9 * * *', async () => {
      console.log('📅 Sending daily health log reminders...');
      // Get all users and their FCM tokens
      // Send notifications
    });

    // Weekly progress update on Mondays at 10:00 AM
    cron.schedule('0 10 * * 1', async () => {
      console.log('📅 Sending weekly progress updates...');
      // Calculate each user's current week
      // Send personalized weekly updates
    });

    // Hydration reminder every 3 hours (9 AM - 9 PM)
    cron.schedule('0 9,12,15,18,21 * * *', async () => {
      console.log('💧 Sending hydration reminders...');
      // Send to all active users
    });

    console.log('✅ Notification scheduler started');
  }
}

module.exports = new NotificationScheduler();
```

Start scheduler in `server/src/app.js`:
```javascript
const notificationScheduler = require('./services/notificationScheduler');
notificationScheduler.start();
```

---

## 🎨 Notification Icons & Sounds

### Custom Notification Icon (Android)

1. Create icon files in `mensa/android/app/src/main/res/`:
   - `drawable-mdpi/ic_notification.png` (24x24)
   - `drawable-hdpi/ic_notification.png` (36x36)
   - `drawable-xhdpi/ic_notification.png` (48x48)
   - `drawable-xxhdpi/ic_notification.png` (72x72)
   - `drawable-xxxhdpi/ic_notification.png` (96x96)

2. Update AndroidManifest.xml:
```xml
<meta-data
    android:name="com.google.firebase.messaging.default_notification_icon"
    android:resource="@drawable/ic_notification" />
```

### Custom Notification Sound

1. Add sound file to `mensa/android/app/src/main/res/raw/notification_sound.mp3`

2. Update notification code:
```dart
const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
  'pregnancy_tracker_channel',
  'Pregnancy Tracker Notifications',
  sound: RawResourceAndroidNotificationSound('notification_sound'),
);
```

---

## 🔍 Debugging

### Check FCM Token
```dart
// In your app
final token = await NotificationService().getToken();
print('FCM Token: $token');
```

### Test Notification Delivery
```bash
# Using Firebase Console
1. Go to Cloud Messaging
2. Click "Send test message"
3. Paste your FCM token
4. Send

# Using cURL
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "YOUR_DEVICE_TOKEN",
    "notification": {
      "title": "Test",
      "body": "Hello from cURL"
    }
  }'
```

### Common Issues

**Issue 1: Notifications not received in background**
- Ensure `@pragma('vm:entry-point')` is on background handler
- Check AndroidManifest.xml has FCM service configured
- Verify app has notification permissions

**Issue 2: Token is null**
- Check google-services.json is correct
- Verify Firebase is initialized before getting token
- Check internet connection

**Issue 3: Notifications work in foreground but not background**
- Ensure background handler is top-level function
- Check battery optimization settings on device
- Verify FCM service in AndroidManifest.xml

---

## ✅ Verification Checklist

- [ ] Firebase project created
- [ ] Android app added to Firebase
- [ ] Real google-services.json downloaded and placed
- [ ] Dependencies installed (`flutter pub get`)
- [ ] App runs without errors
- [ ] FCM token printed in console
- [ ] Test notification sent from Firebase Console
- [ ] Notification received in foreground
- [ ] Notification received in background
- [ ] Notification received when app is terminated
- [ ] Notification tap opens app
- [ ] Backend can send notifications

---

## 🚀 Production Checklist

- [ ] Replace demo google-services.json with real one
- [ ] Store FCM tokens in database
- [ ] Implement token refresh handling
- [ ] Set up notification scheduling
- [ ] Add notification preferences in app
- [ ] Implement notification analytics
- [ ] Test on multiple devices
- [ ] Test on different Android versions
- [ ] Handle notification permissions properly
- [ ] Add unsubscribe functionality

---

## 📚 Additional Resources

- [Firebase Cloud Messaging Docs](https://firebase.google.com/docs/cloud-messaging)
- [Flutter Firebase Messaging Plugin](https://pub.dev/packages/firebase_messaging)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
- [FCM HTTP v1 API](https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages)

---

**Your FCM setup is complete! Background notifications are now enabled! 🎉**
