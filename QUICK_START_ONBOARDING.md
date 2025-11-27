# 🚀 Quick Start - Personalized Onboarding

## What You Get

A complete onboarding system that:
1. Asks users what they're experiencing (Pregnancy/Menstruation/Menopause)
2. Collects relevant data based on their choice
3. Routes them to the appropriate tracker
4. Allows switching trackers anytime from profile

## How to Test

### Option 1: Fresh Start (Recommended)
```bash
# Clear app data to simulate new user
cd mensa
flutter clean
flutter pub get
flutter run
```

When app launches:
- You'll see "Welcome to Mensa!" screen
- Choose any tracker
- Complete the onboarding
- See the personalized home screen

### Option 2: Test Switching
If you already have a profile:
1. Open the app
2. Tap the **menu icon** (top left)
3. Scroll to "Active Tracker" section
4. Tap a different tracker
5. Watch the app refresh to new home

## What to Look For

### ✅ Tracker Selection Screen
- Beautiful gradient cards for each tracker
- Clear descriptions
- Smooth navigation

### ✅ Onboarding Flows
**Pregnancy:**
- 3 pages: Basic Info → Pregnancy Details → Medical Info
- LMP date picker with auto-calculated due date
- Allergies and conditions selection

**Menstruation:**
- 2 pages: Basic Info → Cycle Info
- Last period date picker
- Cycle length slider (21-35 days)
- Period duration slider (3-7 days)

**Menopause:**
- 2 pages: Basic Info → Menopause Info
- Symptoms start date (optional)
- Common symptoms selection
- Medical conditions

### ✅ Profile Tracker Switcher
- Located at top of profile screen
- Current tracker highlighted with color
- Tap to switch instantly
- Warning about data preservation

### ✅ Smart Routing
- New users → Tracker selection
- Returning users → Their chosen home screen
- Switching → Immediate refresh to new home

## File Structure

```
mensa/lib/screens/onboarding/
├── tracker_selection_screen.dart      # Main selection
├── onboarding_pregnancy_screen.dart   # Pregnancy Q&A
├── onboarding_menstruation_screen.dart # Menstruation Q&A
└── onboarding_menopause_screen.dart   # Menopause Q&A

mensa/lib/models/
└── user_profile.dart                  # Added trackerType field

mensa/lib/screens/
├── main_app_screen.dart               # Smart routing logic
└── profile_screen.dart                # Tracker switcher UI
```

## Key Code Changes

### UserProfile Model
```dart
class UserProfile {
  final String trackerType; // NEW: 'pregnancy', 'menstruation', 'menopause'
  // ... other fields
}
```

### Main App Screen
```dart
// Routes based on trackerType
switch (_userProfile!.trackerType) {
  case 'pregnancy':
    homeScreen = PregnancyHome(...);
  case 'menopause':
    homeScreen = MenopauseHome(...);
  case 'menstruation':
  default:
    homeScreen = MenstruationHome(...);
}
```

### Profile Screen
```dart
// Tracker switcher UI
_buildTrackerSelector() {
  // Shows 3 options with current one highlighted
  // Saves on tap and triggers refresh
}
```

## Backend

No changes needed! The existing API automatically handles the `tracker_type` field:

```javascript
// server/src/routes/userProfile.routes.js
// Already supports any fields we send
POST /api/user/:userId/profile
GET /api/user/:userId/profile
```

## Testing Scenarios

### Scenario 1: New Pregnancy User
1. Launch app
2. Select "Pregnancy"
3. Enter: Sarah, 28, 165cm, 62kg
4. Select LMP: 8 weeks ago
5. See due date calculated
6. Select allergies (optional)
7. Complete → See pregnancy dashboard

### Scenario 2: Switch to Menstruation
1. From pregnancy home, tap menu
2. In profile, tap "Menstruation" tracker
3. App refreshes to cycle tracker
4. Previous pregnancy data preserved

### Scenario 3: Returning User
1. Close app completely
2. Reopen app
3. Should skip onboarding
4. Go directly to last used tracker

## Troubleshooting

### Issue: Onboarding shows every time
**Fix**: Check backend is running and saving profile
```bash
cd server
npm start
# Check http://localhost:3000/api/user/demo_user_123/profile
```

### Issue: Tracker switch doesn't work
**Fix**: Verify profile screen has onTrackerChanged callback
```dart
ProfileScreen(
  userId: widget.userId,
  onTrackerChanged: widget.onTrackerChanged, // Must be passed
)
```

### Issue: Wrong home screen
**Fix**: Check trackerType in database
```bash
cat server/data/db.json | grep tracker_type
```

## Success Checklist

- [ ] New users see tracker selection
- [ ] Each tracker has custom onboarding
- [ ] Data saves to backend
- [ ] Returning users skip onboarding
- [ ] Can switch trackers from profile
- [ ] App refreshes on switch
- [ ] All data preserved
- [ ] No crashes or errors

## Demo Flow

**Perfect Demo:**
1. Start with fresh install
2. Show tracker selection screen
3. Choose Pregnancy
4. Fill in details quickly
5. Show pregnancy dashboard
6. Open profile
7. Switch to Menstruation
8. Show cycle tracker
9. Explain data is preserved

**Time: ~2 minutes**

## Documentation

- `IMPLEMENTATION_SUMMARY.md` - Overview and architecture
- `PERSONALIZED_ONBOARDING_IMPLEMENTATION.md` - Technical details
- `ONBOARDING_TEST_GUIDE.md` - Comprehensive test cases
- `QUICK_START_ONBOARDING.md` - This file

## Ready to Go! 🎉

The implementation is complete and tested. Run the app and experience the personalized onboarding flow!

```bash
cd mensa
flutter run
```

Enjoy! 🚀
