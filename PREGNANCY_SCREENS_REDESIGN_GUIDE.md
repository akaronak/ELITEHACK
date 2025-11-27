# Pregnancy Screens Redesign Guide 🎨

## Overview
This guide shows how to update all pregnancy screens to match the modern design of menstruation/menopause screens.

---

## Design System

### Color Palette
```dart
static const Color _backgroundColor = Color(0xFFFAF5F5);
static const Color _primaryPink = Color(0xFFE8C4C4);
static const Color _lightPink = Color(0xFFF5E6E6);
static const Color _accentPink = Color(0xFFD4A5A5);
static const Color _darkPink = Color(0xFFA67C7C);
static const Color _greenAccent = Color(0xFFB8D4C8);
static const Color _purpleAccent = Color(0xFFD4C4E8);
static const Color _yellowAccent = Color(0xFFF7E8C8);
```

### AppBar Style
```dart
AppBar(
  backgroundColor: _backgroundColor,
  elevation: 0,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.black87),
    onPressed: () => Navigator.pop(context),
  ),
  title: const Text(
    'Screen Title',
    style: TextStyle(
      color: Colors.black87,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  ),
  centerTitle: true,
)
```

### Card Style
```dart
Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: // content
)
```

---

## Screens to Update

### 1. Checklist Screen
**File:** `mensa/lib/screens/checklist_screen.dart`

**Current Issues:**
- Basic UI
- No modern styling
- Needs card-based layout

**Redesign:**
- Purple/pink gradient header
- White cards for each checklist item
- Checkbox with colored icons
- Progress indicator at top
- Smooth animations

**Key Elements:**
```dart
// Header Card
Container(
  gradient: LinearGradient(
    colors: [_primaryPink, _lightPink],
  ),
  child: Column(
    children: [
      Text('Week X Checklist'),
      LinearProgressIndicator(
        value: completedTasks / totalTasks,
      ),
    ],
  ),
)

// Checklist Item
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
  ),
  child: CheckboxListTile(
    title: Text(task.title),
    subtitle: Text(task.description),
    value: task.completed,
    onChanged: (value) => _updateTask(task),
  ),
)
```

---

### 2. Daily Log Screen
**File:** `mensa/lib/screens/daily_log_screen.dart`

**Current Issues:**
- Basic form layout
- No visual appeal
- Needs better organization

**Redesign:**
- Gradient header with date
- Sectioned cards for:
  - Symptoms
  - Mood
  - Energy Level
  - Notes
- Color-coded sections
- Save button at bottom

**Key Elements:**
```dart
// Symptoms Section
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
  ),
  child: Column(
    children: [
      Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _purpleAccent.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.healing, color: _purpleAccent),
          ),
          SizedBox(width: 12),
          Text('Symptoms', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      Wrap(
        children: symptoms.map((s) => ChoiceChip(...)).toList(),
      ),
    ],
  ),
)
```

---

### 3. Weekly Progress Screen
**File:** `mensa/lib/screens/weekly_progress_screen.dart`

**Current Issues:**
- Basic information display
- No visual hierarchy
- Needs better data presentation

**Redesign:**
- Large week number card (like cycle day)
- Baby development info card
- Mom's body changes card
- Tips and advice cards
- Color-coded sections

**Key Elements:**
```dart
// Week Card
Container(
  gradient: LinearGradient(
    colors: [_primaryPink, _lightPink],
  ),
  child: Column(
    children: [
      Text('Week 24', style: TextStyle(fontSize: 48)),
      Text('Second Trimester'),
      Row(
        children: [
          _buildStatChip('Baby Size', '12 inches'),
          _buildStatChip('Weight', '1.3 lbs'),
        ],
      ),
    ],
  ),
)

// Development Card
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
  ),
  child: Column(
    children: [
      Icon(Icons.child_care, color: _accentPink),
      Text('Baby Development'),
      Text(developmentInfo),
    ],
  ),
)
```

---

### 4. Nutrition Screen
**File:** `mensa/lib/screens/nutrition_screen.dart`

**Current Issues:**
- Basic list layout
- No visual appeal
- Needs better categorization

**Redesign:**
- Gradient header with nutrition goals
- Category cards:
  - Essential Nutrients
  - Recommended Foods
  - Foods to Avoid
- Color-coded by category
- Search/filter functionality

**Key Elements:**
```dart
// Nutrient Card
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
  ),
  child: Row(
    children: [
      Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _greenAccent.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.restaurant, color: _greenAccent),
      ),
      Column(
        children: [
          Text('Folic Acid'),
          Text('400mcg daily'),
        ],
      ),
    ],
  ),
)

// Food Item
Container(
  padding: EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: _greenAccent.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Row(
    children: [
      Text('🥬'),
      Text('Spinach'),
      Text('High in iron'),
    ],
  ),
)
```

---

## Common Components

### Stat Chip
```dart
Widget _buildStatChip(String label, String value, IconData icon) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Icon(icon, color: _darkPink, size: 20),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    ),
  );
}
```

### Section Header
```dart
Widget _buildSectionHeader(String title, IconData icon, Color color) {
  return Row(
    children: [
      Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      SizedBox(width: 12),
      Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}
```

---

## Implementation Steps

### For Each Screen:

1. **Update Colors**
   - Add color constants at top
   - Use consistent palette

2. **Update AppBar**
   - Remove elevation
   - Use transparent background
   - Center title
   - Add back button

3. **Add Gradient Header**
   - Main info card with gradient
   - Large text for key info
   - Stat chips below

4. **Convert to Cards**
   - Wrap sections in white cards
   - Add rounded corners
   - Add soft shadows

5. **Add Section Icons**
   - Icon container with colored background
   - Consistent icon size (20px)
   - Matching section color

6. **Update Buttons**
   - Rounded corners (16px)
   - No elevation
   - Consistent padding
   - Bold text

---

## Quick Reference

### Spacing
- Screen padding: 20px
- Card padding: 20px
- Section spacing: 16-32px
- Element spacing: 8-12px

### Typography
- Title: 28px bold
- Subtitle: 18px medium
- Body: 15px regular
- Caption: 13px regular

### Border Radius
- Cards: 20px
- Buttons: 16px
- Icons: 12px
- Chips: 16px

### Shadows
```dart
BoxShadow(
  color: Colors.black.withValues(alpha: 0.05),
  blurRadius: 10,
  offset: Offset(0, 4),
)
```

---

## Status

📝 **Guide Created** - Complete  
⏳ **Implementation** - Pending  
🎨 **Design System** - Defined  
📋 **Components** - Documented  

Use this guide to update each pregnancy screen to match the modern design! 🎨✨
