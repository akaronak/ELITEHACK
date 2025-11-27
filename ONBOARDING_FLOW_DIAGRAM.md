# 📊 Onboarding Flow - Visual Diagram

## Complete User Journey

```
┌─────────────────────────────────────────────────────────────────────┐
│                         APP LAUNCH                                  │
└─────────────────────────────────────────────────────────────────────┘
                              ↓
                    ┌─────────────────────┐
                    │  Check User Profile │
                    │  (API Call)         │
                    └─────────────────────┘
                              ↓
                    ┌─────────┴─────────┐
                    │                   │
              Profile Exists      No Profile
                    │                   │
                    ↓                   ↓
        ┌───────────────────┐  ┌──────────────────────┐
        │ Load tracker_type │  │ TRACKER SELECTION    │
        └───────────────────┘  │ SCREEN               │
                    │          │                      │
        ┌───────────┼──────────┤ "What are you       │
        │           │          │  going through?"    │
        │           │          │                      │
        │           │          │ 🤰 Pregnancy         │
        │           │          │ 📅 Menstruation      │
        │           │          │ ❤️  Menopause        │
        │           │          └──────────────────────┘
        │           │                   │
        │           │          ┌────────┼────────┐
        │           │          │        │        │
        │           │          ↓        ↓        ↓
        │           │     ┌─────┐  ┌─────┐  ┌─────┐
        │           │     │  P  │  │  M  │  │  M  │
        │           │     │  R  │  │  E  │  │  E  │
        │           │     │  E  │  │  N  │  │  N  │
        │           │     │  G  │  │  S  │  │  O  │
        │           │     │  N  │  │  T  │  │  P  │
        │           │     │  A  │  │  R  │  │  A  │
        │           │     │  N  │  │  U  │  │  U  │
        │           │     │  C  │  │  A  │  │  S  │
        │           │     │  Y  │  │  T  │  │  E  │
        │           │     └─────┘  └─────┘  └─────┘
        │           │        │        │        │
        │           │        └────────┼────────┘
        │           │                 │
        │           │          Save Profile
        │           │          (with tracker_type)
        │           │                 │
        │           └─────────────────┘
        │                             │
        ↓                             ↓
┌───────────────────────────────────────────────────────────┐
│              ROUTE TO HOME SCREEN                         │
│                                                           │
│  if tracker_type == 'pregnancy'    → Pregnancy Home      │
│  if tracker_type == 'menstruation' → Menstruation Home   │
│  if tracker_type == 'menopause'    → Menopause Home      │
└───────────────────────────────────────────────────────────┘
```

## Pregnancy Onboarding Flow

```
┌──────────────────────────────────────────────────────────┐
│              PREGNANCY ONBOARDING                        │
└──────────────────────────────────────────────────────────┘

Page 1: Basic Information
┌────────────────────────────┐
│ 🤰 Basic Information       │
│                            │
│ Name: [____________]       │
│ Age:  [____] years         │
│ Height: [____] cm          │
│ Weight: [____] kg          │
│                            │
│         [Next →]           │
└────────────────────────────┘
            ↓
Page 2: Pregnancy Details
┌────────────────────────────┐
│ 🤰 Pregnancy Details       │
│                            │
│ Last Menstrual Period:     │
│ [📅 Select Date]           │
│                            │
│ Expected Due Date:         │
│ ✅ March 15, 2026          │
│ (Auto-calculated)          │
│                            │
│    [← Back]  [Next →]      │
└────────────────────────────┘
            ↓
Page 3: Medical Information
┌────────────────────────────┐
│ 💊 Medical Information     │
│                            │
│ Allergies:                 │
│ [Penicillin] [Latex]       │
│ [Pollen] [None]            │
│                            │
│ Medical Conditions:        │
│ [Diabetes] [Hypertension]  │
│ [Thyroid] [None]           │
│                            │
│    [← Back]  [Complete]    │
└────────────────────────────┘
            ↓
    Save & Route to
    Pregnancy Dashboard
```

## Menstruation Onboarding Flow

```
┌──────────────────────────────────────────────────────────┐
│            MENSTRUATION ONBOARDING                       │
└──────────────────────────────────────────────────────────┘

Page 1: Basic Information
┌────────────────────────────┐
│ 📅 Basic Information       │
│                            │
│ Name: [____________]       │
│ Age:  [____] years         │
│ Height: [____] cm          │
│ Weight: [____] kg          │
│                            │
│         [Next →]           │
└────────────────────────────┘
            ↓
Page 2: Cycle Information
┌────────────────────────────┐
│ 📅 Cycle Information       │
│                            │
│ Last Period Start:         │
│ [📅 Select Date]           │
│                            │
│ Average Cycle Length:      │
│ ◄─────●─────► 28 days      │
│ (21-35 days)               │
│                            │
│ Period Duration:           │
│ ◄───●───► 5 days           │
│ (3-7 days)                 │
│                            │
│    [← Back]  [Complete]    │
└────────────────────────────┘
            ↓
    Save & Route to
    Menstruation Home
```

## Menopause Onboarding Flow

```
┌──────────────────────────────────────────────────────────┐
│              MENOPAUSE ONBOARDING                        │
└──────────────────────────────────────────────────────────┘

Page 1: Basic Information
┌────────────────────────────┐
│ ❤️  Basic Information      │
│                            │
│ Name: [____________]       │
│ Age:  [____] years         │
│ Height: [____] cm          │
│ Weight: [____] kg          │
│                            │
│         [Next →]           │
└────────────────────────────┘
            ↓
Page 2: Menopause Information
┌────────────────────────────┐
│ ❤️  Menopause Information  │
│                            │
│ Symptoms Started:          │
│ [📅 Select Date] (optional)│
│                            │
│ Common Symptoms:           │
│ [Hot Flashes] [Night Sweats]│
│ [Mood Changes] [Fatigue]   │
│ [Sleep Problems]           │
│                            │
│ Medical Conditions:        │
│ [Osteoporosis] [Diabetes]  │
│ [Hypertension] [None]      │
│                            │
│    [← Back]  [Complete]    │
└────────────────────────────┘
            ↓
    Save & Route to
    Menopause Home
```

## Tracker Switching Flow

```
┌──────────────────────────────────────────────────────────┐
│                  ANY HOME SCREEN                         │
│                                                          │
│  ☰ Menu                                    🔔 📊        │
│  ─────────────────────────────────────────────────      │
│                                                          │
│  [Current Tracker Content]                              │
│                                                          │
└──────────────────────────────────────────────────────────┘
            ↓ (Tap Menu)
┌──────────────────────────────────────────────────────────┐
│                  PROFILE SCREEN                          │
│                                                          │
│  ← My Profile                                    💾      │
│  ─────────────────────────────────────────────────      │
│                                                          │
│  👤 Sarah Johnson                                        │
│  BMI: 22.8 (Normal)                                      │
│                                                          │
│  ┌────────────────────────────────────────────┐         │
│  │ 🔄 Active Tracker                          │         │
│  │                                            │         │
│  │ ┌────────────────────────────────────┐    │         │
│  │ │ 🤰 Pregnancy              ✓        │    │         │
│  │ └────────────────────────────────────┘    │         │
│  │                                            │         │
│  │ ┌────────────────────────────────────┐    │         │
│  │ │ 📅 Menstruation           ○        │ ← Tap        │
│  │ └────────────────────────────────────┘    │         │
│  │                                            │         │
│  │ ┌────────────────────────────────────┐    │         │
│  │ │ ❤️  Menopause             ○        │    │         │
│  │ └────────────────────────────────────┘    │         │
│  │                                            │         │
│  │ ⚠️  Changing tracker will switch your     │         │
│  │    home screen. Your data is preserved.   │         │
│  └────────────────────────────────────────────┘         │
│                                                          │
└──────────────────────────────────────────────────────────┘
            ↓ (Tap Menstruation)
    ┌─────────────────┐
    │ Save Profile    │
    │ tracker_type =  │
    │ 'menstruation'  │
    └─────────────────┘
            ↓
    ┌─────────────────┐
    │ Trigger         │
    │ onTrackerChanged│
    └─────────────────┘
            ↓
    ┌─────────────────┐
    │ Refresh App     │
    └─────────────────┘
            ↓
┌──────────────────────────────────────────────────────────┐
│              MENSTRUATION HOME SCREEN                    │
│                                                          │
│  ☰ Menu                                    🔔 📊        │
│  ─────────────────────────────────────────────────      │
│                                                          │
│  [Cycle Tracker Content]                                │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

## Data Flow Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    FRONTEND (Flutter)                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Onboarding Screens                                         │
│  ├── TrackerSelectionScreen                                │
│  ├── OnboardingPregnancyScreen                             │
│  ├── OnboardingMenstruationScreen                          │
│  └── OnboardingMenopauseScreen                             │
│                    ↓                                        │
│  UserProfile Model                                          │
│  ├── userId                                                 │
│  ├── name, age, height, weight                             │
│  ├── trackerType ← KEY FIELD                               │
│  └── other fields...                                        │
│                    ↓                                        │
│  ApiService                                                 │
│  └── saveUserProfile(profile)                              │
│                    ↓                                        │
└─────────────────────────────────────────────────────────────┘
                     ↓ HTTP POST
┌─────────────────────────────────────────────────────────────┐
│                    BACKEND (Node.js)                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  POST /api/user/:userId/profile                            │
│  ├── Receives profile data                                 │
│  ├── Checks if profile exists                              │
│  ├── Updates or creates profile                            │
│  └── Returns saved profile                                 │
│                    ↓                                        │
└─────────────────────────────────────────────────────────────┘
                     ↓ Write
┌─────────────────────────────────────────────────────────────┐
│                    DATABASE (lowdb)                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  {                                                          │
│    "userProfiles": [                                        │
│      {                                                      │
│        "user_id": "demo_user_123",                          │
│        "name": "Sarah Johnson",                             │
│        "tracker_type": "pregnancy", ← STORED HERE           │
│        "age": 28,                                           │
│        ...                                                  │
│      }                                                      │
│    ]                                                        │
│  }                                                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                     ↑ Read on App Launch
┌─────────────────────────────────────────────────────────────┐
│                    FRONTEND (Flutter)                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  MainAppScreen                                              │
│  ├── Loads user profile                                    │
│  ├── Reads trackerType                                     │
│  └── Routes to appropriate home:                           │
│      ├── 'pregnancy' → PregnancyHome                       │
│      ├── 'menstruation' → MenstruationHome                 │
│      └── 'menopause' → MenopauseHome                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## State Management Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    MainAppScreen                            │
│  (Root of app, manages overall state)                      │
└─────────────────────────────────────────────────────────────┘
                     ↓ passes callback
┌─────────────────────────────────────────────────────────────┐
│                    Home Screen                              │
│  (Pregnancy/Menstruation/Menopause)                        │
│  - Receives: onTrackerChanged callback                     │
│  - Passes to: ProfileScreen                                │
└─────────────────────────────────────────────────────────────┘
                     ↓ passes callback
┌─────────────────────────────────────────────────────────────┐
│                    ProfileScreen                            │
│  - Shows tracker switcher                                  │
│  - User taps different tracker                             │
│  - Saves profile with new trackerType                      │
│  - Calls: onTrackerChanged()                               │
└─────────────────────────────────────────────────────────────┘
                     ↓ callback triggers
┌─────────────────────────────────────────────────────────────┐
│                    MainAppScreen                            │
│  - Receives callback                                       │
│  - Reloads user profile                                    │
│  - Rebuilds with new trackerType                           │
│  - Routes to new home screen                               │
└─────────────────────────────────────────────────────────────┘
```

## Summary

This visual guide shows:
- ✅ Complete user journey from launch to home
- ✅ Each onboarding flow in detail
- ✅ Tracker switching mechanism
- ✅ Data flow architecture
- ✅ State management pattern

All flows are implemented and working! 🎉
