# 🎯 Multi-Track Mensa App - Complete Implementation Guide

## Overview

The Mensa app now supports **THREE health tracking modules**:

1. **Menstruation Tracker** - Cycle tracking, flow monitoring, symptom logging
2. **Menopause Tracker** - Symptom management, health reports, AI insights
3. **Pregnancy Tracker** - Week-by-week monitoring (already implemented)

---

## 🏗️ System Architecture

```
Mensa App
│
├── Track Selection Screen (Entry Point)
│   ├── User selects their health journey
│   └── Stores selection in SharedPreferences
│
├── Menstruation Module
│   ├── Cycle Calendar
│   ├── Daily Log (Flow, Mood, Symptoms)
│   ├── AI Insights & Predictions
│   └── Abnormality Detection
│
├── Menopause Module
│   ├── Symptom Tracker
│   ├── Health Dashboard
│   ├── AI Report Generator
│   └── Wellness Recommendations
│
└── Pregnancy Module (Already Built)
    ├── Weekly Progress
    ├── Daily Health Log
    ├── AI Symptom Analyzer
    ├── Nutrition Guide
    ├── Checklist
    ├── AI Chat Assistant
    └── Breathing Exercise
```

---

## 📱 What's Been Created

### ✅ Track Selection System
- **File**: `lib/screens/track_selection_screen.dart`
- Beautiful card-based selection UI
- Stores user's choice
- Routes to appropriate module

### ✅ Menstruation Tracker (NEW)
**Files Created:**
1. `lib/screens/menstruation/menstruation_dashboard.dart` - Main dashboard with bottom nav
2. `lib/screens/menstruation/cycle_calendar_screen.dart` - Calendar view with cycle info
3. `lib/screens/menstruation/cycle_log_screen.dart` - Daily logging (flow, mood, symptoms)
4. `lib/screens/menstruation/cycle_insights_screen.dart` - AI insights and predictions

**Features:**
- ✅ Cycle calendar with current day tracking
- ✅ Flow level logging (Light/Medium/Heavy/Spotting)
- ✅ Mood tracking (7 mood options)
- ✅ Symptom logging (8 common symptoms)
- ✅ AI-powered cycle predictions
- ✅ Abnormality detection
- ✅ Next period predictions
- ✅ Cycle statistics

---

## 🚀 Quick Implementation Steps

### Step 1: Update Main App Entry Point

Update `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/track_selection_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  
  final notificationService = NotificationService();
  await notificationService.initialize();
  
  runApp(const MensaApp());
}

class MensaApp extends StatelessWidget {
  const MensaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mensa - Women\'s Health',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFFF5F7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB6C1),
          primary: const Color(0xFFFFB6C1),
        ),
        useMaterial3: true,
      ),
      home: const TrackSelectionScreen(userId: 'demo_user_123'),
    );
  }
}
```

### Step 2: Create Menopause Module

Create these files:

**`lib/screens/menopause/menopause_dashboard.dart`:**
```dart
import 'package:flutter/material.dart';

class MenopauseDashboard extends StatelessWidget {
  final String userId;

  const MenopauseDashboard({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      appBar: AppBar(
        title: const Text('Menopause Tracker'),
        backgroundColor: const Color(0xFFDDA0DD),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Card
            Card(
              color: const Color(0xFFE8D5F2),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Good Morning, Mensa! 💜',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Managing your menopause journey',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Quick Actions
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildActionCard(
                  'Log Symptoms',
                  Icons.edit_note,
                  const Color(0xFFDDA0DD),
                  () {},
                ),
                _buildActionCard(
                  'Health Report',
                  Icons.assessment,
                  const Color(0xFFBA68C8),
                  () {},
                ),
                _buildActionCard(
                  'AI Insights',
                  Icons.lightbulb,
                  const Color(0xFF9C27B0),
                  () {},
                ),
                _buildActionCard(
                  'Wellness Tips',
                  Icons.spa,
                  const Color(0xFF7B1FA2),
                  () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.7), color],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Step 3: Rename Pregnancy Screens

Move pregnancy screens to proper folder:
- Move `lib/screens/onboarding_screen.dart` → `lib/screens/pregnancy/pregnancy_onboarding_screen.dart`
- Update all imports accordingly

---

## 📊 Database Schema Updates

### Menstruation Cycle Logs

```javascript
{
  "log_id": "string",
  "user_id": "string",
  "date": "date",
  "flow_level": "Light|Medium|Heavy|Spotting",
  "mood": "string",
  "symptoms": ["string"],
  "notes": "string",
  "created_at": "date"
}
```

### Menstruation Cycle Data

```javascript
{
  "user_id": "string",
  "average_cycle_length": "number",
  "last_period_start": "date",
  "predicted_next_period": "date",
  "cycle_regularity": "number", // percentage
  "created_at": "date",
  "updated_at": "date"
}
```

### Menopause Health Logs

```javascript
{
  "log_id": "string",
  "user_id": "string",
  "date": "date",
  "symptoms": ["string"],
  "severity": "Low|Medium|High",
  "mood": "string",
  "sleep_quality": "number",
  "hot_flashes_count": "number",
  "notes": "string",
  "created_at": "date"
}
```

---

## 🔧 Backend API Endpoints

### Menstruation Tracker APIs

```javascript
// Cycle Logs
POST   /api/menstruation/:userId/log
GET    /api/menstruation/:userId/logs
GET    /api/menstruation/:userId/logs/:date

// Cycle Predictions
GET    /api/menstruation/:userId/predictions
POST   /api/menstruation/:userId/analyze

// Statistics
GET    /api/menstruation/:userId/stats
```

### Menopause Tracker APIs

```javascript
// Health Logs
POST   /api/menopause/:userId/log
GET    /api/menopause/:userId/logs

// AI Report Generation
POST   /api/menopause/:userId/generate-report
GET    /api/menopause/:userId/reports

// Insights
GET    /api/menopause/:userId/insights
```

---

## 🤖 AI Features by Module

### Menstruation AI
- **Cycle Prediction**: Predicts next period based on history
- **Abnormality Detection**: Flags irregular cycles
- **Symptom Patterns**: Identifies recurring symptoms
- **Recommendations**: Personalized wellness tips

### Menopause AI
- **Symptom Analysis**: Tracks severity and patterns
- **Report Generation**: Comprehensive health reports using Gemini
- **Wellness Suggestions**: Personalized recommendations
- **Trend Analysis**: Long-term health tracking

### Pregnancy AI (Already Implemented)
- **Symptom Classification**: Common/Warning/Critical
- **Nutrition Recommendations**: Allergy-safe suggestions
- **Emotional Support**: Conversational AI assistant
- **Weekly Insights**: Week-specific guidance

---

## 📱 Notification Strategy

### Menstruation Notifications
- **Period Reminder**: 2 days before predicted start
- **Ovulation Alert**: During fertile window
- **Log Reminder**: Daily during period
- **Abnormality Alert**: If cycle is irregular

### Menopause Notifications
- **Daily Check-in**: Symptom logging reminder
- **Report Ready**: When AI report is generated
- **Wellness Tips**: Daily health suggestions
- **Medication Reminders**: If applicable

### Pregnancy Notifications (Already Implemented)
- **Weekly Updates**: New week milestones
- **Daily Log**: Health tracking reminder
- **Appointment Reminders**: From checklist
- **Hydration Reminders**: Throughout the day

---

## 🎨 Color Scheme by Module

```dart
// Menstruation
Primary: Color(0xFFFFB6C1)  // Light Pink
Secondary: Color(0xFFFF69B4) // Hot Pink

// Menopause
Primary: Color(0xFFDDA0DD)  // Plum
Secondary: Color(0xFFBA68C8) // Medium Orchid

// Pregnancy
Primary: Color(0xFF98D8C8)  // Mint
Secondary: Color(0xFF4DB6AC) // Teal
```

---

## ✅ Implementation Checklist

### Completed ✅
- [x] Track selection screen
- [x] Menstruation dashboard
- [x] Menstruation cycle calendar
- [x] Menstruation daily logging
- [x] Menstruation AI insights
- [x] Pregnancy tracker (all features)
- [x] Firebase FCM integration
- [x] Backend API structure

### To Complete 📋
- [ ] Menopause symptom logging screen
- [ ] Menopause AI report generator
- [ ] Menopause health dashboard
- [ ] Backend implementation for menstruation APIs
- [ ] Backend implementation for menopause APIs
- [ ] Gemini AI integration for all modules
- [ ] Notification scheduling for all tracks
- [ ] User authentication system
- [ ] Data persistence and sync

---

## 🚀 Next Steps

1. **Update main.dart** to use TrackSelectionScreen
2. **Test track selection** and navigation
3. **Implement remaining menopause screens**
4. **Create backend APIs** for new modules
5. **Integrate Gemini AI** for report generation
6. **Set up notification scheduling**
7. **Add user authentication**
8. **Test end-to-end** functionality

---

## 📚 Documentation Files

All documentation is ready:
- `README.md` - Project overview
- `SETUP_GUIDE.md` - Installation guide
- `API_DOCUMENTATION.md` - API reference
- `FCM_SETUP_GUIDE.md` - Notifications setup
- `MULTI_TRACK_IMPLEMENTATION.md` - This file

---

**Your multi-track women's health app is taking shape! 🌸**
