# Test Background Notifications 🚀

## Quick Start (3 Steps)

### Step 1: Start Test Server
```bash
cd server
node test-notifications.js
```

Or use the batch file:
```bash
cd server
test-notification.bat
```

### Step 2: Get FCM Token from App
1. Run your Flutter app
2. Look in the console for:
```
📱 FCM Token: c-OPhdCQTYuxWdHlAZwkk6:APA91bGb_FuVMC98hh2K6qnCCFQ4exf19tutbyu3vGg1_-obF3xE5zflNBhVnnrqL0NUBn1ljktUsNXsPIwqYdOmjasZ5rxFq-gIiEczxbthxaZOd-Hb2fE
```
3. Copy the entire token

### Step 3: Test It!

**Add your token:**
```bash
curl -X POST http://localhost:3001/add-test-token -H "Content-Type: application/json" -d "{\"token\": \"YOUR_FCM_TOKEN_HERE\"}"
```

**Send notification to all:**
```bash
curl -X POST http://localhost:3001/test-send-all
```

## What You'll See

✅ **Notification appears on your device**
✅ **Works even when app is closed**
✅ **Title:** "🌸 Server Test Notification"
✅ **Body:** "This notification was sent from the Node.js server! Background notifications are working! 🎉"

## API Endpoints

### 📱 Add Token
```http
POST http://localhost:3001/add-test-token
Content-Type: application/json

{
  "token": "your-fcm-token-here"
}
```

### 🚀 Send to All
```http
POST http://localhost:3001/test-send-all
```

### 📋 List Tokens
```http
GET http://localhost:3001/tokens
```

### ❤️ Health Check
```http
GET http://localhost:3001/health
```

## Testing Scenarios

### ✅ App Open (Foreground)
- Keep app open
- Send notification
- Should appear in system tray

### ✅ App Closed (Background)
- Close app completely
- Send notification
- Should appear in system tray
- Tap to open app

### ✅ App Minimized
- Minimize app
- Send notification
- Should appear normally

## Troubleshooting

**No notification received?**
1. Check token is added: `curl http://localhost:3001/tokens`
2. Check server logs for errors
3. Verify notifications enabled on device
4. Check Firebase project ID in .env

**Server error?**
- Ensure Firebase is configured in .env
- Check FIREBASE_PROJECT_ID is set
- Verify google-services.json is in place

## Success! 🎉

When you see the notification on your device, background notifications are working!
