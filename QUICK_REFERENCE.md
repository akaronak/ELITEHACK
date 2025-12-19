# Quick Reference: Daily Streak & Wallet System

## 🎯 What Was Added

A complete **Daily Streak & Wallet Points System** for the Mensa app that rewards users for consistent health tracking.

## 📊 Points System

| Action | Points | Category |
|--------|--------|----------|
| Daily Check-in | +10 | Earned |
| Broken Streak | -5 | Deducted |
| Voucher Purchase | Variable | Redeemed |

## 🔥 Streak Rules

- **Active**: Check-in today or yesterday
- **Broken**: Miss 2+ consecutive days
- **Penalty**: -5 points when broken
- **Tracked**: Current and longest streaks

## 📁 New Files Created

### Backend
- Enhanced `server/src/routes/streak.routes.js` with:
  - `/streak/:userId/summary` - Get streak summary
  - `/streak/:userId/validate` - Validate streaks

### Frontend
- `mensa/lib/models/streak.dart` - Streak data models
- `mensa/lib/widgets/streak_widget.dart` - Reusable streak widget
- `mensa/lib/screens/voucher_screen.dart` - Complete voucher screen
- Enhanced `mensa/lib/services/api_service.dart` with new methods

### Documentation
- `STREAK_WALLET_SYSTEM.md` - Full system documentation
- `INTEGRATION_GUIDE.md` - Step-by-step integration
- `IMPLEMENTATION_SUMMARY.md` - Complete summary
- `QUICK_REFERENCE.md` - This file

## 🚀 Quick Integration

### 1. Add Streak Widget to Tracker Screens

```dart
import '../widgets/streak_widget.dart';

// In your tracker home screen
StreakWidget(
  userId: widget.userId,
  category: 'menstruation', // or 'pregnancy', 'menopause'
  onStreakUpdated: () => setState(() {}),
)
```

### 2. Add Wallet/Voucher Navigation to Profile

```dart
// In profile_screen.dart
ListTile(
  leading: Icon(Icons.wallet),
  title: Text('My Wallet'),
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => WalletScreen(userId: widget.userId),
    ),
  ),
),

ListTile(
  leading: Icon(Icons.card_giftcard),
  title: Text('Vouchers'),
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => VoucherScreen(userId: widget.userId),
    ),
  ),
),
```

### 3. Add Streak Validation on App Start

```dart
// In main.dart or app initialization
Future<void> _validateStreaksOnAppStart() async {
  final userId = await SharedPreferences.getInstance()
    .then((p) => p.getString('userId'));
  
  if (userId != null) {
    await _apiService.validateStreaks(userId);
  }
}
```

## 📱 User Flow

```
1. Open Tracker
   ↓
2. See Streak Widget
   ↓
3. Click "Check In Today"
   ↓
4. Earn +10 Points
   ↓
5. Streak Increases by 1
   ↓
6. View Points in Wallet
   ↓
7. Purchase Voucher
   ↓
8. Redeem for Discount
```

## 🔌 API Endpoints

### Streak
```
GET    /api/streak/:userId/:category
POST   /api/streak/:userId/:category/check-in
GET    /api/streak/:userId/all
GET    /api/streak/:userId/summary
POST   /api/streak/:userId/validate
```

### Wallet
```
GET    /api/wallet/:userId
POST   /api/wallet/:userId/add-points
POST   /api/wallet/:userId/deduct-points
GET    /api/wallet/:userId/history
```

### Voucher
```
GET    /api/voucher/available
GET    /api/voucher/:userId/my-vouchers
POST   /api/voucher/:userId/purchase
POST   /api/voucher/:userId/redeem/:userVoucherId
POST   /api/voucher/admin/create
```

## 🎁 Create Sample Vouchers

```bash
# Health Voucher
curl -X POST http://localhost:3000/api/voucher/admin/create \
  -H "Content-Type: application/json" \
  -d '{
    "code": "HEALTH_10",
    "title": "10% Health Store Discount",
    "points_required": 100,
    "discount_percentage": 10,
    "category": "health"
  }'

# Wellness Voucher
curl -X POST http://localhost:3000/api/voucher/admin/create \
  -H "Content-Type: application/json" \
  -d '{
    "code": "WELLNESS_YOGA",
    "title": "Free Yoga Class",
    "points_required": 150,
    "discount_amount": 50,
    "category": "wellness"
  }'
```

## 🧪 Testing

### Test Check-in
```bash
curl -X POST http://localhost:3000/api/streak/user123/menstruation/check-in
```

### Test Wallet
```bash
curl -X GET http://localhost:3000/api/wallet/user123
```

### Test Voucher Purchase
```bash
curl -X POST http://localhost:3000/api/voucher/user123/purchase \
  -H "Content-Type: application/json" \
  -d '{"voucher_id": "voucher_123"}'
```

## 📊 Database Models

### Streak
```javascript
{
  streak_id: String,
  user_id: String,
  category: String, // 'menstruation', 'pregnancy', 'menopause'
  current_streak: Number,
  longest_streak: Number,
  last_check_in_date: Date,
  check_in_dates: [Date]
}
```

### Wallet
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
  }]
}
```

### Voucher
```javascript
{
  voucher_id: String,
  code: String,
  title: String,
  points_required: Number,
  discount_percentage: Number,
  discount_amount: Number,
  category: String,
  validity_end: Date,
  is_active: Boolean,
  max_redemptions: Number
}
```

## 🎨 UI Components

### StreakWidget
- Displays current streak with fire emoji
- Shows longest streak
- Active/Inactive status
- Daily check-in button
- Points earned info

### WalletScreen
- Total points display
- Transaction history
- Filter by type
- Refresh functionality

### VoucherScreen
- Available vouchers tab
- My Vouchers tab
- Wallet points display
- Purchase/Redeem buttons

## ⚙️ Configuration

### Point Values
```dart
const int DAILY_CHECKIN_POINTS = 10;
const int BROKEN_STREAK_PENALTY = 5;
const int MIN_VOUCHER_COST = 50;
const int MAX_VOUCHER_COST = 500;
```

### Streak Rules
```dart
// Streak continues if:
// - Last check-in was today OR
// - Last check-in was yesterday

// Streak breaks if:
// - No check-in for 2+ consecutive days
// - Penalty: -5 points
```

## 🔒 Security

- ✅ User ID validation on all endpoints
- ✅ Point balance verification before deduction
- ✅ Voucher validity checks
- ✅ Transaction audit trail
- ✅ Rate limiting on check-in

## 📈 Metrics to Track

- Daily active users (check-ins)
- Average streak length
- Points earned per user
- Voucher redemption rate
- User retention

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| Streak not updating | Check API response, verify wallet exists |
| Points not showing | Verify wallet created, check transaction history |
| Voucher purchase fails | Check point balance, verify voucher is active |
| Widget not displaying | Verify userId/category passed, check imports |

## 📚 Documentation

- **Full System**: `STREAK_WALLET_SYSTEM.md`
- **Integration**: `INTEGRATION_GUIDE.md`
- **Summary**: `IMPLEMENTATION_SUMMARY.md`
- **This File**: `QUICK_REFERENCE.md`

## ✅ Checklist

- [ ] Add StreakWidget to menstruation tracker
- [ ] Add StreakWidget to pregnancy tracker
- [ ] Add StreakWidget to menopause tracker
- [ ] Add Wallet navigation to profile
- [ ] Add Voucher navigation to profile
- [ ] Create sample vouchers
- [ ] Add streak validation on app start
- [ ] Test daily check-in flow
- [ ] Test streak breaking
- [ ] Test voucher purchase
- [ ] Test voucher redemption
- [ ] Deploy to production

## 🎯 Next Steps

1. Review `INTEGRATION_GUIDE.md`
2. Add StreakWidget to tracker screens
3. Add navigation to Wallet/Voucher screens
4. Create sample vouchers
5. Test all functionality
6. Deploy and monitor

## 💡 Tips

- Cache streak data locally to reduce API calls
- Show daily reminder notifications
- Celebrate streak milestones
- Rotate vouchers regularly
- Monitor redemption rates
- Adjust point values based on engagement

## 📞 Support

For questions or issues:
1. Check the full documentation files
2. Review API endpoint responses
3. Check database records
4. Verify user permissions
5. Contact development team

---

**System Status**: ✅ Ready for Integration

**Last Updated**: December 2024

**Version**: 1.0
