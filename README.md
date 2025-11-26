# Mensa - Pregnancy Tracker Module

A comprehensive pregnancy tracking application built with Flutter (frontend) and Node.js (backend). This module is part of the larger Mensa multi-track health app.

## 🌟 Features

### 1. **Onboarding & Profile**
- Input Last Menstrual Period (LMP) or Due Date
- Auto-calculate pregnancy week and trimester
- Store allergies and dietary preferences

### 2. **Weekly Progress Tracker**
- View baby development by week
- Track body changes
- Get weekly tips and advice
- Visual progress indicators

### 3. **Daily Health Log**
- Record mood, symptoms, water intake, and weight
- Track health patterns over time
- AI-powered symptom analysis

### 4. **AI Symptom Analyzer**
- Classifies symptoms as Common, Warning, or Critical
- Provides actionable guidance
- Red flag alerts for medical consultation
- Safety disclaimers included

### 5. **Nutrition Recommendation Engine**
- Trimester-specific food recommendations
- Allergy safety warnings (⚠️)
- Key nutrient information
- Safe/unsafe indicators

### 6. **Checklist Engine**
- Week-based medical and wellness tasks
- Track appointment reminders
- Mark tasks as complete

### 7. **Conversational AI Assistant**
- Emotional support and mood detection
- Pregnancy Q&A from knowledge base
- Personalized suggestions
- Chat history memory

### 8. **Breathing Exercise Game**
- Guided breathing animations
- Stress relief and relaxation
- Progress tracking
- Mood improvement logging

## 🏗️ Architecture

```
┌─────────────────────────────────────┐
│     Flutter Mobile App (Frontend)   │
│  ┌──────────────────────────────┐  │
│  │  Screens & UI Components     │  │
│  └──────────────────────────────┘  │
│  ┌──────────────────────────────┐  │
│  │  Services & API Client       │  │
│  └──────────────────────────────┘  │
│  ┌──────────────────────────────┐  │
│  │  Models & Data Classes       │  │
│  └──────────────────────────────┘  │
└─────────────────────────────────────┘
                 ↕ REST API
┌─────────────────────────────────────┐
│   Node.js + Express (Backend)       │
│  ┌──────────────────────────────┐  │
│  │  Routes & Controllers        │  │
│  └──────────────────────────────┘  │
│  ┌──────────────────────────────┐  │
│  │  AI Services                 │  │
│  │  - Symptom Analyzer          │  │
│  │  - Chat Assistant            │  │
│  │  - Nutrition Engine          │  │
│  └──────────────────────────────┘  │
│  ┌──────────────────────────────┐  │
│  │  Data Models (In-Memory)     │  │
│  └──────────────────────────────┘  │
└─────────────────────────────────────┘
```

## 📁 Project Structure

### Flutter Frontend (`/mensa`)
```
lib/
├── models/              # Data models
│   ├── user_pregnancy.dart
│   ├── daily_log.dart
│   ├── chat_message.dart
│   ├── food_item.dart
│   └── ...
├── screens/             # UI screens
│   ├── onboarding_screen.dart
│   ├── dashboard_screen.dart
│   ├── daily_log_screen.dart
│   ├── nutrition_screen.dart
│   ├── ai_chat_screen.dart
│   ├── breathing_game_screen.dart
│   └── ...
├── services/            # Business logic & API
│   ├── api_service.dart
│   ├── date_calculator_service.dart
│   └── notification_service.dart
└── main.dart           # App entry point

assets/
└── data/               # Static JSON data
    ├── week_data.json
    ├── foods.json
    ├── symptom_week_map.json
    └── pregnancy_faq.json
```

### Node.js Backend (`/server`)
```
src/
├── routes/             # API endpoints
│   ├── users.routes.js
│   ├── logs.routes.js
│   ├── ai.routes.js
│   ├── nutrition.routes.js
│   ├── checklist.routes.js
│   └── breathing.routes.js
├── models/             # Data models
│   ├── userPregnancy.model.js
│   ├── dailyLogs.model.js
│   └── chatMemory.model.js
├── services/           # AI & business logic
│   ├── aiSymptomAnalyzer.js
│   ├── chatAssistant.js
│   └── nutritionEngine.js
├── data/              # Static data files
│   ├── week_data.json
│   ├── foods.json
│   ├── symptom_week_map.json
│   └── pregnancy_faq.json
└── app.js             # Server entry point
```

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Node.js (16.x or higher)
- npm or yarn

### Frontend Setup (Flutter)

1. Navigate to the Flutter project:
```bash
cd mensa
```

2. Install dependencies:
```bash
flutter pub get
```

3. Update API base URL in `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://YOUR_IP:3000/api';
```

4. Run the app:
```bash
flutter run
```

### Backend Setup (Node.js)

1. Navigate to the server directory:
```bash
cd server
```

2. Install dependencies:
```bash
npm install
```

3. Create `.env` file:
```bash
cp .env.example .env
```

4. Edit `.env` with your configuration:
```
PORT=3000
MONGODB_URI=mongodb://localhost:27017/mensa_pregnancy
GEMINI_API_KEY=your_api_key_here
```

5. Start the server:
```bash
npm start
```

For development with auto-reload:
```bash
npm run dev
```

## 📡 API Endpoints

### User Profile
- `GET /api/user/:userId/pregnancy` - Get pregnancy profile
- `POST /api/user/:userId/pregnancy` - Create/update profile

### Daily Logs
- `GET /api/logs/:userId` - Get all logs
- `POST /api/logs/:userId` - Add daily log

### AI Services
- `POST /api/ai/symptom-analysis` - Analyze symptoms
- `POST /api/ai/chat` - Chat with AI assistant

### Nutrition
- `GET /api/nutrition/:userId/:week` - Get recommendations

### Checklist
- `GET /api/checklist/:userId/:week` - Get checklist
- `POST /api/checklist/:userId/:week` - Update task

### Breathing Exercise
- `GET /api/breathing/game/:userId` - Get stats
- `POST /api/breathing/game/:userId` - Update session

## 🔒 Safety & Ethics

### Medical Disclaimers
All AI-generated advice includes clear disclaimers:
- "This guidance doesn't replace medical advice"
- "Always consult your healthcare provider"
- Red flag alerts for critical symptoms

### Data Privacy
- User data stored securely
- No diagnosis features - guidance only
- HIPAA-compliant design considerations

### AI Limitations
- Rule-based symptom classification
- Static knowledge base (no real-time medical data)
- Encourages professional medical consultation

## 🎨 UI/UX Design

- **Color Palette**: Warm pastels (pink, lavender, mint)
- **Layout**: Card-based, grid navigation
- **Typography**: Clear, readable fonts
- **Icons**: Intuitive, pregnancy-themed
- **Accessibility**: High contrast, large touch zones

## 🧪 Testing

### Flutter Tests
```bash
cd mensa
flutter test
```

### Backend Tests
```bash
cd server
npm test
```

## 📱 Firebase Push Notifications (FCM)

### ✅ FCM is Pre-Configured!

Background notifications are **already set up** in this project. You just need to add your Firebase project:

### Quick Setup (5 minutes)

1. **Create Firebase project** at [console.firebase.google.com](https://console.firebase.google.com)

2. **Add Android app** with package name: `com.example.mensa`

3. **Download `google-services.json`** and replace the demo file at:
   ```
   mensa/android/app/google-services.json
   ```

4. **Run the app**:
   ```bash
   cd mensa
   flutter pub get
   flutter run
   ```

5. **Test notification** from Firebase Console → Cloud Messaging

### 📚 Detailed Guides

- **Quick Start**: See `FIREBASE_QUICK_START.md` (5-minute setup)
- **Complete Guide**: See `FCM_SETUP_GUIDE.md` (backend integration, scheduling, etc.)

### Features Included

- ✅ Foreground notifications with local display
- ✅ Background notifications (app minimized)
- ✅ Notifications when app is terminated
- ✅ Notification tap handling
- ✅ Topic subscriptions
- ✅ Token refresh handling
- ✅ Android notification channels

## 🔄 Future Enhancements

- [ ] MongoDB integration for persistent storage
- [ ] Real-time Gemini AI integration
- [ ] Partner mode for shared tracking
- [ ] Wearable device integration
- [ ] Voice input support
- [ ] Multi-language support
- [ ] Doctor consultation booking
- [ ] Community forum

## 📄 License

MIT License - See LICENSE file for details

## 👥 Contributors

Built for the Mensa health tracking platform.

## 📞 Support

For issues or questions, please open an issue on GitHub.

---

**⚕️ Medical Disclaimer**: This application is for informational purposes only and does not provide medical advice. Always consult with a qualified healthcare provider for medical concerns.
#   M e n s a - W I E E E  
 