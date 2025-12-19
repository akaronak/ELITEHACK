# 🎁 Sample Vouchers Catalog

## Overview

Here are 12 sample vouchers that can be redeemed with points earned from daily streaks. Each voucher offers real value to users and encourages consistent health tracking.

---

## 💚 Health & Wellness Vouchers

### 1. 10% Health Store Discount
- **Code**: `HEALTH_10`
- **Points Required**: 100
- **Discount**: 10% off health products
- **Category**: Health
- **Max Redemptions**: 50
- **Validity**: 90 days
- **Description**: Get 10% off on health and wellness products at partner stores

### 2. Organic Produce Box
- **Code**: `ORGANIC_BOX`
- **Points Required**: 120
- **Discount**: 15% off
- **Category**: Health
- **Max Redemptions**: 60
- **Validity**: 90 days
- **Description**: Get a box of fresh organic vegetables and fruits delivered to your home

### 3. Premium Vitamin Pack
- **Code**: `VITAMIN_PACK`
- **Points Required**: 130
- **Discount**: 20% off
- **Category**: Health
- **Max Redemptions**: 80
- **Validity**: 90 days
- **Description**: Monthly supply of essential vitamins and supplements

### 4. Smart Sleep Tracker Device
- **Code**: `SLEEP_TRACKER`
- **Points Required**: 220
- **Discount**: $120 value
- **Category**: Health
- **Max Redemptions**: 20
- **Validity**: 90 days
- **Description**: Advanced wearable device to track your sleep patterns and improve sleep quality

---

## 🧘 Wellness & Relaxation Vouchers

### 5. Free Yoga Class
- **Code**: `WELLNESS_YOGA`
- **Points Required**: 150
- **Discount**: $50 value
- **Category**: Wellness
- **Max Redemptions**: 100
- **Validity**: 90 days
- **Description**: Redeem for a free 60-minute yoga session at premium studios

### 6. Spa Massage Session
- **Code**: `SPA_MASSAGE`
- **Points Required**: 170
- **Discount**: $90 value
- **Category**: Wellness
- **Max Redemptions**: 35
- **Validity**: 90 days
- **Description**: Relaxing 60-minute full body massage at premium spa facilities

### 7. 3 Months Premium Meditation App
- **Code**: `MEDITATION_APP`
- **Points Required**: 140
- **Discount**: $60 value
- **Category**: Mental Health
- **Max Redemptions**: 75
- **Validity**: 90 days
- **Description**: Access to premium meditation and mindfulness content for 3 months

---

## 🥗 Nutrition & Cooking Vouchers

### 8. Nutrition Consultation
- **Code**: `NUTRITION_MEAL`
- **Points Required**: 200
- **Discount**: $100 value
- **Category**: Nutrition
- **Max Redemptions**: 30
- **Validity**: 90 days
- **Description**: Free 30-minute consultation with a certified nutritionist

### 9. Healthy Cooking Class
- **Code**: `COOKING_CLASS`
- **Points Required**: 160
- **Discount**: $75 value
- **Category**: Nutrition
- **Max Redemptions**: 45
- **Validity**: 90 days
- **Description**: Learn to cook healthy meals with a professional chef

---

## 💪 Fitness Vouchers

### 10. 1 Month Gym Membership
- **Code**: `FITNESS_MONTH`
- **Points Required**: 250
- **Discount**: $150 value
- **Category**: Fitness
- **Max Redemptions**: 25
- **Validity**: 90 days
- **Description**: Free 1-month access to premium gym facilities and classes

### 11. 5 Pilates Classes
- **Code**: `PILATES_CLASS`
- **Points Required**: 110
- **Discount**: 25% off
- **Category**: Fitness
- **Max Redemptions**: 55
- **Validity**: 90 days
- **Description**: Five sessions of professional pilates training

---

## 🧠 Mental Health Voucher

### 12. Mental Health Session
- **Code**: `MENTAL_THERAPY`
- **Points Required**: 180
- **Discount**: $80 value
- **Category**: Mental Health
- **Max Redemptions**: 40
- **Validity**: 90 days
- **Description**: Free 45-minute therapy session with a licensed counselor

---

## 📊 Voucher Statistics

| Category | Count | Total Points | Avg Points |
|----------|-------|--------------|-----------|
| Health | 4 | 580 | 145 |
| Wellness | 2 | 320 | 160 |
| Nutrition | 2 | 360 | 180 |
| Fitness | 2 | 360 | 180 |
| Mental Health | 2 | 320 | 160 |
| **Total** | **12** | **1,940** | **162** |

---

## 💰 Points to Voucher Conversion

### Budget-Friendly (100-130 points)
- 10% Health Store Discount (100 pts)
- Organic Produce Box (120 pts)
- Premium Vitamin Pack (130 pts)

### Mid-Range (140-180 points)
- 3 Months Premium Meditation App (140 pts)
- Free Yoga Class (150 pts)
- Nutrition Consultation (200 pts)
- Mental Health Session (180 pts)
- Healthy Cooking Class (160 pts)
- Spa Massage Session (170 pts)

### Premium (200+ points)
- 1 Month Gym Membership (250 pts)
- Smart Sleep Tracker Device (220 pts)

---

## 🎯 How to Earn Points

### Daily Logging
- **Menstruation Tracker**: Log daily symptoms → +10 points
- **Pregnancy Tracker**: Log daily progress → +10 points
- **Menopause Tracker**: Log daily symptoms → +10 points

### Streak Bonuses
- **Day 1**: 10 points
- **Day 2**: 20 points total
- **Day 3**: 30 points total
- **Day 5**: 50 points total
- **Day 10**: 100 points total
- **Day 15**: 150 points total
- **Day 20**: 200 points total
- **Day 25**: 250 points total

---

## 📈 Redemption Examples

### Example 1: Budget User
```
Day 1-10: Log daily
Points earned: 100
Redeem: 10% Health Store Discount
Savings: 10% on health products
```

### Example 2: Consistent User
```
Day 1-15: Log daily
Points earned: 150
Redeem: Free Yoga Class
Value: $50 worth of yoga
```

### Example 3: Dedicated User
```
Day 1-25: Log daily
Points earned: 250
Redeem: 1 Month Gym Membership
Value: $150 worth of gym access
```

### Example 4: Super User
```
Day 1-30: Log daily
Points earned: 300
Redeem: 1 Month Gym Membership (250 pts) + 5 Pilates Classes (110 pts)
Total Value: $225+ worth of fitness
```

---

## 🚀 How to Create Vouchers

### Option 1: Run the Script
```bash
cd server
node create-sample-vouchers.js
```

### Option 2: Manual API Call
```bash
curl -X POST http://localhost:3000/api/voucher/admin/create \
  -H "Content-Type: application/json" \
  -d '{
    "code": "HEALTH_10",
    "title": "10% Health Store Discount",
    "description": "Get 10% off on health products",
    "points_required": 100,
    "discount_percentage": 10,
    "category": "health",
    "validity_end": "2025-03-20T23:59:59Z",
    "max_redemptions": 50
  }'
```

### Option 3: Create Custom Voucher
```javascript
const voucher = {
  code: "CUSTOM_CODE",
  title: "Your Voucher Title",
  description: "Your voucher description",
  points_required: 150,
  discount_percentage: 20,
  discount_amount: 0,
  category: "health",
  validity_end: new Date(Date.now() + 90 * 24 * 60 * 60 * 1000).toISOString(),
  max_redemptions: 50
};

// POST to /api/voucher/admin/create
```

---

## 📱 User Experience

### Browsing Vouchers
1. User opens app
2. Clicks Voucher button in AppBar or Profile
3. Sees "Available Vouchers" tab
4. Browses all vouchers with:
   - Title and description
   - Points required
   - Discount percentage/amount
   - Category badge
5. Clicks "Purchase" to buy with points

### Purchasing Voucher
1. User clicks "Purchase" on voucher
2. System checks:
   - User has enough points
   - Voucher is active
   - Redemption limit not reached
3. Points deducted from wallet
4. Voucher added to "My Vouchers"
5. Transaction recorded

### Redeeming Voucher
1. User opens "My Vouchers" tab
2. Sees purchased vouchers
3. Clicks "Redeem Now"
4. Voucher status changes to "Redeemed"
5. User gets voucher code/details
6. Can use at partner location

---

## 🎨 Voucher Categories

### Health
- Discounts on health products
- Medical devices
- Supplements and vitamins
- Health consultations

### Wellness
- Yoga and fitness classes
- Spa and massage services
- Relaxation activities
- Wellness programs

### Nutrition
- Cooking classes
- Nutritionist consultations
- Organic food boxes
- Meal planning services

### Fitness
- Gym memberships
- Personal training
- Group fitness classes
- Sports equipment

### Mental Health
- Therapy sessions
- Counseling services
- Meditation apps
- Mental wellness programs

---

## 💡 Tips for Users

### Maximize Points
1. Log daily to maintain streak
2. Don't miss days (streak breaks = -5 points)
3. Aim for 25+ day streaks for premium vouchers
4. Combine multiple vouchers for maximum value

### Best Value Vouchers
1. **Smart Sleep Tracker** (220 pts) - $120 value = 55% value
2. **1 Month Gym Membership** (250 pts) - $150 value = 60% value
3. **Spa Massage Session** (170 pts) - $90 value = 53% value

### Budget Vouchers
1. **10% Health Store Discount** (100 pts) - Flexible savings
2. **Organic Produce Box** (120 pts) - Regular value
3. **Premium Vitamin Pack** (130 pts) - Monthly supply

---

## 📊 Voucher Performance Metrics

### Expected Redemption Rates
- Budget vouchers (100-130 pts): 60-70% redemption
- Mid-range vouchers (140-180 pts): 40-50% redemption
- Premium vouchers (200+ pts): 20-30% redemption

### User Engagement
- Users with 10+ day streaks: 80% likely to purchase
- Users with 20+ day streaks: 95% likely to purchase
- Average voucher purchase: 2-3 per user per month

---

## 🔄 Voucher Lifecycle

```
Created
  ↓
Active (Available for purchase)
  ↓
Purchased (User buys with points)
  ↓
Redeemed (User uses voucher)
  ↓
Completed
```

---

## 🎯 Future Voucher Ideas

1. **Partner Discounts**
   - Restaurant discounts
   - Retail store coupons
   - Online shopping vouchers

2. **Experience Vouchers**
   - Weekend wellness retreats
   - Health seminars
   - Fitness camps

3. **Product Vouchers**
   - Fitness equipment
   - Health gadgets
   - Wellness products

4. **Service Vouchers**
   - Home delivery services
   - Personal training
   - Health coaching

5. **Exclusive Vouchers**
   - VIP gym access
   - Premium app subscriptions
   - Exclusive events

---

## 📞 Support

For questions about vouchers:
1. Check the Wallet screen for points balance
2. Browse available vouchers in Voucher screen
3. Review transaction history in Wallet
4. Contact support for redemption issues

---

**Last Updated**: December 2024
**Total Vouchers**: 12
**Total Points Value**: 1,940 points
**Average Redemption Value**: $80+

**Ready to Earn and Redeem! 🎉**
