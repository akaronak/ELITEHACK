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
    
    if (context.history) {
      fullPrompt += 'Previous conversation:\n';
      context.history.forEach(msg => {
        fullPrompt += `${msg.role}: ${msg.content}\n`;
      });
      fullPrompt += '\n';
    }
    
    if (context.userData) {
      fullPrompt += `User context: ${JSON.stringify(context.userData)}\n\n`;
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

      menopause: `You are a knowledgeable menopause health assistant.

Your role:
- Provide information about menopause symptoms
- Offer coping strategies and lifestyle advice
- Explain hormonal changes
- Suggest wellness practices
- Identify when medical help is needed

Guidelines:
- Be understanding and supportive
- Provide practical, actionable advice
- Explain medical terms clearly
- Encourage healthy lifestyle choices
- Recommend professional help when appropriate

Always include: "⚕️ Please consult your healthcare provider for personalized medical advice."`,

      general: `You are a helpful women's health assistant. Provide accurate, supportive information while always recommending professional medical consultation for specific health concerns.`
    };

    return prompts[type] || prompts.general;
  }

  async chatMenstruation(userId, message, history = [], userProfile = null) {
    return await this.generateResponse(message, {
      type: 'menstruation',
      history: history.slice(-5), // Last 5 messages for context
      userData: userProfile,
    });
  }

  async chatPregnancy(userId, message, week, history = []) {
    return await this.generateResponse(message, {
      type: 'pregnancy',
      history: history.slice(-5),
      userData: { week, trimester: Math.ceil(week / 13) },
    });
  }

  async chatMenopause(userId, message, history = []) {
    return await this.generateResponse(message, {
      type: 'menopause',
      history: history.slice(-5),
    });
  }
}

module.exports = new GeminiService();
