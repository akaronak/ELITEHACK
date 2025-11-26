# ⚡ Quick Reference Card

## 🚀 Start Commands

### Backend
```bash
cd server
npm install
npm start
```
**URL**: http://localhost:3000

### Frontend
```bash
cd mensa
flutter pub get
flutter run
```

---

## 📡 Key API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/health` | GET | Server health check |
| `/api/user/:userId/pregnancy` | GET/POST | User profile |
| `/api/logs/:userId` | GET/POST | Daily logs |
| `/api/ai/symptom-analysis` | POST | Analyze symptoms |
| `/api/ai/chat` | POST | Chat with AI |
| `/api/nutrition/:userId/:week` | GET | Nutrition guide |
| `/api/checklist/:userId/:week` | GET/POST | Checklist |
| `/api/breathing/game/:userId` | GET/POST | Breathing stats |

---

## 📁 Important Files

### Configuration
- `server/.env` - Backend config
- `mensa/lib/services/api_service.dart` - API base URL
- `mensa/pubspec.yaml` - Flutter dependencies
- `server/package.json` - Node dependencies

### Data Files
- `assets/data/week_data.json` - 40 weeks of pregnancy data
- `assets/data/foods.json` - 15+ food recommendations
- `assets/data/symptom_week_map.json` - Symptom classifications
- `assets/data/pregnancy_faq.json` - 10+ Q&A topics
- `assets/data/checklist_templates.json` - Weekly tasks

---

## 🎨 Color Scheme

```dart
Primary: Color(0xFFFFB6C1)    // Pink
Secondary: Color(0xFFDDA0DD)  // Lavender
Accent: Color(0xFF98D8C8)     // Mint
Background: Color(0xFFFFF5F7) // Light Pink
```

---

## 🔧 Common Commands

### Flutter
```bash
flutter clean              # Clean build
flutter pub get           # Get dependencies
flutter run               # Run app
flutter build apk         # Build Android APK
flutter doctor            # Check setup
```

### Node.js
```bash
npm install               # Install dependencies
npm start                 # Start server
npm run dev              # Dev mode with nodemon
node src/app.js          # Direct start
```

### Testing
```bash
# Backend
curl http://localhost:3000/health

# Flutter
flutter test
```

---

## 🐛 Quick Fixes

### "Cannot connect to server"
```dart
// In api_service.dart, change baseUrl to:
// Android Emulator:
static const String baseUrl = 'http://10.0.2.2:3000/api';

// Physical Device:
static const String baseUrl = 'http://YOUR_IP:3000/api';
```

### "Package not found"
```bash
cd mensa
flutter clean && flutter pub get
```

### "Port already in use"
```bash
# Windows
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Mac/Linux
lsof -ti:3000 | xargs kill -9
```

---

## 📊 Feature Checklist

- [ ] Onboarding with LMP/Due Date
- [ ] Dashboard with 6 modules
- [ ] Weekly Progress (40 weeks)
- [ ] Daily Health Log
- [ ] AI Symptom Analyzer
- [ ] Nutrition Guide with Allergies
- [ ] Smart Checklist
- [ ] AI Chat Assistant
- [ ] Breathing Exercise Game

---

## 🎯 Demo Flow (10 min)

1. **Intro** (1 min) - Show app overview
2. **Onboarding** (2 min) - Set up profile
3. **Dashboard** (1 min) - Tour all modules
4. **Daily Log** (1 min) - Add health data
5. **AI Symptom** (1 min) - Show analysis
6. **Nutrition** (1 min) - Allergy warnings
7. **AI Chat** (2 min) - Emotional support
8. **Breathing** (1 min) - Stress relief

---

## 🔔 Firebase Notifications

### Quick Setup
```bash
# 1. Get google-services.json from Firebase Console
# 2. Replace file at: mensa/android/app/google-services.json
# 3. Run app
flutter pub get
flutter run
```

### Test Notification
1. Copy FCM token from console
2. Firebase Console → Cloud Messaging → Send test message
3. Paste token → Test

### Send from Backend
```javascript
const admin = require('firebase-admin');
await admin.messaging().send({
  notification: { title: 'Test', body: 'Hello!' },
  token: 'device-token-here'
});
```

---

## 📞 Emergency Contacts

### Documentation
- `README.md` - Project overview
- `SETUP_GUIDE.md` - Detailed setup
- `API_DOCUMENTATION.md` - API reference
- `HACKATHON_CHECKLIST.md` - Demo prep
- `COMPLETE_SYSTEM_GUIDE.md` - Everything
- `FIREBASE_QUICK_START.md` - FCM 5-min setup
- `FCM_SETUP_GUIDE.md` - Complete FCM guide

### Troubleshooting
1. Check `SETUP_GUIDE.md` troubleshooting section
2. Verify server is running: `curl http://localhost:3000/health`
3. Check Flutter logs: Look for error messages
4. Review API responses: Check network tab

---

## 💡 Pro Tips

1. **Use hot reload** - Press 'r' in Flutter terminal
2. **Test API first** - Use cURL before Flutter
3. **Check logs** - Both server and Flutter console
4. **Keep server running** - Don't stop during development
5. **Use VS Code** - Best IDE for this stack

---

## 🎨 UI Components

### Screens
- `onboarding_screen.dart` - Profile setup
- `dashboard_screen.dart` - Main hub
- `daily_log_screen.dart` - Health logging
- `nutrition_screen.dart` - Food guide
- `ai_chat_screen.dart` - Chat interface
- `breathing_game_screen.dart` - Breathing exercise
- `weekly_progress_screen.dart` - Week info
- `checklist_screen.dart` - Task list

### Services
- `api_service.dart` - API calls
- `date_calculator_service.dart` - Date math
- `notification_service.dart` - FCM

---

## 🔐 Safety Notes

- ✅ Always show medical disclaimers
- ✅ Never diagnose conditions
- ✅ Encourage doctor consultation
- ✅ Red flag critical symptoms
- ✅ Protect user privacy

---

## 📈 Performance Tips

### Backend
- Use in-memory cache for static data
- Minimize database queries
- Enable CORS properly
- Add rate limiting in production

### Frontend
- Lazy load screens
- Cache images
- Use const constructors
- Minimize rebuilds

---

## 🎉 Success Metrics

### Must Work
- ✅ Server responds to /health
- ✅ App builds without errors
- ✅ All 8 features functional
- ✅ No crashes during demo

### Should Work
- ✅ Smooth animations
- ✅ Fast API responses
- ✅ Good error handling
- ✅ Professional UI

---

## 📱 Device Testing

### Android Emulator
```bash
flutter emulators
flutter emulators --launch <emulator_id>
flutter run
```

### iOS Simulator (macOS)
```bash
open -a Simulator
flutter run
```

### Physical Device
```bash
flutter devices
flutter run -d <device_id>
```

---

## 🌟 Key Features to Highlight

1. **AI Symptom Analysis** - Week-specific, medical guidelines
2. **Allergy-Safe Nutrition** - Personalized recommendations
3. **Emotional AI Support** - Mood detection, empathy
4. **Breathing Game** - Interactive stress relief
5. **Comprehensive Tracking** - 40 weeks of data

---

## 📝 Quick Notes

- **User ID**: Currently hardcoded as "demo_user_123"
- **Storage**: In-memory (MongoDB-ready)
- **AI**: Rule-based (Gemini-ready)
- **Notifications**: Firebase FCM
- **Platform**: Cross-platform (Android, iOS, Web)

---

## ✅ Pre-Demo Checklist

- [ ] Server running on port 3000
- [ ] App installed on demo device
- [ ] Device fully charged
- [ ] Internet connection stable
- [ ] All features tested
- [ ] Demo script practiced
- [ ] Backup device ready

---

**Print this card and keep it handy during development and demo! 🚀**
