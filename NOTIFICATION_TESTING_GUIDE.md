# Notification Testing Guide 🔔

## Quick Test Menu

Tap the **bell icon** in the menstruation tracker to access the test menu with 3 options:

### 1. ✅ Immediate Notification
**What it tests:** Foreground notifications (app is open)

**How to test:**
1. Tap bell icon
2. Select "Immediate"
3. Notification appears instantly
4. ✅ **Pass:** Notification shows in tray

**Expected Result:**
- Title: "🌸 Immediate Test"
- Body: "This notification appeared instantly!"
- Shows immediately while app is open

---

### 2. ⏰ Scheduled (10 seconds)
**What it tests:** Background notifications (app is closed)

**How to test:**
1. Tap bell icon
2. Select "Scheduled (10s)"
3. See snackbar: "Notification scheduled in 10 seconds!"
4. **CLOSE THE APP** (press home button or recent apps)
5. Wait 10 seconds
6. ✅ **Pass:** Notification appears while app is closed

**Expected Result:**
- Title: "🌸 Background Test"
- Body: "This notification was scheduled! Close the app to test background."
- Shows even when app is closed

---

### 3. ⏰ Scheduled (30 seconds)
**What it tests:** Longer background notifications

**How to test:**
1. Tap bell icon
2. Select "Scheduled (30s)"
3. See snackbar: "Notification scheduled in 30 seconds!"
4. **MINIMIZE THE APP** (press home button)
5. Wait 30 seconds
6. ✅ **Pass:** Notification appears

**Expected Result:**
- Title: "🌸 Period Reminder"
- Body: "Your next period is expected in X days"
- Shows with real cycle data

---

## Complete Testing Checklist

### ✅ Foreground Test (App Open)
- [ ] Tap bell icon
- [ ] Select "Immediate"
- [ ] Notification appears in tray
- [ ] Can tap notification
- [ ] Notification has correct title and body

### ✅ Background Test (App Closed)
- [ ] Tap bell icon
- [ ] Select "Scheduled (10s)"
- [ ] Close app completely
- [ ] Wait 10 seconds
- [ ] Notification appears
- [ ] Tap notification opens app

### ✅ Minimized Test (App in Background)
- [ ] Tap bell icon
- [ ] Select "Scheduled (30s)"
- [ ] Press home button (minimize)
- [ ] Wait 30 seconds
- [ ] Notification appears
- [ ] Notification shows correct data

---

## What Each Test Proves

### Immediate Notification ✅
**Proves:**
- Local notifications work
- Notification channel is configured
- Permissions are granted
- Notification service is initialized

### 10-Second Scheduled ✅
**Proves:**
- Scheduled notifications work
- Background execution works
- Notifications fire when app is closed
- System can wake app for notifications

### 30-Second Scheduled ✅
**Proves:**
- Longer scheduling works
- Notifications persist across app states
- Real data (cycle info) is included
- Production-ready notification system

---

## Troubleshooting

### Notification Doesn't Appear?

**Check 1: Permissions**
```
Settings > Apps > Mensa > Notifications
- Ensure "All Mensa notifications" is ON
- Check notification channel is enabled
```

**Check 2: Do Not Disturb**
```
- Swipe down from top
- Check if DND mode is active
- Disable DND for testing
```

**Check 3: Battery Optimization**
```
Settings > Apps > Mensa > Battery
- Set to "Unrestricted"
- Prevents Android from killing scheduled notifications
```

**Check 4: App Logs**
```
Look for in console:
✅ User granted notification permission
📱 FCM Token: [token]
```

### Scheduled Notification Not Firing?

**Solution 1: Check Exact Alarm Permission (Android 12+)**
```
Settings > Apps > Mensa > Alarms & reminders
- Enable "Allow setting alarms and reminders"
```

**Solution 2: Disable Battery Saver**
```
Battery saver can prevent scheduled notifications
Disable it temporarily for testing
```

**Solution 3: Check Logs**
```
If you see "Error scheduling notification"
The fallback immediate notification will show instead
```

---

## Expected Behavior

### ✅ When App is Open (Foreground)
- Notification shows in system tray
- Notification sound plays
- Notification icon appears
- Can tap to interact

### ✅ When App is Closed (Background)
- Notification still appears
- System wakes app if needed
- Notification persists in tray
- Tapping opens app

### ✅ When App is Minimized
- Notification appears normally
- No difference from closed state
- App doesn't need to be active

---

## Firebase Cloud Messaging (FCM) Test

### Send Test from Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select project: `smensa-c9679`
3. Navigate to **Cloud Messaging**
4. Click **Send your first message**
5. Fill in:
   - **Title**: "Test from Firebase"
   - **Text**: "This is a remote notification"
6. Click **Send test message**
7. Paste your FCM token (from app logs)
8. Click **Test**

**Expected Result:**
- Notification appears on device
- Works even when app is closed
- Proves remote notifications work

---

## Production Notification Examples

### Period Reminder (Day Before)
```dart
await notificationService.scheduleNotification(
  title: '🌸 Period Coming Soon',
  body: 'Your period is expected tomorrow. Be prepared!',
  scheduledDate: nextPeriodDate.subtract(Duration(days: 1)),
);
```

### Daily Log Reminder
```dart
await notificationService.scheduleNotification(
  title: '📝 Daily Check-in',
  body: 'How are you feeling today? Log your symptoms.',
  scheduledDate: DateTime.now().copyWith(hour: 20, minute: 0),
);
```

### Ovulation Window
```dart
await notificationService.scheduleNotification(
  title: '🌟 Fertile Window',
  body: 'You\'re entering your fertile window.',
  scheduledDate: ovulationDate.subtract(Duration(days: 2)),
);
```

---

## Success Criteria

### ✅ All Tests Pass When:
1. Immediate notification shows instantly
2. 10-second notification appears after closing app
3. 30-second notification appears with correct data
4. Notifications can be tapped to open app
5. FCM token is generated successfully
6. No errors in console logs

### 🎉 Production Ready When:
- All 3 test types work
- Notifications appear in all app states
- Data is accurate in notifications
- No crashes or errors
- Battery optimization doesn't block notifications

---

## Current Status

✅ **Notification System:** Fully Implemented
✅ **FCM Integration:** Working (token generated)
✅ **Local Notifications:** Configured
✅ **Scheduled Notifications:** Implemented
✅ **Test Menu:** Available (bell icon)
✅ **Error Handling:** Fallback to immediate if scheduling fails

**Ready for Testing!** 🚀

Tap the bell icon and run through all 3 tests to verify everything works!
