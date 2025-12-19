# Notifications Quick Reference

## 🚀 Quick Start

### 1. Configuration
```env
# .env file
TWILIO_ACCOUNT_SID=AC3b9d3421a05a0e4099e58197fc14f7e2ab4f82477c331da627d01fb1dc075a73
TWILIO_AUTH_TOKEN=your_auth_token_here
TWILIO_WHATSAPP_NUMBER=+14155238886
```

### 2. Check Status
```bash
curl http://localhost:3000/api/notifications/status
```

### 3. Send Notification
```dart
// In Flutter
await apiService.sendStreakReminder(
  userId: 'user123',
  tracker: 'menstruation',
);
```

## 📱 All Notification Methods

### Backend Routes

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/notifications/send` | POST | Send custom notification |
| `/api/notifications/bulk` | POST | Send to multiple users |
| `/api/notifications/streak-reminder` | POST | Streak milestone reminder |
| `/api/notifications/period-reminder` | POST | Period prediction reminder |
| `/api/notifications/health-tip` | POST | Personalized health tip |
| `/api/notifications/appointment-reminder` | POST | Appointment reminder |
| `/api/notifications/voucher` | POST | Voucher available notification |
| `/api/notifications/motivation` | POST | Motivation message |
| `/api/notifications/daily-checkin` | POST | Daily check-in reminder |
| `/api/notifications/status` | GET | Service status |

### Frontend Methods

```dart
// Streak Reminder
await apiService.sendStreakReminder(
  userId: 'user123',
  tracker: 'menstruation', // or 'pregnancy', 'menopause'
);

// Period Reminder
await apiService.sendPeriodReminder(
  userId: 'user123',
  daysUntil: 3,
);

// Health Tip (personalized based on logs)
await apiService.sendHealthTip(
  userId: 'user123',
  tracker: 'menstruation',
);

// Motivation Message (based on points)
await apiService.sendMotivationMessage(userId: 'user123');

// Daily Check-in Reminder
await apiService.sendDailyCheckInReminder(
  userId: 'user123',
  tracker: 'menstruation',
);

// Appointment Reminder
await apiService.sendAppointmentReminder(
  userId: 'user123',
  appointmentTitle: 'Doctor Checkup',
  appointmentTime: '2:00 PM',
  minutesBefore: 30,
);

// Voucher Notification
await apiService.sendVoucherNotification(
  userId: 'user123',
  voucherName: 'Wellness Kit',
  points: 150,
);

// Custom Notification
await apiService.sendNotification(
  userId: 'user123',
  phoneNumber: '+1234567890',
  fcmToken: 'fcm_token_here',
  title: 'Custom Title',
  body: 'Custom message body',
  sendFCM: true,
  sendWhatsApp: true,
  sendLocal: true,
);

// Check Status
await apiService.getNotificationStatus();
```

## 📊 Message Examples

### Streak Reminders
- **Day 1**: "Hey Sarah! 🌸 You just started your streak! Keep going, you've got this!"
- **Day 3**: "Sarah! 🔥 You're on a 3-day streak! You're doing amazing!"
- **Day 7**: "Wow Sarah! 🎉 A whole week of logging! You're incredible!"
- **Day 30**: "Sarah! 👑 30 days of dedication! You're absolutely crushing it!"

### Period Reminders
- **Today**: "Sarah! 🌸 Your period is here! Take it easy today, you deserve self-care. 💕"
- **Tomorrow**: "Sarah! 🌺 Your period is coming tomorrow! Get some rest and stay hydrated. 💧"
- **3 Days**: "Sarah! 🌸 Your period is coming in 3 days! Start preparing and taking extra care. 💕"

### Health Tips (Based on Symptoms)
- **Cramps**: "Sarah! 💕 We noticed you often have cramps. Try gentle yoga or heating pads. You deserve comfort! 🧘‍♀️"
- **Fatigue**: "Sarah! 😴 Feeling tired? Make sure you're getting enough iron-rich foods and rest. 💗"
- **Anxiety**: "Sarah! 🧘‍♀️ We noticed you feel anxious sometimes. Try meditation or deep breathing. You've got this! 💕"

### Motivation Messages
- "Sarah! 🌟 You've earned 250 points! You're crushing your health goals! Keep going! 💪"
- "Sarah! 💎 Amazing! You have 500 points! You're an inspiration! 🎉"

### Daily Check-in
- "Sarah! 🌸 Don't forget to log your cycle today! It only takes a minute! 📊"
- "Sarah! 🌺 How are you feeling today? Log your mood and symptoms! 💕"

## 🔄 Notification Channels

All notifications are sent via **3 channels**:

1. **WhatsApp** (Twilio) - Direct message
2. **FCM** - Push notification
3. **Local** - Device notification

You can control which channels to use:

```dart
await apiService.sendNotification(
  userId: 'user123',
  phoneNumber: '+1234567890',
  fcmToken: 'fcm_token',
  title: 'Title',
  body: 'Body',
  sendFCM: true,        // Enable/disable FCM
  sendWhatsApp: true,   // Enable/disable WhatsApp
  sendLocal: true,      // Enable/disable Local
);
```

## 🎯 Common Use Cases

### Send Streak Reminder When Streak Reaches 7 Days
```javascript
// In backend (e.g., in streak.routes.js)
if (streak.current_streak === 7) {
  await unifiedNotificationService.sendStreakReminder(
    { userId, phoneNumber, fcmToken, name },
    'menstruation',
    7
  );
}
```

### Send Daily Check-in at 9 AM
```javascript
// Use a scheduler (e.g., node-cron)
const cron = require('node-cron');

cron.schedule('0 9 * * *', async () => {
  const users = db.get('users').value();
  for (const user of users) {
    await unifiedNotificationService.sendDailyCheckInReminder(
      user,
      'menstruation'
    );
  }
});
```

### Send Health Tip Based on Symptoms
```javascript
// When user logs symptoms
const logs = db.get('menstruationLogs')
  .filter({ user_id: userId })
  .take(10)
  .value();

const hasFrequentCramps = logs.filter(log => 
  log.symptoms?.includes('Cramps')
).length > 5;

if (hasFrequentCramps) {
  await unifiedNotificationService.sendHealthTip(
    { userId, phoneNumber, fcmToken, name },
    'menstruation'
  );
}
```

### Send Motivation When Points Reach Milestone
```javascript
// When user earns points
const wallet = db.get('userWallets').find({ user_id: userId }).value();

if (wallet.total_points === 100 || wallet.total_points === 250 || wallet.total_points === 500) {
  await unifiedNotificationService.sendMotivationMessage(
    { userId, phoneNumber, fcmToken, name }
  );
}
```

## 🔐 Database Requirements

Users must have these fields:

```javascript
{
  user_id: "user123",
  name: "Sarah",
  phone_number: "+1234567890",  // With country code
  fcm_token: "fcm_token_here",
  // ... other fields
}
```

## ✅ Testing Checklist

- [ ] `.env` has all Twilio credentials
- [ ] Server restarted after `.env` update
- [ ] `/api/notifications/status` shows Twilio configured
- [ ] Test user has phone_number with country code
- [ ] Test notification sent via WhatsApp
- [ ] Test notification sent via FCM
- [ ] Test notification sent via Local
- [ ] Message is personalized with user's name
- [ ] Message includes relevant emojis
- [ ] Message is sweet and encouraging

## 🚨 Troubleshooting

| Issue | Solution |
|-------|----------|
| "Twilio not configured" | Check `.env` has all 3 variables, restart server |
| "Message failed to send" | Verify phone number format (+country_code_number) |
| "Auth Token invalid" | Get new token from Twilio Console, update `.env` |
| "User not found" | Verify userId exists in database |
| "Phone number invalid" | Ensure format is +country_code_number (e.g., +1234567890) |
| "No message received" | Check if number is in WhatsApp Sandbox |

## 📈 Metrics to Track

- Message delivery rate
- Message open rate
- User engagement after notification
- Streak continuation rate
- Log completion rate
- User satisfaction

## 🎯 Best Practices

1. **Personalize**: Always use user's name
2. **Timing**: Send at appropriate times
3. **Frequency**: Don't overwhelm users
4. **Relevance**: Only send relevant notifications
5. **Opt-out**: Allow users to disable
6. **Testing**: Test all variations
7. **Emojis**: Use for warmth and engagement
8. **Variety**: Randomize messages

---

**Last Updated**: December 20, 2025
**Status**: ✅ Ready to Use
