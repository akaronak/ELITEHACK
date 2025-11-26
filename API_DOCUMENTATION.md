# Mensa Pregnancy Tracker - API Documentation

## Base URL
```
http://localhost:3000/api
```

## Authentication
Currently using userId passed from main app. In production, implement JWT or OAuth2.

---

## 📋 User Profile Endpoints

### Get Pregnancy Profile
Retrieve user's pregnancy profile information.

**Endpoint:** `GET /user/:userId/pregnancy`

**Parameters:**
- `userId` (path) - User identifier

**Response:**
```json
{
  "user_id": "demo_user_123",
  "lmp_date": "2024-09-01T00:00:00.000Z",
  "due_date": "2025-06-08T00:00:00.000Z",
  "allergies": ["lactose", "peanuts"],
  "preferences": ["vegetarian"],
  "created_at": "2024-11-01T10:00:00.000Z",
  "updated_at": "2024-11-20T15:30:00.000Z"
}
```

**Status Codes:**
- `200` - Success
- `404` - Profile not found
- `500` - Server error

---

### Create/Update Pregnancy Profile
Create a new profile or update existing one.

**Endpoint:** `POST /user/:userId/pregnancy`

**Parameters:**
- `userId` (path) - User identifier

**Request Body:**
```json
{
  "lmp_date": "2024-09-01T00:00:00.000Z",
  "due_date": "2025-06-08T00:00:00.000Z",
  "allergies": ["lactose", "peanuts"],
  "preferences": ["vegetarian"]
}
```

**Response:**
```json
{
  "user_id": "demo_user_123",
  "lmp_date": "2024-09-01T00:00:00.000Z",
  "due_date": "2025-06-08T00:00:00.000Z",
  "allergies": ["lactose", "peanuts"],
  "preferences": ["vegetarian"],
  "created_at": "2024-11-01T10:00:00.000Z",
  "updated_at": "2024-11-26T12:00:00.000Z"
}
```

**Status Codes:**
- `200` - Updated successfully
- `201` - Created successfully
- `500` - Server error

---

## 📝 Daily Logs Endpoints

### Get All Daily Logs
Retrieve all daily health logs for a user.

**Endpoint:** `GET /logs/:userId`

**Parameters:**
- `userId` (path) - User identifier

**Response:**
```json
[
  {
    "log_id": "log_1234567890_abc123",
    "user_id": "demo_user_123",
    "date": "2024-11-26T00:00:00.000Z",
    "mood": "Happy",
    "symptoms": ["Nausea", "Fatigue"],
    "water": 8,
    "weight": 145.5
  }
]
```

**Status Codes:**
- `200` - Success
- `500` - Server error

---

### Add Daily Log
Create a new daily health log entry.

**Endpoint:** `POST /logs/:userId`

**Parameters:**
- `userId` (path) - User identifier

**Request Body:**
```json
{
  "date": "2024-11-26T00:00:00.000Z",
  "mood": "Happy",
  "symptoms": ["Nausea", "Fatigue"],
  "water": 8,
  "weight": 145.5
}
```

**Response:**
```json
{
  "log_id": "log_1234567890_abc123",
  "user_id": "demo_user_123",
  "date": "2024-11-26T00:00:00.000Z",
  "mood": "Happy",
  "symptoms": ["Nausea", "Fatigue"],
  "water": 8,
  "weight": 145.5
}
```

**Status Codes:**
- `201` - Created successfully
- `500` - Server error

---

## 🤖 AI Services Endpoints

### Symptom Analysis
Analyze symptoms and classify severity.

**Endpoint:** `POST /ai/symptom-analysis`

**Request Body:**
```json
{
  "userId": "demo_user_123",
  "symptoms": ["nausea", "fatigue", "headache"],
  "week": 8
}
```

**Response:**
```json
{
  "classification": "common",
  "matchedSymptoms": ["nausea", "fatigue"],
  "guidance": "✓ COMMON: nausea, fatigue are typical symptoms for week 8 of pregnancy. Stay hydrated, rest when needed, and maintain a healthy diet. If symptoms become severe, contact your healthcare provider.",
  "disclaimer": "⚕️ DISCLAIMER: This analysis is for informational purposes only and does not replace professional medical advice. Always consult your healthcare provider for medical concerns.",
  "seekDoctor": false
}
```

**Classification Types:**
- `common` - Normal pregnancy symptoms
- `warning` - Symptoms to monitor
- `critical` - Requires immediate medical attention
- `unmatched` - Not in database
- `unknown` - Week data unavailable

**Status Codes:**
- `200` - Success
- `400` - Missing required fields
- `500` - Server error

---

### Chat with AI Assistant
Send message to conversational AI assistant.

**Endpoint:** `POST /ai/chat`

**Request Body:**
```json
{
  "userId": "demo_user_123",
  "message": "I'm feeling stressed today",
  "context": {
    "week": 12
  }
}
```

**Response:**
```json
{
  "response": "I'm here for you, Mensa. 💕 Feeling stressed during pregnancy is completely normal. Here are some things that might help:\n\n• Try our breathing exercise - it can help calm your mind\n• Take a short walk in fresh air\n• Talk to someone you trust\n• Rest when you can\n\nRemember, you're doing an amazing job. If anxiety persists, please talk to your healthcare provider about it."
}
```

**Status Codes:**
- `200` - Success
- `400` - Missing required fields
- `500` - Server error

---

## 🥗 Nutrition Endpoints

### Get Nutrition Recommendations
Get personalized food recommendations based on trimester and allergies.

**Endpoint:** `GET /nutrition/:userId/:week`

**Parameters:**
- `userId` (path) - User identifier
- `week` (path) - Current pregnancy week

**Response:**
```json
{
  "trimester": 1,
  "week": 8,
  "advice": "First Trimester: Focus on folic acid (400-800 mcg daily), iron, and protein. Eat small, frequent meals to manage nausea. Stay hydrated.",
  "keyNutrients": ["Folic Acid", "Iron", "Protein", "Vitamin B12", "Vitamin D"],
  "foods": [
    {
      "name": "Milk",
      "nutrients": ["calcium", "protein", "vitamin D"],
      "avoid_if_allergic": ["lactose", "dairy"],
      "trimester": [1, 2, 3],
      "isSafe": false,
      "allergyWarning": "⚠️ Contains: lactose"
    },
    {
      "name": "Spinach",
      "nutrients": ["iron", "folate", "fiber"],
      "avoid_if_allergic": [],
      "trimester": [1, 2, 3],
      "isSafe": true,
      "allergyWarning": null
    }
  ]
}
```

**Status Codes:**
- `200` - Success
- `404` - User profile not found
- `500` - Server error

---

## ✅ Checklist Endpoints

### Get Checklist for Week
Retrieve checklist tasks for a specific week.

**Endpoint:** `GET /checklist/:userId/:week`

**Parameters:**
- `userId` (path) - User identifier
- `week` (path) - Pregnancy week number

**Response:**
```json
[
  {
    "user_id": "demo_user_123",
    "week": 8,
    "task": "Schedule first prenatal appointment",
    "completed": false
  },
  {
    "user_id": "demo_user_123",
    "week": 8,
    "task": "Start taking prenatal vitamins",
    "completed": true
  }
]
```

**Status Codes:**
- `200` - Success
- `500` - Server error

---

### Update Checklist Task
Mark a task as complete or incomplete.

**Endpoint:** `POST /checklist/:userId/:week`

**Parameters:**
- `userId` (path) - User identifier
- `week` (path) - Pregnancy week number

**Request Body:**
```json
{
  "task": "Schedule first prenatal appointment",
  "completed": true
}
```

**Response:**
```json
{
  "success": true
}
```

**Status Codes:**
- `200` - Success
- `500` - Server error

---

## 🧘 Breathing Exercise Endpoints

### Get Breathing Game Stats
Retrieve user's breathing exercise statistics.

**Endpoint:** `GET /breathing/game/:userId`

**Parameters:**
- `userId` (path) - User identifier

**Response:**
```json
{
  "totalSessions": 15,
  "totalDuration": 450,
  "completedSessions": 12,
  "lastSession": {
    "duration": 30,
    "completed": true,
    "timestamp": "2024-11-26T10:30:00.000Z"
  }
}
```

**Status Codes:**
- `200` - Success
- `500` - Server error

---

### Update Breathing Game Session
Log a completed breathing exercise session.

**Endpoint:** `POST /breathing/game/:userId`

**Parameters:**
- `userId` (path) - User identifier

**Request Body:**
```json
{
  "duration": 30,
  "completed": true,
  "timestamp": "2024-11-26T10:30:00.000Z"
}
```

**Response:**
```json
{
  "success": true
}
```

**Status Codes:**
- `200` - Success
- `500` - Server error

---

## 🏥 Health Check

### Server Health Check
Verify server is running.

**Endpoint:** `GET /health`

**Response:**
```json
{
  "status": "OK",
  "message": "Mensa Pregnancy Tracker API is running"
}
```

**Status Codes:**
- `200` - Server is healthy

---

## 🔐 Error Responses

All endpoints may return these error responses:

### 400 Bad Request
```json
{
  "error": "Missing required fields"
}
```

### 404 Not Found
```json
{
  "error": "Profile not found"
}
```

### 500 Internal Server Error
```json
{
  "error": "Something went wrong!"
}
```

---

## 📊 Rate Limiting

Currently no rate limiting implemented. In production, implement:
- 100 requests per minute per user
- 1000 requests per hour per user

---

## 🔄 Data Storage

**Current Implementation:** In-memory storage (Map objects)
- Data persists only while server is running
- Suitable for development and testing

**Production Recommendation:** MongoDB
- Persistent storage
- Scalable
- Backup capabilities

---

## 🚀 Example Usage

### Using cURL

```bash
# Get pregnancy profile
curl http://localhost:3000/api/user/demo_user_123/pregnancy

# Add daily log
curl -X POST http://localhost:3000/api/logs/demo_user_123 \
  -H "Content-Type: application/json" \
  -d '{
    "date": "2024-11-26T00:00:00.000Z",
    "mood": "Happy",
    "symptoms": ["Nausea"],
    "water": 8,
    "weight": 145.5
  }'

# Analyze symptoms
curl -X POST http://localhost:3000/api/ai/symptom-analysis \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "demo_user_123",
    "symptoms": ["nausea", "fatigue"],
    "week": 8
  }'
```

### Using Flutter (http package)

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

// Get pregnancy profile
final response = await http.get(
  Uri.parse('http://localhost:3000/api/user/demo_user_123/pregnancy'),
);

if (response.statusCode == 200) {
  final data = jsonDecode(response.body);
  print(data);
}

// Add daily log
final response = await http.post(
  Uri.parse('http://localhost:3000/api/logs/demo_user_123'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'date': DateTime.now().toIso8601String(),
    'mood': 'Happy',
    'symptoms': ['Nausea'],
    'water': 8,
    'weight': 145.5,
  }),
);
```

---

## 📝 Notes

- All dates should be in ISO 8601 format
- User IDs are strings
- Week numbers range from 1-40
- Trimester values: 1, 2, or 3
- All responses are JSON formatted
- CORS is enabled for all origins (configure for production)

---

**Last Updated:** November 26, 2024
