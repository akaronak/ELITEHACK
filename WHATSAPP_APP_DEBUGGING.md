# WhatsApp Notification - App Debugging Guide

## Issue

Test notification works, but app notification doesn't show WhatsApp message.

## Debugging Steps

### Step 1: Check Flutter Logs

When you send a personalized notification from the app, look for these logs:

```
📨 Sending notification:
  userId: user_123
  phoneNumber: +919811226924
  title: 🌸 Menstrual Phase
  body: Stay hydrated and rest well...
  sendWhatsApp: true

📡 Response status: 200
📡 Response body: {...}

✅ Notification sent successfully
```

### Step 2: Check Server Logs

Look for these logs on the server:

```
📨 Notification request received:
  userId: user_123
  phoneNumber: +919811226924
  title: 🌸 Menstrual Phase
  body: Stay hydrated and rest well...
  sendWhatsApp: true

📱 Sending WhatsApp message via Twilio...
✅ WhatsApp message sent successfully: SM...
```

### Step 3: Verify Phone Number is Being Passed

**In Flutter logs, check:**
```
phoneNumber: +919811226924
```

If it shows `phoneNumber: null`, then the phone number is not being retrieved from the database.

### Step 4: Check API Response

**In Flutter logs, check:**
```
📡 Response status: 200
```

If it's not 200, there's an API error.

## Common Issues & Solutions

### Issue 1: phoneNumber is null

**Logs show:**
```
phoneNumber: null
```

**Cause:** Phone number not being retrieved from database

**Solution:**
1. Check if phone number is saved in profile
2. Verify phone number format: `+919811226924`
3. Check database: `cat server/data/db.json | jq '.users'`

### Issue 2: Response status is not 200

**Logs show:**
```
📡 Response status: 500
```

**Cause:** Server error

**Solution:**
1. Check server logs for error message
2. Verify all parameters are correct
3. Restart server
4. Try again

### Issue 3: WhatsApp message not sent

**Server logs show:**
```
❌ Error sending WhatsApp message: [error]
```

**Cause:** Twilio error

**Solution:**
1. Check Twilio credentials in `.env`
2. Verify phone number format
3. Check phone is in sandbox
4. Check Twilio account status

### Issue 4: No logs appearing

**Cause:** App not making API call

**Solution:**
1. Check if "Personalized" button is being clicked
2. Verify no errors in Flutter code
3. Check network connection
4. Restart app

## Testing Workflow

### Step 1: Prepare

1. Open Flutter logs (run `flutter logs`)
2. Open server logs (check terminal where server is running)
3. Have WhatsApp open on your phone

### Step 2: Send Notification

1. Open Menstruation Screen
2. Click notification icon (🔔)
3. Select "Personalized"

### Step 3: Check Logs

**Flutter logs should show:**
```
📨 Sending notification:
  userId: ...
  phoneNumber: +919811226924
  ...
✅ Notification sent successfully
```

**Server logs should show:**
```
📨 Notification request received:
  ...
📱 Sending WhatsApp message via Twilio...
✅ WhatsApp message sent successfully: SM...
```

### Step 4: Check WhatsApp

- Open WhatsApp
- Look for message from `+14155238886`
- Should contain personalized message

## Log Locations

### Flutter Logs

Run in terminal:
```bash
flutter logs
```

Or in Android Studio:
- View → Tool Windows → Logcat

### Server Logs

Check terminal where server is running:
```bash
npm start
```

## Detailed Debugging

### Debug 1: Verify Phone Number Retrieval

**In menstruation_home.dart:**

Add this before sending notification:
```dart
final phoneNumber = await apiService.getPhoneNumber(widget.userId);
debugPrint('🔍 Retrieved phone number: $phoneNumber');
```

**Expected log:**
```
🔍 Retrieved phone number: +919811226924
```

### Debug 2: Verify API Call

**In api_service.dart:**

The logs already show:
```
📨 Sending notification:
  phoneNumber: +919811226924
```

### Debug 3: Verify Server Processing

**In notifications.routes.js:**

The logs already show:
```
📨 Notification request received:
  phoneNumber: +919811226924
```

### Debug 4: Verify Twilio Sending

**In twilioWhatsappService.js:**

The logs already show:
```
✅ WhatsApp message sent successfully: SM...
```

## Complete Flow Debugging

```
1. User clicks "Personalized"
   ↓
2. Flutter retrieves phone number
   Log: 🔍 Retrieved phone number: +919811226924
   ↓
3. Flutter sends API request
   Log: 📨 Sending notification: phoneNumber: +919811226924
   ↓
4. Server receives request
   Log: 📨 Notification request received: phoneNumber: +919811226924
   ↓
5. Server sends to Twilio
   Log: 📱 Sending WhatsApp message via Twilio...
   ↓
6. Twilio sends message
   Log: ✅ WhatsApp message sent successfully: SM...
   ↓
7. User receives on WhatsApp
```

## Checklist

- [ ] Flutter logs show phoneNumber is not null
- [ ] Flutter logs show response status 200
- [ ] Server logs show notification request received
- [ ] Server logs show WhatsApp message sent
- [ ] Phone number is in Twilio sandbox
- [ ] WhatsApp message received on phone

## If Still Not Working

1. **Check all logs** - Follow debugging steps above
2. **Verify phone number** - Must be in sandbox
3. **Test API directly** - Use cURL to test
4. **Restart everything** - App, server, phone
5. **Check Twilio status** - Go to Twilio Console

## Quick Test

```bash
# Test API directly
curl -X POST http://localhost:3000/api/notifications/send \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "user_123",
    "phoneNumber": "+919811226924",
    "title": "Test",
    "body": "Test message",
    "sendWhatsApp": true
  }'

# Check server logs for:
# ✅ WhatsApp message sent successfully
```

## Support

If you need help:

1. Share Flutter logs
2. Share server logs
3. Verify phone is in sandbox
4. Check all parameters are correct

---

**Use these logs to debug WhatsApp notifications!** 🔍
