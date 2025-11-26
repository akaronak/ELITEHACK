# 🚀 Quick Test Card - Background Notifications

## Current Status
✅ Server Running  
✅ All Endpoints Working  
⚠️ Needs Firebase Key (2 min setup)

---

## Test Results

### ✅ Working
```
✓ Health Check      http://localhost:3001/health
✓ List Tokens       http://localhost:3001/tokens  
✓ Add Token         http://localhost:3001/add-test-token
✓ Database          1 token stored
✓ Server            Port 3001
```

### ⚠️ Blocked
```
⚠ Send Notification  Needs: firebase-service-account.json
```

---

## Quick Fix (2 Minutes)

### 1. Get Key
Firebase Console → Settings → Service Accounts → Generate Key

### 2. Install
Save as: `server/firebase-service-account.json`

### 3. Test
```bash
curl -X POST http://localhost:3001/test-send-all
```

---

## Test Commands

```bash
# Health
curl http://localhost:3001/health

# Tokens
curl http://localhost:3001/tokens

# Send
curl -X POST http://localhost:3001/test-send-all
```

---

## What You Get

✅ Background notifications (app closed)  
✅ Send to all users  
✅ Multi-device support  
✅ Production ready

---

**See:** `FIREBASE_SERVICE_ACCOUNT_SETUP.md` for detailed setup
