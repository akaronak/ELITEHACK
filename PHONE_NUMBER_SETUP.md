# Phone Number Setup for WhatsApp Notifications

This guide explains how to add and manage phone numbers in the Mensa app for WhatsApp notifications.

## Overview

The system stores user phone numbers in the database and uses them to send personalized WhatsApp notifications via Twilio. Phone numbers must be in international format (e.g., `+1234567890`).

## Database Structure

Phone numbers are stored in two places:

1. **`users` collection** - Main user record with phone number
2. **`userProfiles` collection** - User profile data (optional phone number field)

### User Record Schema

```json
{
  "user_id": "user_123",
  "name": "User Name",
  "phone_number": "+1234567890",
  "fcm_token": "fcm_token_here",
  "created_at": "2025-12-20T10:00:00Z",
  "updated_at": "2025-12-20T10:00:00Z"
}
```

## Methods to Add Phone Numbers

### Method 1: API Endpoint (Recommended)

**Endpoint:** `POST /api/user/{userId}/phone-number`

**Request Body:**
```json
{
  "phone_number": "+1234567890"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Phone number updated successfully",
  "user_id": "user_123",
  "phone_number": "+1234567890"
}
```

**Example using cURL:**
```bash
curl -X POST http://localhost:3000/api/user/user_123/phone-number \
  -H "Content-Type: application/json" \
  -d '{"phone_number": "+1234567890"}'
```

### Method 2: User Profile Update

**Endpoint:** `POST /api/user/{userId}/profile`

Include `phone_number` in the profile data:

```json
{
  "name": "User Name",
  "email": "user@example.com",
  "phone_number": "+1234567890",
  "fcm_token": "fcm_token_here"
}
```

This will automatically create/update the user record with the phone number.

### Method 3: Flutter App Integration

Use the `ApiService` class to update phone numbers:

```dart
import 'package:mensa/services/api_service.dart';

final apiService = ApiService();

// Update phone number
bool success = await apiService.updatePhoneNumber(
  'user_123',
  '+1234567890'
);

if (success) {
  print('Phone number updated successfully');
}

// Get phone number
String? phoneNumber = await apiService.getPhoneNumber('user_123');
print('Phone number: $phoneNumber');
```

## Phone Number Format

Phone numbers must follow the international format:

- **Format:** `+[country_code][number]`
- **Examples:**
  - USA: `+1234567890`
  - India: `+919876543210`
  - UK: `+441234567890`
  - Canada: `+14165551234`

## Validation

The system validates phone numbers using this pattern:
```regex
^\+\d{1,15}$
```

This ensures:
- Starts with `+` symbol
- Contains 1-15 digits
- No spaces or special characters

## Retrieving Phone Numbers

### Get Phone Number via API

**Endpoint:** `GET /api/user/{userId}/phone-number`

**Response:**
```json
{
  "user_id": "user_123",
  "phone_number": "+1234567890"
}
```

**Example using cURL:**
```bash
curl http://localhost:3000/api/user/user_123/phone-number
```

### Get Phone Number in Flutter

```dart
String? phoneNumber = await apiService.getPhoneNumber('user_123');
```

## Sending WhatsApp Notifications

Once phone numbers are stored, you can send WhatsApp notifications:

### Send Notification to Single User

**Endpoint:** `POST /api/notifications/send`

```json
{
  "userId": "user_123",
  "title": "Daily Reminder",
  "body": "Don't forget to log your health today!",
  "sendWhatsApp": true,
  "sendFCM": true,
  "sendLocal": true
}
```

The system will automatically fetch the phone number from the database.

### Send Bulk Notifications

**Endpoint:** `POST /api/notifications/bulk`

```json
{
  "users": [
    {
      "userId": "user_123",
      "phoneNumber": "+1234567890"
    },
    {
      "userId": "user_456",
      "phoneNumber": "+1987654321"
    }
  ],
  "title": "Health Reminder",
  "body": "Time to check in!",
  "sendWhatsApp": true
}
```

### Send Personalized Messages

The system automatically generates personalized messages based on user logs:

**Endpoint:** `POST /api/notifications/motivation`

```json
{
  "userId": "user_123"
}
```

This sends a sweet, personalized motivation message based on the user's wallet points and streak.

## Notification Types

### 1. Streak Reminder
```
POST /api/notifications/streak-reminder
{
  "userId": "user_123",
  "tracker": "menstruation"
}
```

### 2. Period Reminder
```
POST /api/notifications/period-reminder
{
  "userId": "user_123",
  "daysUntil": 3
}
```

### 3. Health Tip
```
POST /api/notifications/health-tip
{
  "userId": "user_123",
  "tracker": "menstruation"
}
```

### 4. Appointment Reminder
```
POST /api/notifications/appointment-reminder
{
  "userId": "user_123",
  "appointmentTitle": "Doctor Checkup",
  "appointmentTime": "2025-12-21T10:00:00Z",
  "minutesBefore": 60
}
```

### 5. Voucher Notification
```
POST /api/notifications/voucher
{
  "userId": "user_123",
  "voucherName": "Free Health Checkup",
  "points": 100
}
```

### 6. Daily Check-in Reminder
```
POST /api/notifications/daily-checkin
{
  "userId": "user_123",
  "tracker": "menstruation"
}
```

## Testing Phone Number Setup

### Test with Postman

1. **Add Phone Number:**
   - Method: POST
   - URL: `http://localhost:3000/api/user/test_user/phone-number`
   - Body (JSON):
     ```json
     {
       "phone_number": "+1234567890"
     }
     ```

2. **Verify Phone Number:**
   - Method: GET
   - URL: `http://localhost:3000/api/user/test_user/phone-number`

3. **Send Test Notification:**
   - Method: POST
   - URL: `http://localhost:3000/api/notifications/send`
   - Body (JSON):
     ```json
     {
       "userId": "test_user",
       "title": "Test Notification",
       "body": "This is a test WhatsApp notification",
       "sendWhatsApp": true
     }
     ```

### Test with cURL

```bash
# Add phone number
curl -X POST http://localhost:3000/api/user/test_user/phone-number \
  -H "Content-Type: application/json" \
  -d '{"phone_number": "+1234567890"}'

# Get phone number
curl http://localhost:3000/api/user/test_user/phone-number

# Send notification
curl -X POST http://localhost:3000/api/notifications/send \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test_user",
    "title": "Test",
    "body": "Test message",
    "sendWhatsApp": true
  }'
```

## Twilio Configuration

Ensure Twilio credentials are set in `.env`:

```env
TWILIO_ACCOUNT_SID=your_account_sid
TWILIO_AUTH_TOKEN=your_auth_token
TWILIO_WHATSAPP_NUMBER=+14155238886
```

The `TWILIO_WHATSAPP_NUMBER` is the Twilio sandbox number that sends messages.

## Database File Location

Phone numbers are stored in:
```
server/data/db.json
```

Example structure:
```json
{
  "users": [
    {
      "user_id": "user_123",
      "name": "Jane Doe",
      "phone_number": "+1234567890",
      "fcm_token": "token_here",
      "created_at": "2025-12-20T10:00:00Z",
      "updated_at": "2025-12-20T10:00:00Z"
    }
  ]
}
```

## Troubleshooting

### Phone Number Not Saved

1. Check if the format is correct (must start with `+`)
2. Verify the user ID is correct
3. Check server logs for validation errors

### WhatsApp Notifications Not Sending

1. Verify phone number is stored: `GET /api/user/{userId}/phone-number`
2. Check Twilio credentials in `.env`
3. Ensure phone number is in Twilio sandbox (for testing)
4. Check server logs for Twilio API errors

### Invalid Phone Number Error

- Ensure format: `+[country_code][number]`
- No spaces or special characters
- Must be 1-15 digits after the `+`

## Next Steps

1. Add phone number to user profile in the Flutter app
2. Create a settings screen where users can update their phone number
3. Test WhatsApp notifications with sample messages
4. Set up automated notification schedules

## Related Documentation

- `NOTIFICATIONS_QUICK_REFERENCE.md` - Quick reference for notification endpoints
- `TWILIO_SETUP_GUIDE.md` - Twilio configuration guide
- `TWILIO_PERSONALIZED_NOTIFICATIONS.md` - Personalized message generation
