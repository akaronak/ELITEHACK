# HerOS: UI/UX Design System
## Making the App Feel Alive, Calm, and Personal

---

## DESIGN PHILOSOPHY

**Core Principle:** The app should feel like a supportive friend who knows you, gets you, and makes you feel seen—not judged.

**Visual Language:**
- Soft, calming colors
- Smooth, intentional animations
- Breathing space (generous padding)
- Playful but professional
- Accessible by default

---

## COLOR PALETTES

### Theme 1: Minimal (Clinical, Focus)
```
Primary: #E8E8F0 (soft gray-purple)
Secondary: #4A90A4 (calm teal)
Accent: #2C3E50 (dark slate)
Background: #FAFBFC (almost white)
Text: #2C3E50 (dark slate)
Success: #27AE60 (soft green)
Warning: #F39C12 (warm orange)
Danger: #E74C3C (soft red)
```

### Theme 2: Playful (Fun, Colorful)
```
Primary: #FFB6D9 (soft pink)
Secondary: #A8D8EA (sky blue)
Accent: #AA96DA (lavender)
Background: #FFF5F9 (blush white)
Text: #5A4A6F (deep purple)
Success: #81C784 (playful green)
Warning: #FFB74D (playful orange)
Danger: #EF5350 (playful red)
```

### Theme 3: Nature (Grounding, Holistic)
```
Primary: #6B9E7F (sage green)
Secondary: #C9ADA7 (warm taupe)
Accent: #9A8C98 (muted purple)
Background: #F5F3F0 (cream)
Text: #3E3E3E (charcoal)
Success: #52B788 (forest green)
Warning: #D4A574 (earth orange)
Danger: #D62828 (deep red)
```

### Theme 4: Night (Dark, Soothing)
```
Primary: #6A5ACD (medium slate blue)
Secondary: #20B2AA (light sea green)
Accent: #FFB6C1 (light pink)
Background: #1A1A2E (deep navy)
Surface: #16213E (dark blue)
Text: #E0E0E0 (light gray)
Success: #66BB6A (soft green)
Warning: #FFA726 (soft orange)
Danger: #EF5350 (soft red)
```

### Theme 5: Bold (High-Contrast, Accessible)
```
Primary: #000000 (pure black)
Secondary: #FF1493 (deep pink)
Accent: #FFD700 (gold)
Background: #FFFFFF (pure white)
Text: #000000 (pure black)
Success: #00AA00 (bright green)
Warning: #FF8800 (bright orange)
Danger: #FF0000 (bright red)
```

---

## TYPOGRAPHY

### Font Families
- **Default:** Inter (clean, modern, accessible)
- **Dyslexia-Friendly:** OpenDyslexic (when enabled)
- **Headings:** Poppins (friendly, rounded)

### Font Sizes
```
H1 (Page Title): 32px, weight 700
H2 (Section): 24px, weight 600
H3 (Subsection): 18px, weight 600
Body (Regular): 16px, weight 400
Body (Small): 14px, weight 400
Caption: 12px, weight 400
Button: 16px, weight 600
```

### Line Heights
- Headings: 1.2
- Body: 1.6
- Captions: 1.4

---

## SPACING SYSTEM

```
xs: 4px
sm: 8px
md: 16px
lg: 24px
xl: 32px
xxl: 48px
```

**Rule:** Use multiples of 8px for consistency.

---

## COMPONENT LIBRARY

### 1. Buttons

#### Primary Button
```
Background: Primary color
Text: White
Padding: 16px 24px
Border Radius: 12px
Shadow: Soft (0 4px 12px rgba(0,0,0,0.1))
Hover: Slightly darker, lift effect
Active: Pressed effect
Disabled: 50% opacity
```

#### Secondary Button
```
Background: Transparent
Border: 2px Primary color
Text: Primary color
Padding: 14px 22px
Border Radius: 12px
Hover: Light background fill
```

#### Icon Button
```
Size: 48px (touch target)
Icon: 24px
Background: Transparent
Hover: Light background circle
```

### 2. Input Fields

```
Background: Light (theme-specific)
Border: 1px light gray
Border Radius: 12px
Padding: 14px 16px
Focus: 2px primary color border, subtle glow
Error: Red border + error message below
Placeholder: 60% opacity text
```

### 3. Cards

```
Background: Surface color
Border Radius: 16px
Padding: 20px
Shadow: Soft (0 2px 8px rgba(0,0,0,0.08))
Hover: Slight lift (0 8px 16px rgba(0,0,0,0.12))
```

### 4. Badges & Chips

```
Background: Accent color (20% opacity)
Text: Accent color (100%)
Padding: 6px 12px
Border Radius: 20px
Font Size: 12px
```

### 5. Modals & Dialogs

```
Background: Surface color
Border Radius: 20px
Padding: 24px
Shadow: Deep (0 20px 60px rgba(0,0,0,0.3))
Backdrop: 50% opacity dark overlay
Animation: Fade in + slight scale up (200ms)
```

---

## ANIMATIONS

### Principles
- **Duration:** 200-400ms for most interactions
- **Easing:** Cubic-bezier(0.4, 0, 0.2, 1) (Material standard)
- **Purpose:** Provide feedback, guide attention, delight

### Key Animations

#### 1. Page Transitions
```
Duration: 300ms
Type: Fade + slide up
Easing: Ease-out
```

#### 2. Button Press
```
Duration: 150ms
Type: Scale (0.98) + opacity
Easing: Ease-in-out
```

#### 3. Loading Spinner
```
Duration: 1.5s (loop)
Type: Rotation
Easing: Linear
Color: Primary (animated gradient optional)
```

#### 4. Twin Reactions
```
Duration: 400ms
Type: Bounce + scale
Easing: Ease-out
Examples:
- Pain logged: curl up (scale 0.8, rotate -10°)
- Relief logged: stretch (scale 1.1, rotate 5°)
- Mood logged: expression change (face animation)
```

#### 5. Streak Badge
```
Duration: 500ms
Type: Pop in (scale 0 → 1.1 → 1)
Easing: Cubic-bezier(0.34, 1.56, 0.64, 1) (bounce)
Sound: Subtle chime (optional)
```

#### 6. Insight Reveal
```
Duration: 600ms
Type: Fade in + slide up
Easing: Ease-out
Stagger: 100ms between lines
```

---

## SCREEN LAYOUTS

### 1. Quick Log Hub (Main Entry Point)

```
┌─────────────────────────────────┐
│  HerOS                    ⚙️ 🔔  │
├─────────────────────────────────┤
│                                 │
│  "How's your day, [Name]?"      │
│                                 │
│  ┌─────────────────────────────┐│
│  │  🎡 Wheel Spin              ││
│  │  Quick random Q              ││
│  └─────────────────────────────┘│
│                                 │
│  ┌─────────────────────────────┐│
│  │  💬 Chat                    ││
│  │  Talk to your AI friend      ││
│  └─────────────────────────────┘│
│                                 │
│  ┌─────────────────────────────┐│
│  │  🎤 Voice Dump              ││
│  │  Talk for 10 seconds         ││
│  └─────────────────────────────┘│
│                                 │
│  ┌─────────────────────────────┐│
│  │  👤 Body Selfie             ││
│  │  Emoji reactions             ││
│  └─────────────────────────────┘│
│                                 │
│  ┌─────────────────────────────┐│
│  │  🧘 Drag Twin               ││
│  │  Slider for pain/mood        ││
│  └─────────────────────────────┘│
│                                 │
│  ┌─────────────────────────────┐│
│  │  🤖 Auto-Guess              ││
│  │  Based on your patterns      ││
│  └─────────────────────────────┘│
│                                 │
├─────────────────────────────────┤
│  📊 Dashboard  📚 Learn  👥 Community
```

### 2. Wheel Spin Screen

```
┌─────────────────────────────────┐
│  ← Wheel Spin                   │
├─────────────────────────────────┤
│                                 │
│         🎡 SPIN ME! 🎡          │
│                                 │
│      ┌─────────────────┐        │
│      │   Pain Level?   │        │
│      │   Mood Today?   │        │
│      │   Stress?       │        │
│      │   Energy?       │        │
│      │   Sleep?        │        │
│      │   Hydration?    │        │
│      └─────────────────┘        │
│                                 │
│      [TAP TO SPIN]              │
│                                 │
│  ┌─────────────────────────────┐│
│  │ Question: Rate your pain    ││
│  │ (1-10 slider)               ││
│  │                             ││
│  │ [●────────────────] 5/10    ││
│  │                             ││
│  │ [NEXT] [SKIP]               ││
│  └─────────────────────────────┘│
│                                 │
├─────────────────────────────────┤
│  ✨ Sarcastic insight appears   │
│  "Ah yes, the classic 5/10      │
│   Tuesday pain. Solid."         │
```

### 3. Chat Logging Screen

```
┌─────────────────────────────────┐
│  ← Chat                         │
├─────────────────────────────────┤
│                                 │
│  App: "So, what's your body    │
│       drama today?"             │
│                                 │
│  [Cramps again]                 │
│  [Hormones are terrible]        │
│  [Feel like a goddess]          │
│  [Bleeding like science]        │
│  [Just existing]                │
│                                 │
│  You: [Cramps again]            │
│                                 │
│  App: "On a scale of 'fine'    │
│       to 'dying', how painful?" │
│                                 │
│  [●────────────────] 6/10       │
│                                 │
│  [NEXT]                         │
│                                 │
├─────────────────────────────────┤
│  ✨ "Ah yes, the classic..."   │
```

### 4. Body Selfie Screen

```
┌─────────────────────────────────┐
│  ← Body Selfie                  │
├─────────────────────────────────┤
│                                 │
│  "How's your body feeling?"     │
│                                 │
│  ┌─────────────────────────────┐│
│  │                             ││
│  │      😊 😐 😣 🤔 🎉        ││
│  │                             ││
│  │   Chill / Meh / Achy /      ││
│  │   Confused / Awesome        ││
│  │                             ││
│  │   [SWIPE FOR MORE]          ││
│  │                             ││
│  └─────────────────────────────┘│
│                                 │
│  You selected: 😣 Achy         │
│                                 │
│  [CONFIRM]                      │
│                                 │
├─────────────────────────────────┤
│  ✨ Twin curls up in sympathy  │
```

### 5. Drag Twin Screen

```
┌─────────────────────────────────┐
│  ← Drag Twin                    │
├─────────────────────────────────┤
│                                 │
│  "How's your pain today?"       │
│                                 │
│  ┌─────────────────────────────┐│
│  │                             ││
│  │          👩 (animated)      ││
│  │                             ││
│  │  [●────────────────] 5/10   ││
│  │  Fine              Dying    ││
│  │                             ││
│  │  (Twin reacts as you drag)  ││
│  │                             ││
│  └─────────────────────────────┘│
│                                 │
│  [CONFIRM]                      │
│                                 │
├─────────────────────────────────┤
│  ✨ Twin stretches in relief   │
```

### 6. Voice Dump Screen

```
┌─────────────────────────────────┐
│  ← Voice Dump                   │
├─────────────────────────────────┤
│                                 │
│  "Tell me in 10 seconds how    │
│   your day felt"                │
│                                 │
│  ┌─────────────────────────────┐│
│  │                             ││
│  │      🎤 RECORDING...        ││
│  │                             ││
│  │      ⏱️ 0:05 / 0:10         ││
│  │                             ││
│  │      [STOP]                 ││
│  │                             ││
│  └─────────────────────────────┘│
│                                 │
│  Transcribed: "I'm so tired    │
│  and my cramps are killing me" │
│                                 │
│  Sentiment: Frustrated          │
│  Keywords: tired, cramps        │
│                                 │
│  [CONFIRM] [RE-RECORD]          │
│                                 │
├─────────────────────────────────┤
│  ✨ "Rough day, huh? Rest up." │
```

### 7. Auto-Guess Screen

```
┌─────────────────────────────────┐
│  ← Auto-Guess                   │
├─────────────────────────────────┤
│                                 │
│  "Last Tuesday at 2PM you had  │
│   a headache. Today's Tuesday  │
│   at 1:45PM..."                 │
│                                 │
│  ┌─────────────────────────────┐│
│  │  Feeling it?                ││
│  │                             ││
│  │  [YES] [NO] [WORSE] [BETTER]││
│  │                             ││
│  └─────────────────────────────┘│
│                                 │
│  You: [YES]                     │
│                                 │
│  App: "Oof. Hydrate + rest?"   │
│                                 │
│  [CONFIRM]                      │
│                                 │
├─────────────────────────────────┤
│  ✨ Logged + insight generated  │
```

---

## INSTANT FEEDBACK SYSTEM

### After Every Log

```
┌─────────────────────────────────┐
│  ✨ INSIGHT POPUP               │
├─────────────────────────────────┤
│                                 │
│  "Good self-care choice,       │
│   future you will thank you."   │
│                                 │
│  [DISMISS]                      │
│                                 │
│  Twin animation: stretches      │
│  and smiles                     │
│                                 │
│  Streak badge (if applicable):  │
│  "5-day check-in streak! 🔥"   │
│                                 │
└─────────────────────────────────┘
```

### Sarcastic Insights Examples

```
"Caffeine + period = science experiment vibes."
"You logged pain for the 3rd time this hour. Deep breaths, babe."
"Ah yes, the classic 'stress + period = chaos' combo."
"Your body said 'SHIP IT' today. Time to deep work, babe."
"Nope, today's a 'be kind to yourself' day."
"Your system is screaming. Real talk: you need structural change."
```

---

## TWIN ANIMATIONS

### Character Design
- Simple, cute, gender-neutral
- Expressive face (eyes, mouth)
- Flexible body (can curl, stretch, dance)
- Color-coded by theme

### Reactions

| Action | Animation | Duration |
|--------|-----------|----------|
| Pain logged | Curl up (scale 0.8, rotate -10°) | 400ms |
| Relief logged | Stretch (scale 1.1, rotate 5°) | 400ms |
| Mood logged | Expression change | 300ms |
| Streak achieved | Jump + spin | 500ms |
| Burnout flag | Collapse (dramatic) | 600ms |
| Recovery mode | Relax (breathing animation) | 2s loop |

---

## ACCESSIBILITY FEATURES

### 1. Font Size Slider
```
Min: 12px
Max: 28px
Default: 16px
Increment: 2px
```

### 2. High Contrast Mode
```
- Increase color contrast to WCAG AAA
- Thicker borders
- Larger touch targets (56px minimum)
```

### 3. Dyslexia-Friendly Font
```
- OpenDyslexic font option
- Increased letter spacing
- Increased line height
- Reduced visual clutter
```

### 4. Animation Toggle
```
- Disable all animations (seizure-friendly)
- Reduce motion option
- Instant transitions instead of animations
```

### 5. Screen Reader Support
```
- Semantic HTML/Flutter widgets
- Descriptive labels
- ARIA attributes
- Alt text for images
```

---

## RESPONSIVE DESIGN

### Breakpoints
```
Mobile: 320px - 767px
Tablet: 768px - 1024px
Desktop: 1025px+
```

### Mobile-First Approach
- Design for mobile first
- Enhance for larger screens
- Touch targets: 48px minimum
- Spacing: Generous on mobile

---

## LOADING STATES

### Skeleton Screens
```
- Show placeholder content
- Animated shimmer effect
- Same layout as final content
- Duration: 200-800ms
```

### Loading Spinner
```
- Rotating circle
- Primary color
- 24px size
- Centered on screen
```

### Progress Indicators
```
- Linear progress bar for multi-step
- Circular progress for uploads
- Percentage text
- Smooth animation
```

---

## ERROR STATES

### Error Messages
```
- Clear, non-technical language
- Icon + text
- Actionable suggestions
- Retry button
```

### Example
```
❌ "Couldn't connect to server.
   Check your internet and try again."
   [RETRY]
```

---

## EMPTY STATES

### No Data
```
- Friendly illustration
- Encouraging message
- Call-to-action button
- Suggestion for next step
```

### Example
```
📊 "No logs yet!
   Start by logging how you're feeling today.
   [LOG NOW]"
```

---

## DARK MODE CONSIDERATIONS

### Automatic Switching
- Follow system preference
- Manual override in settings
- Smooth transition (300ms)

### Color Adjustments
- Increase brightness of text
- Reduce brightness of backgrounds
- Maintain contrast ratios

---

## MICRO-INTERACTIONS

### Pull-to-Refresh
```
- Smooth animation
- Haptic feedback (if available)
- Loading spinner
- Success checkmark
```

### Swipe Gestures
```
- Swipe left: next
- Swipe right: previous
- Swipe down: dismiss
- Visual feedback during swipe
```

### Long Press
```
- Show context menu
- Haptic feedback
- 500ms delay
- Visual highlight
```

---

## NOTIFICATION DESIGN

### In-App Notifications
```
- Toast (bottom, auto-dismiss)
- Banner (top, persistent)
- Modal (urgent, requires action)
```

### Push Notifications
```
- Contextual (relevant to user)
- Timely (not intrusive)
- Actionable (clear CTA)
- Opt-in (user controls)
```

---

## FINAL DESIGN CHECKLIST

- [ ] All colors meet WCAG AA contrast ratios
- [ ] All interactive elements are 48px+ touch targets
- [ ] All animations have reduced-motion alternatives
- [ ] All text is readable at 12px minimum
- [ ] All images have alt text
- [ ] All forms have clear labels
- [ ] All errors are helpful and actionable
- [ ] All loading states are clear
- [ ] All empty states are encouraging
- [ ] All micro-interactions feel natural
- [ ] All transitions are smooth (200-400ms)
- [ ] All colors work in light and dark modes
- [ ] All fonts are readable and accessible
- [ ] All spacing follows 8px grid
- [ ] All components are consistent

---

## DESIGN TOKENS (CSS/Flutter)

```dart
// Colors
const Color primary = Color(0xFFE8E8F0);
const Color secondary = Color(0xFF4A90A4);
const Color accent = Color(0xFF2C3E50);
const Color background = Color(0xFFFAFBFC);
const Color text = Color(0xFF2C3E50);
const Color success = Color(0xFF27AE60);
const Color warning = Color(0xFFF39C12);
const Color danger = Color(0xFFE74C3C);

// Spacing
const double xs = 4;
const double sm = 8;
const double md = 16;
const double lg = 24;
const double xl = 32;
const double xxl = 48;

// Border Radius
const double radiusSm = 8;
const double radiusMd = 12;
const double radiusLg = 16;
const double radiusXl = 20;

// Shadows
const BoxShadow shadowSm = BoxShadow(
  color: Color(0x0D000000),
  blurRadius: 4,
  offset: Offset(0, 2),
);

const BoxShadow shadowMd = BoxShadow(
  color: Color(0x14000000),
  blurRadius: 8,
  offset: Offset(0, 4),
);

// Typography
const TextStyle h1 = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.w700,
  height: 1.2,
);

const TextStyle body = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  height: 1.6,
);
```

