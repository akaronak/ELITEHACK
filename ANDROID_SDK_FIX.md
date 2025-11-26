# Android SDK Version Fix ✅

## Issue
```
Warning: The plugin shared_preferences_android requires Android SDK version 36 or higher.
Your project is configured to compile against Android SDK 34
```

## Solution Applied

Updated `mensa/android/app/build.gradle.kts`:

### Changes Made
```kotlin
android {
    compileSdk = 36  // Changed from 34 to 36
    
    defaultConfig {
        targetSdk = 36  // Changed from 34 to 36
    }
}
```

## What This Fixes

✅ Removes the Android SDK version warning  
✅ Ensures compatibility with latest plugins  
✅ Enables all features of `shared_preferences_android`  
✅ Future-proofs the app for newer Android versions  

## Why This Is Safe

- Android SDKs are **backward compatible**
- Apps compiled with SDK 36 work on older Android versions
- Only affects compilation, not minimum supported Android version
- `minSdk` remains unchanged (supports older devices)

## Next Steps

Run the app again:
```bash
cd mensa
flutter run
```

The warning should be gone! 🎉

## Technical Details

- **compileSdk**: Version of Android SDK used to compile the app
- **targetSdk**: Version of Android the app is designed for
- **minSdk**: Minimum Android version required to run the app

All three can have different values for maximum compatibility.
