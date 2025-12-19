# Gemini AI Personalized Notifications

## Overview

Implemented AI-powered personalized notifications using Google Gemini that generate unique, non-repetitive messages based on user's actual health logs and data.

## How It Works

### 1. User Sends Personalized Notification

- Opens Menstruation Screen
- Clicks notification icon (🔔)
- Selects "Personalized"

### 2. System Collects User Data

- Recent menstruation logs (last 5)
- Moods from logs
- Symptoms from logs
- Flow levels
- Current cycle day
- Wallet points
- Streak days
- User name

### 3. Gemini AI Generates Message

- Analyzes user's actual health data
- Generates unique, personalized message
- References specific moods/symptoms
- Includes encouragement
- Adds relevant emoji

### 4. Notification Sent

- Local notification (immediate)
- WhatsApp message (if phone saved)
- User receives personalized message

## Example Messages

### Based on Actual Logs

**If user logged: Cramps, Fatigue, Sad mood**
```
Title: 🌸 Take It Easy Today
Body: I see you're dealing with cramps and fatigue. Be gentle with yourself - rest is productive too. You've got this! 💪
```

**If user logged: High energy, Happy mood, Exercise**
```
Title: 🌼 You're Glowing!
Body: Your energy is amazing today! Keep riding this wave - you've earned 50 points already! ✨
```

**If user has 10-day streak**
```
Title: 🔥 Streak Champion!
Body: 10 days of consistency! You're building amazing health habits. Your dedication is inspiring! 🌟
```

## Features

✅ **AI-Generated** - Uses Gemini 2.5 Flash
✅ **Non-Repetitive** - Unique message each time
✅ **Data-Driven** - Based on actual user logs
✅ **Personalized** - References specific moods/symptoms
✅ **Encouraging** - Supportive, positive tone
✅ **Contextual** - Considers cycle day, streak, points
✅ **Fallback** - Default messages if AI fails

## Implementation Details

### Files Created

1. **server/src/services/geminiNotificationService.js**
   - Generates personalized notifications
   - Collects user data
   - Calls Gemini API
   - Provides fallback messages

2. **server/src/routes/notifications.routes.js** (updated)
   - New endpoint: `/api/notifications/generate-personalized`
   - Handles AI notification generation

3. **mensa/lib/services/api_service.dart** (updated)
   - New method: `generatePersonalizedNotification()`
   - Calls backend endpoint

4. **mensa/lib/screens/menstruation/menstruation_home.dart** (updated)
   - Updated `_sendPersonalizedNotification()`
   - Calls Gemini service instead of hardcoded messages

### API Endpoint

**POST** `/api/notifications/generate-personalized`

**Request:**
```json
{
  "userId": "user_123",
  "tracker": "menstruation",
  "cycleDay": 3
}
```

**Response:**
```json
{
  "success": true,
  "title": "🌸 Take It Easy Today",
  "body": "I see you're dealing with cramps and fatigue..."
}
```

## Gemini Prompt

The system sends this context to Gemini:

```
User Context:
- Name: Jane
- Current Day: 3
- Streak: 10 days
- Wallet Points: 250
- Recent Moods: Sad, Tired, Calm
- Recent Symptoms: Cramps, Bloating
- Recent Flow Levels: Heavy, Medium
- Last Log: 2025-12-20

Requirements:
1. Generate UNIQUE, NON-REPETITIVE notification
2. Reference specific moods or symptoms
3. Be encouraging and supportive
4. Include an emoji
5. Keep it concise (1-2 sentences)
6. Avoid generic messages
7. Personalize based on streak and points
```

## Data Collection

### From Logs

- **Moods**: Happy, Sad, Anxious, Irritable, Calm, Energetic, Tired
- **Symptoms**: Cramps, Headache, Bloating, Fatigue, Back Pain, etc.
- **Flow Levels**: Light, Medium, Heavy, Spotting, None

### From Profile

- User name
- Current cycle day
- Cycle phase

### From Wallet

- Total points earned

### From Streak

- Current streak days
- Streak category

## Fallback Messages

If Gemini fails, system uses default messages based on cycle phase:

**Menstrual Phase (Days 1-5)**
```
Title: 🌸 Menstrual Phase
Body: Take care of yourself today. Rest, hydrate, and be kind to your body.
```

**Follicular Phase (Days 6-13)**
```
Title: 🌼 Follicular Phase
Body: Energy is rising! Great time for new activities and exercise.
```

**Ovulation Phase (Days 14-16)**
```
Title: 🔥 Ovulation Phase
Body: Peak energy and confidence! Make the most of this phase.
```

**Luteal Phase (Days 17+)**
```
Title: 🌙 Luteal Phase
Body: Time for self-care and reflection. Listen to your body.
```

## Configuration

### Gemini API Key

Uses: `AGORA_LLM_API_KEY` or `GEMINI_API_KEY` from `.env`

Already configured in your `.env` file:
```
AGORA_LLM_API_KEY=AIzaSyACXZ5XpLB-eTMARR-uZtYZevRP87Wtxzk
```

### Model

Uses: `gemini-2.5-flash` (fast, efficient)

## Testing

### Test 1: Send Personalized Notification

1. Open Menstruation Screen
2. Click notification icon (🔔)
3. Select "Personalized"
4. Check logs for generated message

### Test 2: Verify Uniqueness

Send multiple notifications and verify each message is different.

### Test 3: Check Data Usage

Verify message references:
- User's actual moods
- User's actual symptoms
- User's streak
- User's points

### Test 4: API Test

```bash
curl -X POST http://localhost:3000/api/notifications/generate-personalized \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "user_123",
    "tracker": "menstruation",
    "cycleDay": 3
  }'
```

## Logs

### Flutter Logs

```
📨 Sending notification:
  userId: user_123
  phoneNumber: +919811226924
  title: 🌸 Take It Easy Today
  body: I see you're dealing with cramps...
  sendWhatsApp: true

✅ Notification sent successfully
```

### Server Logs

```
📨 Notification request received:
  userId: user_123
  phoneNumber: +919811226924
  title: 🌸 Take It Easy Today
  ...

📱 Sending WhatsApp message via Twilio...
✅ WhatsApp message sent successfully: SM...
```

## Benefits

✅ **Unique Messages** - Never repetitive
✅ **Personalized** - Based on actual data
✅ **Encouraging** - Supportive tone
✅ **Contextual** - Considers user's situation
✅ **Engaging** - More interesting than templates
✅ **Data-Driven** - Uses real health information
✅ **Scalable** - Works for all trackers

## Future Enhancements

- [ ] Generate different message types (motivation, health tips, reminders)
- [ ] Learn from user feedback
- [ ] Customize tone/style per user
- [ ] Multi-language support
- [ ] Scheduled notifications with AI
- [ ] Predictive health insights

## Troubleshooting

### Issue: Generic message instead of personalized

**Cause:** Gemini API error or no logs

**Solution:**
1. Check Gemini API key in `.env`
2. Verify user has logs
3. Check server logs for errors

### Issue: Same message repeated

**Cause:** Caching or API issue

**Solution:**
1. Restart server
2. Clear cache
3. Check Gemini API status

### Issue: Message doesn't reference user data

**Cause:** Data not being collected

**Solution:**
1. Verify logs exist in database
2. Check data collection in service
3. Review Gemini prompt

## Status

✅ **Complete and Ready to Use**

Personalized AI notifications are now live!

## Related Documentation

- `PERSONALIZED_NOTIFICATION_FEATURE.md` - Original feature
- `WHATSAPP_NOTIFICATION_FIXED.md` - WhatsApp setup
- `PHONE_NUMBER_SETUP.md` - Phone number setup

---

**AI-powered personalized notifications are now live!** 🤖✨
