# 🔥 Firebase Quick Start - 5 Minutes Setup

## ⚡ Fast Track to Background Notifications

### Step 1: Create Firebase Project (2 minutes)

1. Go to https://console.firebase.google.com
2. Click **"Add project"**
3. Name: **"Mensa Pregnancy Tracker"**
4. Click through setup (disable Analytics if you want faster setup)

### Step 2: Add Android App (2 minutes)

1. Click Android icon
2. Package name: **`com.example.mensa`**
3. Click **"Register app"**
4. **Download `google-services.json`**
5. **IMPORTANT**: Replace the file at:
   ```
   mensa/android/app/google-services.json
   ```

### Step 3: Install & Run (1 minute)

```bash
cd mensa
flutter pub get
flutter run
```

### Step 4: Verify (30 seconds)

Check console output for:
```
✅ User granted notification permission
📱 FCM Token: [your-token-here]
```

### Step 5: Test Notification (1 minute)

1. Copy your FCM token from console
2. Firebase Console → **Cloud Messaging** → **Send test message**
3. Paste token → Click **"Test"**
4. Check your device! 🎉

---

## 🎯 That's It!

Your app now supports:
- ✅ Foreground notifications
- ✅ Background notifications
- ✅ Notifications when app is closed
- ✅ Notification tap handling
- ✅ Local notification display

---

## 📱 Next Steps

### Send Notifications from Backend

See `FCM_SETUP_GUIDE.md` for:
- Backend integration with Firebase Admin SDK
- Scheduled notifications
- Custom notification types
- Production deployment

### Customize Notifications

Edit `mensa/lib/services/notification_service.dart` to:
- Change notification channel settings
- Customize notification appearance
- Add custom notification sounds
- Handle notification taps

---

## 🚨 Important Notes

1. **Replace Demo File**: The `google-services.json` in the project is a DEMO file. You MUST replace it with your actual Firebase configuration file.

2. **Package Name**: If you change the package name from `com.example.mensa`, update it in:
   - `mensa/android/app/build.gradle.kts`
   - Firebase Console Android app settings

3. **iOS Setup**: For iOS notifications, follow the iOS-specific steps in `FCM_SETUP_GUIDE.md`

---

## ✅ Verification Checklist

- [ ] Firebase project created
- [ ] Android app added to Firebase
- [ ] Real `google-services.json` downloaded
- [ ] File placed in `mensa/android/app/`
- [ ] `flutter pub get` completed
- [ ] App runs without errors
- [ ] FCM token appears in console
- [ ] Test notification received

---

## 🆘 Troubleshooting

**No FCM token?**
- Check internet connection
- Verify `google-services.json` is correct
- Run `flutter clean` and rebuild

**Notifications not received?**
- Check notification permissions
- Verify token is correct
- Check device battery optimization settings

**Build errors?**
- Run `flutter clean`
- Delete `build` folder
- Run `flutter pub get`
- Rebuild app

---

**Need more details? See `FCM_SETUP_GUIDE.md` for complete documentation! 📚**
