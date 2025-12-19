# Phone Number Testing Guide

Complete testing guide for phone number functionality and WhatsApp notifications.

## Prerequisites

- Server running on `http://localhost:3000`
- Twilio credentials configured in `.env`
- cURL or Postman installed
- Database file at `server/data/db.json`

## Test 1: Add Phone Number

### Using cURL

```bash
curl -X POST http://localhost:3000/api/user/test_user_1/phone-number \
  -H "Content-Type: application/json" \
  -d '{"phone_number": "+1234567890"}'
```

### Expected Response

```json
{
  "success": true,
  "message": "Phone number updated successfully",
  "user_id": "test_user_1",
  "phone_number": "+1234567890"
}
```

### Verify in Database

```bash
cat server/data/db.json | grep -A 5 "test_user_1"
```

Should show:
```json
{
  "user_id": "test_user_1",
  "phone_number": "+1234567890",
  "created_at": "2025-12-20T...",
  "updated_at": "2025-12-20T..."
}
```

---

## Test 2: Get Phone Number

### Using cURL

```bash
curl http://localhost:3000/api/user/test_user_1/phone-number
```

### Expected Response

```json
{
  "user_id": "test_user_1",
  "phone_number": "+1234567890"
}
```

---

## Test 3: Invalid Phone Number Format

### Using cURL

```bash
curl -X POST http://localhost:3000/api/user/test_user_2/phone-number \
  -H "Content-Type: application/json" \
  -d '{"phone_number": "1234567890"}'
```

### Expected Response (400)

```json
{
  "error": "Invalid phone number format. Use format: +1234567890"
}
```

---

## Test 4: Update Profile with Phone Number

### Using cURL

```bash
curl -X POST http://localhost:3000/api/user/test_user_3/profile \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "phone_number": "+1987654321"
  }'
```

### Expected Response

```json
{
  "user_id": "test_user_3",
  "name": "Test User",
  "email": "test@example.com",
  "phone_number": "+1987654321",
  "created_at": "2025-12-20T...",
  "updated_at": "2025-12-20T..."
}
```

### Verify Both Collections Updated

```bash
# Check userProfiles
cat server/data/db.json | grep -A 10 '"userProfiles"'

# Check users
cat server/data/db.json | grep -A 10 '"users"'
```

---

## Test 5: Send WhatsApp Notification

### Using cURL

```bash
curl -X POST http://localhost:3000/api/notifications/send \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test_user_1",
    "title": "Test Notification",
    "body": "This is a test WhatsApp message",
    "sendWhatsApp": true,
    "sendFCM": false,
    "sendLocal": false
  }'
```

### Expected Response

```json
{
  "success": true,
  "message": "Notification sent successfully",
  "channels": {
    "whatsapp": {
      "success": true,
      "messageId": "SM..."
    }
  }
}
```

### Check Server Logs

Look for:
```
✅ WhatsApp notification sent to +1234567890
Message ID: SM...
```

---

## Test 6: Send Personalized Motivation Message

### Using cURL

```bash
curl -X POST http://localhost:3000/api/notifications/motivation \
  -H "Content-Type: application/json" \
  -d '{"userId": "test_user_1"}'
```

### Expected Response

```json
{
  "success": true,
  "message": "Motivation message sent successfully",
  "channels": {
    "whatsapp": {
      "success": true,
      "messageId": "SM..."
    }
  }
}
```

### Message Example

The system generates personalized messages like:
- "You're doing amazing! Keep up your health streak! 💪"
- "Great job logging today! You've earned 10 points! 🎉"
- "Your dedication is inspiring! Keep going! ✨"

---

## Test 7: Send Streak Reminder

### Using cURL

```bash
curl -X POST http://localhost:3000/api/notifications/streak-reminder \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test_user_1",
    "tracker": "menstruation"
  }'
```

### Expected Response

```json
{
  "success": true,
  "message": "Streak reminder sent successfully"
}
```

---

## Test 8: Send Daily Check-in Reminder

### Using cURL

```bash
curl -X POST http://localhost:3000/api/notifications/daily-checkin \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test_user_1",
    "tracker": "menstruation"
  }'
```

### Expected Response

```json
{
  "success": true,
  "message": "Daily check-in reminder sent successfully"
}
```

---

## Test 9: Bulk Notifications

### Using cURL

```bash
curl -X POST http://localhost:3000/api/notifications/bulk \
  -H "Content-Type: application/json" \
  -d '{
    "users": [
      {
        "userId": "test_user_1",
        "phoneNumber": "+1234567890"
      },
      {
        "userId": "test_user_2",
        "phoneNumber": "+1987654321"
      }
    ],
    "title": "Health Reminder",
    "body": "Time to check in!",
    "sendWhatsApp": true
  }'
```

### Expected Response

```json
{
  "success": true,
  "message": "Bulk notification sent successfully",
  "results": [
    {
      "userId": "test_user_1",
      "success": true
    },
    {
      "userId": "test_user_2",
      "success": true
    }
  ]
}
```

---

## Test 10: Error Handling

### Missing Phone Number

```bash
curl -X POST http://localhost:3000/api/user/test_user_4/phone-number \
  -H "Content-Type: application/json" \
  -d '{}'
```

Expected: `400 - "phone_number is required"`

### Non-existent User

```bash
curl http://localhost:3000/api/user/nonexistent_user/phone-number
```

Expected: `404 - "Phone number not found for this user"`

### Invalid User ID in Notification

```bash
curl -X POST http://localhost:3000/api/notifications/send \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "nonexistent_user",
    "title": "Test",
    "body": "Test"
  }'
```

Expected: `404 - "User not found"`

---

## Test 11: Flutter Integration

### Add Phone Number

```dart
import 'package:mensa/services/api_service.dart';

void testPhoneNumber() async {
  final apiService = ApiService();
  
  // Add phone number
  bool success = await apiService.updatePhoneNumber(
    'flutter_test_user',
    '+1234567890'
  );
  
  print('Phone added: $success');
  
  // Get phone number
  String? phone = await apiService.getPhoneNumber('flutter_test_user');
  print('Phone retrieved: $phone');
}
```

### Send Notification

```dart
void testNotification() async {
  final apiService = ApiService();
  
  var result = await apiService.sendNotification(
    userId: 'flutter_test_user',
    title: 'Flutter Test',
    body: 'Testing from Flutter',
    sendWhatsApp: true,
  );
  
  print('Notification sent: $result');
}
```

---

## Test 12: Database Integrity

### Check All Users with Phone Numbers

```bash
cat server/data/db.json | jq '.users[] | select(.phone_number != null)'
```

### Count Users with Phone Numbers

```bash
cat server/data/db.json | jq '.users | map(select(.phone_number != null)) | length'
```

### Export Users to CSV

```bash
cat server/data/db.json | jq -r '.users[] | [.user_id, .phone_number] | @csv' > users.csv
```

---

## Test 13: Performance Testing

### Add 100 Phone Numbers

```bash
for i in {1..100}; do
  curl -X POST http://localhost:3000/api/user/perf_test_$i/phone-number \
    -H "Content-Type: application/json" \
    -d "{\"phone_number\": \"+1234567890\"}" \
    -s > /dev/null
  echo "Added user $i"
done
```

### Send 100 Notifications

```bash
for i in {1..100}; do
  curl -X POST http://localhost:3000/api/notifications/send \
    -H "Content-Type: application/json" \
    -d "{
      \"userId\": \"perf_test_$i\",
      \"title\": \"Test\",
      \"body\": \"Performance test\",
      \"sendWhatsApp\": true
    }" \
    -s > /dev/null
  echo "Sent notification $i"
done
```

---

## Test 14: Postman Collection

### Import Collection

1. Open Postman
2. Click "Import"
3. Create new collection "Phone Number Tests"
4. Add these requests:

#### Request 1: Add Phone Number
```
POST http://localhost:3000/api/user/{{userId}}/phone-number
Body (JSON):
{
  "phone_number": "{{phoneNumber}}"
}
```

#### Request 2: Get Phone Number
```
GET http://localhost:3000/api/user/{{userId}}/phone-number
```

#### Request 3: Send Notification
```
POST http://localhost:3000/api/notifications/send
Body (JSON):
{
  "userId": "{{userId}}",
  "title": "Test",
  "body": "Test message",
  "sendWhatsApp": true
}
```

#### Request 4: Send Motivation
```
POST http://localhost:3000/api/notifications/motivation
Body (JSON):
{
  "userId": "{{userId}}"
}
```

### Set Environment Variables

```json
{
  "userId": "test_user_1",
  "phoneNumber": "+1234567890"
}
```

---

## Troubleshooting Tests

### Server Not Running

```bash
# Check if server is running
curl http://localhost:3000/health

# Should return:
# {"status":"OK","message":"Mensa Pregnancy Tracker API is running"}
```

### Database File Not Found

```bash
# Check if database exists
ls -la server/data/db.json

# If not, restart server to create it
```

### Twilio Errors

```bash
# Check Twilio credentials in .env
cat server/.env | grep TWILIO

# Verify credentials are correct
# TWILIO_ACCOUNT_SID should start with AC
# TWILIO_AUTH_TOKEN should be 32 characters
# TWILIO_WHATSAPP_NUMBER should be +14155238886
```

### Phone Number Not Saved

```bash
# Check database directly
cat server/data/db.json | jq '.users'

# Should show your test user with phone number
```

---

## Test Results Template

```
Test Date: 2025-12-20
Tester: [Your Name]

✅ Test 1: Add Phone Number - PASSED
✅ Test 2: Get Phone Number - PASSED
✅ Test 3: Invalid Format - PASSED
✅ Test 4: Update Profile - PASSED
✅ Test 5: Send WhatsApp - PASSED
✅ Test 6: Motivation Message - PASSED
✅ Test 7: Streak Reminder - PASSED
✅ Test 8: Daily Check-in - PASSED
✅ Test 9: Bulk Notifications - PASSED
✅ Test 10: Error Handling - PASSED
✅ Test 11: Flutter Integration - PASSED
✅ Test 12: Database Integrity - PASSED
✅ Test 13: Performance - PASSED
✅ Test 14: Postman Collection - PASSED

Overall Status: ALL TESTS PASSED ✅
```

---

## Next Steps

1. Run all tests above
2. Document any failures
3. Fix issues if needed
4. Deploy to production
5. Monitor WhatsApp delivery rates

See `PHONE_NUMBER_SETUP.md` for complete documentation.
