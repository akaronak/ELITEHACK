# Firebase Service Account Setup 🔑

## Why You Need This

To send notifications from the Node.js server, you need a Firebase service account key. This allows the server to authenticate with Firebase Cloud Messaging (FCM).

## Quick Setup (2 Minutes)

### Step 1: Download Service Account Key

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **smensa-c9679**
3. Click the gear icon ⚙️ > **Project Settings**
4. Go to **Service Accounts** tab
5. Click **Generate New Private Key**
6. Click **Generate Key** (a JSON file will download)

### Step 2: Add to Server

1. Rename the downloaded file to: `firebase-service-account.json`
2. Move it to the `server` folder:
```
Mensa/
  server/
    firebase-service-account.json  ← Put it here
    test-notifications.js
    package.json
```

### Step 3: Restart Server

```bash
cd server
node test-notifications.js
```

You should see:
```
✅ Firebase Admin initialized with service account key
🚀 Notification test server running on port 3001
```

## Alternative: Use Environment Variable

If you don't want to commit the key file, you can use an environment variable:

1. Add to `server/.env`:
```env
FIREBASE_SERVICE_ACCOUNT_KEY=./path/to/firebase-service-account.json
```

2. Or set the full JSON as an environment variable:
```env
FIREBASE_SERVICE_ACCOUNT_KEY='{"type":"service_account","project_id":"smensa-c9679",...}'
```

## Security Notes

⚠️ **IMPORTANT:**
- Never commit `firebase-service-account.json` to Git
- Add it to `.gitignore`
- Keep it secure (it has admin access to your Firebase project)

The `.gitignore` already includes:
```
firebase-service-account.json
*-service-account.json
```

## Test It Works

After setup, test the notification:

```bash
# Add a test token
curl -X POST http://localhost:3001/add-test-token -H "Content-Type: application/json" -d "{\"token\":\"YOUR_FCM_TOKEN\"}"

# Send notification
curl -X POST http://localhost:3001/test-send-all
```

You should see:
```
✅ 1 notifications sent successfully
```

## Troubleshooting

**Error: "invalid-credential"**
- Service account key is missing or invalid
- Follow Step 1 again to download a fresh key

**Error: "ENOENT: no such file"**
- File is not in the correct location
- Make sure it's in the `server` folder

**Still not working?**
- Check the file name is exactly: `firebase-service-account.json`
- Verify the JSON file is valid (open it in a text editor)
- Restart the server after adding the file

## What's Next?

Once this works, you can:
- ✅ Send notifications from server to all users
- ✅ Schedule automatic period reminders
- ✅ Send health tips and daily check-ins
- ✅ Implement real-time notifications

The test server will work perfectly once the service account is configured!
