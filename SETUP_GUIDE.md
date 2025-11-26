# 🚀 Complete Setup Guide - Mensa Pregnancy Tracker

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Backend Setup](#backend-setup)
3. [Frontend Setup](#frontend-setup)
4. [Firebase Configuration](#firebase-configuration)
5. [Testing](#testing)
6. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Software

#### 1. Flutter SDK
```bash
# Check if Flutter is installed
flutter --version

# Should show Flutter 3.9.2 or higher
```

**Installation:**
- Windows: Download from [flutter.dev](https://flutter.dev/docs/get-started/install/windows)
- macOS: `brew install flutter`
- Linux: Follow [official guide](https://flutter.dev/docs/get-started/install/linux)

#### 2. Node.js & npm
```bash
# Check if Node.js is installed
node --version  # Should be v16.x or higher
npm --version   # Should be v8.x or higher
```

**Installation:**
- Download from [nodejs.org](https://nodejs.org/)
- Or use nvm: `nvm install 16`

#### 3. Code Editor
- **VS Code** (recommended) with extensions:
  - Flutter
  - Dart
  - ESLint
- **Android Studio** (for Android development)
- **Xcode** (for iOS development on macOS)

#### 4. Mobile Development Tools

**For Android:**
```bash
# Install Android Studio
# Configure Android SDK
flutter doctor --android-licenses
```

**For iOS (macOS only):**
```bash
# Install Xcode from App Store
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

---

## Backend Setup

### Step 1: Navigate to Server Directory
```bash
cd server
```

### Step 2: Install Dependencies
```bash
npm install
```

This installs:
- express (web framework)
- cors (cross-origin requests)
- body-parser (request parsing)
- mongoose (MongoDB ODM)
- dotenv (environment variables)
- firebase-admin (push notifications)

### Step 3: Configure Environment Variables
```bash
# Copy example env file
cp .env.example .env
```

Edit `.env`:
```env
PORT=3000
MONGODB_URI=mongodb://localhost:27017/mensa_pregnancy
GEMINI_API_KEY=your_gemini_api_key_here
FIREBASE_PROJECT_ID=your_firebase_project_id
```

### Step 4: Start the Server

**Development mode (with auto-reload):**
```bash
npm run dev
```

**Production mode:**
```bash
npm start
```

### Step 5: Verify Server is Running
```bash
# Test health endpoint
curl http://localhost:3000/health
```

Expected response:
```json
{
  "status": "OK",
  "message": "Mensa Pregnancy Tracker API is running"
}
```

---

## Frontend Setup

### Step 1: Navigate to Flutter Project
```bash
cd mensa
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

This installs:
- http (API calls)
- provider (state management)
- shared_preferences (local storage)
- intl (date formatting)
- firebase_core & firebase_messaging (notifications)
- fl_chart (health charts)
- lottie (animations)

### Step 3: Configure API Base URL

Edit `lib/services/api_service.dart`:

**For Android Emulator:**
```dart
static const String baseUrl = 'http://10.0.2.2:3000/api';
```

**For iOS Simulator:**
```dart
static const String baseUrl = 'http://localhost:3000/api';
```

**For Physical Device:**
```dart
static const String baseUrl = 'http://YOUR_COMPUTER_IP:3000/api';
```

To find your IP:
- Windows: `ipconfig`
- macOS/Linux: `ifconfig` or `ip addr`

### Step 4: Run the App

**Check connected devices:**
```bash
flutter devices
```

**Run on specific device:**
```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Chrome (web)
flutter run -d chrome
```

**Hot reload during development:**
- Press `r` in terminal
- Or save files in VS Code with hot reload enabled

---

## Firebase Configuration

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add project"
3. Enter project name: "Mensa Pregnancy Tracker"
4. Enable Google Analytics (optional)
5. Create project

### Step 2: Add Android App

1. Click "Add app" → Android icon
2. Enter package name: `com.example.mensa` (or your package name)
3. Download `google-services.json`
4. Place in `mensa/android/app/`

**Update `android/build.gradle`:**
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```

**Update `android/app/build.gradle`:**
```gradle
apply plugin: 'com.google.gms.google-services'
```

### Step 3: Add iOS App (macOS only)

1. Click "Add app" → iOS icon
2. Enter bundle ID: `com.example.mensa`
3. Download `GoogleService-Info.plist`
4. Open Xcode: `open ios/Runner.xcworkspace`
5. Drag `GoogleService-Info.plist` into Runner folder

### Step 4: Enable Cloud Messaging

1. In Firebase Console → Project Settings
2. Go to "Cloud Messaging" tab
3. Note the Server Key (for backend)

### Step 5: Update Backend with FCM

Edit `server/.env`:
```env
FIREBASE_PROJECT_ID=your-project-id
```

Download service account key:
1. Firebase Console → Project Settings → Service Accounts
2. Click "Generate new private key"
3. Save as `server/firebase-service-account.json`

---

## Testing

### Backend API Tests

**Test User Profile:**
```bash
# Create profile
curl -X POST http://localhost:3000/api/user/test_user/pregnancy \
  -H "Content-Type: application/json" \
  -d '{
    "lmp_date": "2024-09-01T00:00:00.000Z",
    "due_date": "2025-06-08T00:00:00.000Z",
    "allergies": ["lactose"],
    "preferences": ["vegetarian"]
  }'

# Get profile
curl http://localhost:3000/api/user/test_user/pregnancy
```

**Test Symptom Analysis:**
```bash
curl -X POST http://localhost:3000/api/ai/symptom-analysis \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test_user",
    "symptoms": ["nausea", "fatigue"],
    "week": 8
  }'
```

**Test Chat:**
```bash
curl -X POST http://localhost:3000/api/ai/chat \
  -H "Content-Type: application/json" \
  -d '{
    "userId": "test_user",
    "message": "I am feeling stressed",
    "context": {"week": 12}
  }'
```

### Flutter App Tests

**Run unit tests:**
```bash
cd mensa
flutter test
```

**Run integration tests:**
```bash
flutter test integration_test/
```

---

## Troubleshooting

### Common Issues

#### 1. "Unable to connect to server"

**Solution:**
- Verify server is running: `curl http://localhost:3000/health`
- Check firewall settings
- Use correct IP address for physical devices
- For Android emulator, use `10.0.2.2` instead of `localhost`

#### 2. "Package not found" errors

**Solution:**
```bash
cd mensa
flutter clean
flutter pub get
```

#### 3. "Gradle build failed" (Android)

**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter run
```

#### 4. "Pod install failed" (iOS)

**Solution:**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter run
```

#### 5. Firebase initialization error

**Solution:**
- Verify `google-services.json` is in `android/app/`
- Verify `GoogleService-Info.plist` is in Xcode project
- Check package name matches Firebase configuration
- Run `flutter clean` and rebuild

#### 6. CORS errors in API

**Solution:**
Backend already has CORS enabled. If issues persist, check:
```javascript
// server/src/app.js
app.use(cors({
  origin: '*', // Change to specific origin in production
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
}));
```

#### 7. "Module not found" in Node.js

**Solution:**
```bash
cd server
rm -rf node_modules package-lock.json
npm install
```

---

## Development Workflow

### 1. Start Backend
```bash
cd server
npm run dev
```

### 2. Start Flutter App
```bash
cd mensa
flutter run
```

### 3. Make Changes
- Edit code
- Save files
- Hot reload automatically applies changes

### 4. Test Changes
- Use app on device/emulator
- Check API responses in terminal
- Monitor logs

---

## Production Deployment

### Backend Deployment

**Option 1: Heroku**
```bash
cd server
heroku create mensa-pregnancy-api
git push heroku main
```

**Option 2: AWS EC2**
1. Launch EC2 instance
2. Install Node.js
3. Clone repository
4. Run with PM2: `pm2 start src/app.js`

**Option 3: DigitalOcean**
1. Create droplet
2. Setup Node.js environment
3. Use nginx as reverse proxy

### Frontend Deployment

**Android:**
```bash
flutter build apk --release
# APK location: build/app/outputs/flutter-apk/app-release.apk
```

**iOS:**
```bash
flutter build ios --release
# Open Xcode and archive for App Store
```

**Web:**
```bash
flutter build web --release
# Deploy build/web/ to hosting service
```

---

## Environment-Specific Configuration

### Development
```dart
// lib/config/environment.dart
class Environment {
  static const String apiUrl = 'http://localhost:3000/api';
  static const bool enableLogging = true;
}
```

### Production
```dart
class Environment {
  static const String apiUrl = 'https://api.mensa.com/api';
  static const bool enableLogging = false;
}
```

---

## Next Steps

1. ✅ Complete setup following this guide
2. ✅ Test all features
3. ✅ Configure Firebase notifications
4. ✅ Customize branding and colors
5. ✅ Add your Gemini API key for enhanced AI
6. ✅ Deploy to staging environment
7. ✅ Conduct user testing
8. ✅ Deploy to production

---

## Support

For issues:
1. Check this troubleshooting guide
2. Review API documentation
3. Check Flutter/Node.js logs
4. Open GitHub issue with details

---

**Happy Coding! 🚀**
