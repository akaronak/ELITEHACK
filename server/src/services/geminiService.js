const { GoogleGenAI } = require('@google/genai');

class GeminiService {
  constructor() {
    this.apiKey = process.env.GEMINI_API_KEY;
    if (!this.apiKey) {
      console.warn('⚠️ GEMINI_API_KEY not found in environment variables');
      this.ai = null;
    } else {
      this.ai = new GoogleGenAI({ apiKey: this.apiKey });
      console.log('✅ Gemini AI initialized');
    }
  }

  async generateResponse(prompt, context = {}) {
    if (!this.ai) {
      throw new Error('Gemini AI not initialized. Please set GEMINI_API_KEY in .env file');
    }

    try {
      const fullPrompt = this._buildPrompt(prompt, context);
      
      const response = await this.ai.models.generateContent({
        model: 'gemini-2.5-flash',
        contents: fullPrompt,
        config: {
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 2048,
        }
      });
      
      return response.text;
    } catch (error) {
      console.error('Gemini API Error:', error);
      throw new Error('Failed to generate AI response: ' + error.message);
    }
  }

  _buildPrompt(userMessage, context) {
    const systemPrompt = this._getSystemPrompt(context.type || 'general');
    
    let fullPrompt = systemPrompt + '\n\n';
    
    // Add user profile context if available
    if (context.userData) {
      fullPrompt += `User Profile:\n`;
      if (context.userData.age) fullPrompt += `- Age: ${context.userData.age}\n`;
      if (context.userData.bmi) fullPrompt += `- BMI: ${context.userData.bmi}\n`;
      if (context.userData.medical_conditions && context.userData.medical_conditions.length > 0) {
        fullPrompt += `- Medical Conditions: ${context.userData.medical_conditions.join(', ')}\n`;
      }
      if (context.userData.allergies && context.userData.allergies.length > 0) {
        fullPrompt += `- Allergies: ${context.userData.allergies.join(', ')}\n`;
      }
      fullPrompt += '\n';
    }
    
    // Add conversation history for context
    if (context.history && context.history.length > 0) {
      fullPrompt += 'Previous conversation:\n';
      context.history.forEach(msg => {
        const role = msg.role === 'user' ? 'User' : 'Assistant';
        fullPrompt += `${role}: ${msg.content}\n\n`;
      });
    }
    
    fullPrompt += `User: ${userMessage}\n\nAssistant:`;
    
    return fullPrompt;
  }

  _getSystemPrompt(type) {
    const prompts = {
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
}

module.exports = new GeminiService();
