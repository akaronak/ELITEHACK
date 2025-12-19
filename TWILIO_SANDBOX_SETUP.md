# Twilio WhatsApp Sandbox Setup - REQUIRED

## Important: Sandbox Requirement

Twilio WhatsApp requires phone numbers to be added to a **sandbox** for testing. Without this, messages are sent but not delivered.

## Status

✅ **Twilio service is working correctly**
✅ **Messages are being sent to Twilio**
❌ **Phone number needs to be added to sandbox**

## What is Twilio Sandbox?

The Twilio WhatsApp sandbox is a testing environment where:
- You can send and receive WhatsApp messages
- Phone numbers must be explicitly added
- Messages are sent but only delivered to sandbox numbers
- Perfect for development and testing

## How to Add Your Phone Number to Sandbox

### Step 1: Go to Twilio Console

1. Open: https://www.twilio.com/console
2. Log in with your Twilio account
3. Navigate to: **Messaging** → **WhatsApp** → **Sandbox**

### Step 2: Find Your Sandbox Number

You should see a sandbox number like: `+14155238886`

This is the Twilio number that sends messages.

### Step 3: Add Your Phone Number

1. Look for "Sandbox Participants" section
2. Click "Add Participant" or similar button
3. Enter your phone number: `+919811226924`
4. Save

### Step 4: Send Join Code to WhatsApp

1. You'll see a join code (e.g., `join abc123`)
2. Open WhatsApp on your phone
3. Send a message to: `+14155238886`
4. Type: `join abc123` (use the actual code shown)
5. Send the message

### Step 5: Wait for Confirmation

WhatsApp will send you a confirmation message:
```
You have been added to the Mensa WhatsApp sandbox
```

Once confirmed, you're ready to receive messages!

## Visual Guide

```
Twilio Console
    ↓
Messaging → WhatsApp → Sandbox
    ↓
Find sandbox number: +14155238886
    ↓
Add participant: +919811226924
    ↓
Send to WhatsApp: "join [code]"
    ↓
Receive confirmation
    ↓
Ready to receive messages! ✅
```

## Testing After Sandbox Setup

### Test 1: Send from App

1. Open Menstruation Screen
2. Click notification icon (🔔)
3. Select "Personalized"
4. Check WhatsApp

### Test 2: Send from API

```bash
curl -X POST http://localhost:3000/api/notifications/send \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "user_123",
    "phoneNumber": "+919811226924",
    "title": "Test",
    "body": "Test WhatsApp message",
    "sendWhatsApp": true
  }'
```

### Test 3: Direct Twilio Test

Run the test script:
```bash
node server/test-whatsapp.js
```

Expected output:
```
✅ WhatsApp message sent successfully: SM...
```

## Verification

### Check if Phone is in Sandbox

1. Go to Twilio Console
2. Messaging → WhatsApp → Sandbox
3. Look for your phone number in "Sandbox Participants"
4. Should show: `+919811226924`

### Check Message Status

1. Go to Twilio Console
2. Messaging → WhatsApp → Logs
3. Look for your phone number
4. Should show "Delivered" or "Sent"

## Common Issues

### Issue 1: "Message sent but not received"

**Cause:** Phone number not in sandbox

**Solution:**
1. Go to Twilio Console
2. Add phone number to sandbox
3. Send join code to WhatsApp
4. Wait for confirmation
5. Try again

### Issue 2: "Join code not working"

**Cause:** Wrong code or expired code

**Solution:**
1. Go back to Twilio Console
2. Get the latest join code
3. Send it to WhatsApp again
4. Wait for confirmation

### Issue 3: "Phone number already added"

**Cause:** Phone is already in sandbox

**Solution:**
1. Just send the join code to WhatsApp
2. You should receive confirmation
3. Try sending a message

### Issue 4: "Twilio account issue"

**Cause:** Account suspended or no credits

**Solution:**
1. Check Twilio account status
2. Verify account has credits
3. Check billing information
4. Contact Twilio support if needed

## Sandbox Limitations

- ✅ Can send messages to sandbox numbers
- ✅ Can receive messages from sandbox numbers
- ❌ Cannot send to non-sandbox numbers
- ❌ Messages expire after 24 hours of inactivity
- ❌ Limited to sandbox participants only

## Production Setup

For production (sending to any WhatsApp number):

1. Request WhatsApp Business Account
2. Get approved by Meta/WhatsApp
3. Use production credentials
4. No sandbox required

## Troubleshooting Checklist

- [ ] Twilio account created
- [ ] WhatsApp sandbox enabled
- [ ] Phone number added to sandbox
- [ ] Join code sent to WhatsApp
- [ ] Confirmation received
- [ ] Phone number format correct: `+919811226924`
- [ ] Twilio credentials in `.env`
- [ ] Server restarted
- [ ] Test message sent
- [ ] Message received on WhatsApp

## Quick Steps

1. **Go to Twilio Console**
   - https://www.twilio.com/console

2. **Navigate to Sandbox**
   - Messaging → WhatsApp → Sandbox

3. **Add Your Phone**
   - Click "Add Participant"
   - Enter: `+919811226924`

4. **Send Join Code**
   - Copy the join code
   - Send to: `+14155238886`
   - Message: `join [code]`

5. **Wait for Confirmation**
   - You'll receive a confirmation message

6. **Test**
   - Open Menstruation Screen
   - Click 🔔 → Personalized
   - Check WhatsApp

## Status

✅ **Twilio service working**
✅ **Messages being sent**
⏳ **Waiting for sandbox setup**

Once you add your phone to the sandbox, WhatsApp notifications will work!

## Support

If you need help:

1. Check Twilio Console for errors
2. Verify phone number format
3. Confirm join code was sent
4. Check WhatsApp for confirmation
5. Contact Twilio support if needed

## Related Documentation

- `WHATSAPP_FIX_GUIDE.md` - Fix guide
- `PHONE_NUMBER_SETUP.md` - Phone setup
- `PERSONALIZED_NOTIFICATION_FEATURE.md` - Feature guide

---

**Add your phone to Twilio sandbox to receive WhatsApp messages!** 📱
