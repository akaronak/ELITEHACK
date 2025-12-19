# Phone Number UI Integration Guide

This guide shows how to add phone number collection to your Flutter app UI.

## Option 1: Add to Profile Screen

### Update profile_screen.dart

```dart
import 'package:flutter/material.dart';
import 'package:mensa/services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController phoneController = TextEditingController();
  String userId = 'user_123'; // Get from auth/session
  bool isLoading = false;
  String? savedPhone;

  @override
  void initState() {
    super.initState();
    _loadPhoneNumber();
  }

  Future<void> _loadPhoneNumber() async {
    final phone = await apiService.getPhoneNumber(userId);
    setState(() {
      savedPhone = phone;
      phoneController.text = phone ?? '';
    });
  }

  Future<void> _savePhoneNumber() async {
    if (phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a phone number')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      bool success = await apiService.updatePhoneNumber(
        userId,
        phoneController.text,
      );

      if (success) {
        setState(() => savedPhone = phoneController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Phone number saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save phone number'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Settings')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WhatsApp Notifications',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            Text(
              'Add your phone number to receive health reminders and notifications via WhatsApp.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 24),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: '+1234567890',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
                helperText: 'Format: +[country code][number]',
                suffixIcon: savedPhone != null
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : null,
              ),
              keyboardType: TextInputType.phone,
              enabled: !isLoading,
            ),
            SizedBox(height: 16),
            if (savedPhone != null)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Phone number saved: $savedPhone',
                        style: TextStyle(color: Colors.green.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _savePhoneNumber,
                child: isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('Save Phone Number'),
              ),
            ),
            SizedBox(height: 24),
            Divider(),
            SizedBox(height: 16),
            Text(
              'Notification Preferences',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('WhatsApp Notifications'),
              subtitle: Text('Receive health reminders via WhatsApp'),
              value: true,
              onChanged: (value) {
                // TODO: Implement notification preference toggle
              },
            ),
            CheckboxListTile(
              title: Text('Daily Check-in Reminders'),
              subtitle: Text('Get reminded to log your health daily'),
              value: true,
              onChanged: (value) {
                // TODO: Implement daily reminder toggle
              },
            ),
            CheckboxListTile(
              title: Text('Streak Notifications'),
              subtitle: Text('Get notified about your health streaks'),
              value: true,
              onChanged: (value) {
                // TODO: Implement streak notification toggle
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}
```

---

## Option 2: Add to Onboarding/Registration

### Create phone_number_setup_screen.dart

```dart
import 'package:flutter/material.dart';
import 'package:mensa/services/api_service.dart';

class PhoneNumberSetupScreen extends StatefulWidget {
  final String userId;

  const PhoneNumberSetupScreen({required this.userId});

  @override
  State<PhoneNumberSetupScreen> createState() => _PhoneNumberSetupScreenState();
}

class _PhoneNumberSetupScreenState extends State<PhoneNumberSetupScreen> {
  final ApiService apiService = ApiService();
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  Future<void> _continueWithPhone() async {
    if (phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      bool success = await apiService.updatePhoneNumber(
        widget.userId,
        phoneController.text,
      );

      if (success) {
        // Navigate to next screen
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save phone number')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setup Notifications')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_active,
              size: 64,
              color: Colors.blue,
            ),
            SizedBox(height: 24),
            Text(
              'Stay Connected',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'Get personalized health reminders and tips via WhatsApp',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: '+1234567890',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                helperText: 'Include country code (e.g., +1 for USA)',
              ),
              keyboardType: TextInputType.phone,
              enabled: !isLoading,
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _continueWithPhone,
                child: isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Text('Continue'),
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () => Navigator.of(context).pushReplacementNamed('/home'),
              child: Text('Skip for now'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}
```

---

## Option 3: Add to Settings/Preferences Screen

### Create notification_settings_screen.dart

```dart
import 'package:flutter/material.dart';
import 'package:mensa/services/api_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final ApiService apiService = ApiService();
  String userId = 'user_123'; // Get from auth
  String? phoneNumber;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPhoneNumber();
  }

  Future<void> _loadPhoneNumber() async {
    final phone = await apiService.getPhoneNumber(userId);
    setState(() => phoneNumber = phone);
  }

  void _showPhoneNumberDialog() {
    final controller = TextEditingController(text: phoneNumber ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Phone Number'),
        content: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: '+1234567890',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              bool success = await apiService.updatePhoneNumber(
                userId,
                controller.text,
              );

              if (success) {
                setState(() => phoneNumber = controller.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Phone number updated!')),
                );
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notification Settings')),
      body: ListView(
        children: [
          ListTile(
            title: Text('WhatsApp Phone Number'),
            subtitle: Text(phoneNumber ?? 'Not set'),
            trailing: Icon(Icons.edit),
            onTap: _showPhoneNumberDialog,
          ),
          Divider(),
          SwitchListTile(
            title: Text('WhatsApp Notifications'),
            subtitle: Text('Receive messages via WhatsApp'),
            value: phoneNumber != null,
            onChanged: (value) {
              if (value) {
                _showPhoneNumberDialog();
              }
            },
          ),
          SwitchListTile(
            title: Text('Daily Reminders'),
            subtitle: Text('Get reminded to log your health'),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: Text('Streak Notifications'),
            subtitle: Text('Get notified about your streaks'),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: Text('Health Tips'),
            subtitle: Text('Receive personalized health tips'),
            value: true,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}
```

---

## Integration Steps

1. **Choose an option** above based on your app flow
2. **Copy the code** into your Flutter project
3. **Update the `userId`** to get it from your auth system
4. **Add route** to your navigation (if needed)
5. **Test** by entering a phone number and checking the database

---

## Testing the Integration

### In Flutter

```dart
// Test phone number update
bool success = await apiService.updatePhoneNumber(
  'test_user',
  '+1234567890',
);
print('Phone saved: $success');

// Test phone number retrieval
String? phone = await apiService.getPhoneNumber('test_user');
print('Phone: $phone');
```

### In Database

Check `server/data/db.json`:

```json
{
  "users": [
    {
      "user_id": "test_user",
      "phone_number": "+1234567890",
      "created_at": "2025-12-20T10:00:00Z",
      "updated_at": "2025-12-20T10:00:00Z"
    }
  ]
}
```

---

## Next Steps

1. Implement one of the UI options above
2. Test phone number storage
3. Send test WhatsApp notifications
4. Set up automated notification schedules
5. Add notification preferences/toggles

See `PHONE_NUMBER_SETUP.md` for complete API documentation.
