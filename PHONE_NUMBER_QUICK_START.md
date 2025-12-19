# Phone Number Quick Start Guide

## TL;DR - Add Phone Number in 3 Steps

### Step 1: Update User Profile (Flutter App)

In your profile screen, add a phone number field:

```dart
// In profile_screen.dart or settings screen
String phoneNumber = '+1234567890'; // User enters this

// Call API to save
bool success = await apiService.updatePhoneNumber(userId, phoneNumber);
```

### Step 2: Verify It's Saved

```dart
String? savedPhone = await apiService.getPhoneNumber(userId);
print('Saved phone: $savedPhone');
```

### Step 3: Send WhatsApp Notification

```dart
await apiService.sendNotification(
  userId: userId,
  title: 'Hello!',
  body: 'This is a WhatsApp message',
  sendWhatsApp: true,
);
```

---

## API Endpoints

### Add/Update Phone Number
```
POST /api/user/{userId}/phone-number
Content-Type: application/json

{
  "phone_number": "+1234567890"
}
```

### Get Phone Number
```
GET /api/user/{userId}/phone-number
```

### Send WhatsApp Notification
```
POST /api/notifications/send
Content-Type: application/json

{
  "userId": "user_123",
  "title": "Title",
  "body": "Message",
  "sendWhatsApp": true
}
```

---

## Phone Number Format

✅ **Correct:**
- `+1234567890` (USA)
- `+919876543210` (India)
- `+441234567890` (UK)

❌ **Incorrect:**
- `1234567890` (missing +)
- `+1 234 567 890` (has spaces)
- `+1-234-567-890` (has dashes)

---

## Where to Add Phone Number in App

### Option 1: Profile Screen
Add a text field in the profile settings where users can enter their phone number.

### Option 2: Onboarding
Ask for phone number during app setup/registration.

### Option 3: Notification Settings
Create a dedicated notification preferences screen.

---

## Example: Add Phone Number to Profile Screen

```dart
// In profile_screen.dart

TextFormField(
  initialValue: userPhone,
  decoration: InputDecoration(
    labelText: 'Phone Number (for WhatsApp)',
    hintText: '+1234567890',
  ),
  onChanged: (value) {
    phoneNumber = value;
  },
),

ElevatedButton(
  onPressed: () async {
    bool success = await apiService.updatePhoneNumber(
      userId,
      phoneNumber,
    );
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Phone number saved!')),
      );
    }
  },
  child: Text('Save Phone Number'),
),
```

---

## Testing

### Using cURL

```bash
# Add phone number
curl -X POST http://localhost:3000/api/user/user_123/phone-number \
  -H "Content-Type: application/json" \
  -d '{"phone_number": "+1234567890"}'

# Get phone number
curl http://localhost:3000/api/user/user_123/phone-number

# Send test notification
curl -X POST http://localhost:3000/api/notifications/send \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "user_123",
    "title": "Test",
    "body": "Test message",
    "sendWhatsApp": true
  }'
```

---

## Common Issues

| Issue | Solution |
|-------|----------|
| "Invalid phone number format" | Use format: `+1234567890` |
| Phone number not saved | Check user ID is correct |
| WhatsApp not sending | Verify phone number is saved first |
| Twilio error | Check `.env` has correct credentials |

---

## Next: Personalized Messages

Once phone numbers are set up, the system automatically sends personalized messages based on:
- User's health logs
- Streak status
- Wallet points
- Health history

See `TWILIO_PERSONALIZED_NOTIFICATIONS.md` for details.
