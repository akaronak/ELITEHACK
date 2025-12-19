# 🎁 How to Create Sample Vouchers

## Quick Start

### Step 1: Make sure your server is running
```bash
cd server
npm start
```

The server should be running on `http://localhost:3000`

### Step 2: Run the voucher creation script
```bash
cd server
node create-sample-vouchers.js
```

### Expected Output
```
🎁 Creating sample vouchers...

✅ Created: 10% Health Store Discount
   Code: HEALTH_10
   Points Required: 100
   Category: health

✅ Created: Free Yoga Class
   Code: WELLNESS_YOGA
   Points Required: 150
   Category: wellness

✅ Created: Nutrition Consultation
   Code: NUTRITION_MEAL
   Points Required: 200
   Category: nutrition

... (and 9 more vouchers)

✨ Sample vouchers creation complete!
```

---

## What Gets Created

### 12 Sample Vouchers:

1. **10% Health Store Discount** (100 pts)
2. **Free Yoga Class** (150 pts)
3. **Nutrition Consultation** (200 pts)
4. **1 Month Gym Membership** (250 pts)
5. **Mental Health Session** (180 pts)
6. **Organic Produce Box** (120 pts)
7. **3 Months Premium Meditation App** (140 pts)
8. **Premium Vitamin Pack** (130 pts)
9. **Spa Massage Session** (170 pts)
10. **Healthy Cooking Class** (160 pts)
11. **5 Pilates Classes** (110 pts)
12. **Smart Sleep Tracker Device** (220 pts)

---

## Verify Vouchers Were Created

### Option 1: Check via API
```bash
curl http://localhost:3000/api/voucher/available
```

You should see all 12 vouchers in the response.

### Option 2: Check in the App
1. Open the Mensa app
2. Navigate to Voucher screen
3. You should see all 12 vouchers listed

---

## Manual Voucher Creation

If you want to create a custom voucher manually:

```bash
curl -X POST http://localhost:3000/api/voucher/admin/create \
  -H "Content-Type: application/json" \
  -d '{
    "code": "CUSTOM_CODE",
    "title": "Your Voucher Title",
    "description": "Your voucher description",
    "points_required": 150,
    "discount_percentage": 20,
    "discount_amount": 0,
    "category": "health",
    "validity_end": "2025-03-20T23:59:59Z",
    "max_redemptions": 50
  }'
```

---

## Voucher Categories

Valid categories:
- `health` - Health products and services
- `wellness` - Wellness and relaxation
- `nutrition` - Food and nutrition
- `fitness` - Fitness and exercise
- `mental_health` - Mental health services
- `other` - Other categories

---

## Testing the System

### Step 1: Create a test user and add logs
1. Open the app
2. Create an account or login
3. Add daily logs for 5 days
4. You should earn 50 points

### Step 2: Purchase a voucher
1. Go to Voucher screen
2. Click on "10% Health Store Discount" (100 pts)
3. You'll see "Insufficient Points" (need 100, have 50)

### Step 3: Add more logs
1. Add 5 more daily logs
2. Now you have 100 points
3. Go back to Voucher screen
4. Click "Purchase" on "10% Health Store Discount"
5. Points deducted, voucher added to "My Vouchers"

### Step 4: Redeem voucher
1. Go to "My Vouchers" tab
2. Click "Redeem Now"
3. Voucher status changes to "Redeemed"

---

## Troubleshooting

### Issue: "Cannot find module 'axios'"
**Solution**: Install axios
```bash
cd server
npm install axios
```

### Issue: "Server not running"
**Solution**: Start the server first
```bash
cd server
npm start
```

### Issue: "Vouchers not appearing in app"
**Solution**: 
1. Restart the app
2. Clear app cache
3. Refresh the voucher screen

### Issue: "Error creating vouchers"
**Solution**:
1. Check server logs for errors
2. Verify database is running
3. Check if voucher codes already exist

---

## Voucher Points Guide

### How to Earn Points
- Add daily log: +10 points
- Maintain streak: +10 points per day
- Day 1: 10 points
- Day 5: 50 points
- Day 10: 100 points
- Day 15: 150 points
- Day 20: 200 points
- Day 25: 250 points

### Cheapest Vouchers
1. 5 Pilates Classes (110 pts)
2. 10% Health Store Discount (100 pts)
3. Organic Produce Box (120 pts)

### Most Expensive Vouchers
1. 1 Month Gym Membership (250 pts)
2. Smart Sleep Tracker Device (220 pts)
3. Nutrition Consultation (200 pts)

---

## Sample User Journey

```
Day 1: User logs symptoms
  → Streak: 1, Points: 10

Day 2: User logs symptoms
  → Streak: 2, Points: 20

Day 3: User logs symptoms
  → Streak: 3, Points: 30

Day 4: User logs symptoms
  → Streak: 4, Points: 40

Day 5: User logs symptoms
  → Streak: 5, Points: 50

Day 6: User logs symptoms
  → Streak: 6, Points: 60

Day 7: User logs symptoms
  → Streak: 7, Points: 70

Day 8: User logs symptoms
  → Streak: 8, Points: 80

Day 9: User logs symptoms
  → Streak: 9, Points: 90

Day 10: User logs symptoms
  → Streak: 10, Points: 100
  → Can now purchase "10% Health Store Discount"!

Day 11: User logs symptoms
  → Streak: 11, Points: 110
  → Can now purchase "5 Pilates Classes"!

Day 15: User logs symptoms
  → Streak: 15, Points: 150
  → Can now purchase "Free Yoga Class"!

Day 20: User logs symptoms
  → Streak: 20, Points: 200
  → Can now purchase "Nutrition Consultation"!

Day 25: User logs symptoms
  → Streak: 25, Points: 250
  → Can now purchase "1 Month Gym Membership"!
```

---

## Next Steps

1. ✅ Run the voucher creation script
2. ✅ Verify vouchers appear in the app
3. ✅ Test purchasing a voucher
4. ✅ Test redeeming a voucher
5. ✅ Monitor user engagement
6. ✅ Adjust voucher values based on feedback

---

## Support

For issues or questions:
1. Check the SAMPLE_VOUCHERS.md file for voucher details
2. Review the AUTOMATIC_STREAK_IMPLEMENTATION.md for streak logic
3. Check server logs for errors
4. Verify database is running

---

**Ready to create vouchers! 🎉**

Run: `node create-sample-vouchers.js`
