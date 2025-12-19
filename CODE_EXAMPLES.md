# Code Examples: Daily Streak & Wallet System

## Flutter Examples

### Example 1: Add Streak Widget to Menstruation Tracker

```dart
import 'package:flutter/material.dart';
import '../widgets/streak_widget.dart';
import '../screens/wallet_screen.dart';
import '../screens/voucher_screen.dart';

class MenstruationHomeScreen extends StatefulWidget {
  final String userId;

  const MenstruationHomeScreen({required this.userId});

  @override
  State<MenstruationHomeScreen> createState() => _MenstruationHomeScreenState();
}

class _MenstruationHomeScreenState extends State<MenstruationHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menstruation Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.wallet),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WalletScreen(userId: widget.userId),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.card_giftcard),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VoucherScreen(userId: widget.userId),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Streak Widget
              StreakWidget(
                userId: widget.userId,
                category: 'menstruation',
                onStreakUpdated: () {
                  setState(() {});
                },
              ),
              
              const SizedBox(height: 24),
              
              // Rest of your widgets...
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Your other content here'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Example 2: Display Wallet Points in Dashboard

```dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  final String userId;

  const DashboardScreen({required this.userId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _apiService.getUserWallet(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final wallet = snapshot.data;
          final points = wallet?['total_points'] ?? 0;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Points Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFD4C4E8),
                          Color(0xFF9B7FC8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Points',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '$points',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to vouchers
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          child: const Text('Redeem Vouchers'),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Rest of dashboard...
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
```

### Example 3: Handle Streak Check-in with Error Handling

```dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class StreakCheckInExample extends StatefulWidget {
  final String userId;
  final String category;

  const StreakCheckInExample({
    required this.userId,
    required this.category,
  });

  @override
  State<StreakCheckInExample> createState() => _StreakCheckInExampleState();
}

class _StreakCheckInExampleState extends State<StreakCheckInExample> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _handleCheckIn() async {
    setState(() => _isLoading = true);

    try {
      final result = await _apiService.checkInStreak(
        widget.userId,
        widget.category,
      );

      if (mounted) {
        if (result != null && result['success'] == true) {
          // Success
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Check-in successful!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Show points awarded
          final pointsAwarded = result['points_awarded'] ?? 10;
          _showPointsAnimation(pointsAwarded);

          // Refresh UI
          setState(() {});
        } else {
          // Error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result?['error'] ?? 'Check-in failed. Please try again.',
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error during check-in: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Network error. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showPointsAnimation(int points) {
    // Show animated points popup
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Points Earned! 🎉'),
        content: Text('You earned +$points points'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Great!'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleCheckIn,
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text('Check In Today'),
    );
  }
}
```

### Example 4: Display Streak Summary

```dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/streak.dart';

class StreakSummaryWidget extends StatefulWidget {
  final String userId;

  const StreakSummaryWidget({required this.userId});

  @override
  State<StreakSummaryWidget> createState() => _StreakSummaryWidgetState();
}

class _StreakSummaryWidgetState extends State<StreakSummaryWidget> {
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
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_summary == null) {
      return const Text('No streak data available');
    }

    return Column(
      children: [
        // Total Points
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Points Earned'),
                Text(
                  '${_summary!.totalPointsEarned}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Active Streaks
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Active Streaks'),
                Text(
                  '${_summary!.totalActiveStreaks}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Streaks by Category
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Current: ${entry.value.currentStreak}'),
                      Text('Best: ${entry.value.longestStreak}'),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
```

## Node.js/Backend Examples

### Example 1: Create Sample Vouchers

```javascript
// Create vouchers via API
const axios = require('axios');

async function createSampleVouchers() {
  const baseUrl = 'http://localhost:3000/api';

  const vouchers = [
    {
      code: 'HEALTH_10',
      title: '10% Health Store Discount',
      description: 'Get 10% off on health products',
      points_required: 100,
      discount_percentage: 10,
      category: 'health',
      validity_end: new Date(Date.now() + 90 * 24 * 60 * 60 * 1000),
      max_redemptions: 50,
    },
    {
      code: 'WELLNESS_YOGA',
      title: 'Free Yoga Class',
      description: 'Redeem for a free yoga session',
      points_required: 150,
      discount_amount: 50,
      category: 'wellness',
      validity_end: new Date(Date.now() + 90 * 24 * 60 * 60 * 1000),
      max_redemptions: 100,
    },
    {
      code: 'NUTRITION_MEAL',
      title: 'Nutrition Consultation',
      description: 'Free consultation with nutritionist',
      points_required: 200,
      discount_amount: 100,
      category: 'nutrition',
      validity_end: new Date(Date.now() + 90 * 24 * 60 * 60 * 1000),
      max_redemptions: 30,
    },
  ];

  for (const voucher of vouchers) {
    try {
      const response = await axios.post(
        `${baseUrl}/voucher/admin/create`,
        voucher
      );
      console.log(`✅ Created voucher: ${voucher.code}`);
    } catch (error) {
      console.error(`❌ Failed to create ${voucher.code}:`, error.message);
    }
  }
}

createSampleVouchers();
```

### Example 2: Validate Streaks Scheduled Task

```javascript
// Add to your server startup or use a cron job
const cron = require('node-cron');
const db = require('./services/database');

// Run streak validation every day at midnight
cron.schedule('0 0 * * *', () => {
  console.log('🔄 Running daily streak validation...');
  validateAllStreaks();
});

function validateAllStreaks() {
  try {
    const users = db.get('streaks')
      .map(s => s.user_id)
      .uniq()
      .value();

    users.forEach(userId => {
      const streaks = db.get('streaks')
        .filter({ user_id: userId })
        .value();

      streaks.forEach(streak => {
        const today = new Date().toDateString();
        const lastCheckIn = streak.last_check_in_date
          ? new Date(streak.last_check_in_date).toDateString()
          : null;

        if (lastCheckIn !== today) {
          const yesterday = new Date();
          yesterday.setDate(yesterday.getDate() - 1);
          const yesterdayStr = yesterday.toDateString();

          if (lastCheckIn !== yesterdayStr && streak.current_streak > 0) {
            // Streak broken
            deductStreakPenalty(userId, streak.category, streak.current_streak);
            streak.current_streak = 0;
            streak.updated_at = new Date().toISOString();

            db.get('streaks')
              .find({ streak_id: streak.streak_id })
              .assign(streak)
              .write();

            console.log(
              `⚠️ Streak broken for ${userId} - ${streak.category}`
            );
          }
        }
      });
    });

    console.log('✅ Streak validation completed');
  } catch (error) {
    console.error('Error validating streaks:', error);
  }
}
```

### Example 3: Get User Statistics

```javascript
// Add to your routes
router.get('/:userId/statistics', (req, res) => {
  try {
    const { userId } = req.params;

    // Get all streaks
    const streaks = db.get('streaks')
      .filter({ user_id: userId })
      .value();

    // Get wallet
    const wallet = db.get('userWallets')
      .find({ user_id: userId })
      .value();

    // Calculate statistics
    const stats = {
      total_streaks: streaks ? streaks.length : 0,
      active_streaks: streaks
        ? streaks.filter(s => s.current_streak > 0).length
        : 0,
      total_points: wallet ? wallet.total_points : 0,
      total_earned: wallet
        ? wallet.points_history
            .filter(t => t.type === 'earned')
            .reduce((sum, t) => sum + t.amount, 0)
        : 0,
      total_spent: wallet
        ? wallet.points_history
            .filter(t => t.type === 'redeemed')
            .reduce((sum, t) => sum + t.amount, 0)
        : 0,
      streaks_by_category: {},
    };

    if (streaks) {
      streaks.forEach(streak => {
        stats.streaks_by_category[streak.category] = {
          current: streak.current_streak,
          longest: streak.longest_streak,
        };
      });
    }

    res.json(stats);
  } catch (error) {
    console.error('Error fetching statistics:', error);
    res.status(500).json({ error: error.message });
  }
});
```

## Testing Examples

### Example 1: Test Streak Check-in

```bash
#!/bin/bash

USER_ID="user123"
CATEGORY="menstruation"
API_URL="http://localhost:3000/api"

echo "Testing Streak Check-in..."

# Check-in
curl -X POST "$API_URL/streak/$USER_ID/$CATEGORY/check-in" \
  -H "Content-Type: application/json" \
  -d '{}' | jq .

echo ""
echo "Getting streak..."

# Get streak
curl -X GET "$API_URL/streak/$USER_ID/$CATEGORY" | jq .

echo ""
echo "Getting wallet..."

# Get wallet
curl -X GET "$API_URL/wallet/$USER_ID" | jq .
```

### Example 2: Test Voucher Purchase

```bash
#!/bin/bash

USER_ID="user123"
VOUCHER_ID="voucher_123"
API_URL="http://localhost:3000/api"

echo "Testing Voucher Purchase..."

# Get available vouchers
echo "Available Vouchers:"
curl -X GET "$API_URL/voucher/available" | jq .

echo ""
echo "Purchasing voucher..."

# Purchase voucher
curl -X POST "$API_URL/voucher/$USER_ID/purchase" \
  -H "Content-Type: application/json" \
  -d "{\"voucher_id\": \"$VOUCHER_ID\"}" | jq .

echo ""
echo "Getting user vouchers..."

# Get user vouchers
curl -X GET "$API_URL/voucher/$USER_ID/my-vouchers" | jq .
```

## Integration Examples

### Example 1: Complete Tracker Integration

```dart
import 'package:flutter/material.dart';
import '../widgets/streak_widget.dart';
import '../screens/wallet_screen.dart';
import '../screens/voucher_screen.dart';
import '../services/api_service.dart';

class CompleteTrackerExample extends StatefulWidget {
  final String userId;

  const CompleteTrackerExample({required this.userId});

  @override
  State<CompleteTrackerExample> createState() => _CompleteTrackerExampleState();
}

class _CompleteTrackerExampleState extends State<CompleteTrackerExample> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _wallet;

  @override
  void initState() {
    super.initState();
    _loadWallet();
    _validateStreaks();
  }

  Future<void> _loadWallet() async {
    final wallet = await _apiService.getUserWallet(widget.userId);
    if (mounted) {
      setState(() => _wallet = wallet);
    }
  }

  Future<void> _validateStreaks() async {
    await _apiService.validateStreaks(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Tracker'),
        actions: [
          // Points Badge
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '💎 ${_wallet?['total_points'] ?? 0}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Wallet Button
          IconButton(
            icon: const Icon(Icons.wallet),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WalletScreen(userId: widget.userId),
                ),
              );
            },
          ),
          // Voucher Button
          IconButton(
            icon: const Icon(Icons.card_giftcard),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VoucherScreen(userId: widget.userId),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Streak Widget
              StreakWidget(
                userId: widget.userId,
                category: 'menstruation',
                onStreakUpdated: _loadWallet,
              ),
              
              const SizedBox(height: 24),
              
              // Other content...
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Your tracker content here'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

These examples cover the most common use cases for the Daily Streak & Wallet System. Adapt them to your specific needs!
