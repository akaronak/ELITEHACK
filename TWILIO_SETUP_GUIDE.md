# Twilio WhatsApp Setup Guide

## ✅ Configuration Added

Your Twilio WhatsApp number has been added to `.env`:

```env
TWILIO_ACCOUNT_SID=AC3b9d3421a05a0e4099e58197fc14f7e2ab4f82477c331da627d01fb1dc075a73
TWILIO_WHATSAPP_NUMBER=+14155238886
```

## 🔧 Next Steps

### 1. Get Your Twilio Auth Token

You need to add your **Auth Token** to complete the setup:

1. Go to [Twilio Console](https://www.twilio.com/console)
2. Look for your **Auth Token** (it's hidden by default)
3. Click the eye icon to reveal it
4. Copy the token
5. Update `.env`:

```env
TWILIO_AUTH_TOKEN=your_auth_token_here
```

### 2. Verify WhatsApp Sandbox

Your Twilio WhatsApp number is ready. To start sending messages:

1. Go to [Twilio Console > Messaging > Try it out > Send an SMS](https://www.twilio.com/console/sms/try-it-out)
2. Or go to [WhatsApp Sandbox](https://www.twilio.com/console/sms/whatsapp/sandbox)
3. Follow the setup instructions to join the sandbox
4. Send a message to your Twilio number to activate

### 3. Test the Integration

Once configured, test with:

```bash
curl -X POST http://localhost:3000/api/notifications/send \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test_user",
    "phoneNumber": "+your_phone_number",
    "title": "Test Notification",
    "body": "Hello from Mensa! 🌸",
    "sendWhatsApp": true,
    "sendFCM": false,
    "sendLocal": false
  }'
```

### 4. Check Service Status

```bash
curl http://localhost:3000/api/notifications/status
```

Expected response:
```json
{
  "success": true,
  "status": {
    "fcm": {
      "available": true,
      "description": "Firebase Cloud Messaging"
    },
    "whatsapp": {
      "service": "Twilio",
      "configured": true,
      "hasAccountSid": true,
      "hasAuthToken": true,
      "hasPhoneNumber": true,
      "phoneNumber": "+14***"
    },
    "local": {
      "available": true,
      "description": "Local device notifications"
    }
  }
}
```

## 📱 WhatsApp Sandbox vs Production

### Sandbox (Current - Free)
- ✅ Free to use
- ✅ Good for testing
- ✅ Limited to approved numbers
- ⚠️ Messages expire after 24 hours
- ⚠️ Can only send to numbers that have messaged you first

**To use Sandbox**:
1. Go to [Twilio WhatsApp Sandbox](https://www.twilio.com/console/sms/whatsapp/sandbox)
2. Send "join [code]" to the sandbox number
3. You're ready to receive messages

### Production (When Ready)
- ✅ Full WhatsApp Business features
- ✅ Custom branding
- ✅ No message expiration
- ✅ Can send to any number
- ⚠️ Requires WhatsApp Business Account approval
- ⚠️ Costs per message

**To upgrade to Production**:
1. Apply for WhatsApp Business Account
2. Get approved by Meta
3. Update Twilio configuration
4. Update `.env` with production credentials

## 🎯 Notification Types Available

### 1. Streak Reminder
```dart
await apiService.sendStreakReminder(
  userId: 'user123',
  tracker: 'menstruation',
);
```

**Message Example**:
"Wow Sarah! 🎉 A whole week of logging! You're incredible! Keep this momentum going."

### 2. Period Reminder
```dart
await apiService.sendPeriodReminder(
  userId: 'user123',
  daysUntil: 3,
);
```

**Message Example**:
"Sarah! 🌸 Your period is coming in 3 days! Start preparing and taking extra care of yourself. 💕"

### 3. Health Tip
```dart
await apiService.sendHealthTip(
  userId: 'user123',
  tracker: 'menstruation',
);
```

**Message Example**:
"Sarah! 💕 We noticed you often have cramps. Try gentle yoga, heating pads, or magnesium supplements. You deserve comfort! 🧘‍♀️"

### 4. Motivation Message
```dart
await apiService.sendMotivationMessage(userId: 'user123');
```

**Message Example**:
"Sarah! 🌟 You've earned 250 points! You're crushing your health goals! Keep going! 💪"

### 5. Daily Check-in Reminder
```dart
await apiService.sendDailyCheckInReminder(
  userId: 'user123',
  tracker: 'menstruation',
);
```

**Message Example**:
"Sarah! 🌸 Don't forget to log your cycle today! It only takes a minute and helps us give you better insights! 📊"

### 6. Appointment Reminder
```dart
await apiService.sendAppointmentReminder(
  userId: 'user123',
  appointmentTitle: 'Doctor Checkup',
  appointmentTime: '2:00 PM',
  minutesBefore: 30,
);
```

**Message Example**:
"Sarah! 📅 Your Doctor Checkup is in 30 minutes at 2:00 PM. See you soon! 💕"

### 7. Voucher Notification
```dart
await apiService.sendVoucherNotification(
  userId: 'user123',
  voucherName: 'Wellness Kit',
  points: 150,
);
```

**Message Example**:
"Sarah! 🎁 Exciting! You can now redeem 'Wellness Kit' for 150 points! Treat yourself! 💕"

## 🔄 Message Personalization

All messages are personalized based on:
- **User's name** - Included in every message
- **Previous logs** - Analyzed for symptoms, moods, patterns
- **Streak history** - Milestone-based messages
- **Points earned** - Motivation based on achievements
- **Tracker type** - Menstruation, pregnancy, or menopause specific

## 📊 Example Flow

```
User logs their daily cycle
    ↓
Backend detects new log
    ↓
Streak increases to 7 days
    ↓
Trigger streak reminder
    ↓
Personalized Message Service:
  - Fetches user name: "Sarah"
  - Fetches streak days: 7
  - Fetches tracker: "menstruation"
  - Generates message: "Wow Sarah! 🎉 A whole week of logging! You're incredible!"
    ↓
Unified Notification Service:
  - Sends via Twilio WhatsApp
  - Sends via FCM Push
  - Sends via Local notification
    ↓
Sarah receives on WhatsApp: "Wow Sarah! 🎉 A whole week of logging! You're incredible!"
```

## 🚀 Production Deployment

### Before Going Live

1. **Test all notification types**
   ```bash
   # Test streak reminder
   curl -X POST http://localhost:3000/api/notifications/streak-reminder \
     -H "Content-Type: application/json" \
     -d '{"userId": "test_user", "tracker": "menstruation"}'
   ```

2. **Verify user data**
   - Ensure all users have `phone_number` field
   - Ensure phone numbers have country code (e.g., +1234567890)

3. **Set up rate limiting**
   - Prevent spam notifications
   - Implement cooldown periods

4. **Monitor delivery**
   - Track message delivery rates
   - Monitor for errors

5. **Get user consent**
   - Ensure users opt-in to WhatsApp notifications
   - Provide opt-out mechanism

### Deployment Checklist

- [ ] Auth Token added to `.env`
- [ ] Twilio WhatsApp Sandbox activated
- [ ] Test notifications sent successfully
- [ ] User phone numbers validated
- [ ] Rate limiting implemented
- [ ] Error handling tested
- [ ] User consent collected
- [ ] Monitoring set up

## 🔐 Security Best Practices

1. **Never commit credentials**
   - Keep `.env` in `.gitignore`
   - Use environment variables in production

2. **Validate phone numbers**
   - Check format before sending
   - Validate country codes

3. **Rate limiting**
   - Limit messages per user per day
   - Implement cooldown periods

4. **User consent**
   - Get explicit opt-in for WhatsApp
   - Provide easy opt-out

5. **Data privacy**
   - Don't send sensitive data in messages
   - Comply with GDPR/privacy laws

## 📞 Support

### Twilio Resources
- [Twilio Console](https://www.twilio.com/console)
- [WhatsApp API Docs](https://www.twilio.com/docs/whatsapp)
- [WhatsApp Sandbox Guide](https://www.twilio.com/docs/whatsapp/sandbox)

### Common Issues

**"Twilio not configured"**
- Check `.env` file has all three variables
- Verify no typos in credentials
- Restart server after updating `.env`

**"Message failed to send"**
- Verify phone number format (+country_code_number)
- Check if number is in WhatsApp Sandbox
- Verify Twilio account has credits

**"Auth Token invalid"**
- Go to Twilio Console
- Copy Auth Token again (it may have changed)
- Update `.env` and restart

## ✅ Verification Checklist

- [ ] `.env` has `TWILIO_ACCOUNT_SID`
- [ ] `.env` has `TWILIO_AUTH_TOKEN`
- [ ] `.env` has `TWILIO_WHATSAPP_NUMBER`
- [ ] Server restarted after `.env` update
- [ ] `/api/notifications/status` shows Twilio configured
- [ ] Test message sent successfully
- [ ] Message received on WhatsApp
- [ ] Message is personalized with user's name

---

**Status**: ✅ Ready to Configure
**Date**: December 20, 2025
**Next Step**: Add Auth Token to `.env`
