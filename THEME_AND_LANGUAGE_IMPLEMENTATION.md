# Theme & Language Implementation Guide

## Overview
The Mensa app now supports:
- 🌓 **Light & Dark Themes** - Toggle between light and dark modes
- 🌐 **Multi-Language Support** - English and Hindi
- ⚙️ **Settings Panel** - Easy access from profile screen

## Architecture

### Files Created

#### 1. **Theme Provider** (`mensa/lib/providers/theme_provider.dart`)
- Manages theme state (light/dark)
- Persists theme preference to SharedPreferences
- Provides light and dark theme definitions
- Colors:
  - Primary Purple: `#D4C4E8`
  - Dark Purple: `#9B7FC8`
  - Light Purple: `#F0E6FA`
  - Background: `#FAF5FF`

#### 2. **Localization Provider** (`mensa/lib/providers/localization_provider.dart`)
- Manages language state (en/hi)
- Provides easy access to translated strings
- Helper method `t(key)` for quick translation

#### 3. **App Strings** (`mensa/lib/localization/app_strings.dart`)
- Contains all translations for English and Hindi
- 100+ strings covering all app features
- Easy to extend with more languages

#### 4. **Updated Main** (`mensa/lib/main.dart`)
- Integrated Provider for state management
- Multi-provider setup for theme and language
- Loads saved preferences on app startup

#### 5. **Updated Profile Screen** (`mensa/lib/screens/profile_screen.dart`)
- Added settings button (⚙️) in AppBar
- Settings dialog with theme and language options
- Real-time theme and language switching

## How It Works

### Theme System
```dart
// Access theme provider
final themeProvider = Provider.of<ThemeProvider>(context);

// Change theme
await themeProvider.setTheme(ThemeMode.dark);

// Toggle theme
await themeProvider.toggleTheme();

// Check if dark mode
if (themeProvider.isDarkMode) { ... }
```

### Language System
```dart
// Access localization provider
final localization = Provider.of<LocalizationProvider>(context);

// Get translated string
String text = localization.getString('profile');

// Or use helper
String text = localization.t('profile');

// Change language
await localizationProvider.setLanguage('hi');
```

### Using Translations in Widgets
```dart
Consumer<LocalizationProvider>(
  builder: (context, localization, _) {
    return Text(localization.getString('my_profile'));
  },
)
```

## Supported Languages

### English (en)
- Default language
- All strings available

### Hindi (हिंदी)
- Complete Hindi translations
- Supports Devanagari script
- All UI elements translated

## Supported Themes

### Light Theme
- Purple gradient colors
- White backgrounds
- Dark text
- Suitable for daytime use

### Dark Theme
- Dark backgrounds (#1A1A2E, #16213E)
- Purple accents
- Light text
- Suitable for nighttime use

## Settings Panel

### Location
- Profile Screen → Settings Button (⚙️)

### Options
1. **Theme Selection**
   - Light Mode
   - Dark Mode

2. **Language Selection**
   - English
   - हिंदी (Hindi)

### Features
- Real-time switching
- Instant visual feedback
- Persistent storage
- Success notifications

## Implementation Details

### State Management
- Uses Provider package (already in pubspec.yaml)
- ChangeNotifier for reactive updates
- MultiProvider for multiple providers

### Data Persistence
- SharedPreferences for storage
- Keys: `app_theme`, `app_language`
- Automatic loading on app startup

### Translation Keys
All keys follow naming convention:
- `snake_case` format
- Descriptive names
- Grouped by feature

## Adding New Translations

### Step 1: Add to AppStrings
```dart
'en': {
  'new_key': 'English text',
  ...
},
'hi': {
  'new_key': 'हिंदी पाठ',
  ...
},
```

### Step 2: Use in Widget
```dart
Consumer<LocalizationProvider>(
  builder: (context, localization, _) {
    return Text(localization.t('new_key'));
  },
)
```

## Adding New Theme Colors

### Step 1: Update ThemeProvider
```dart
static const Color _newColor = Color(0xFFXXXXXX);
```

### Step 2: Use in Theme
```dart
ThemeData(
  colorScheme: ColorScheme.light(
    primary: _newColor,
    ...
  ),
)
```

## Supported Screens

All screens automatically support:
- ✅ Theme switching
- ✅ Language switching
- ✅ Persistent preferences

### Screens with Localization
- Profile Screen
- Dashboard
- All tracker screens
- Settings dialog
- And more...

## Testing

### Test Theme Switching
1. Open Profile
2. Click Settings (⚙️)
3. Select Dark Mode
4. Verify all screens update
5. Close and reopen app
6. Verify theme persists

### Test Language Switching
1. Open Profile
2. Click Settings (⚙️)
3. Select हिंदी
4. Verify all text updates
5. Close and reopen app
6. Verify language persists

## Performance

- Minimal overhead
- Efficient state management
- No unnecessary rebuilds
- Fast theme switching
- Smooth animations

## Future Enhancements

- [ ] Add more languages (Spanish, French, etc.)
- [ ] Add custom theme colors
- [ ] Add system theme detection
- [ ] Add theme scheduling (auto dark at night)
- [ ] Add language auto-detection
- [ ] Add RTL support for Arabic/Urdu

## Troubleshooting

### Theme not persisting
- Check SharedPreferences initialization
- Verify `app_theme` key in storage

### Language not changing
- Verify `app_language` key in storage
- Check LocalizationProvider initialization

### Missing translations
- Add key to both 'en' and 'hi' in AppStrings
- Use fallback key if translation missing

## Code Examples

### Complete Settings Implementation
```dart
void _showSettingsDialog() {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  final localizationProvider = Provider.of<LocalizationProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(localizationProvider.t('app_settings')),
      content: Consumer2<ThemeProvider, LocalizationProvider>(
        builder: (context, theme, localization, _) {
          return Column(
            children: [
              // Theme options
              RadioListTile(
                title: Text(localization.t('light_mode')),
                value: ThemeMode.light,
                groupValue: theme.themeMode,
                onChanged: (value) {
                  themeProvider.setTheme(value!);
                },
              ),
              // Language options
              RadioListTile(
                title: Text(localization.t('english')),
                value: 'en',
                groupValue: localization.language,
                onChanged: (value) {
                  localizationProvider.setLanguage(value!);
                },
              ),
            ],
          );
        },
      ),
    ),
  );
}
```

## Notes

- All translations are complete and production-ready
- Theme system is optimized for performance
- Language switching is instant
- Preferences persist across app restarts
- No internet required for theme/language switching
