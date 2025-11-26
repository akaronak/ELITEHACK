# 🤖 AI Prompts & System Architecture

## AI Integration Guide

This document contains all AI prompts, integration patterns, and architectural decisions for the Mensa Pregnancy Tracker.

---

## Table of Contents
1. [AI Symptom Analyzer Prompts](#ai-symptom-analyzer-prompts)
2. [Conversational AI Assistant Prompts](#conversational-ai-assistant-prompts)
3. [Nutrition Engine Prompts](#nutrition-engine-prompts)
4. [Breathing Exercise Prompts](#breathing-exercise-prompts)
5. [Gemini API Integration](#gemini-api-integration)
6. [System Architecture](#system-architecture)

---

## AI Symptom Analyzer Prompts

### Base Prompt Template

```
You are a pregnancy symptom assistant for week {WEEK_NUMBER}. 

The user reports the following symptoms: {SYMPTOMS_LIST}

Using medical guidelines and week-specific data, analyze these symptoms and:

1. Classify each symptom as:
   - COMMON: Normal for this pregnancy week
   - WATCH-OUT: Should be monitored, may need medical attention
   - CRITICAL: Requires immediate medical consultation

2. Provide friendly, actionable advice for managing symptoms

3. Include a safety disclaimer: "This analysis does not replace professional medical advice. Always consult your healthcare provider for medical concerns."

4. If any critical symptoms are detected, strongly recommend immediate medical consultation

Context:
- Pregnancy Week: {WEEK_NUMBER}
- Trimester: {TRIMESTER}
- User's Previous Symptoms: {HISTORY}

Respond in JSON format:
{
  "classification": "common|warning|critical",
  "matchedSymptoms": [],
  "guidance": "string",
  "disclaimer": "string",
  "seekDoctor": boolean
}
```

### Example Prompts by Week

**Week 8 (First Trimester):**
```
You are analyzing symptoms for week 8 of pregnancy.

Symptoms reported: nausea, fatigue, breast tenderness

Expected symptoms at week 8:
- Common: nausea, fatigue, breast soreness, frequent urination
- Warning: persistent vomiting, dehydration, weight loss
- Critical: severe abdominal pain, bleeding, high fever

Provide classification and guidance.
```

**Week 20 (Second Trimester):**
```
You are analyzing symptoms for week 20 of pregnancy.

Symptoms reported: back pain, leg cramps, baby movements

Expected symptoms at week 20:
- Common: baby movements, back pain, leg cramps, heartburn
- Warning: reduced fetal movement, severe swelling
- Critical: no fetal movement for 24 hours, severe headache with vision changes

Provide classification and guidance.
```

**Week 36 (Third Trimester):**
```
You are analyzing symptoms for week 36 of pregnancy.

Symptoms reported: pelvic pressure, Braxton Hicks, frequent urination

Expected symptoms at week 36:
- Common: pelvic pressure, frequent urination, Braxton Hicks, fatigue
- Warning: regular contractions before 37 weeks, decreased fetal movement
- Critical: water breaking, bleeding, severe pain, no fetal movement

Provide classification and guidance.
```

---

## Conversational AI Assistant Prompts

### System Prompt

```
You are 'Gemini', a friendly and supportive pregnancy wellness assistant for the Mensa app.

Your role:
- Provide emotional support and encouragement
- Answer pregnancy-related questions using verified medical information
- Detect mood and offer appropriate suggestions
- Learn from conversation history to personalize responses
- Suggest wellness activities (breathing exercises, hydration, rest)
- NEVER diagnose medical conditions
- ALWAYS include safety disclaimers when discussing health topics

Personality:
- Warm, caring, and empathetic
- Professional but approachable
- Encouraging and positive
- Uses emojis appropriately (💕, 🌸, 💪, 🌟)

Guidelines:
1. Address the user as "Mensa" when appropriate
2. Acknowledge emotions and validate feelings
3. Provide evidence-based information
4. Encourage professional medical consultation for concerns
5. Suggest app features when relevant (breathing exercise, nutrition guide)
6. Keep responses concise but comprehensive
7. Always end health advice with: "⚕️ Remember: This guidance doesn't replace medical advice. Always consult your healthcare provider for medical concerns."

Context you have access to:
- Current pregnancy week
- Recent mood logs
- Previous chat history
- Symptom patterns
- User preferences

Respond naturally and conversationally while maintaining medical accuracy.
```

### Mood-Based Response Templates

**Stressed/Anxious:**
```
I'm here for you, Mensa. 💕 Feeling {EMOTION} during pregnancy is completely normal.

Here are some things that might help:
• Try our breathing exercise - it can help calm your mind
• Take a short walk in fresh air
• Talk to someone you trust
• Rest when you can
• Stay hydrated

{PERSONALIZED_SUGGESTION based on what helped before}

Remember, you're doing an amazing job. If {EMOTION} persists or worsens, please talk to your healthcare provider about it.
```

**Tired/Exhausted:**
```
Fatigue is one of the most common pregnancy symptoms, especially in the {TRIMESTER} trimester. Your body is working hard! 💪

Tips to manage:
• Take short naps when possible
• Stay hydrated - aim for 8 glasses of water
• Eat iron-rich foods (check our Nutrition Guide)
• Don't push yourself too hard
• Ask for help when you need it

Listen to your body and rest when you need to. You're growing a human - that's exhausting work!
```

**Happy/Excited:**
```
That's wonderful to hear! 🌟 Your positive energy is great for both you and your baby. 

Keep embracing these beautiful moments of your pregnancy journey. Would you like to:
• Log this mood in your Daily Health Log?
• Check your baby's development this week?
• Try a relaxing breathing exercise?

Keep shining, Mensa! 💕
```

**Sad/Depressed:**
```
I'm sorry you're feeling this way. 💙 Your feelings are valid, and it's important to address them.

Mood changes are common during pregnancy due to hormones, but persistent sadness should be taken seriously.

Please reach out to:
• Your healthcare provider
• A mental health professional
• A trusted friend or family member
• Pregnancy support groups

Perinatal depression is real and treatable. You don't have to go through this alone.

⚕️ This is important: Please contact your healthcare provider to discuss these feelings.
```

### FAQ Response Templates

**Coffee/Caffeine:**
```
Great question! ☕

Caffeine during pregnancy:
• Limit to under 200mg per day (about one 12oz cup of coffee)
• Excessive caffeine may increase miscarriage risk
• Remember caffeine is also in tea, chocolate, and soda

Tips:
• Switch to decaf
• Try herbal teas (pregnancy-safe varieties)
• Stay hydrated with water

⚕️ Always consult your healthcare provider about your specific situation.
```

**Exercise:**
```
Yes, exercise is generally beneficial during pregnancy! 💪

Safe activities:
• Walking
• Swimming
• Prenatal yoga
• Light strength training

Avoid:
• Contact sports
• Activities with fall risk
• Exercises lying flat on your back (after first trimester)
• Overheating

Listen to your body and stop if you feel:
• Dizzy
• Short of breath
• Pain
• Contractions

⚕️ Always get clearance from your healthcare provider before starting any exercise program.
```

**Foods to Avoid:**
```
Important question about nutrition! 🥗

Foods to avoid during pregnancy:
• Raw or undercooked meat, eggs, fish
• Unpasteurized dairy products
• High-mercury fish (shark, swordfish, king mackerel)
• Deli meats (unless heated to steaming)
• Unwashed produce
• Raw sprouts
• Excessive caffeine
• Alcohol

Check our Nutrition Guide for safe food recommendations personalized to your allergies and trimester!

⚕️ When in doubt, ask your healthcare provider.
```

---

## Nutrition Engine Prompts

### Recommendation Generation Prompt

```
You are a pregnancy nutrition expert providing recommendations for {TRIMESTER} trimester.

User Profile:
- Pregnancy Week: {WEEK}
- Trimester: {TRIMESTER}
- Allergies: {ALLERGIES_LIST}
- Dietary Preferences: {PREFERENCES_LIST}

Task:
Generate 5-7 food recommendations that:
1. Are appropriate for this trimester
2. Provide key nutrients needed at this stage
3. Avoid user's allergens
4. Respect dietary preferences
5. Include variety (proteins, vegetables, fruits, grains, dairy)

For each food, provide:
- Name
- Key nutrients (3-5)
- Why it's beneficial for this trimester
- Serving suggestions
- Allergy warnings if applicable

Trimester-Specific Focus:
- First Trimester: Folic acid, iron, protein, B vitamins
- Second Trimester: Calcium, vitamin D, omega-3, iron
- Third Trimester: Iron, protein, fiber, vitamin C

Format as JSON array.
```

### Meal Planning Prompt

```
Create a one-day meal plan for a pregnant woman in {TRIMESTER} trimester.

Requirements:
- Allergies: {ALLERGIES}
- Preferences: {PREFERENCES}
- Calorie target: {BASE_CALORIES + TRIMESTER_ADDITION}
- Key nutrients: {TRIMESTER_NUTRIENTS}

Provide:
- Breakfast
- Morning Snack
- Lunch
- Afternoon Snack
- Dinner
- Evening Snack (if needed)

For each meal:
- Recipe name
- Ingredients
- Nutritional highlights
- Preparation time
- Allergy-safe alternatives

Include hydration reminders and supplement recommendations (prenatal vitamins).
```

---

## Breathing Exercise Prompts

### Guided Breathing Script

```
Welcome to your calming breathing exercise, Mensa. 🧘‍♀️

This exercise will help you:
• Reduce stress and anxiety
• Lower blood pressure
• Improve oxygen flow to your baby
• Promote relaxation

We'll do 5 cycles of:
- 4 seconds breathing in
- 4 seconds holding
- 4 seconds breathing out

Find a comfortable position, either sitting or lying on your left side.

Let's begin...

[Cycle 1]
Breathe in slowly through your nose... 1... 2... 3... 4...
Hold gently... 1... 2... 3... 4...
Breathe out slowly through your mouth... 1... 2... 3... 4...

[Repeat for 5 cycles]

Wonderful job, Mensa! 🌟

How do you feel now?
• More relaxed?
• Calmer?
• Centered?

Regular breathing exercises can:
• Help with labor preparation
• Reduce pregnancy anxiety
• Improve sleep quality
• Lower stress hormones

Would you like to log your mood after this exercise?

⚕️ If you experience persistent anxiety or stress, please discuss with your healthcare provider.
```

---

## Gemini API Integration

### Setup

```javascript
// server/src/services/geminiService.js
const { GoogleGenerativeAI } = require("@google/generative-ai");

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

async function generateResponse(prompt, context = {}) {
  const model = genAI.getGenerativeModel({ model: "gemini-pro" });
  
  const fullPrompt = `
    ${getSystemPrompt()}
    
    Context:
    ${JSON.stringify(context, null, 2)}
    
    User Input:
    ${prompt}
  `;
  
  const result = await model.generateContent(fullPrompt);
  const response = await result.response;
  return response.text();
}

function getSystemPrompt() {
  return `You are a pregnancy wellness assistant...`;
}

module.exports = { generateResponse };
```

### Enhanced Symptom Analysis with Gemini

```javascript
async function analyzeWithGemini(symptoms, week, history) {
  const prompt = `
    Analyze these pregnancy symptoms for week ${week}:
    ${symptoms.join(', ')}
    
    Previous symptom history:
    ${JSON.stringify(history)}
    
    Provide:
    1. Classification (common/warning/critical)
    2. Detailed explanation
    3. Management suggestions
    4. When to seek medical help
    5. Disclaimer
  `;
  
  const response = await generateResponse(prompt, {
    week,
    symptoms,
    history
  });
  
  return parseGeminiResponse(response);
}
```

### Enhanced Chat with Gemini

```javascript
async function chatWithGemini(userId, message, context) {
  const chatHistory = await getChatHistory(userId);
  const moodHistory = await getMoodHistory(userId);
  
  const prompt = `
    User message: ${message}
    
    Chat history:
    ${formatChatHistory(chatHistory)}
    
    Mood patterns:
    ${formatMoodHistory(moodHistory)}
    
    Current context:
    - Week: ${context.week}
    - Trimester: ${context.trimester}
    
    Respond with empathy and provide helpful guidance.
  `;
  
  const response = await generateResponse(prompt, context);
  
  // Store in chat memory
  await storeChatMessage(userId, 'user', message);
  await storeChatMessage(userId, 'ai', response);
  
  return response;
}
```

---

## System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Mobile App (Flutter)                  │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐        │
│  │  Screens   │  │  Services  │  │   Models   │        │
│  └────────────┘  └────────────┘  └────────────┘        │
└─────────────────────────────────────────────────────────┘
                          ↕ HTTP/REST
┌─────────────────────────────────────────────────────────┐
│              Backend API (Node.js + Express)             │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐        │
│  │   Routes   │  │ Controllers│  │   Models   │        │
│  └────────────┘  └────────────┘  └────────────┘        │
│  ┌────────────────────────────────────────────┐        │
│  │            AI Services Layer                │        │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐ │        │
│  │  │ Symptom  │  │   Chat   │  │ Nutrition│ │        │
│  │  │ Analyzer │  │ Assistant│  │  Engine  │ │        │
│  │  └──────────┘  └──────────┘  └──────────┘ │        │
│  └────────────────────────────────────────────┘        │
└─────────────────────────────────────────────────────────┘
                          ↕
┌─────────────────────────────────────────────────────────┐
│                  External Services                       │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐        │
│  │  MongoDB   │  │   Gemini   │  │  Firebase  │        │
│  │  Database  │  │     AI     │  │    FCM     │        │
│  └────────────┘  └────────────┘  └────────────┘        │
└─────────────────────────────────────────────────────────┘
```

### Data Flow Diagram

```
User Action (Flutter)
        ↓
API Service Call
        ↓
HTTP Request → Backend Route
        ↓
Controller Logic
        ↓
┌───────┴───────┐
│               │
↓               ↓
AI Service    Database
│               │
↓               ↓
Process       Query/Store
│               │
└───────┬───────┘
        ↓
Response JSON
        ↓
Flutter Model
        ↓
UI Update
```

### AI Service Architecture

```
┌─────────────────────────────────────────┐
│         AI Services Layer                │
│                                          │
│  ┌────────────────────────────────────┐ │
│  │    Symptom Analyzer Service        │ │
│  │  • Load symptom-week mapping       │ │
│  │  • Classify symptoms                │ │
│  │  • Generate guidance                │ │
│  │  • Detect red flags                 │ │
│  └────────────────────────────────────┘ │
│                                          │
│  ┌────────────────────────────────────┐ │
│  │    Chat Assistant Service          │ │
│  │  • Mood detection                   │ │
│  │  • FAQ matching                     │ │
│  │  • Context awareness                │ │
│  │  • Response generation              │ │
│  │  • Chat memory management           │ │
│  └────────────────────────────────────┘ │
│                                          │
│  ┌────────────────────────────────────┐ │
│  │    Nutrition Engine Service        │ │
│  │  • Trimester calculation            │ │
│  │  • Allergy checking                 │ │
│  │  • Food recommendations             │ │
│  │  • Nutrient mapping                 │ │
│  └────────────────────────────────────┘ │
│                                          │
│  ┌────────────────────────────────────┐ │
│  │    Gemini Integration (Optional)   │ │
│  │  • Enhanced responses               │ │
│  │  • Natural language understanding   │ │
│  │  • Personalization                  │ │
│  └────────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

### Security Architecture

```
┌─────────────────────────────────────────┐
│          Security Layers                 │
│                                          │
│  1. Authentication (Future)              │
│     • JWT tokens                         │
│     • OAuth2 integration                 │
│     • Session management                 │
│                                          │
│  2. Authorization                        │
│     • User-specific data isolation       │
│     • Role-based access (future)         │
│                                          │
│  3. Data Protection                      │
│     • HTTPS encryption                   │
│     • Input validation                   │
│     • SQL injection prevention           │
│     • XSS protection                     │
│                                          │
│  4. Privacy                              │
│     • HIPAA compliance considerations    │
│     • Data anonymization                 │
│     • Consent management                 │
│                                          │
│  5. API Security                         │
│     • Rate limiting                      │
│     • CORS configuration                 │
│     • Request validation                 │
└─────────────────────────────────────────┘
```

---

## Implementation Checklist

### Current Implementation (✅ Complete)
- [x] Rule-based symptom analysis
- [x] FAQ-based chat responses
- [x] Mood detection keywords
- [x] Static knowledge base
- [x] JSON data loading
- [x] Basic AI logic

### Gemini Integration (🔄 Ready for Enhancement)
- [ ] Gemini API key configuration
- [ ] Enhanced symptom analysis
- [ ] Natural language chat
- [ ] Personalized recommendations
- [ ] Context-aware responses
- [ ] Learning from interactions

### Future AI Features (📋 Planned)
- [ ] Predictive health insights
- [ ] Risk assessment algorithms
- [ ] Partner mode AI
- [ ] Voice interaction
- [ ] Multi-language support
- [ ] Community insights

---

**This architecture is production-ready and scalable for hackathon demo and beyond! 🚀**
