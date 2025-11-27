# 🧪 Onboarding Flow - Testing Guide

## Quick Test Steps

### Test 1: First Time User - Pregnancy
1. Clear app data or use new user ID
2. Launch app
3. Should see "Welcome to Mensa!" screen
4. Tap **Pregnancy** card
5. Fill in:
   - Name: "Sarah Johnson"
   - Age: 28
   - Height: 165 cm
   - Weight: 62 kg
6. Tap **Next**
7. Select Last Menstrual Period date (e.g., 2 months ago)
8. See calculated due date
9. Tap **Next**
10. Select allergies and conditions (optional)
11. Tap **Complete Setup**
12. ✅ Should route to Pregnancy Home with dashboard

### Test 2: First Time User - Menstruation
1. Clear app data or use new user ID
2. Launch app
3. Tap **Menstruation** card
4. Fill in basic info
5. Tap **Next**
6. Select last period start date
7. Adjust cycle length slider (default 28 days)
8. Adjust period duration slider (default 5 days)
9. Tap **Complete Setup**
10. ✅ Should route to Menstruation Home with cycle tracker

### Test 3: First Time User - Menopause
1. Clear app data or use new user ID
2. Launch app
3. Tap **Menopause** card
4. Fill in basic info (age 45-65)
5. Tap **Next**
6. Optionally select when symptoms started
7. Select common symptoms
8. Select medical conditions
9. Tap **Complete Setup**
10. ✅ Should route to Menopause Home

### Test 4: Tracker Switching
1. Complete onboarding for any tracker
2. Tap **menu icon** (top left)
3. Opens Profile screen
4. See "Active Tracker" section at top
5. Current tracker should be highlighted
6. Tap a different tracker option
7. ✅ App should save and refresh to new home screen
8. Verify menu icon still works
9. Check that previous data is preserved

### Test 5: Returning User
1. Complete onboarding
2. Close app completely
3. Reopen app
4. ✅ Should skip onboarding and go directly to home screen
5. ✅ Should load correct tracker based on profile

### Test 6: Profile Data Persistence
1. Complete onboarding with full details
2. Go to Profile (menu icon)
3. Verify all data is displayed correctly
4. Edit some fields
5. Tap Save
6. Close and reopen app
7. Go to Profile again
8. ✅ All changes should be persisted

### Test 7: AI Context Awareness
1. Complete onboarding for Pregnancy
2. Open AI Chat
3. Ask: "What should I eat?"
4. ✅ AI should respond with pregnancy-specific advice
5. Switch to Menstruation tracker
6. Ask same question
7. ✅ AI should respond with menstruation-specific advice

## Expected Behaviors

### Tracker Selection Screen
- ✅ Shows 3 beautiful gradient cards
- ✅ Each card has icon, title, description
- ✅ Tapping card navigates to specific onboarding
- ✅ Back button returns to selection

### Onboarding Screens
- ✅ Progress indicator shows current page
- ✅ Form validation works (required fields)
- ✅ Back button navigates to previous page
- ✅ Next button validates before proceeding
- ✅ Complete Setup saves data and routes to home

### Profile Tracker Switcher
- ✅ Current tracker is highlighted with color
- ✅ Other trackers are grayed out
- ✅ Tapping tracker saves immediately
- ✅ App refreshes to new home screen
- ✅ Warning message about data preservation shown

### Home Screen Routing
- ✅ Pregnancy → Shows dashboard with week info
- ✅ Menstruation → Shows cycle tracker with predictions
- ✅ Menopause → Shows symptom tracker with insights

## Common Issues & Solutions

### Issue: Onboarding shows every time
**Solution**: Check that profile is being saved to backend. Verify API endpoint is working.

### Issue: Tracker switch doesn't refresh app
**Solution**: Ensure `onTrackerChanged` callback is passed through all screens.

### Issue: Data not persisting
**Solution**: Check backend database file permissions. Verify API routes are working.

### Issue: Wrong home screen after switch
**Solution**: Verify `trackerType` field is being saved correctly in profile.

## Backend Verification

### Check User Profile
```bash
# View database file
cat server/data/db.json | grep -A 20 "userProfiles"
```

Should see:
```json
{
  "user_id": "demo_user_123",
  "name": "Sarah Johnson",
  "tracker_type": "pregnancy",
  ...
}
```

### Check Pregnancy Data
```bash
cat server/data/db.json | grep -A 10 "userPregnancies"
```

### Check Cycle Data
```bash
cat server/data/db.json | grep -A 10 "menstruationLogs"
```

## API Testing

### Get User Profile
```bash
curl http://localhost:3000/api/user/demo_user_123/profile
```

### Update Tracker Type
```bash
curl -X POST http://localhost:3000/api/user/demo_user_123/profile \
  -H "Content-Type: application/json" \
  -d '{"tracker_type": "menstruation"}'
```

## Success Criteria
- ✅ New users see tracker selection
- ✅ Each tracker has custom onboarding
- ✅ Data saves to backend correctly
- ✅ Returning users skip onboarding
- ✅ Users can switch trackers anytime
- ✅ All data is preserved
- ✅ AI receives correct context
- ✅ No crashes or errors

## Performance Checks
- ⚡ Onboarding loads in < 1 second
- ⚡ Tracker switch refreshes in < 2 seconds
- ⚡ Profile data loads in < 1 second
- ⚡ No memory leaks on repeated switches

## Accessibility
- ♿ All buttons have proper labels
- ♿ Form fields have clear labels
- ♿ Error messages are descriptive
- ♿ Color contrast meets WCAG standards

## Ready to Test!
Run the app and follow the test steps above. Report any issues found.
