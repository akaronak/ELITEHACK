# 🎯 Smart Onboarding Flow - Implementation Plan

## Overview
Create intelligent onboarding that asks users what they're experiencing, collects relevant data, and routes to appropriate tracker.

## Flow

### 1. Welcome Screen
- "Welcome to Mensa!"
- "What brings you here today?"
- 3 options: Pregnancy / Menstruation / Menopause

### 2. Pregnancy Path
**Questions:**
- Name, Age
- Last menstrual period date
- Due date (or calculate from LMP)
- Allergies
- Medical conditions

**Stores:** UserProfile + UserPregnancy
**Routes to:** PregnancyHome

### 3. Menstruation Path
**Questions:**
- Name, Age
- Last period start date
- Average cycle length
- Typical period duration

**Stores:** UserProfile + Cycle setup
**Routes to:** MenstruationHome

### 4. Menopause Path
**Questions:**
- Name, Age
- When symptoms started
- Most common symptoms
- Medical conditions

**Stores:** UserProfile
**Routes to:** MenopauseHome

## Profile Switching
- Add "Change Tracker" option in profile
- Shows current tracker
- Allows switching between trackers
- Preserves all data

## Files to Create/Modify
1. `onboarding_welcome_screen.dart` - Initial choice
2. `onboarding_pregnancy_screen.dart` - Pregnancy Q&A
3. `onboarding_menstruation_screen.dart` - Menstruation Q&A
4. `onboarding_menopause_screen.dart` - Menopause Q&A
5. `profile_screen.dart` - Add tracker switching
6. `main_app_screen.dart` - Check onboarding status

## Implementation in next session due to token limits.
