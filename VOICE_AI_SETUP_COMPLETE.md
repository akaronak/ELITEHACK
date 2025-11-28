# Voice AI Setup Complete ✅

## What Was Fixed

1. **HTTPS Server**: Created custom HTTPS server with self-signed SSL certificates for microphone access
2. **Port Configuration**: Changed from port 3001 to 3002 to avoid conflicts
3. **Backend Agent**: Started LiveKit Python agent with all required models downloaded
4. **Flutter App**: Updated to use HTTPS URL

## Servers Running

### Frontend (Voice AI Interface)
- **URL**: https://10.10.136.37:3002
- **Local**: https://localhost:3002
- **Status**: ✅ Running with HTTPS
- **Process ID**: 7

### Backend (LiveKit Agent)
- **Status**: ✅ Connected to LiveKit Cloud
- **Region**: India West
- **Process ID**: 8

## How to Test

### From Flutter App:
1. Open the Mensa app
2. Navigate to Pregnancy Dashboard
3. Tap the "Voice AI" button
4. Your browser will open to https://10.10.136.37:3002
5. **Accept the self-signed certificate warning** (this is normal for development)
6. Click "Start call" button
7. **Allow microphone access** when prompted
8. Start speaking to the pregnancy companion AI

### Certificate Warning:
When you first open the URL, you'll see a security warning because we're using a self-signed certificate. This is expected for development:
- Chrome: Click "Advanced" → "Proceed to 10.10.136.37 (unsafe)"
- Edge: Click "Advanced" → "Continue to 10.10.136.37 (unsafe)"
- Firefox: Click "Advanced" → "Accept the Risk and Continue"

## Microphone Access

The microphone will now work because:
1. ✅ Using HTTPS (required by browsers for mic access)
2. ✅ SSL certificates generated with correct IP address
3. ✅ LiveKit agent connected and ready
4. ✅ Frontend properly configured

## Troubleshooting

### If microphone doesn't work:
1. Check browser permissions: Settings → Privacy → Microphone
2. Make sure you clicked "Allow" when prompted
3. Try refreshing the page
4. Check that both servers are still running (see process IDs above)

### If certificate error persists:
1. Clear browser cache
2. Close and reopen browser
3. Try a different browser

### To restart servers:
```powershell
# Stop processes
Stop-Process -Id 7, 8 -Force

# Start frontend
cd HackHerth/ten-days-of-voice-agents-2025/frontend
pnpm run dev:https

# Start backend
cd HackHerth/ten-days-of-voice-agents-2025/backend
uv run src/agent.py dev
```

## Files Modified

1. `mensa/lib/screens/dashboard_screen.dart` - Updated Voice AI URL to HTTPS
2. `HackHerth/ten-days-of-voice-agents-2025/frontend/server-https.js` - Created HTTPS server
3. `HackHerth/ten-days-of-voice-agents-2025/frontend/generate-cert.js` - SSL certificate generator
4. `HackHerth/ten-days-of-voice-agents-2025/frontend/next.config.ts` - Cleaned up config
5. `HackHerth/ten-days-of-voice-agents-2025/frontend/package.json` - Added dev:https script

## Next Steps

The Voice AI companion is now ready to use! It will:
- Listen to your voice input
- Respond with natural speech
- Track pregnancy symptoms, emotions, and tasks
- Provide supportive guidance
- Save journal entries
- Create Todoist reminders (if configured)
