# PCOS/PCOD Feature Implementation Plan

## Overview
This plan adds comprehensive PCOS/PCOD support to the existing menstruation tracker, maintaining the current UI design while adding specialized tracking, insights, and lifestyle coaching for women with irregular cycles.

---

## Phase 1: Database & Backend (Server-Side)

### 1.1 Database Schema Extensions

**Add to `server/src/services/database.js`:**

```javascript
// New collections to add in defaults:
pcosProfiles: [],        // PCOS-specific user data
pcosSymptomLogs: [],     // Daily PCOS symptom tracking
pcosLifestyleLogs: [],   // Lifestyle tracking (exercise, sleep, meals)
pcosInsights: [],        // Generated insights and patterns
pcosEducation: []        // Educational content tracking
```

**PCOS Profile Structure:**
```javascript
{
  profile_id: string,
  user_id: string,
  has_pcos_diagnosis: boolean,
  diagnosis_date: date,
  pcos_type: string, // 'insulin-resistant', 'inflammatory', 'post-pill', 'adrenal'
  is_on_medication: boolean,
  medications: [string],
  fertility_concerns: boolean,
  weight_goal: string, // 'maintain', 'lose', 'gain', 'not-tracking'
  created_at: date,
  updated_at: date
}
```

**PCOS Symptom Log Structure:**
```javascript
{
  log_id: string,
  user_id: string,
  date: date,
  
  // PCOS-specific symptoms
  acne_severity: number, // 0-5 scale
  hair_loss: boolean,
  facial_hair: boolean,
  body_hair: boolean,
  weight_change: number, // kg
  energy_level: number, // 1-5
  sleep_quality: number, // 1-5
  stress_level: number, // 1-5
  cravings: [string], // ['sweet', 'salty', 'carbs']
  
  // Lifestyle
  exercise_minutes: number,
  exercise_type: string,
  water_intake: number, // glasses
  
  // Existing menstruation fields
  flow_level: string,
  mood: string,
  symptoms: [string],
  notes: string,
  
  created_at: date
}
```

### 1.2 New API Routes

**Create `server/src/routes/pcos.routes.js`:**

```javascript
// PCOS Profile Management
POST   /api/pcos/:userId/profile          // Create/update PCOS profile
GET    /api/pcos/:userId/profile          // Get PCOS profile

// PCOS Symptom Logging
POST   /api/pcos/:userId/symptom-log      // Log daily PCOS symptoms
GET    /api/pcos/:userId/symptom-logs     // Get symptom history
GET    /api/pcos/:userId/symptom-trends   // Get symptom trends over time

// PCOS Insights & Analytics
GET    /api/pcos/:userId/insights         // Get AI-generated insights
GET    /api/pcos/:userId/cycle-analysis   // Irregular cycle analysis
GET    /api/pcos/:userId/lifestyle-score  // Lifestyle health score

// PCOS Education
GET    /api/pcos/education                // Get educational content
POST   /api/pcos/:userId/education/track  // Track viewed content

// Doctor Report
GET    /api/pcos/:userId/doctor-report    // Generate PDF-ready report
```

### 1.3 Enhanced Menstruation Routes

**Update `server/src/routes/menstruation.routes.js`:**

- Add PCOS-aware cycle prediction (handle irregular cycles)
- Add long cycle detection (>35 days)
- Add missed period alerts (>90 days)
- Enhanced statistics with PCOS markers

---

## Phase 2: Flutter Models (Client-Side)

### 2.1 New Models

**Create `mensa/lib/models/pcos_profile.dart`:**
```dart
class PCOSProfile {
  final String profileId;
  final String userId;
  final bool hasPcosDiagnosis;
  final DateTime? diagnosisDate;
  final String? pcosType;
  final bool isOnMedication;
  final List<String> medications;
  final bool fertilityConcerns;
  final String weightGoal;
  
  // Methods: fromJson, toJson
}
```

**Create `mensa/lib/models/pcos_symptom_log.dart`:**
```dart
class PCOSSymptomLog {
  final String? logId;
  final String userId;
  final DateTime date;
  
  // PCOS symptoms
  final int acneSeverity;
  final bool hairLoss;
  final bool facialHair;
  final bool bodyHair;
  final double? weightChange;
  final int energyLevel;
  final int sleepQuality;
  final int stressLevel;
  final List<String> cravings;
  
  // Lifestyle
  final int exerciseMinutes;
  final String? exerciseType;
  final int waterIntake;
  
  // Menstruation
  final String flowLevel;
  final String mood;
  final List<String> symptoms;
  final String? notes;
  
  // Methods: fromJson, toJson
}
```

### 2.2 Update Existing Models

**Update `mensa/lib/models/user_profile.dart`:**
```dart
// Add field:
final bool hasPCOS;
final String? pcosProfileId;
```

---

## Phase 3: UI Implementation

### 3.1 PCOS Setup Screen

**Create `mensa/lib/screens/menstruation/pcos_setup_screen.dart`:**

- Onboarding flow when user indicates PCOS diagnosis
- Questions:
  - "Have you been diagnosed with PCOS/PCOD?"
  - "When were you diagnosed?"
  - "Are you on any medications?"
  - "Do you have fertility concerns?"
  - "What's your health goal?"
- Soft, empathetic UI matching existing design
- Save to backend and enable PCOS mode

### 3.2 Enhanced Menstruation Home

**Update `mensa/lib/screens/menstruation/menstruation_home.dart`:**

**Add PCOS Toggle Section (after "Log Today" title):**
```dart
// PCOS Mode Indicator
if (_hasPCOS) {
  Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: _purpleMood.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(Icons.favorite, color: _purpleMood),
        SizedBox(width: 8),
        Text('PCOS Tracking Enabled'),
        Spacer(),
        Switch(value: _pcosMode, onChanged: _togglePCOSMode),
      ],
    ),
  ),
}
```

**Expand Symptom Chips (when PCOS mode enabled):**
```dart
// Add PCOS-specific symptoms to existing _symptoms list:
'Acne',
'Hair Loss',
'Facial Hair',
'Body Hair',
'Low Energy',
'Poor Sleep',
'Sugar Cravings',
'Weight Gain',
```

**Add Lifestyle Tracking Card:**
```dart
// New card after Symptoms card
Container(
  padding: EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
  ),
  child: Column(
    children: [
      // Exercise tracking
      _buildLifestyleRow('Exercise', Icons.fitness_center),
      // Water intake
      _buildLifestyleRow('Water', Icons.water_drop),
      // Sleep quality
      _buildLifestyleRow('Sleep', Icons.bedtime),
    ],
  ),
)
```

### 3.3 PCOS Insights Screen

**Create `mensa/lib/screens/menstruation/pcos_insights_screen.dart`:**

**Features:**
- Cycle irregularity visualization (chart showing cycle lengths)
- Symptom trends over time (acne, hair, energy)
- Lifestyle score (exercise, sleep, nutrition)
- Doctor-ready insights:
  - "No period for 90+ days → See your doctor"
  - "Cycles longer than 45 days in 3 of last 4 months"
- Correlation insights:
  - "Acne flares during luteal phase"
  - "Better sleep = better mood"
  - "Exercise days = higher energy"

**UI Design:**
- Match existing soft pink/purple color scheme
- Card-based layout
- Charts using fl_chart package
- Export button for doctor report

### 3.4 PCOS Education Hub

**Create `mensa/lib/screens/menstruation/pcos_education_screen.dart`:**

**Content Categories:**
1. **Understanding PCOS**
   - What is PCOS?
   - Types of PCOS
   - Common symptoms
   - Long-term health impacts

2. **Managing PCOS**
   - Lifestyle changes
   - Nutrition tips
   - Exercise recommendations
   - Stress management

3. **Medical Care**
   - When to see a doctor
   - Questions to ask
   - Treatment options
   - Fertility and PCOS

4. **Mental Health**
   - Emotional impact
   - Support resources
   - Community links

**UI:**
- Expandable cards
- Progress tracking (mark as read)
- Bookmark favorites
- Share with doctor option

### 3.5 PCOS Lifestyle Coach

**Create `mensa/lib/screens/menstruation/pcos_lifestyle_coach_screen.dart`:**

**Features:**
- Daily challenges based on cycle phase:
  - Menstrual: "Gentle yoga for 15 mins"
  - Follicular: "Try a new low-GI recipe"
  - Ovulation: "30-min strength training"
  - Luteal: "Practice deep breathing"
  
- Nutrition suggestions:
  - Low-GI meal ideas
  - Protein + fiber combos
  - "Swap this for that" cards
  - Weekly meal planning

- Gamification:
  - Streak tracking
  - Badges (7-day exercise, 30-day water goal)
  - Progress visualization

**UI:**
- Daily card with 3 suggested actions
- Mark as complete
- Streak counter
- Badge showcase

### 3.6 Doctor Report Generator

**Create `mensa/lib/screens/menstruation/pcos_doctor_report_screen.dart`:**

**Report Contents:**
- Patient info
- Last 6-12 months cycle history
- Cycle length chart
- Symptom frequency table
- Lifestyle summary
- Medications
- Questions for doctor
- Disclaimer: "Auto-generated summary, not medical advice"

**Export Options:**
- PDF export (using pdf package)
- Share via email/WhatsApp
- Print option

---

## Phase 4: API Service Updates

**Update `mensa/lib/services/api_service.dart`:**

```dart
// PCOS Profile
Future<PCOSProfile?> getPCOSProfile(String userId);
Future<void> savePCOSProfile(PCOSProfile profile);

// PCOS Symptom Logging
Future<void> logPCOSSymptoms(PCOSSymptomLog log);
Future<List<PCOSSymptomLog>> getPCOSSymptomLogs(String userId);
Future<Map<String, dynamic>> getPCOSSymptomTrends(String userId);

// PCOS Insights
Future<List<Map<String, dynamic>>> getPCOSInsights(String userId);
Future<Map<String, dynamic>> getCycleAnalysis(String userId);
Future<Map<String, dynamic>> getLifestyleScore(String userId);

// Doctor Report
Future<Map<String, dynamic>> generateDoctorReport(String userId);
```

---

## Phase 5: Navigation & Integration

### 5.1 Update Menstruation Dashboard

**Update `mensa/lib/screens/menstruation/menstruation_dashboard.dart`:**

Add 4th tab for PCOS:
```dart
BottomNavigationBarItem(
  icon: Icon(Icons.favorite),
  label: 'PCOS',
)
```

### 5.2 Add PCOS Quick Actions

**Update `menstruation_home.dart` Quick Actions:**
```dart
Row(
  children: [
    _buildActionButton('Calendar', ...),
    _buildActionButton('PCOS Insights', Icons.analytics, ...),
  ],
),
Row(
  children: [
    _buildActionButton('Lifestyle Coach', Icons.spa, ...),
    _buildActionButton('Education', Icons.school, ...),
  ],
),
```

---

## Phase 6: Smart Alerts & Notifications

### 6.1 PCOS-Specific Notifications

**Add to `mensa/lib/services/notification_service.dart`:**

```dart
// Long cycle alert
Future<void> scheduleLongCycleAlert(int daysSinceLastPeriod);

// Missed period alert (90+ days)
Future<void> scheduleMissedPeriodAlert();

// Daily lifestyle reminder
Future<void> scheduleDailyLifestyleReminder();

// Medication reminder
Future<void> scheduleMedicationReminder(String medication, DateTime time);
```

---

## Phase 7: AI Integration

### 7.1 Enhanced AI Chat

**Update `mensa/lib/screens/menstruation/menstruation_ai_chat_screen.dart`:**

- Add PCOS context to AI prompts
- PCOS-specific questions:
  - "How can I manage my PCOS symptoms?"
  - "What foods should I eat with PCOS?"
  - "Why is my cycle so irregular?"
  - "Should I see a doctor about my symptoms?"

### 7.2 Backend AI Insights

**Update `server/src/routes/pcos.routes.js`:**

```javascript
// Generate AI insights using Gemini
async function generatePCOSInsights(userId) {
  // Analyze symptom patterns
  // Detect correlations (exercise → energy, sleep → mood)
  // Identify concerning patterns (long cycles, severe symptoms)
  // Generate personalized recommendations
  // Flag doctor consultation needs
}
```

---

## Implementation Priority

### Sprint 1 (Week 1): Foundation
1. ✅ Database schema updates
2. ✅ PCOS profile API routes
3. ✅ PCOS models in Flutter
4. ✅ PCOS setup screen

### Sprint 2 (Week 2): Core Tracking
1. ✅ Enhanced symptom logging UI
2. ✅ Lifestyle tracking card
3. ✅ PCOS symptom log API
4. ✅ Update menstruation_home.dart

### Sprint 3 (Week 3): Insights & Analytics
1. ✅ PCOS insights screen
2. ✅ Cycle analysis backend
3. ✅ Symptom trend visualization
4. ✅ Lifestyle score calculation

### Sprint 4 (Week 4): Education & Support
1. ✅ PCOS education hub
2. ✅ Lifestyle coach screen
3. ✅ Doctor report generator
4. ✅ Smart notifications

### Sprint 5 (Week 5): Polish & Testing
1. ✅ AI chat enhancements
2. ✅ UI/UX refinements
3. ✅ Testing with real data
4. ✅ Documentation

---

## Key Design Principles

1. **Non-Judgmental**: No toxic "weight loss" messaging, focus on health
2. **Empowering**: Give users data to advocate for themselves
3. **Doctor-Friendly**: Generate reports doctors can actually use
4. **Flexible**: Handle irregular cycles without forcing averages
5. **Holistic**: Track symptoms, lifestyle, and mental health together
6. **Evidence-Based**: All education content backed by research
7. **Privacy-First**: Sensitive health data stays secure

---

## Technical Stack

- **Backend**: Node.js + Express + LowDB
- **Frontend**: Flutter + Dart
- **Charts**: fl_chart package
- **PDF**: pdf + printing packages
- **AI**: Google Gemini API
- **Notifications**: flutter_local_notifications

---

## Success Metrics

1. Users can log PCOS symptoms in <30 seconds
2. Insights screen shows actionable patterns
3. Doctor report exports successfully
4. Education content completion rate >50%
5. Lifestyle coach engagement >3 days/week
6. User satisfaction with PCOS features >4.5/5

---

## Next Steps

1. Review and approve this plan
2. Set up development environment
3. Start with Sprint 1 (Database & Backend)
4. Iterate based on user feedback

---

**Ready to implement? Let me know which sprint to start with!**
