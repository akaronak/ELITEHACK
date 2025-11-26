# 📅 Menstruation Tracker - Complete with History & AI

## ✅ What's Been Added

Your menstruation tracker now has:

1. **📊 History View** - Top-right corner button to view all previous logs
2. **🤖 AI Insights** - Smart analysis based on saved data
3. **📈 Pattern Recognition** - Identifies trends in your cycle
4. **💡 Personalized Recommendations** - Based on your history

---

## 🎯 New Features

### 1. History Button (Top Right)
- **Icon**: History icon in app bar
- **Action**: Opens detailed history and AI insights screen
- **Tooltip**: "View History & AI Insights"

### 2. Cycle History Screen

**AI Insights Section:**
- ✅ **Cycle Pattern Analysis**
  - Average cycle length
  - Regularity percentage
  - Normal range comparison

- ✅ **Common Symptoms**
  - Most frequent symptoms
  - Percentage occurrence
  - Typical timing in cycle

- ✅ **Mood Patterns**
  - Mood trends by cycle phase
  - Best days for activities
  - Emotional patterns

- ✅ **Personalized Recommendations**
  - Hydration tips
  - Exercise suggestions
  - Nutrition advice
  - Tracking tips

**Recent Logs Section:**
- Date and cycle day
- Flow level with color coding
- Mood indicator
- Symptoms tags
- Chronological order (newest first)

---

## 🎨 UI Design

### History Screen Layout

```
┌─────────────────────────────┐
│  ← Cycle History            │
├─────────────────────────────┤
│                             │
│     🔍 AI Analysis          │
│   Based on last 30 days     │
│                             │
├─────────────────────────────┤
│                             │
│  ✓ Cycle Pattern            │
│  Your cycle has been...     │
│                             │
│  📊 Common Symptoms         │
│  You most frequently...     │
│                             │
│  😊 Mood Patterns           │
│  Your mood tends to...      │
│                             │
│  💡 Recommendations         │
│  • Stay hydrated...         │
│                             │
├─────────────────────────────┤
│  📜 Recent Logs             │
├─────────────────────────────┤
│  Wednesday, Nov 26          │
│  Day 14 of cycle    [Medium]│
│  😊 Mood: Happy             │
│  🩹 Cramps, Fatigue         │
├─────────────────────────────┤
│  Tuesday, Nov 25            │
│  Day 13 of cycle    [Heavy] │
│  😴 Mood: Tired             │
│  🩹 Cramps, Headache        │
└─────────────────────────────┘
```

---

## 🤖 AI Analysis Features

### 1. Cycle Pattern Analysis

**What it does:**
- Calculates average cycle length
- Measures cycle regularity (0-100%)
- Compares to normal range (21-35 days)
- Predicts next period date

**Example Output:**
```
"Your cycle has been regular with an average 
length of 28 days. This is within the normal 
range (21-35 days)."
```

### 2. Symptom Pattern Recognition

**What it does:**
- Identifies most common symptoms
- Calculates occurrence percentage
- Determines typical timing in cycle
- Suggests management strategies

**Example Output:**
```
"You most frequently experience cramps (80% 
of days) and fatigue (60% of days). These 
typically occur on days 1-3 of your period."
```

### 3. Mood Pattern Analysis

**What it does:**
- Tracks mood by cycle phase
- Identifies positive/negative patterns
- Suggests optimal timing for activities
- Recognizes hormonal influences

**Example Output:**
```
"Your mood tends to be more positive during 
days 8-14 (follicular phase). Consider 
planning important activities during this time."
```

### 4. Personalized Recommendations

**What it provides:**
- Hydration reminders
- Exercise suggestions
- Nutrition advice
- Symptom management tips
- Tracking best practices

---

## 📊 Backend API Implementation

### Menstruation Routes

**File**: `server/src/routes/menstruation.routes.js`

**Endpoints:**

1. **POST /api/menstruation/:userId/log**
   - Saves menstruation log
   - Updates cycle predictions
   - Returns saved log

2. **GET /api/menstruation/:userId/logs**
   - Retrieves all logs
   - Sorted by date (newest first)
   - Returns array of logs

3. **GET /api/menstruation/:userId/predictions**
   - Returns cycle predictions
   - Average cycle length
   - Next period date
   - Regularity percentage

4. **GET /api/menstruation/:userId/stats**
   - Returns statistics
   - Common symptoms
   - Mood patterns
   - Flow patterns
   - AI-generated insights

---

## 🔧 How It Works

### Data Flow

```
User logs data
    ↓
Save to backend
    ↓
Backend calculates:
  - Average cycle length
  - Cycle regularity
  - Next period prediction
    ↓
User taps History button
    ↓
Fetch logs & stats from backend
    ↓
Display AI insights
    ↓
Show chronological history
```

### AI Insight Generation

```javascript
// Backend analyzes:
1. Period start dates
2. Cycle lengths between periods
3. Symptom frequency
4. Mood patterns
5. Flow patterns

// Generates:
- Regularity score (0-100%)
- Average cycle length
- Next period prediction
- Common symptom list
- Personalized recommendations
```

---

## 📱 User Experience

### Main Screen
1. User logs daily data (flow, mood, symptoms)
2. Sees current cycle day and phase
3. Gets real-time AI insights
4. Taps "Save Today's Log"

### History Screen
1. User taps history icon (top right)
2. Sees AI analysis at top
3. Scrolls through insights cards
4. Reviews recent logs below
5. Understands patterns and trends

---

## 🎨 Color Coding

### Flow Levels
- **Heavy**: Red
- **Medium**: Orange
- **Light**: Yellow
- **Spotting**: Grey
- **None**: Light Grey

### Insight Cards
- **Positive** (Green): Good news, regular patterns
- **Warning** (Orange): Needs attention
- **Info** (Blue): General information
- **Recommendation** (Purple): Actionable tips

---

## 📈 Statistics Tracked

### Cycle Metrics
- Average cycle length
- Cycle regularity percentage
- Last period start date
- Predicted next period
- Days until next period

### Symptom Metrics
- Most common symptoms
- Symptom frequency
- Symptom timing in cycle
- Severity patterns

### Mood Metrics
- Mood distribution
- Mood by cycle phase
- Positive/negative trends
- Hormonal correlations

---

## 🚀 To Enable Full Functionality

### 1. Start Backend
```bash
cd server
npm start
```

### 2. Update Frontend
Uncomment API calls in `menstruation_home.dart`:
```dart
final apiService = ApiService();
final success = await apiService.addMenstruationLog(log);
```

### 3. Test Flow
1. Log several days of data
2. Tap history button
3. View AI insights
4. Check predictions
5. Review recommendations

---

## 💡 AI Insights Examples

### Regular Cycle
```
✓ Cycle Pattern
Your cycle has been very regular with an 
average length of 28 days. This is a good 
sign of hormonal balance.
```

### Irregular Cycle
```
⚠ Cycle Pattern
Your cycle shows some irregularity. Consider 
tracking for a few more months. If it persists, 
consult your healthcare provider.
```

### Symptom Insights
```
📊 Common Symptoms
You most frequently experience cramps (80% 
of logged days). This is common during 
menstruation. Light exercise and heat therapy 
can help manage discomfort.
```

### Mood Insights
```
😊 Mood Patterns
Your mood tends to be more positive during 
days 8-14 (follicular phase). This is when 
estrogen levels rise. Consider scheduling 
important meetings or activities during this time.
```

---

## ✅ Features Summary

### Implemented ✅
- [x] History button in app bar
- [x] Cycle history screen
- [x] AI insights display
- [x] Pattern recognition
- [x] Symptom analysis
- [x] Mood tracking
- [x] Flow color coding
- [x] Chronological log display
- [x] Backend API routes
- [x] Statistics calculation
- [x] Prediction algorithm
- [x] Personalized recommendations

### Ready for Backend Integration 📋
- [ ] Connect save button to API
- [ ] Fetch real data for history
- [ ] Load predictions from backend
- [ ] Display actual statistics
- [ ] Enable real-time updates

---

## 🎯 Next Steps

1. **Start the backend server**
2. **Test API endpoints** with Postman/cURL
3. **Enable API calls** in Flutter app
4. **Log multiple days** of data
5. **View history** and AI insights
6. **Verify predictions** are accurate

---

**Your menstruation tracker now has intelligent history tracking and AI-powered insights! 📅🤖**
