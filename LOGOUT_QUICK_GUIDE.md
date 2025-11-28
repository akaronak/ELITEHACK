# 🚪 Logout & Restart - Quick Guide

## ✅ What's Fixed

Added a **Logout & Restart App** button that:
- Clears all app state
- Generates new user ID
- Returns to tracker selection screen
- Allows fresh start

## 📍 Where to Find It

**Profile Screen → Scroll Down → App Settings Section → "Logout & Restart App" button**

## 🎯 How to Use

1. Open any tracker (Pregnancy/Menstruation/Menopause)
2. Tap menu icon (☰) → Profile
3. Scroll down to "App Settings"
4. Tap "Logout & Restart App"
5. Confirm in dialog
6. ✅ Returns to tracker selection with new user ID

## 🔄 What Happens

### Before Logout:
- User: `demo_user_123`
- Tracker: Menstruation
- Data: All logs and settings

### After Logout:
- User: `user_1764314567890` (new ID)
- Tracker: None (choose again)
- Data: Fresh start

## 💾 Data Safety

✅ **Server data preserved** - Your logs are safe on the backend
✅ **Only local state cleared** - App just resets
✅ **Can recover** - Use same user ID to access old data

## 🎨 UI Preview

```
┌─────────────────────────────────────┐
│  App Settings                        │
│                                      │
│  Reset & Restart                     │
│  Clear all app data and restart     │
│  with fresh setup.                  │
│                                      │
│  ┌────────────────────────────────┐ │
│  │  🚪 Logout & Restart App       │ │
│  │  (Red outlined button)         │ │
│  └────────────────────────────────┘ │
└─────────────────────────────────────┘
```

## 🧪 Test It

1. **Test Logout:**
   ```
   Profile → App Settings → Logout & Restart App → Confirm
   ```
   ✅ Should return to tracker selection

2. **Test Cancel:**
   ```
   Profile → App Settings → Logout & Restart App → Cancel
   ```
   ✅ Should stay on profile screen

3. **Test Fresh Start:**
   ```
   Logout → Choose Menstruation → Complete setup
   ```
   ✅ Should work with new user ID

## 🐛 Troubleshooting

**Q: Button not visible?**
A: Scroll down in Profile screen to "App Settings" section

**Q: Error after logout?**
A: Check that track_selection_screen.dart exists

**Q: Lost my data?**
A: Server data is preserved. Only local app state cleared.

## 📝 Files Changed

1. ✅ `mensa/lib/main.dart` - Added route for track-selection
2. ✅ `mensa/lib/screens/profile_screen.dart` - Added logout button & logic

## 🎉 Benefits

- ✅ Easy testing of onboarding flows
- ✅ Switch between trackers cleanly
- ✅ Troubleshoot app issues
- ✅ Demo app to others
- ✅ Fresh start anytime

---

**Status:** ✅ Ready to use!

**Quick Access:** Profile → App Settings → Logout & Restart App
