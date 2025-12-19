# Daily Streak & Wallet Points System

## Overview

The Mensa app now includes a comprehensive **Daily Streak & Wallet Points System** that rewards users for consistent engagement with their health tracking across three categories:
- **Menstruation Tracking**
- **Pregnancy Tracking**
- **Menopause Tracking**

## Features

### 1. Daily Streak Tracking

Users can maintain daily streaks for each tracker category:

- **Check-in Daily**: Users check in once per day to maintain their streak
- **Points Reward**: +10 points for each consecutive day checked in
- **Streak Tracking**: Current streak and longest streak are tracked
- **Streak Penalty**: -5 points if streak is broken (missed a day)

### 2. Wallet Points System

Users accumulate points through:
- Daily streak check-ins (+10 points/day)
- Completing health tracking activities
- Maintaining consistent engagement

Points can be:
- Viewed in the Wallet screen
- Redeemed for vouchers
- Tracked with transaction history

### 3. Voucher System

Users can purchase vouchers using accumulated points:
- Browse available vouchers
- View point requirements
- Purchase vouchers with points
- Redeem vouchers for discounts/benefits
- Track purchased vouchers

## Backend Implementation

### Database Models

#### Streak Model (`server/src/models/streak.model.js`)
```javascript
{
  streak_id: String (unique),
  user_id: String,
  category: String (enum: 'menstruation', 'menopause', 'pregnancy'),
  current_streak: Number,
  longest_streak: Number,
  last_check_in_date: Date,
  check_in_dates: [Date],
  created_at: Date,
  updated_at: Date
}
```

#### Wallet Model (`server/src/models/userWallet.model.js`)
```javascript
{
  user_id: String (unique),
  total_points: Number,
  points_history: [{
    transaction_id: String,
    amount: Number,
    type: String (enum: 'earned', 'deducted', 'redeemed'),
    reason: String,
    category: String,
    date: Date
  }],
  created_at: Date,
  updated_at: Date
}
```

#### Voucher Model (`server/src/models/voucher.model.js`)
```javascript
{
  voucher_id: String (unique),
  code: String (unique),
  title: String,
  description: String,
  points_required: Number,
  discount_percentage: Number,
  discount_amount: Number,
  category: String,
  validity_start: Date,
  validity_end: Date,
  is_active: Boolean,
  max_redemptions: Number,
  current_redemptions: Number,
  created_at: Date,
  updated_at: Date
}
```

#### User Voucher Model (`server/src/models/userVoucher.model.js`)
```javascript
{
  user_voucher_id: String (unique),
  user_id: String,
  voucher_id: String,
  voucher_code: String,
  status: String (enum: 'active', 'redeemed', 'expired'),
  purchased_at: Date,
  redeemed_at: Date,
  expires_at: Date,
  created_at: Date,
  updated_at: Date
}
```

### API Endpoints

#### Streak Routes (`/api/streak`)

**Get Streak for Category**
```
GET /api/streak/:userId/:category
Response: Streak object
```

**Daily Check-in**
```
POST /api/streak/:userId/:category/check-in
Response: {
  success: boolean,
  message: string,
  streak: Streak object,
  points_awarded: number,
  streak_continues: boolean
}
```

**Get All Streaks for User**
```
GET /api/streak/:userId/all
Response: { streaks: [Streak] }
```

**Get Streak Summary**
```
GET /api/streak/:userId/summary
Response: {
  total_active_streaks: number,
  streaks_by_category: {
    menstruation: { current_streak, longest_streak, last_check_in },
    pregnancy: { ... },
    menopause: { ... }
  },
  total_points_earned: number
}
```

**Validate Streaks (Check for Broken Streaks)**
```
POST /api/streak/:userId/validate
Response: {
  success: boolean,
  message: string,
  results: [{ category, status, message }]
}
```

#### Wallet Routes (`/api/wallet`)

**Get User Wallet**
```
GET /api/wallet/:userId
Response: {
  wallet_id: string,
  user_id: string,
  total_points: number,
  points_history: [Transaction],
  created_at: Date,
  updated_at: Date
}
```

**Add Points**
```
POST /api/wallet/:userId/add-points
Body: { amount, reason, category }
Response: { success, message, wallet }
```

**Deduct Points**
```
POST /api/wallet/:userId/deduct-points
Body: { amount, reason, category }
Response: { success, message, wallet }
```

**Get Points History**
```
GET /api/wallet/:userId/history
Response: { history: [Transaction] }
```

#### Voucher Routes (`/api/voucher`)

**Get Available Vouchers**
```
GET /api/voucher/available
Response: { vouchers: [Voucher] }
```

**Get User's Vouchers**
```
GET /api/voucher/:userId/my-vouchers
Response: { vouchers: [UserVoucher] }
```

**Purchase Voucher**
```
POST /api/voucher/:userId/purchase
Body: { voucher_id }
Response: {
  success: boolean,
  message: string,
  user_voucher: UserVoucher,
  remaining_points: number
}
```

**Redeem Voucher**
```
POST /api/voucher/:userId/redeem/:userVoucherId
Response: {
  success: boolean,
  message: string,
  user_voucher: UserVoucher
}
```

**Create Voucher (Admin)**
```
POST /api/voucher/admin/create
Body: {
  code,
  title,
  description,
  points_required,
  discount_percentage,
  discount_amount,
  category,
  validity_end,
  max_redemptions
}
Response: { success, message, voucher }
```

## Frontend Implementation

### Models

#### Streak Model (`mensa/lib/models/streak.dart`)
- `Streak`: Main streak data model
- `StreakSummary`: Summary of all streaks for a user
- `StreakData`: Individual streak data

### Services

#### API Service Methods
- `getStreak(userId, category)`: Get streak for a category
- `checkInStreak(userId, category)`: Daily check-in
- `getAllStreaks(userId)`: Get all streaks
- `getStreakSummary(userId)`: Get streak summary
- `validateStreaks(userId)`: Validate and update streaks
- `getUserWallet(userId)`: Get wallet
- `addWalletPoints(userId, amount, reason, category)`: Add points
- `deductWalletPoints(userId, amount, reason, category)`: Deduct points
- `getWalletHistory(userId)`: Get transaction history
- `getAvailableVouchers()`: Get available vouchers
- `getUserVouchers(userId)`: Get user's vouchers
- `purchaseVoucher(userId, voucherId)`: Purchase voucher
- `redeemVoucher(userId, userVoucherId)`: Redeem voucher

### Widgets

#### StreakWidget (`mensa/lib/widgets/streak_widget.dart`)
Displays:
- Current streak count with fire emoji
- Longest streak
- Active/Inactive status
- Daily check-in button
- Points earned information

### Screens

#### Wallet Screen (`mensa/lib/screens/wallet_screen.dart`)
- Display total points
- Show transaction history
- Filter by type (earned, deducted, redeemed)
- Refresh wallet data

#### Voucher Screen (`mensa/lib/screens/voucher_screen.dart`)
- Browse available vouchers
- View point requirements
- Purchase vouchers
- View purchased vouchers
- Redeem vouchers
- Track voucher status

## Usage Flow

### For Users

1. **Daily Check-in**
   - Open tracker (Menstruation, Pregnancy, or Menopause)
   - See StreakWidget on home screen
   - Click "Check In Today" button
   - Earn +10 points
   - Streak increases by 1

2. **Maintain Streak**
   - Check in every day to keep streak active
   - Miss a day = streak breaks and -5 points deducted
   - Longest streak is tracked for motivation

3. **Earn Points**
   - Daily check-ins: +10 points
   - Consistent engagement: bonus points
   - View all transactions in Wallet

4. **Redeem Points**
   - Open Profile → Vouchers
   - Browse available vouchers
   - Purchase voucher with points
   - Redeem voucher for discount/benefit

### For Admins

1. **Create Vouchers**
   - Use `/api/voucher/admin/create` endpoint
   - Set point requirements
   - Set discount percentage or amount
   - Set validity period
   - Set max redemptions

2. **Monitor Usage**
   - Track redemption counts
   - View user wallet balances
   - Monitor streak participation

## Integration with Trackers

### Menstruation Tracker
- Add StreakWidget to home screen
- Check-in when logging daily symptoms
- Earn points for consistent tracking

### Pregnancy Tracker
- Add StreakWidget to home screen
- Check-in when logging daily progress
- Earn points for week-by-week engagement

### Menopause Tracker
- Add StreakWidget to home screen
- Check-in when logging symptoms
- Earn points for consistent monitoring

## Points System Details

### Earning Points
- **Daily Check-in**: +10 points per day
- **Streak Milestone**: Bonus points at 7, 14, 30 days (optional)
- **Completing Activities**: Additional points for logging data

### Losing Points
- **Broken Streak**: -5 points per broken streak
- **Voucher Purchase**: Points deducted when purchasing

### Point Redemption
- **Voucher Purchase**: Points converted to vouchers
- **Minimum Purchase**: Typically 50-100 points per voucher
- **No Expiration**: Points don't expire (unless configured)

## Notifications

### Push Notifications
- Daily reminder to check in
- Streak milestone achievements
- Voucher availability alerts
- Streak broken warnings

### In-App Notifications
- Check-in success/failure
- Points earned/deducted
- Voucher purchase confirmation
- Redemption status

## Best Practices

1. **Encourage Daily Check-ins**
   - Show streak progress prominently
   - Celebrate milestones
   - Send timely reminders

2. **Gamification**
   - Display fire emoji for active streaks
   - Show longest streak achievements
   - Create leaderboards (optional)

3. **Reward Consistency**
   - Bonus points for longer streaks
   - Special vouchers for high-point users
   - Exclusive benefits for consistent trackers

4. **Manage Vouchers**
   - Rotate vouchers regularly
   - Offer relevant health/wellness products
   - Set reasonable point requirements
   - Monitor redemption rates

## Future Enhancements

1. **Streak Freezes**: Allow users to freeze streak for 1-2 days
2. **Bonus Multipliers**: 2x points on weekends or special days
3. **Social Sharing**: Share streak achievements
4. **Leaderboards**: Compete with friends
5. **Achievements**: Unlock badges for milestones
6. **Partner Integrations**: Redeem points with health partners
7. **Referral Rewards**: Points for referring friends
8. **Seasonal Events**: Special point bonuses during campaigns

## Testing

### Backend Testing
```bash
# Test streak check-in
curl -X POST http://localhost:3000/api/streak/user123/menstruation/check-in

# Test wallet
curl -X GET http://localhost:3000/api/wallet/user123

# Test voucher purchase
curl -X POST http://localhost:3000/api/voucher/user123/purchase \
  -H "Content-Type: application/json" \
  -d '{"voucher_id": "voucher_123"}'
```

### Frontend Testing
1. Test daily check-in flow
2. Test streak validation
3. Test wallet point updates
4. Test voucher purchase and redemption
5. Test transaction history display

## Troubleshooting

### Streak Not Updating
- Check if user has checked in today
- Verify streak validation endpoint is called
- Check database for streak records

### Points Not Showing
- Verify wallet exists for user
- Check points_history array
- Ensure transactions are being recorded

### Voucher Purchase Fails
- Check user has sufficient points
- Verify voucher is active
- Check voucher hasn't reached max redemptions

## Support

For issues or questions:
1. Check API response messages
2. Review transaction history
3. Validate streak status
4. Check voucher availability
5. Contact support team
