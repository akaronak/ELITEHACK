# 🌸 Mensa - Women's Health Tracker

<div align="center">

![Mensa Logo](mensa/assets/icon/appicon.png)

**A comprehensive women's health tracking application supporting Menstruation, Pregnancy, and Menopause journeys**

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Node.js-Express-339933?logo=node.js)](https://nodejs.org)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)](https://firebase.google.com)
[![MongoDB](https://img.shields.io/badge/MongoDB-Atlas-47A248?logo=mongodb)](https://www.mongodb.com)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Running the Application](#-running-the-application)
- [API Documentation](#-api-documentation)
- [Features Deep Dive](#-features-deep-dive)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🌟 Overview

**Mensa** is a comprehensive women's health tracking application designed to support women through three critical life stages:

1. **Menstruation Tracking** - Cycle monitoring, symptom logging, PCOS tracking
2. **Pregnancy Tracking** - Week-by-week guidance, appointments, nutrition
3. **Menopause Tracking** - Symptom management, health insights

The app combines modern Flutter UI with a powerful Node.js backend, AI-powered insights using Google Gemini, and real-time notifications via Firebase.

---

## ✨ Features

### 🩸 Menstruation Tracker
- **Cycle Prediction** - AI-powered period predictions based on historical data
- **Symptom Logging** - Track mood, flow, symptoms, and notes
- **Calendar View** - Visual cycle calendar with phase indicators
- **PCOS Tracking** - Specialized tracking for PCOS symptoms
- **Insights & Analytics** - Cycle patterns and health insights
- **PDF Reports** - Generate and share health reports

### 🤰 Pregnancy Tracker
- **Week-by-Week Guidance** - Detailed information for each pregnancy week
- **Daily Logging** - Track mood, symptoms, weight, and notes
- **Nutrition Recommendations** - AI-powered meal suggestions
- **Appointment Management** - Schedule and track prenatal appointments
- **Checklist System** - Week-specific tasks and reminders
- **AI Chat Assistant** - 24/7 pregnancy support and Q&A
- **Breathing Exercises** - Guided relaxation techniques
- **PDF Reports** - Comprehensive pregnancy health reports

### 🌺 Menopause Tracker
- **Symptom Tracking** - Hot flashes, mood swings, sleep quality
- **Daily Logging** - Track symptoms and their severity
- **AI Insights** - Personalized health recommendations
- **History View** - Track symptom patterns over time
- **PDF Reports** - Generate menopause health reports

### 🔔 Universal Features
- **Multi-Tracker Support** - Switch between trackers seamlessly
- **User Profiles** - Comprehensive health profiles with medical history
- **Emergency Alerts** - Quick emergency contact notifications
- **Push Notifications** - Reminders and health tips
- **Education Hub** - Learn about periods, pregnancy, and menopause
- **Voice AI Integration** - Voice-based health assistant
- **Dark/Light Themes** - Beautiful, calming color schemes
- **Offline Support** - Local data caching

---

## 🏗️ Architecture

### System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Flutter Mobile App                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │ Menstruation │  │  Pregnancy   │  │  Menopause   │     │
│  │   Tracker    │  │   Tracker    │  │   Tracker    │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │           Shared Services & Components                │  │
│  │  • API Service  • Notification Service               │  │
│  │  • Date Calculator  • Local Storage                  │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            ↕ HTTP/REST API
┌─────────────────────────────────────────────────────────────┐
│                    Node.js Backend Server                    │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                   Express Routes                      │  │
│  │  • User Routes  • Pregnancy Routes                   │  │
│  │  • Menstruation Routes  • Menopause Routes           │  │
│  │  • AI Routes  • Notification Routes                  │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                    Services Layer                     │  │
│  │  • Gemini AI Service  • Email Service                │  │
│  │  • FCM Service  • Nutrition Engine                   │  │
│  │  • Chat Assistant  • Symptom Analyzer                │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│                    External Services                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   MongoDB    │  │   Firebase   │  │ Google Gemini│     │
│  │    Atlas     │  │     FCM      │  │      AI      │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow

1. **User Interaction** → Flutter UI captures user input
2. **API Service** → Sends HTTP requests to backend
3. **Express Routes** → Routes requests to appropriate handlers
4. **Services Layer** → Processes business logic, AI, notifications
5. **Database** → Stores/retrieves data from MongoDB
6. **Response** → Returns data to Flutter app
7. **UI Update** → Flutter rebuilds UI with new data

---

## 🛠️ Tech Stack

### Frontend (Flutter)
- **Framework**: Flutter 3.9.2 (Dart SDK)
- **State Management**: Provider
- **HTTP Client**: http package
- **Local Storage**: shared_preferences
- **Notifications**: flutter_local_notifications, firebase_messaging
- **UI Components**: 
  - Material Design 3
  - Custom widgets with gradient designs
  - Lottie animations
  - FL Chart for data visualization
  - Table Calendar for cycle tracking
- **PDF Generation**: pdf, path_provider, open_file, share_plus
- **Other**: intl (internationalization), url_launcher, webview_flutter

### Backend (Node.js)
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB Atlas (Mongoose ODM)
- **AI Integration**: Google Gemini AI (@google/genai)
- **Push Notifications**: Firebase Admin SDK
- **Email Service**: Nodemailer
- **Data Storage**: LowDB (for local JSON storage)
- **Environment**: dotenv

### Cloud Services
- **Database**: MongoDB Atlas
- **Push Notifications**: Firebase Cloud Messaging (FCM)
- **AI**: Google Gemini 1.5 Flash
- **Hosting**: Render (backend deployment)

---

## 📁 Project Structure

```
mensa/
├── mensa/                          # Flutter mobile app
│   ├── lib/
│   │   ├── main.dart              # App entry point
│   │   ├── models/                # Data models
│   │   │   ├── user_profile.dart
│   │   │   ├── user_pregnancy.dart
│   │   │   ├── daily_log.dart
│   │   │   ├── menstruation_log.dart
│   │   │   ├── appointment.dart
│   │   │   └── ...
│   │   ├── screens/               # UI screens
│   │   │   ├── auth/             # Authentication screens
│   │   │   ├── menstruation/     # Menstruation tracker screens
│   │   │   ├── pregnancy/        # Pregnancy tracker screens
│   │   │   ├── menopause/        # Menopause tracker screens
│   │   │   ├── onboarding/       # Onboarding flows
│   │   │   ├── main_app_screen.dart
│   │   │   ├── dashboard_screen.dart
│   │   │   ├── profile_screen.dart
│   │   │   └── ...
│   │   └── services/              # Business logic services
│   │       ├── api_service.dart
│   │       ├── notification_service.dart
│   │       └── date_calculator_service.dart
│   ├── assets/                    # Static assets
│   │   ├── data/                 # JSON data files
│   │   ├── images/               # Image assets
│   │   ├── animations/           # Lottie animations
│   │   └── icon/                 # App icons
│   ├── android/                   # Android-specific code
│   ├── ios/                       # iOS-specific code
│   └── pubspec.yaml              # Flutter dependencies
│
├── server/                         # Node.js backend
│   ├── src/
│   │   ├── app.js                # Express app setup
│   │   ├── models/               # Mongoose models
│   │   │   ├── userPregnancy.model.js
│   │   │   ├── dailyLogs.model.js
│   │   │   ├── menstruationLog.model.js
│   │   │   ├── cycleData.model.js
│   │   │   └── chatMemory.model.js
│   │   ├── routes/               # API routes
│   │   │   ├── users.routes.js
│   │   │   ├── userProfile.routes.js
│   │   │   ├── logs.routes.js
│   │   │   ├── menstruation.routes.js
│   │   │   ├── menopause.routes.js
│   │   │   ├── ai.routes.js
│   │   │   ├── nutrition.routes.js
│   │   │   ├── appointments.routes.js
│   │   │   ├── notification.routes.js
│   │   │   └── emergency.routes.js
│   │   ├── services/             # Business logic
│   │   │   ├── geminiService.js
│   │   │   ├── chatAssistant.js
│   │   │   ├── aiSymptomAnalyzer.js
│   │   │   ├── nutritionEngine.js
│   │   │   ├── fcmService.js
│   │   │   ├── emailService.js
│   │   │   └── database.js
│   │   └── data/                 # Static data
│   │       ├── week_data.json
│   │       ├── foods.json
│   │       ├── checklist_templates.json
│   │       └── pregnancy_faq.json
│   ├── .env                      # Environment variables
│   └── package.json              # Node dependencies
│
├── google-services.json           # Firebase config
├── firebase-service-account.json  # Firebase admin SDK
└── README.md                      # This file
```

---

## 🚀 Installation

### Prerequisites

- **Flutter SDK** 3.9.2 or higher
- **Dart SDK** (comes with Flutter)
- **Node.js** 16.x or higher
- **npm** or **yarn**
- **MongoDB Atlas** account
- **Firebase** project
- **Google Gemini API** key
- **Android Studio** / **Xcode** (for mobile development)

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/mensa.git
cd mensa
```

### 2. Setup Flutter App

```bash
cd mensa
flutter pub get
```

### 3. Setup Backend Server

```bash
cd ../server
npm install
```

---

## ⚙️ Configuration

### 1. Firebase Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Enable **Firebase Cloud Messaging (FCM)**
3. Download `google-services.json` (Android) and place in `mensa/android/app/`
4. Download `GoogleService-Info.plist` (iOS) and place in `mensa/ios/Runner/`
5. Download Firebase Admin SDK service account JSON and save as `firebase-service-account.json`

### 2. MongoDB Setup

1. Create a MongoDB Atlas cluster
2. Get your connection string
3. Whitelist your IP address

### 3. Google Gemini API

1. Get API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Add to `.env` file

### 4. Environment Variables

Create `server/.env`:

```env
PORT=3000
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/mensa
GEMINI_API_KEY=your_gemini_api_key
FIREBASE_PROJECT_ID=your_firebase_project_id

# Email Service for Emergency Alerts
EMAIL_USER=your_email@gmail.com
EMAIL_APP_PASSWORD=your_app_password
```

### 5. Update API Base URL

In `mensa/lib/services/api_service.dart`, update the base URL:

```dart
// For local development
static const String baseUrl = 'http://10.0.2.2:3000/api';  // Android Emulator
// static const String baseUrl = 'http://localhost:3000/api';  // iOS Simulator

// For production
// static const String baseUrl = 'https://your-backend-url.com/api';
```

---

## 🏃 Running the Application

### Start Backend Server

```bash
cd server
npm start
# or for development with auto-reload
npm run dev
```

Server will run on `http://localhost:3000`

### Run Flutter App

#### Android
```bash
cd mensa
flutter run
```

#### iOS
```bash
cd mensa
flutter run -d ios
```

#### Web
```bash
cd mensa
flutter run -d chrome
```

---

## 📡 API Documentation

### Base URL
```
http://localhost:3000/api
```

### Authentication
Currently using simple user ID-based authentication. Future versions will implement JWT.

### Main Endpoints

#### User Management
- `POST /api/user/register` - Register new user
- `POST /api/user/login` - User login
- `GET /api/user/:userId/profile` - Get user profile
- `PUT /api/user/:userId/profile` - Update user profile

#### Pregnancy Tracking
- `GET /api/user/:userId/pregnancy` - Get pregnancy profile
- `POST /api/user/:userId/pregnancy` - Create/update pregnancy profile
- `GET /api/logs/:userId` - Get daily logs
- `POST /api/logs/:userId` - Add daily log
- `GET /api/progress/:userId/week/:week` - Get week progress

#### Menstruation Tracking
- `POST /api/menstruation/:userId/setup` - Setup cycle
- `GET /api/menstruation/:userId/predictions` - Get cycle predictions
- `GET /api/menstruation/:userId/logs` - Get menstruation logs
- `POST /api/menstruation/:userId/log` - Add menstruation log
- `GET /api/menstruation/:userId/insights` - Get cycle insights

#### Menopause Tracking
- `GET /api/menopause/:userId/logs` - Get menopause logs
- `POST /api/menopause/:userId/log` - Add menopause log
- `GET /api/menopause/:userId/report` - Generate menopause report

#### AI Features
- `POST /api/ai/chat` - Chat with AI assistant
- `POST /api/ai/analyze-symptoms` - Analyze symptoms
- `GET /api/ai/week-insights/:userId/:week` - Get week insights

#### Nutrition
- `GET /api/nutrition/:userId/recommendations` - Get meal recommendations
- `GET /api/nutrition/foods` - Get food database

#### Appointments
- `GET /api/appointments/:userId` - Get appointments
- `POST /api/appointments/:userId` - Create appointment
- `PUT /api/appointments/:appointmentId` - Update appointment
- `DELETE /api/appointments/:appointmentId` - Delete appointment

#### Notifications
- `POST /api/notifications/register-token` - Register FCM token
- `POST /api/notifications/send` - Send notification

#### Emergency
- `POST /api/emergency/alert` - Send emergency alert

---

## 🎯 Features Deep Dive

### 1. Multi-Tracker System

The app supports three independent trackers that users can switch between:

**Architecture:**
- `MainAppScreen` - Root screen that determines which tracker to show
- `UserProfile` model stores `trackerType` field
- Profile screen allows seamless tracker switching
- Each tracker has its own home screen, onboarding, and features

**Tracker Types:**
- `menstruation` - Default tracker
- `pregnancy` - Pregnancy journey tracker
- `menopause` - Menopause symptom tracker

### 2. AI-Powered Insights

**Google Gemini Integration:**
- **Chat Assistant** - Conversational AI for health questions
- **Symptom Analysis** - AI analyzes symptoms and provides insights
- **Nutrition Recommendations** - Personalized meal suggestions
- **Week Insights** - Weekly pregnancy guidance

**Implementation:**
```javascript
// server/src/services/geminiService.js
const { GoogleGenerativeAI } = require('@google/genai');
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
const model = genAI.getGenerativeModel({ model: 'gemini-1.5-flash' });
```

### 3. Cycle Prediction Algorithm

**Menstruation Prediction:**
1. Collects historical cycle data
2. Calculates average cycle length
3. Identifies patterns in cycle variations
4. Predicts next period date with confidence score
5. Adjusts predictions based on new data

**Implementation:**
```dart
// Calculates cycle day based on last period
int _calculateCurrentCycleDay(Map<String, dynamic> predictions) {
  final lastPeriod = DateTime.parse(predictions['last_period_start']);
  final today = DateTime.now();
  return today.difference(lastPeriod).inDays + 1;
}
```

### 4. Push Notifications

**Firebase Cloud Messaging:**
- Period reminders
- Appointment notifications
- Daily health tips
- Medication reminders
- Emergency alerts

**Types:**
- Immediate notifications
- Scheduled notifications
- Background notifications

### 5. PDF Report Generation

**Features:**
- Comprehensive health reports
- Includes all tracked data
- Professional medical format
- Shareable via email/messaging
- Printable format

**Implementation:**
```dart
// Uses pdf package to generate reports
final pdf = pw.Document();
pdf.addPage(/* report content */);
final file = File('${output.path}/report.pdf');
await file.writeAsBytes(await pdf.save());
```

### 6. Emergency Alert System

**Features:**
- One-tap emergency contact
- Sends email with health information
- Includes medical history
- Current symptoms and medications
- Location information (future)

**Flow:**
1. User taps emergency button
2. Confirms action
3. System sends email to emergency contact
4. Includes comprehensive health data
5. Optionally initiates phone call

---

## 🎨 UI/UX Design

### Design Philosophy
- **Calming Colors** - Soft pinks, purples, and pastels
- **Modern Material Design 3** - Latest Flutter design system
- **Gradient Accents** - Beautiful gradient backgrounds
- **Smooth Animations** - Lottie animations for engagement
- **Intuitive Navigation** - Easy-to-use bottom navigation
- **Accessibility** - High contrast, readable fonts

### Color Schemes

**Menstruation Tracker:**
- Primary: `#E8C4C4` (Soft Pink)
- Light: `#F5E6E6`
- Dark: `#A67C7C`
- Background: `#FAF5F5`

**Pregnancy Tracker:**
- Primary: `#98D8C8` (Mint Green)
- Light: `#F0FFF8`
- Dark: `#66A896`
- Background: `#F5FFF8`

**Menopause Tracker:**
- Primary: `#D4C4E8` (Lavender)
- Light: `#F0E6FA`
- Dark: `#9B7FC8`
- Background: `#FAF5FF`

---

## 🧪 Testing

### Run Tests

```bash
# Flutter tests
cd mensa
flutter test

# Backend tests (if implemented)
cd server
npm test
```

### Test Coverage
- Unit tests for services
- Widget tests for UI components
- Integration tests for API calls
- End-to-end tests for user flows

---

## 📱 Deployment

### Backend Deployment (Render)

1. Create account on [Render](https://render.com)
2. Connect GitHub repository
3. Create new Web Service
4. Set environment variables
5. Deploy

### Mobile App Deployment

#### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

Then upload to respective app stores.

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style
- Follow Flutter/Dart style guide
- Use meaningful variable names
- Add comments for complex logic
- Write tests for new features

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👥 Team

- **Project Lead** - [Your Name]
- **Flutter Developer** - [Developer Name]
- **Backend Developer** - [Developer Name]
- **UI/UX Designer** - [Designer Name]

---

## 🙏 Acknowledgments

- Google Gemini AI for intelligent insights
- Firebase for push notifications
- MongoDB Atlas for database hosting
- Flutter community for amazing packages
- All contributors and testers

---

## 📞 Support

For support, email support@mensa-health.com or join our Slack channel.

---

## 🗺️ Roadmap

### Version 2.0
- [ ] JWT Authentication
- [ ] Social features (community support)
- [ ] Wearable device integration
- [ ] Telemedicine integration
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Offline-first architecture
- [ ] Advanced analytics dashboard
- [ ] Partner/family sharing
- [ ] Export to Apple Health/Google Fit

### Version 3.0
- [ ] AI-powered health predictions
- [ ] Virtual health assistant
- [ ] Medication tracking with reminders
- [ ] Integration with healthcare providers
- [ ] Insurance claim assistance
- [ ] Fertility tracking
- [ ] Mental health support

---

<div align="center">

**Made with ❤️ for Women's Health**

[Website](https://mensa-health.com) • [Documentation](https://docs.mensa-health.com) • [Support](mailto:support@mensa-health.com)

</div>
