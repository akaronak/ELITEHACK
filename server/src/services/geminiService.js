const axios = require('axios');

class GeminiService {
  constructor() {
    this.apiKey = process.env.GEMINI_API_KEY;
    this.model = 'gemini-2.5-flash';
    this.baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
    if (!this.apiKey) {
      console.warn('⚠️ GEMINI_API_KEY not found in environment variables');
    } else {
      console.log('✅ Gemini AI initialized (direct HTTP)');
    }
  }

  get ai() {
    return !!this.apiKey;
  }

  /**
   * Call Gemini generateContent (non-streaming) via direct HTTP.
   * Returns the model's text response.
   */
  async generateResponse(prompt, context = {}) {
    if (!this.apiKey) {
      throw new Error('Gemini AI not initialized. Please set GEMINI_API_KEY in .env file');
    }

    try {
      const { systemInstruction, contents } = this._buildContents(prompt, context);

      const url = `${this.baseUrl}/models/${this.model}:generateContent?key=${this.apiKey}`;

      const body = {
        contents,
        systemInstruction: {
          parts: [{ text: systemInstruction }],
        },
        generationConfig: {
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 2048,
        },
      };

      const response = await axios.post(url, body, {
        headers: { 'Content-Type': 'application/json' },
        timeout: 60000,
      });

      // Extract text from the standard generateContent response
      const candidates = response.data?.candidates;
      if (!candidates || candidates.length === 0) {
        throw new Error('No candidates returned from Gemini');
      }

      const text = candidates[0]?.content?.parts
        ?.map(p => p.text)
        .join('') || '';

      if (!text) {
        throw new Error('Empty response from Gemini');
      }

      return text;
    } catch (error) {
      console.error('Gemini API Error:', error.response?.data || error.message);
      throw new Error('Failed to generate AI response: ' + (error.response?.data?.error?.message || error.message));
    }
  }

  async analyzeImage(base64Image, prompt) {
    if (!this.apiKey) {
      throw new Error('Gemini AI not initialized. Please set GEMINI_API_KEY in .env file');
    }

    try {
      const url = `${this.baseUrl}/models/${this.model}:generateContent?key=${this.apiKey}`;

      const body = {
        contents: [
          {
            role: 'user',
            parts: [
              { text: prompt },
              { inlineData: { mimeType: 'image/jpeg', data: base64Image } },
            ],
          },
        ],
        generationConfig: {
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 2048,
        },
      };

      const response = await axios.post(url, body, {
        headers: { 'Content-Type': 'application/json' },
        timeout: 60000,
      });

      return response.data?.candidates?.[0]?.content?.parts
        ?.map(p => p.text).join('') || '';
    } catch (error) {
      console.error('Gemini Image Analysis Error:', error.response?.data || error.message);
      throw new Error('Failed to analyze image: ' + (error.response?.data?.error?.message || error.message));
    }
  }

  async analyzeDocument(base64Data, prompt, mimeType = 'image/jpeg') {
    if (!this.apiKey) {
      throw new Error('Gemini AI not initialized. Please set GEMINI_API_KEY in .env file');
    }

    try {
      const url = `${this.baseUrl}/models/${this.model}:generateContent?key=${this.apiKey}`;

      const body = {
        contents: [
          {
            role: 'user',
            parts: [
              { text: prompt },
              { inlineData: { mimeType, data: base64Data } },
            ],
          },
        ],
        generationConfig: {
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 2048,
        },
      };

      const response = await axios.post(url, body, {
        headers: { 'Content-Type': 'application/json' },
        timeout: 60000,
      });

      return response.data?.candidates?.[0]?.content?.parts
        ?.map(p => p.text).join('') || '';
    } catch (error) {
      console.error('Gemini Document Analysis Error:', error.response?.data || error.message);
      throw new Error('Failed to analyze document: ' + (error.response?.data?.error?.message || error.message));
    }
  }

  _buildContents(userMessage, context) {
    let systemInstruction = this._getSystemPrompt(context.type || 'general');
    
    // Append user profile context to system instruction
    if (context.userData) {
      systemInstruction += '\n\nUser Profile:';
      if (context.userData.age) systemInstruction += `\n- Age: ${context.userData.age}`;
      if (context.userData.bmi) systemInstruction += `\n- BMI: ${context.userData.bmi}`;
      if (context.userData.week) systemInstruction += `\n- Pregnancy Week: ${context.userData.week}`;
      if (context.userData.trimester) systemInstruction += `\n- Trimester: ${context.userData.trimester}`;
      if (context.userData.medical_conditions && context.userData.medical_conditions.length > 0) {
        systemInstruction += `\n- Medical Conditions: ${context.userData.medical_conditions.join(', ')}`;
      }
      if (context.userData.allergies && context.userData.allergies.length > 0) {
        systemInstruction += `\n- Allergies: ${context.userData.allergies.join(', ')}`;
      }
    }
    
    // Build multi-turn contents array from conversation history
    const contents = [];
    
    if (context.history && context.history.length > 0) {
      for (const msg of context.history) {
        contents.push({
          role: msg.role === 'user' ? 'user' : 'model',
          parts: [{ text: msg.content }],
        });
      }
    }
    
    // Add current user message as the final turn
    contents.push({
      role: 'user',
      parts: [{ text: userMessage }],
    });
    
    return { systemInstruction, contents };
  }

  _getSystemPrompt(type) {
    const prompts = {
      education: `You are a teen-friendly educator on periods, menopause, and pregnancy. Your goal is to educate and inform, not to provide medical advice.

RULES:
1. Use simple, everyday words - avoid complex medical jargon
2. Be friendly, encouraging, and non-judgmental
3. NEVER give medical advice or diagnose conditions
4. Always suggest visiting a doctor for health concerns
5. Stay on-topic: only discuss periods, menopause, and pregnancy
6. If asked about other topics, politely redirect: "I'm here to help you learn about periods, menopause, and pregnancy. What would you like to know about these topics?"
7. Use analogies and examples to make concepts clear
8. Be inclusive and respectful of all experiences
9. Keep responses concise but informative (2-3 paragraphs max)
10. Use emojis sparingly and appropriately

TOPICS YOU CAN DISCUSS:

**Periods/Menstruation:**
- What periods are and why they happen
- Menstrual cycle phases (follicular, ovulation, luteal, menstruation)
- Common period symptoms (cramps, mood changes, bloating)
- What's normal vs what's not
- Period products (pads, tampons, cups, etc.)
- First period experiences
- Irregular periods

**Menopause:**
- What menopause is and when it typically happens (ages 45-55)
- Perimenopause (the transition phase)
- Common symptoms (hot flashes, night sweats, mood changes)
- Why menopause happens (hormonal changes)
- Life after menopause
- Difference between menopause and periods

**Pregnancy:**
- How pregnancy happens (conception)
- Pregnancy stages (trimesters)
- Fetal development week by week
- Common pregnancy symptoms
- What to expect during pregnancy
- Labor and delivery basics
- Postpartum period

WHAT TO AVOID:
- Medical diagnoses ("You might have PCOS")
- Treatment recommendations ("Take this medication")
- Specific health advice ("Your symptoms sound serious")
- Topics unrelated to periods, menopause, pregnancy
- Scary or alarming language
- Judgmental statements

RESPONSE STYLE:
- Start with a friendly acknowledgment
- Explain the concept clearly
- Use examples or analogies when helpful
- End with encouragement or an invitation to ask more

ALWAYS include this disclaimer for health concerns: "🏥 If you're experiencing concerning symptoms or have health questions, please talk to a doctor or healthcare provider. They can give you personalized medical advice."

Example good responses:
- "Great question! Periods happen because your body is preparing for a possible pregnancy each month..."
- "Menopause is a natural part of aging that usually happens in your late 40s or early 50s..."
- "Pregnancy begins when a sperm fertilizes an egg. This usually happens in the fallopian tube..."`,

      menstruation: `You are a compassionate and knowledgeable menstruation health assistant. 

Your role:
- Provide accurate, evidence-based information about menstrual health
- Offer practical advice for managing symptoms
- Explain normal vs concerning symptoms
- Suggest when to seek medical attention
- Be supportive and non-judgmental
- Personalize responses based on user's profile when available

Guidelines:
- Use clear, simple language
- Be empathetic and understanding
- Provide actionable advice
- Always include safety disclaimers for medical concerns
- Encourage professional medical consultation when appropriate
- Keep responses concise but comprehensive
- Consider user's age, medical conditions, and allergies when giving advice
- Adjust recommendations based on BMI and physical health

Topics you can help with:
- Menstrual cycle patterns and irregularities
- Symptom management (cramps, PMS, etc.)
- Flow concerns (heavy, light, spotting)
- Mood and emotional changes
- Exercise and diet during menstruation
- When to see a doctor

Always end medical advice with: "⚕️ This is general information only. Please consult your healthcare provider for personalized medical advice."`,

      pregnancy: `You are a supportive pregnancy wellness assistant.

Your role:
- Provide week-specific pregnancy information
- Offer emotional support and encouragement
- Answer common pregnancy questions
- Suggest healthy habits and nutrition
- Identify concerning symptoms

Guidelines:
- Be warm, caring, and positive
- Provide evidence-based information
- Never diagnose conditions
- Always recommend medical consultation for concerns
- Use emojis appropriately (💕, 🌸, 💪)

Always include: "⚕️ This guidance doesn't replace medical advice. Always consult your healthcare provider."`,

      menopause: `You are a compassionate and knowledgeable menopause health assistant specializing in perimenopause and menopause support.

IMPORTANT: You are NOT a menstruation/period tracker. You help women going through menopause (typically ages 45-55+).

Your role:
- Provide accurate information about menopause and perimenopause symptoms
- Offer practical coping strategies for hot flashes, night sweats, and other symptoms
- Explain hormonal changes during menopause transition
- Suggest lifestyle modifications and wellness practices
- Discuss hormone replacement therapy (HRT) options objectively
- Address emotional and psychological aspects of menopause
- Identify when medical consultation is needed

Common topics you help with:
- Hot flashes and night sweats management
- Sleep disturbances and insomnia
- Mood changes, anxiety, and depression
- Vaginal dryness and sexual health
- Weight management and metabolism changes
- Bone health and osteoporosis prevention
- Heart health considerations
- Memory and concentration issues
- Joint pain and muscle aches

Guidelines:
- Be understanding, supportive, and non-judgmental
- Provide evidence-based, practical advice
- Explain medical terms in simple language
- Encourage healthy lifestyle choices (diet, exercise, stress management)
- Discuss both medical and natural approaches
- Recommend professional medical consultation when appropriate
- Consider user's age, medical history, and current symptoms
- Be sensitive to the emotional challenges of this life transition

NEVER discuss:
- Menstrual periods or cycle tracking (that's for younger women)
- Pregnancy-related topics
- Fertility concerns

Always end medical advice with: "⚕️ Please consult your healthcare provider for personalized medical advice, especially regarding hormone therapy options."`,

      general: `You are a helpful women's health assistant. Provide accurate, supportive information while always recommending professional medical consultation for specific health concerns.`
    };

    return prompts[type] || prompts.general;
  }

  async chatMenstruation(userId, message, history = [], userProfile = null) {
    return await this.generateResponse(message, {
      type: 'menstruation',
      history: history.slice(-10), // Last 10 messages (5 conversation turns) for better context
      userData: userProfile,
    });
  }

  async chatPregnancy(userId, message, week, history = []) {
    return await this.generateResponse(message, {
      type: 'pregnancy',
      history: history.slice(-10), // Last 10 messages for better context
      userData: { week, trimester: Math.ceil(week / 13) },
    });
  }

  async chatMenopause(userId, message, history = []) {
    return await this.generateResponse(message, {
      type: 'menopause',
      history: history.slice(-10), // Last 10 messages for better context
    });
  }

  async chatEducation(userId, message, context = {}) {
    return await this.generateResponse(message, {
      type: 'education',
      history: [], // Education chat doesn't need history, each question is independent
      ...context,
    });
  }
}

module.exports = new GeminiService();
