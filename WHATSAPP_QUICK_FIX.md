# WhatsApp Notification - Quick Fix

## Problem
WhatsApp notifications not received (but local notifications work)

## Solution
Phone number is now being passed to the backend API

## What to Do

### 1. Add Phone Number
- Profile Screen → WhatsApp Notifications
- Enter: `+1234567890`
- Save

### 2. Add to Twilio Sandbox
- Twilio Console → WhatsApp Sandbox
- Add phone number
- Send join code

### 3. Test
- Menstruation Screen → 🔔 → Personalized
- Check WhatsApp

## Verify

```bash
# Check phone saved
cat server/data/db.json | jq '.users'

# Test API
curl -X POST http://localhost:3000/api/notifications/send \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "user_123",
    "phoneNumber": "+1234567890",
    "title": "Test",
    "body": "Test",
    "sendWhatsApp": true
  }'
```

## Status
✅ **Fixed**

---

**See WHATSAPP_FIX_GUIDE.md for complete details**
