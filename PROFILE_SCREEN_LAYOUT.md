# Profile Screen Layout

## Visual Structure

The profile screen now has the following sections in order:

```
┌─────────────────────────────────────────┐
│         PROFILE SCREEN LAYOUT           │
├─────────────────────────────────────────┤
│                                         │
│  1. PROFILE HEADER                      │
│     - Profile icon                      │
│     - User name                         │
│     - BMI info                          │
│                                         │
├─────────────────────────────────────────┤
│                                         │
│  2. ACTIVE TRACKER                      │
│     - Current tracker selector          │
│     - Info about changing tracker       │
│                                         │
├─────────────────────────────────────────┤
│                                         │
│  3. REWARDS & VOUCHERS                  │
│     - My Wallet button                  │
│     - Vouchers button                   │
│                                         │
├─────────────────────────────────────────┤
│                                         │
│  4. BASIC INFORMATION                   │
│     - Full Name                         │
│     - Age                               │
│     - Height (cm)                       │
│     - Weight (kg)                       │
│     - Blood Type                        │
│                                         │
├─────────────────────────────────────────┤
│                                         │
│  5. MEDICAL INFORMATION                 │
│     - Medical Conditions                │
│     - Allergies                         │
│     - Current Medications               │
│                                         │
├─────────────────────────────────────────┤
│                                         │
│  6. MEDICAL REPORT ANALYSIS             │
│     - Upload medical report             │
│     - OCR analysis results              │
│                                         │
├─────────────────────────────────────────┤
│                                         │
│  7. EMERGENCY CONTACT                   │
│     - Contact Name                      │
│     - Phone Number                      │
│     - Email Address                     │
│     - Send Emergency Alert button       │
│                                         │
├─────────────────────────────────────────┤
│                                         │
│  8. WHATSAPP NOTIFICATIONS ⭐ NEW       │
│     - Phone Number for WhatsApp         │
│     - Format helper                     │
│     - Validation info                   │
│                                         │
├─────────────────────────────────────────┤
│                                         │
│  9. APP SETTINGS                        │
│     - Reset & Restart                   │
│     - Logout & Restart App button       │
│                                         │
├─────────────────────────────────────────┤
│                                         │
│  10. SAVE PROFILE BUTTON                │
│      - Saves all changes                │
│                                         │
└─────────────────────────────────────────┘
```

## WhatsApp Notifications Section Details

### Section Header
```
🔔 WhatsApp Notifications
```

### Content
```
┌─────────────────────────────────────────┐
│  📱 Phone Number for WhatsApp           │
│                                         │
│  Add your phone number to receive       │
│  health reminders and personalized      │
│  notifications via WhatsApp.            │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 📞 Phone Number                 │   │
│  │ +1234567890                     │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ℹ️  Format: +[country code][number]   │
│     Example: +1234567890               │
│                                         │
└─────────────────────────────────────────┘
```

## Color Scheme

- **Section Icon:** Green (Colors.green)
- **Background:** White with subtle shadow
- **Text:** Black87 (primary), Black54 (secondary)
- **Info Box:** Light green background with green text
- **Input Field:** Light purple background

## Interaction Flow

### Adding Phone Number

```
1. User opens Profile Screen
   ↓
2. Scrolls to "WhatsApp Notifications" section
   ↓
3. Enters phone number in format: +1234567890
   ↓
4. Clicks "Save Profile" button
   ↓
5. Phone number is validated
   ↓
6. If valid: Saved to database, success message shown
   If invalid: Error message shown
   ↓
7. User can now receive WhatsApp notifications
```

### Editing Phone Number

```
1. User opens Profile Screen
   ↓
2. Phone number is pre-filled from database
   ↓
3. User edits the phone number
   ↓
4. Clicks "Save Profile" button
   ↓
5. New phone number is saved
   ↓
6. Success message is shown
```

## Validation Messages

### Valid Phone Number
```
✅ +1234567890
✅ +919876543210
✅ +441234567890
```

### Invalid Phone Numbers
```
❌ 1234567890 → "Phone must start with +"
❌ +123 → "Invalid phone format"
❌ +12345678901234567 → "Invalid phone format"
❌ +1 234 567 890 → "Phone must start with +"
```

## Responsive Design

- **Mobile:** Full width input field
- **Tablet:** Maintains same layout
- **Desktop:** Maintains same layout

## Accessibility

- ✅ Clear labels for input fields
- ✅ Icon indicators for field type
- ✅ Validation error messages
- ✅ Info box with format example
- ✅ Keyboard type set to phone

## Integration Points

### Data Flow

```
Profile Screen
    ↓
API Service
    ↓
Backend API
    ↓
Database (db.json)
```

### API Calls

1. **Load Profile:**
   - `GET /api/user/{userId}/profile`
   - `GET /api/user/{userId}/phone-number`

2. **Save Profile:**
   - `POST /api/user/{userId}/profile`
   - `POST /api/user/{userId}/phone-number`

## User Experience

### First Time User
1. Opens profile
2. Sees empty phone number field
3. Enters phone number
4. Saves profile
5. Receives confirmation

### Returning User
1. Opens profile
2. Sees pre-filled phone number
3. Can edit if needed
4. Saves changes
5. Receives confirmation

## Performance

- Phone number loads with profile (no extra request)
- Phone number saves with profile (batched operation)
- Validation happens client-side (instant feedback)
- No blocking operations

## Future Enhancements

- [ ] Phone number verification via SMS
- [ ] Multiple phone numbers support
- [ ] Notification preferences toggle
- [ ] Quiet hours configuration
- [ ] Notification history
- [ ] Delivery status tracking

## Status

✅ **Implemented** - WhatsApp phone number section is now part of the profile screen
