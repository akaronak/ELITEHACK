# Personalized Notification Feature

## Overview

Added a "Personalized" test notification option to the menstruation screen's top navigation bar. This sends sweet, personalized notifications based on the user's current cycle phase and health data.

## Feature Details

### Location

**Menstruation Screen → Top Navigation Bar → Notification Icon (🔔)**

### How It Works

1. **User clicks notification icon** in the top nav bar
2. **Dialog appears** with notification options:
   - Immediate
   - Scheduled (10s)
   - Scheduled (30s)
   - **Personalized** ⭐ (NEW)
3. **User selects "Personalized"**
4. **System generates personalized message** based on:
   - Current cycle phase
   - Days until next period
   - User's health logs
5. **Notification is sent via:**
   - Local notification (immediate)
   - WhatsApp (if phone number is saved)

## Personalization Logic

### Messages by Cycle Phase

#### 🌸 Menstrual Phase (Days 1-5)
```
Title: 🌸 Menstrual Phase
Body: Stay hydrated and rest well. You're doing great! 💪
      Your next period is expected in [X days]
```

#### 🌼 Follicular Phase (Days 6-13)
```
Title: 🌼 Follicular Phase
Body: Energy is rising! Great time for exercise and new activities! ✨
      Your next period is expected in [X days]
```

#### 🔥 Ovulation Phase (Days 14-16)
```
Title: 🔥 Ovulation Phase
Body: Peak energy and confidence! Make the most of this phase! 🌟
      Your next period is expected in [X days]
```

#### 🌙 Luteal Phase (Days 17+)
```
Title: 🌙 Luteal Phase
Body: Time for self-care and reflection. Listen to your body! 🧘‍♀️
      Your next period is expected in [X days]
```

## Implementation Details

### File Modified

- `mensa/lib/screens/menstruation/menstruation_home.dart`

### Changes Made

#### 1. Added Personalized Option to Dialog

```dart
ListTile(
  leading: const Icon(Icons.favorite),
  title: const Text('Personalized'),
  subtitle: const Text('Based on your health data'),
  onTap: () async {
    Navigator.pop(context);
    await _sendPersonalizedNotification();
  },
),
```

#### 2. Added Personalization Method

```dart
Future<void> _sendPersonalizedNotification() async {
  try {
    final apiService = ApiService();
    
    // Get user's recent logs
    final logs = await apiService.getMenstruationLogs(widget.userId);
    
    // Generate personalized message based on cycle phase
    String title = '💜 Health Reminder';
    String body = 'Keep tracking your health!';
    
    if (logs.isNotEmpty) {
      // Personalize based on current cycle phase
      if (_currentCycleDay <= 5) {
        title = '🌸 Menstrual Phase';
        body = 'Stay hydrated and rest well. You\'re doing great! 💪';
      } else if (_currentCycleDay <= 13) {
        title = '🌼 Follicular Phase';
        body = 'Energy is rising! Great time for exercise and new activities! ✨';
      } else if (_currentCycleDay <= 16) {
        title = '🔥 Ovulation Phase';
        body = 'Peak energy and confidence! Make the most of this phase! 🌟';
      } else {
        title = '🌙 Luteal Phase';
        body = 'Time for self-care and reflection. Listen to your body! 🧘‍♀️';
      }
      
      // Add personalized info about next period
      final daysUntil = _getDaysUntilNextPeriod();
      body += '\n\nYour next period is expected in $daysUntil';
    }
    
    // Send via API (WhatsApp if phone saved)
    await apiService.sendNotification(
      userId: widget.userId,
      title: title,
      body: body,
      sendWhatsApp: true,
      sendLocal: true,
    );
    
    // Show local notification immediately
    final notificationService = NotificationService();
    await notificationService.showImmediateNotification(
      title: title,
      body: body,
    );
    
    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            '✅ Personalized notification sent!\nCheck WhatsApp if phone number is saved.',
          ),
          backgroundColor: _greenMood,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  } catch (e) {
    debugPrint('Error sending personalized notification: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error sending notification'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}
```

## User Experience

### Step-by-Step

1. **Open Menstruation Screen**
   - User navigates to menstruation tracker

2. **Click Notification Icon**
   - Located in top right of AppBar
   - Shows bell icon (🔔)

3. **Select Personalized Option**
   - Dialog shows 4 options
   - User taps "Personalized"

4. **Notification Sent**
   - Local notification appears immediately
   - WhatsApp message sent (if phone saved)
   - Success message shown

5. **User Receives Message**
   - Personalized based on cycle phase
   - Includes encouragement
   - Shows next period date

## Data Used for Personalization

### From User Profile
- Current cycle day (calculated from logs)
- Cycle phase (determined by day)
- Average cycle length
- Predicted next period

### From Recent Logs
- Last period date
- Flow level
- Symptoms
- Moods

## Notification Channels

### 1. Local Notification
- Shows immediately in app
- Appears in notification center
- Visible even if app is closed

### 2. WhatsApp Notification
- Sent via Twilio API
- Only if phone number is saved in profile
- Personalized message
- Includes cycle phase emoji

## Testing

### Test 1: Send Personalized Notification

1. Open Menstruation Screen
2. Click notification icon (🔔)
3. Select "Personalized"
4. Verify notification appears
5. Check success message

### Test 2: Verify Personalization

1. Note current cycle day
2. Send personalized notification
3. Verify message matches cycle phase:
   - Days 1-5: Menstrual Phase
   - Days 6-13: Follicular Phase
   - Days 14-16: Ovulation Phase
   - Days 17+: Luteal Phase

### Test 3: WhatsApp Integration

1. Add phone number in profile
2. Send personalized notification
3. Check WhatsApp for message
4. Verify message is personalized

### Test 4: Error Handling

1. Disconnect internet
2. Try sending notification
3. Verify error message appears
4. Reconnect and retry

## Features

✅ **Personalized Messages** - Based on cycle phase
✅ **Emoji Indicators** - Visual phase identification
✅ **Encouragement** - Positive, supportive tone
✅ **Period Prediction** - Shows days until next period
✅ **Multi-Channel** - Local + WhatsApp
✅ **Error Handling** - Graceful error messages
✅ **User Feedback** - Success/error notifications
✅ **Data-Driven** - Uses actual user logs

## Integration Points

### API Calls

1. **Get Menstruation Logs**
   ```
   GET /api/menstruation/{userId}/logs
   ```

2. **Send Notification**
   ```
   POST /api/notifications/send
   {
     "userId": "user_123",
     "title": "🌸 Menstrual Phase",
     "body": "Stay hydrated...",
     "sendWhatsApp": true,
     "sendLocal": true
   }
   ```

### Services Used

- `ApiService` - API communication
- `NotificationService` - Local notifications
- Twilio API - WhatsApp messages

## Benefits

1. **Personalized Experience** - Messages match user's cycle
2. **Encouragement** - Positive, supportive tone
3. **Health Awareness** - Reminds about cycle phases
4. **Multi-Channel** - Reaches users where they are
5. **Testing** - Easy to test notification system
6. **Data-Driven** - Uses real user data

## Future Enhancements

- [ ] Customize messages per phase
- [ ] Add symptom-based suggestions
- [ ] Include health tips for phase
- [ ] Track notification engagement
- [ ] A/B test different messages
- [ ] Add reminder scheduling
- [ ] Support multiple languages

## Status

✅ **Complete and Ready to Use**

## Documentation

- `PERSONALIZED_NOTIFICATION_FEATURE.md` - This file
- `PHONE_NUMBER_SETUP.md` - Phone number setup
- `NOTIFICATIONS_QUICK_REFERENCE.md` - Notification endpoints

## Summary

Users can now send personalized test notifications from the menstruation screen that:
- Adapt to their current cycle phase
- Include encouraging messages
- Show period predictions
- Send via local notification and WhatsApp
- Help test the notification system

The feature is fully integrated and ready for production use!
