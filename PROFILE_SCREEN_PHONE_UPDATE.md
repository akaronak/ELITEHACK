# Profile Screen Phone Number Update

## Summary

Added WhatsApp phone number edit option to the profile screen in the Mensa app.

## Changes Made

### 1. Added Phone Number Controller

**File:** `mensa/lib/screens/profile_screen.dart`

Added a new TextEditingController for WhatsApp phone number:

```dart
final TextEditingController _whatsappPhoneController =
    TextEditingController();
```

### 2. Load Phone Number on Profile Load

Updated `_loadProfile()` method to fetch and load the stored phone number:

```dart
// Load phone number
final phoneNumber = await _apiService.getPhoneNumber(widget.userId);

setState(() {
  // ... other fields ...
  _whatsappPhoneController.text = phoneNumber ?? '';
  // ... rest of state ...
});
```

### 3. Save Phone Number on Profile Save

Updated `_saveProfile()` method to save the phone number when profile is saved:

```dart
// Save phone number if provided
if (_whatsappPhoneController.text.trim().isNotEmpty) {
  await _apiService.updatePhoneNumber(
    widget.userId,
    _whatsappPhoneController.text.trim(),
  );
}
```

### 4. Added WhatsApp Notifications Section to UI

Added a new section in the profile screen UI between Emergency Contact and App Settings:

**Location:** After Emergency Contact section, before App Settings

**Features:**
- Green icon with message symbol
- Phone number input field with validation
- Format helper text showing example: `+1234567890`
- Validation for phone format (must start with +, 10-15 digits)
- Info box explaining the purpose

**UI Code:**
```dart
// WhatsApp Notifications
const Text(
  'WhatsApp Notifications',
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  ),
),
const SizedBox(height: 16),

_buildInfoCard(
  icon: Icons.message,
  iconColor: Colors.green,
  children: [
    const Text(
      'Phone Number for WhatsApp',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    ),
    const SizedBox(height: 8),
    const Text(
      'Add your phone number to receive health reminders and personalized notifications via WhatsApp.',
      style: TextStyle(
        fontSize: 13,
        color: Colors.black54,
      ),
    ),
    const SizedBox(height: 16),
    _buildTextField(
      controller: _whatsappPhoneController,
      label: 'Phone Number',
      icon: Icons.phone,
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          if (!value.startsWith('+')) {
            return 'Phone must start with +';
          }
          if (value.length < 10 || value.length > 16) {
            return 'Invalid phone format';
          }
        }
        return null;
      },
    ),
    const SizedBox(height: 12),
    Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: Colors.green,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Format: +[country code][number]\nExample: +1234567890',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    ),
  ],
),
```

## How It Works

### User Flow

1. **Open Profile Screen** → User navigates to profile
2. **Load Profile** → Phone number is automatically loaded from database
3. **Edit Phone Number** → User can edit the WhatsApp phone number field
4. **Save Profile** → When user clicks "Save Profile", phone number is saved to database
5. **Receive Notifications** → User can now receive WhatsApp notifications

### Validation

Phone number validation includes:
- Must start with `+` symbol
- Must be 10-15 digits long
- Format example: `+1234567890`

### Error Handling

- If phone number is invalid, validation error is shown
- If save fails, error message is displayed
- If phone number is empty, it's not saved (optional field)

## Integration with Backend

The profile screen now integrates with:

1. **API Endpoint:** `GET /api/user/{userId}/phone-number`
   - Retrieves stored phone number on profile load

2. **API Endpoint:** `POST /api/user/{userId}/phone-number`
   - Saves phone number when profile is saved

## Testing

### Test 1: Add Phone Number

1. Open Profile Screen
2. Scroll to "WhatsApp Notifications" section
3. Enter phone number: `+1234567890`
4. Click "Save Profile"
5. Verify success message appears

### Test 2: Edit Phone Number

1. Open Profile Screen
2. Phone number should be pre-filled if previously saved
3. Edit the phone number
4. Click "Save Profile"
5. Verify success message appears

### Test 3: Validation

1. Open Profile Screen
2. Try entering invalid phone number (without +)
3. Click "Save Profile"
4. Verify validation error appears

### Test 4: Persistence

1. Add phone number and save
2. Close and reopen Profile Screen
3. Verify phone number is still there

## Files Modified

- `mensa/lib/screens/profile_screen.dart` - Added phone number functionality and UI

## Files Not Modified

- Backend API endpoints already exist
- API service methods already exist
- Database structure already supports phone numbers

## Next Steps

1. Test the phone number functionality
2. Verify WhatsApp notifications work with saved phone numbers
3. Monitor user adoption of the feature
4. Collect feedback for improvements

## Related Documentation

- `PHONE_NUMBER_SETUP.md` - Complete phone number setup guide
- `PHONE_NUMBER_API_REFERENCE.md` - API reference
- `PHONE_NUMBER_TESTING_GUIDE.md` - Testing procedures

## Status

✅ **Complete** - Phone number edit option is now available in the profile screen
