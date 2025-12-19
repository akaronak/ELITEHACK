# Phone Number API Reference

## Quick API Reference Card

### Add/Update Phone Number

```
POST /api/user/{userId}/phone-number
Content-Type: application/json

Request:
{
  "phone_number": "+1234567890"
}

Response (200):
{
  "success": true,
  "message": "Phone number updated successfully",
  "user_id": "user_123",
  "phone_number": "+1234567890"
}

Response (400):
{
  "error": "Invalid phone number format. Use format: +1234567890"
}
```

### Get Phone Number

```
GET /api/user/{userId}/phone-number

Response (200):
{
  "user_id": "user_123",
  "phone_number": "+1234567890"
}

Response (404):
{
  "error": "Phone number not found for this user"
}
```

### Update User Profile (with phone number)

```
POST /api/user/{userId}/profile
Content-Type: application/json

Request:
{
  "name": "Jane Doe",
  "email": "jane@example.com",
  "phone_number": "+1234567890",
  "fcm_token": "token_here"
}

Response (200):
{
  "user_id": "user_123",
  "name": "Jane Doe",
  "email": "jane@example.com",
  "phone_number": "+1234567890",
  "fcm_token": "token_here",
  "created_at": "2025-12-20T10:00:00Z",
  "updated_at": "2025-12-20T10:00:00Z"
}
```

## cURL Examples

### Add Phone Number

```bash
curl -X POST http://localhost:3000/api/user/user_123/phone-number \
  -H "Content-Type: application/json" \
  -d '{"phone_number": "+1234567890"}'
```

### Get Phone Number

```bash
curl http://localhost:3000/api/user/user_123/phone-number
```

### Update Profile with Phone

```bash
curl -X POST http://localhost:3000/api/user/user_123/profile \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Jane Doe",
    "phone_number": "+1234567890"
  }'
```

## Flutter Examples

### Add Phone Number

```dart
import 'package:mensa/services/api_service.dart';

final apiService = ApiService();

bool success = await apiService.updatePhoneNumber(
  'user_123',
  '+1234567890'
);

if (success) {
  print('Phone number saved!');
}
```

### Get Phone Number

```dart
String? phoneNumber = await apiService.getPhoneNumber('user_123');
print('Phone: $phoneNumber');
```

## Postman Collection

### Environment Variables

```json
{
  "baseUrl": "http://localhost:3000/api",
  "userId": "user_123",
  "phoneNumber": "+1234567890"
}
```

### Requests

#### 1. Add Phone Number

```
POST {{baseUrl}}/user/{{userId}}/phone-number
Content-Type: application/json

{
  "phone_number": "{{phoneNumber}}"
}
```

#### 2. Get Phone Number

```
GET {{baseUrl}}/user/{{userId}}/phone-number
```

#### 3. Update Profile

```
POST {{baseUrl}}/user/{{userId}}/profile
Content-Type: application/json

{
  "name": "Jane Doe",
  "phone_number": "{{phoneNumber}}"
}
```

## Phone Number Formats by Country

| Country | Format | Example |
|---------|--------|---------|
| USA | +1 | +12025551234 |
| Canada | +1 | +14165551234 |
| UK | +44 | +441234567890 |
| India | +91 | +919876543210 |
| Australia | +61 | +61212345678 |
| Germany | +49 | +491234567890 |
| France | +33 | +33123456789 |
| Japan | +81 | +81312345678 |
| Brazil | +55 | +5511987654321 |
| Mexico | +52 | +525551234567 |

## Validation Rules

✅ **Valid Format:**
- Starts with `+`
- Followed by 1-15 digits
- No spaces, dashes, or special characters

❌ **Invalid Formats:**
- `1234567890` (missing +)
- `+1 234 567 890` (has spaces)
- `+1-234-567-890` (has dashes)
- `+1(234)567-890` (has parentheses)
- `+123` (too short)
- `+12345678901234567` (too long)

## Status Codes

| Code | Meaning |
|------|---------|
| 200 | Success |
| 400 | Bad request (invalid format) |
| 404 | Phone number not found |
| 500 | Server error |

## Error Messages

| Error | Cause | Solution |
|-------|-------|----------|
| "phone_number is required" | Missing phone_number field | Add phone_number to request |
| "Invalid phone number format" | Wrong format | Use +1234567890 format |
| "Phone number not found" | User has no phone number | Add phone number first |
| "User not found" | Invalid user ID | Check user ID is correct |

## Integration with Notifications

Once phone number is saved, use these endpoints:

### Send WhatsApp Notification

```
POST /api/notifications/send
Content-Type: application/json

{
  "userId": "user_123",
  "title": "Health Reminder",
  "body": "Don't forget to log your health!",
  "sendWhatsApp": true
}
```

### Send Personalized Message

```
POST /api/notifications/motivation
Content-Type: application/json

{
  "userId": "user_123"
}
```

### Send Streak Reminder

```
POST /api/notifications/streak-reminder
Content-Type: application/json

{
  "userId": "user_123",
  "tracker": "menstruation"
}
```

## Database Query Examples

### Check if phone number exists

```javascript
const user = db.get('users')
  .find({ user_id: 'user_123' })
  .value();

if (user && user.phone_number) {
  console.log('Phone:', user.phone_number);
}
```

### Get all users with phone numbers

```javascript
const usersWithPhone = db.get('users')
  .filter(u => u.phone_number)
  .value();
```

### Update phone number directly

```javascript
db.get('users')
  .find({ user_id: 'user_123' })
  .assign({ phone_number: '+1234567890' })
  .write();
```

## Testing Workflow

1. **Add phone number**
   ```bash
   curl -X POST http://localhost:3000/api/user/test_user/phone-number \
     -H "Content-Type: application/json" \
     -d '{"phone_number": "+1234567890"}'
   ```

2. **Verify it's saved**
   ```bash
   curl http://localhost:3000/api/user/test_user/phone-number
   ```

3. **Send test notification**
   ```bash
   curl -X POST http://localhost:3000/api/notifications/send \
     -H "Content-Type: application/json" \
     -d '{
       "userId": "test_user",
       "title": "Test",
       "body": "Test message",
       "sendWhatsApp": true
     }'
   ```

4. **Check database**
   ```bash
   cat server/data/db.json | grep -A 5 "test_user"
   ```

## Common Workflows

### Workflow 1: New User Registration

```
1. Create user profile
   POST /api/user/{userId}/profile
   
2. Add phone number
   POST /api/user/{userId}/phone-number
   
3. Send welcome message
   POST /api/notifications/send
```

### Workflow 2: Update Existing User

```
1. Get current phone number
   GET /api/user/{userId}/phone-number
   
2. Update phone number
   POST /api/user/{userId}/phone-number
   
3. Send confirmation
   POST /api/notifications/send
```

### Workflow 3: Bulk Notification

```
1. Get all users with phone numbers
   Query: db.get('users').filter(u => u.phone_number)
   
2. Send bulk notification
   POST /api/notifications/bulk
```

## Related Endpoints

- `POST /api/notifications/send` - Send notification
- `POST /api/notifications/bulk` - Send bulk notifications
- `POST /api/notifications/motivation` - Send motivation message
- `POST /api/notifications/streak-reminder` - Send streak reminder
- `POST /api/notifications/daily-checkin` - Send daily check-in
- `GET /api/notifications/status` - Get notification status

## Support

For issues or questions:
1. Check `PHONE_NUMBER_SETUP.md` for detailed guide
2. Check `PHONE_NUMBER_QUICK_START.md` for quick reference
3. Check `PHONE_NUMBER_UI_INTEGRATION.md` for UI examples
4. Review error messages in this document
