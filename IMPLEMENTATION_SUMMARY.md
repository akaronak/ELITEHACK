# Daily Streak & Wallet Points System - Implementation Summary

## What Was Implemented

A comprehensive **Daily Streak & Wallet Points System** has been added to the Mensa women's health tracking app. This system rewards users for consistent engagement across three health tracking categories: Menstruation, Pregnancy, and Menopause.

## Key Features

### 1. Daily Streak Tracking
- Users can maintain independent streaks for each tracker category
- Daily check-ins award **+10 points**
- Missed days result in **-5 point penalty**
- Tracks both current and longest streaks
- Visual fire emoji indicator for active streaks

### 2. Wallet Points System
- Accumulate points through daily check-ins
- View total points balance
- Complete transaction history with timestamps
- Filter transactions by type (earned, deducted, redeemed)
- No point expiration

### 3. Voucher Redemption
- Browse available vouchers with point requirements
- Purchase vouchers using accumulated points
- Redeem vouchers for discounts/benefits
- Track voucher status (active, redeemed, expired)
- Admin ability to create and manage vouchers

## Files Created/Modified

### Backend Files

#### New/Enhanced Routes
- **`server/src/routes/streak.routes.js`** - Enhanced with:
  - `GET /streak/:userId/summary` - Get streak summary across all categories
  - `POST /streak/:userId/validate` - Validate and update streaks daily
  - Automatic penalty system for broken streaks

- **`server/src/routes/wallet.routes.js`** - Already implemented with:
  - Point management endpoints
  - Transaction history tracking

- **`server/src/routes/voucher.routes.js`** - Already implemented with:
  - Voucher browsing and purchasing
  - Redemption management

#### Models (Already Exist)
- `server/src/models/streak.model.js`
- `server/src/models/userWallet.model.js`
- `server/src/models/voucher.model.js`
- `server/src/models/userVoucher.model.js`

### Frontend Files

#### New Models
- **`mensa/lib/models/streak.dart`** - Dart models for:
  - `Streak` - Individual streak data
  - `StreakSummary` - Summary across all categories
  - `StreakData` - Category-specific streak info

#### New Widgets
- **`mensa/lib/widgets/streak_widget.dart`** - Reusable streak display widget with:
  - Current streak display with fire emoji
  - Longest streak tracking
  - Daily check-in button
  - Active/Inactive status indicator
  - Points earned information

#### Enhanced Screens
- **`mensa/lib/screens/voucher_screen.dart`** - Complete implementation with:
  - Available vouchers tab
  - My Vouchers tab
  - Wallet points display
  - Purchase functionality
  - Redemption functionality

- **`mensa/lib/screens/wallet_screen.dart`** - Already implemented with:
  - Points balance display
  - Transaction history
  - Refresh functionality

#### Enhanced Services
- **`mensa/lib/services/api_service.dart`** - Added methods:
  - `getStreakSummary(userId)` - Get summary of all streaks
  - `validateStreaks(userId)` - Validate and update streaks
  - `deductWalletPoints(userId, amount, reason, category)` - Deduct points

### Documentation Files

- **`STREAK_WALLET_SYSTEM.md`** - Comprehensive system documentation including:
  - Feature overview
  - Database models
  - API endpoints
  - Frontend implementation details
  - Usage flows
  - Best practices
  - Future enhancements

- **`INTEGRATION_GUIDE.md`** - Step-by-step integration guide including:
  - Adding streak widget to tracker screens
  - Wallet/voucher navigation setup
  - Automatic streak validation
  - Daily reminders
  - Sample voucher creation
  - Testing checklist
  - Troubleshooting

## How It Works

### User Flow

1. **Daily Check-in**
   - User opens any tracker (Menstruation, Pregnancy, or Menopause)
   - Sees StreakWidget on home screen
   - Clicks "Check In Today" button
   - Earns +10 points
   - Streak increases by 1

2. **Maintain Streak**
   - Check in every day to keep streak active
   - Miss a day = streak breaks and -5 points deducted
   - Longest streak is tracked for motivation

3. **Earn Points**
   - Daily check-ins: +10 points per day
   - View all transactions in Wallet screen
   - Track earning/spending history

4. **Redeem Points**
   - Open Profile → Vouchers
   - Browse available vouchers
   - Purchase voucher with points
   - Redeem voucher for discount/benefit

### Points System

**Earning:**
- Daily check-in: +10 points
- Consistent engagement: bonus opportunities

**Losing:**
- Broken streak: -5 points
- Voucher purchase: points deducted

**Redemption:**
- Vouchers cost 50-200+ points
- No expiration on points
- Transaction history maintained

## API Endpoints

### Streak Endpoints
```
GET    /api/streak/:userId/:category              - Get streak
POST   /api/streak/:userId/:category/check-in     - Daily check-in
GET    /api/streak/:userId/all                    - Get all streaks
GET    /api/streak/:userId/summary                - Get summary
POST   /api/streak/:userId/validate               - Validate streaks
```

### Wallet Endpoints
```
GET    /api/wallet/:userId                        - Get wallet
POST   /api/wallet/:userId/add-points             - Add points
POST   /api/wallet/:userId/deduct-points          - Deduct points
GET    /api/wallet/:userId/history                - Get history
```

### Voucher Endpoints
```
GET    /api/voucher/available                     - Get available vouchers
GET    /api/voucher/:userId/my-vouchers           - Get user's vouchers
POST   /api/voucher/:userId/purchase              - Purchase voucher
POST   /api/voucher/:userId/redeem/:userVoucherId - Redeem voucher
POST   /api/voucher/admin/create                  - Create voucher (admin)
```

## Integration Steps

To integrate this system into your app:

1. **Add StreakWidget to tracker home screens**
   ```dart
   StreakWidget(
     userId: widget.userId,
     category: 'menstruation', // or 'pregnancy', 'menopause'
     onStreakUpdated: () => setState(() {}),
   )
   ```

2. **Add navigation to Wallet/Voucher screens in Profile**
   - Add buttons to navigate to WalletScreen
   - Add buttons to navigate to VoucherScreen

3. **Add automatic streak validation on app launch**
   - Call `validateStreaks(userId)` when app starts
   - This checks for broken streaks and applies penalties

4. **Create sample vouchers**
   - Use admin endpoint to create vouchers
   - Set point requirements and benefits

5. **Add daily reminders** (optional)
   - Schedule notifications to remind users to check in
   - Increase engagement and streak maintenance

## Testing

### Manual Testing
1. Check in daily and verify +10 points
2. Miss a day and verify -5 point penalty
3. Purchase voucher and verify points deducted
4. Redeem voucher and verify status changes
5. View transaction history

### API Testing
```bash
# Check in
curl -X POST http://localhost:3000/api/streak/user123/menstruation/check-in

# Get wallet
curl -X GET http://localhost:3000/api/wallet/user123

# Purchase voucher
curl -X POST http://localhost:3000/api/voucher/user123/purchase \
  -H "Content-Type: application/json" \
  -d '{"voucher_id": "voucher_123"}'
```

## Database Schema

### Streak Collection
```javascript
{
  streak_id: String,
  user_id: String,
  category: String, // 'menstruation', 'pregnancy', 'menopause'
  current_streak: Number,
  longest_streak: Number,
  last_check_in_date: Date,
  check_in_dates: [Date],
  created_at: Date,
  updated_at: Date
}
```

### Wallet Collection
```javascript
{
  user_id: String,
  total_points: Number,
  points_history: [{
    transaction_id: String,
    amount: Number,
    type: String, // 'earned', 'deducted', 'redeemed'
    reason: String,
    category: String,
    date: Date
  }],
  created_at: Date,
  updated_at: Date
}
```

### Voucher Collection
```javascript
{
  voucher_id: String,
  code: String,
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

## Configuration

### Point Values (Configurable)
- Daily check-in: **10 points**
- Broken streak penalty: **5 points**
- Voucher cost: **50-200+ points** (configurable per voucher)

### Streak Rules
- Streak continues if check-in is today or yesterday
- Streak breaks if no check-in for 2+ days
- Penalty applied when streak breaks

## Performance Considerations

1. **Caching**: Cache streak data locally to reduce API calls
2. **Batch Operations**: Validate multiple streaks in one call
3. **Lazy Loading**: Load vouchers on demand
4. **Debouncing**: Prevent double check-in submissions

## Security

1. **User Validation**: All endpoints validate user ID
2. **Point Verification**: Check balance before deducting
3. **Voucher Validation**: Verify validity before redemption
4. **Audit Trail**: All transactions logged
5. **Rate Limiting**: Prevent abuse of check-in endpoint

## Future Enhancements

1. **Streak Freezes**: Allow users to freeze streak for 1-2 days
2. **Bonus Multipliers**: 2x points on weekends
3. **Social Features**: Share streaks with friends
4. **Leaderboards**: Compete with other users
5. **Achievements**: Unlock badges for milestones
6. **Partner Integrations**: Redeem with health partners
7. **Referral Rewards**: Points for referring friends
8. **Seasonal Events**: Special point bonuses

## Support & Documentation

- **System Documentation**: See `STREAK_WALLET_SYSTEM.md`
- **Integration Guide**: See `INTEGRATION_GUIDE.md`
- **API Documentation**: See backend route files
- **Model Documentation**: See model files

## Next Steps

1. Review the implementation files
2. Follow the INTEGRATION_GUIDE.md to add widgets to screens
3. Create sample vouchers using admin endpoint
4. Test all functionality
5. Deploy to production
6. Monitor usage and adjust point values as needed

## Summary

The Daily Streak & Wallet Points System is now fully implemented and ready for integration. It provides:

✅ Daily streak tracking for all three health categories
✅ Automatic point rewards (+10) and penalties (-5)
✅ Wallet management with transaction history
✅ Voucher browsing, purchasing, and redemption
✅ Complete API endpoints for all operations
✅ Reusable Flutter widgets for easy integration
✅ Comprehensive documentation and guides

The system is designed to increase user engagement through gamification while maintaining the health-focused mission of the Mensa app.
