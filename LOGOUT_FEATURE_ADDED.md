# 🚪 Logout & Restart Feature Added

## What Was Added

A **Logout & Restart** button in the Profile screen that allows users to:
- Clear all local app data
- Reset all trackers
- Return to tracker selection screen
- Start fresh with new setup and new user ID

## Location

**Profile Screen → App Settings Section → "Logout & Restart App" button**

## How It Works

### 1. User Flow
```
Profile Screen
  ↓
Click "Logout & Restart App" button
  ↓
Confirmation dialog shows:
  • What will happen
  • Data preservation info
  • Confirmation prompt
  ↓
User confirms
  ↓
Loading indicator
  ↓
Navigate to Track Selection Screen
  ↓
Success message
  ↓
User can choose tracker and start fresh setup with new user ID
```

### 2. What Gets Reset
- ✅ Local app state
- ✅ Current tracker selection
- ✅ Navigation stack (all screens cleared)
- ✅ Returns to onboarding

### 3. What's Preserved
- ✅ Server data (all logs, profiles, etc.)
- ✅ User can log back in anytime
- ✅ No data loss on backend

## UI Design

### App Settings Card
```
┌─────────────────────────────────────────┐
│  ⚙️  App Settings                        │
│                                          │
│  Reset & Restart                         │
│  Clear all app data and restart with    │
│  fresh setup. This will log you out     │
│  and reset all trackers.                │
│                                          │
│  ┌────────────────────────────────────┐ │
│  │  🚪 Logout & Restart App           │ │
│  └────────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

### Confirmation Dialog
```
┌─────────────────────────────────────────┐
│  🚪 Logout & Restart                     │
│                                          │
│  This will:                              │
│  • Clear all local app data             │
│  • Reset all trackers                   │
│  • Return to onboarding screen          │
│  • Require fresh setup                  │
│                                          │
│  Your data on the server will be        │
│  preserved. You can log back in         │
│  anytime.                                │
│                                          │
│  Are you sure you want to continue?     │
│                                          │
│  [Cancel]  [Logout & Restart]           │
└─────────────────────────────────────────┘
```

## Code Changes

### 1. Profile Screen (`mensa/lib/screens/profile_screen.dart`)

**Added method:**
```dart
Future<void> _showLogoutDialog() async {
  // Shows confirmation dialog
  // Handles logout flow
  // Navigates to onboarding
}
```

**Added UI section:**
```dart
// App Settings Section
_buildInfoCard(
  icon: Icons.settings,
  iconColor: Colors.blue,
  children: [
    // Description
    // Logout button
  ],
)
```

### 2. Main App (`mensa/lib/main.dart`)

**Added routes:**
```dart
routes: {
  '/': (context) => MainAppScreen(...),
  '/onboarding': (context) => OnboardingScreen(),
}
```

**Added import:**
```dart
import 'screens/onboarding_screen.dart';
```

## Use Cases

### 1. Testing New Features
Developer wants to test onboarding flow:
1. Go to Profile
2. Click "Logout & Restart App"
3. Test onboarding from scratch

### 2. Switching Users
User wants to switch accounts:
1. Logout from current account
2. Start fresh setup
3. Enter new user data

### 3. Resetting Tracker
User wants to change tracker type completely:
1. Logout to reset
2. Choose different tracker in onboarding
3. Fresh start with new tracker

### 4. Troubleshooting
App has issues, user wants fresh start:
1. Logout to clear state
2. Restart with clean slate
3. Reconfigure everything

## Safety Features

### 1. Confirmation Dialog
- ✅ Clear explanation of what will happen
- ✅ Warning about data reset
- ✅ Reassurance about server data
- ✅ Cancel option

### 2. Data Preservation
- ✅ Server data NOT deleted
- ✅ Only local state cleared
- ✅ User can recover by logging back in

### 3. Visual Feedback
- ✅ Loading indicator during logout
- ✅ Success message after completion
- ✅ Smooth navigation transition

## Testing Checklist

### Test 1: Basic Logout
- [ ] Open Profile screen
- [ ] Scroll to "App Settings"
- [ ] Click "Logout & Restart App"
- [ ] Verify confirmation dialog appears
- [ ] Click "Logout & Restart"
- [ ] Verify loading indicator shows
- [ ] Verify navigates to onboarding
- [ ] Verify success message shows

### Test 2: Cancel Logout
- [ ] Click "Logout & Restart App"
- [ ] Click "Cancel" in dialog
- [ ] Verify stays on Profile screen
- [ ] Verify no data changed

### Test 3: Data Preservation
- [ ] Note current user data
- [ ] Logout and restart
- [ ] Complete onboarding with same user ID
- [ ] Verify server data still exists

### Test 4: Fresh Setup
- [ ] Logout and restart
- [ ] Complete onboarding with new tracker
- [ ] Verify fresh setup works
- [ ] Verify no old data interferes

## Future Enhancements

### Potential Additions:
1. **Clear Cache Only** - Option to clear cache without full logout
2. **Export Data** - Export user data before logout
3. **Multiple Accounts** - Switch between accounts without logout
4. **Backup Reminder** - Remind to backup before logout
5. **Logout Timer** - Auto-logout after inactivity

## Troubleshooting

### Issue: Button not visible
**Solution:** Scroll down in Profile screen to "App Settings" section

### Issue: Onboarding not showing
**Solution:** Check routes are properly configured in main.dart

### Issue: Data lost after logout
**Solution:** This is expected - logout clears local data. Server data is preserved.

### Issue: Can't cancel logout
**Solution:** Click "Cancel" button in confirmation dialog before confirming

## Summary

✅ **Added:** Logout & Restart button in Profile screen
✅ **Location:** Profile → App Settings → Logout button
✅ **Function:** Clears local data, returns to onboarding
✅ **Safety:** Confirmation dialog, server data preserved
✅ **Use Case:** Testing, switching users, troubleshooting

---

**Status:** ✅ Feature complete and ready to use!

**To use:** Go to Profile screen → Scroll to "App Settings" → Click "Logout & Restart App"
