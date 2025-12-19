# Integration Guide: Daily Streak & Wallet System

## Quick Start

This guide shows how to integrate the Daily Streak & Wallet Points system into your tracker screens.

## Step 1: Add Streak Widget to Tracker Home Screens

### For Menstruation Tracker

In `mensa/lib/screens/menstruation/menstruation_home_screen.dart` (or similar):

```dart
import '../widgets/streak_widget.dart';

class MenstruationHomeScreen extends StatefulWidget {
  final String userId;
  
  @override
  State<MenstruationHomeScreen> createState() => _MenstruationHomeScreenState();
}

class _MenstruationHomeScreenState extends State<MenstruationHomeScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Add Streak Widget here
              StreakWidget(
                userId: widget.userId,
                category: 'menstruation',
                onStreakUpdated: () {
                  // Refresh other widgets if needed
                  setState(() {});
                },
              ),
              
              const SizedBox(height: 24),
              
              // Rest of your widgets...
            ],
          ),
        ),
      ),
    );
  }
}
```

### For Pregnancy Tracker

In `mensa/lib/screens/pregnancy/pregnancy_home_screen.dart`:

```dart
StreakWidget(
  userId: widget.userId,
  category: 'pregnancy',
  onStreakUpdated: () {
    setState(() {});
  },
),
```

### For Menopause Tracker

In `mensa/lib/screens/menopause/menopause_home_screen.dart`:

```dart
StreakWidget(
  userId: widget.userId,
  category: 'menopause',
  onStreakUpdated: () {
    setState(() {});
  },
),
```

## Step 2: Add Wallet & Voucher Access to Profile Screen

In `mensa/lib/screens/profile_screen.dart`, add navigation buttons:

```dart
// In the profile screen build method, add these buttons

// Wallet Button
Container(
  margin: const EdgeInsets.only(bottom: 16),
  child: ListTile(
    leading: const Icon(Icons.wallet, color: Colors.purple),
    title: const Text('My Wallet'),
    subtitle: const Text('View points and transaction history'),
    trailing: const Icon(Icons.arrow_forward),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WalletScreen(userId: widget.userId),
        ),
      );
    },
  ),
),

// Vouchers Button
Container(
  margin: const EdgeInsets.only(bottom: 16),
  child: ListTile(
    leading: const Icon(Icons.card_giftcard, color: Colors.purple),
    title: const Text('Vouchers'),
    subtitle: const Text('Browse and purchase vouchers'),
    trailing: const Icon(Icons.arrow_forward),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VoucherScreen(userId: widget.userId),
        ),
      );
    },
  ),
),
```

## Step 3: Add Automatic Streak Validation on App Launch

In `mensa/lib/main.dart` or your main app initialization:

```dart
import 'services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _validateStreaksOnAppStart();
  }

  Future<void> _validateStreaksOnAppStart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      
      if (userId != null) {
        // Validate streaks to check for broken streaks
        await _apiService.validateStreaks(userId);
        
        // Get streak summary
        final summary = await _apiService.getStreakSummary(userId);
        debugPrint('Streak Summary: $summary');
      }
    } catch (e) {
      debugPrint('Error validating streaks: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ... your app configuration
    );
  }
}
```

## Step 4: Add Daily Reminder Notification

In your notification service, add a daily reminder:

```dart
// In notification_service.dart or similar

Future<void> scheduleDailyStreakReminder(String userId) async {
  // Schedule notification for 9 AM daily
  // This depends on your notification package (flutter_local_notifications, etc.)
  
  // Example with flutter_local_notifications:
  await flutterLocalNotificationsPlugin.periodicallyShow(
    0,
    'Daily Streak Reminder',
    'Check in today to maintain your streak and earn 10 points!',
    RepeatInterval.daily,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_streak_channel',
        'Daily Streak Reminders',
        channelDescription: 'Reminders to check in daily',
      ),
    ),
  );
}
```

## Step 5: Create Sample Vouchers (Admin)

Use the admin endpoint to create sample vouchers:

```bash
# Create a health voucher
curl -X POST http://localhost:3000/api/voucher/admin/create \
  -H "Content-Type: application/json" \
  -d '{
    "code": "HEALTH_10",
    "title": "10% Health Store Discount",
    "description": "Get 10% off on health products",
    "points_required": 100,
    "discount_percentage": 10,
    "category": "health",
    "validity_end": "2025-12-31T23:59:59Z",
    "max_redemptions": 50
  }'

# Create a wellness voucher
curl -X POST http://localhost:3000/api/voucher/admin/create \
  -H "Content-Type: application/json" \
  -d '{
    "code": "WELLNESS_YOGA",
    "title": "Free Yoga Class",
    "description": "Redeem for a free yoga session",
    "points_required": 150,
    "discount_amount": 50,
    "category": "wellness",
    "validity_end": "2025-12-31T23:59:59Z",
    "max_redemptions": 100
  }'

# Create a nutrition voucher
curl -X POST http://localhost:3000/api/voucher/admin/create \
  -H "Content-Type: application/json" \
  -d '{
    "code": "NUTRITION_MEAL",
    "title": "Nutrition Consultation",
    "description": "Free consultation with nutritionist",
    "points_required": 200,
    "discount_amount": 100,
    "category": "nutrition",
    "validity_end": "2025-12-31T23:59:59Z",
    "max_redemptions": 30
  }'
```

## Step 6: Display Wallet Points in Dashboard

In your dashboard or main screen, show a quick wallet summary:

```dart
// Add to dashboard
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFFD4C4E8), Color(0xFF9B7FC8)],
    ),
    borderRadius: BorderRadius.circular(16),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Points',
            style: TextStyle(color: Colors.white70),
          ),
          FutureBuilder<Map<String, dynamic>?>(
            future: _apiService.getUserWallet(userId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  '${snapshot.data?['total_points'] ?? 0}',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }
              return Text(
                '0',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            },
          ),
        ],
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VoucherScreen(userId: userId),
            ),
          );
        },
        child: Text('Redeem'),
      ),
    ],
  ),
)
```

## Step 7: Handle Streak Notifications

Add notification handling when streak is broken:

```dart
// In your notification service
Future<void> notifyStreakBroken(String category) async {
  await flutterLocalNotificationsPlugin.show(
    1,
    'Streak Broken! 😢',
    'Your $category streak was broken. Check in today to start a new one!',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'streak_alerts',
        'Streak Alerts',
        channelDescription: 'Alerts for streak status',
      ),
    ),
  );
}

// Call this when streak validation detects a broken streak
Future<void> handleStreakValidation(String userId) async {
  final result = await _apiService.validateStreaks(userId);
  
  if (result != null && result['results'] != null) {
    for (var streakResult in result['results']) {
      if (streakResult['status'] == 'broken') {
        await notifyStreakBroken(streakResult['category']);
      }
    }
  }
}
```

## Step 8: Add Streak Statistics Screen (Optional)

Create a new screen to show detailed streak statistics:

```dart
// mensa/lib/screens/streak_stats_screen.dart

class StreakStatsScreen extends StatefulWidget {
  final String userId;

  const StreakStatsScreen({required this.userId});

  @override
  State<StreakStatsScreen> createState() => _StreakStatsScreenState();
}

class _StreakStatsScreenState extends State<StreakStatsScreen> {
  final ApiService _apiService = ApiService();
  StreakSummary? _summary;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    try {
      final summary = await _apiService.getStreakSummary(widget.userId);
      if (summary != null && mounted) {
        setState(() {
          _summary = StreakSummary.fromJson(summary);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading summary: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streak Statistics'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Display summary data
                    if (_summary != null) ...[
                      Text(
                        'Total Points Earned: ${_summary!.totalPointsEarned}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Active Streaks: ${_summary!.totalActiveStreaks}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      // Display each category
                      ..._summary!.streaksByCategory.entries.map((entry) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.key.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Current: ${entry.value.currentStreak}',
                                ),
                                Text(
                                  'Best: ${entry.value.longestStreak}',
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
```

## Testing Checklist

- [ ] Streak widget displays correctly on all tracker screens
- [ ] Daily check-in button works and updates points
- [ ] Streak breaks after missing a day
- [ ] Wallet shows correct point balance
- [ ] Voucher purchase deducts points
- [ ] Voucher redemption works
- [ ] Transaction history displays correctly
- [ ] Notifications trigger at appropriate times
- [ ] Streak validation runs on app start
- [ ] Points are correctly awarded/deducted

## Common Issues & Solutions

### Issue: Streak not updating after check-in
**Solution**: Ensure the API endpoint is returning success and the wallet is being updated.

### Issue: Points not showing in wallet
**Solution**: Check that the wallet exists for the user and transactions are being recorded.

### Issue: Voucher purchase fails
**Solution**: Verify user has sufficient points and voucher is active.

### Issue: Streak widget not displaying
**Solution**: Ensure StreakWidget is imported and userId/category are passed correctly.

## Performance Optimization

1. **Cache streak data** locally to reduce API calls
2. **Batch validate streaks** for multiple users
3. **Lazy load** voucher lists
4. **Debounce** check-in button to prevent double submissions

## Security Considerations

1. **Validate user ID** on all API calls
2. **Verify points balance** before deducting
3. **Check voucher validity** before redemption
4. **Log all transactions** for audit trail
5. **Rate limit** check-in endpoint to prevent abuse

## Next Steps

1. Integrate streak widget into all tracker screens
2. Add wallet/voucher navigation to profile
3. Create sample vouchers
4. Test all functionality
5. Deploy to production
6. Monitor usage and adjust point values as needed
