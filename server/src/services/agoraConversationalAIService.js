const axios = require('axios');

class AgoraConversationalAIService {
  constructor() {
    this.appId = process.env.AGORA_APP_ID;
    this.customerId = process.env.AGORA_CUSTOMER_ID;
    this.customerSecret = process.env.AGORA_CUSTOMER_SECRET;
    this.baseUrl = 'https://api.agora.io/api/conversational-ai-agent/v2';

    this.llmApiKey = process.env.AGORA_LLM_API_KEY;
    this.llmModel = process.env.AGORA_LLM_MODEL || 'gemini-2.0-flash';

    this.ttsApiKey = process.env.AGORA_TTS_API_KEY;
    this.ttsModelId = process.env.AGORA_TTS_MODEL_ID || 'sonic-2';
    this.ttsVoiceId = process.env.AGORA_TTS_VOICE_ID || 'e07c00bc-4134-4eae-9ea4-1a55fb45746b';

    if (!this.appId || !this.customerId || !this.customerSecret) {
      console.warn(
        '⚠️ Agora Conversational AI credentials not fully configured. Some features will be disabled.',
      );
    }
  }

  /**
   * Generate base64 encoded credentials for Agora API authentication
   */
  _getAuthHeader() {
    const credentials = `${this.customerId}:${this.customerSecret}`;
    const base64Credentials = Buffer.from(credentials).toString('base64');
    return `Basic ${base64Credentials}`;
  }

  /**
   * Start a conversational AI agent
   * @param {string} channelName - Agora channel name
   * @param {string} token - Agora RTC token for the agent
   * @param {string} agentName - Unique name for the agent
   * @param {Array<number>} remoteUids - UIDs of remote users to interact with
   * @param {Object} systemMessages - Custom system messages for the LLM
   * @returns {Promise<Object>} Agent creation response with agent_id
   */
  async startAgent(
    channelName,
    token,
    agentName,
    remoteUids = [1002],
    systemMessages = null,
  ) {
    try {
      if (!this.appId || !this.customerId || !this.customerSecret) {
        throw new Error('Agora credentials not configured');
      }

      console.log(`🤖 Starting Agora Conversational AI agent: ${agentName}`);
      console.log(`📋 LLM: ${this.llmModel}`);
      console.log(`🔊 TTS: Cartesia ${this.ttsModelId}`);
      console.log(`🎤 ASR: Ares`);

      // Build Gemini URL with API key in query param (per Agora docs)
      const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/${this.llmModel}:streamGenerateContent?alt=sse&key=${this.llmApiKey}`;

      const defaultSystemMessages = [
        {
          parts: [
            {
              text: `You are a friendly health educator specializing in periods, menopause, and pregnancy. Use simple, everyday words. Be friendly and encouraging. Never give medical advice - always suggest visiting a doctor for health concerns. Keep responses concise (2-3 sentences max). Stay on-topic about reproductive health.`,
            },
          ],
          role: 'user',
        },
      ];

      // Exact configuration format from Agora docs
      const requestBody = {
        name: agentName,
        properties: {
          channel: channelName,
          token: token,
          agent_rtc_uid: '999',
          remote_rtc_uids: ['*'], // Subscribe to ALL users in the channel
          idle_timeout: 120,
          // ASR Configuration - Agora Ares (exact format from docs)
          asr: {
            vendor: 'ares',
            language: 'en-US',
          },
          // TTS Configuration - Cartesia (exact format from docs)
          tts: {
            vendor: 'cartesia',
            params: {
              api_key: this.ttsApiKey,
              model_id: this.ttsModelId,
              voice: {
                mode: 'id',
                id: this.ttsVoiceId,
              },
              output_format: {
                container: 'raw',
                sample_rate: 16000,
              },
              language: 'en',
            },
          },
          // LLM Configuration - Google Gemini (exact format from docs)
          llm: {
            url: geminiUrl,
            system_messages: systemMessages || defaultSystemMessages,
            max_history: 32,
            greeting_message: 'Hello! I am your health educator. How can I help you today?',
            failure_message: 'Hold on a second.',
            params: {
              model: this.llmModel,
            },
            style: 'gemini',
          },
        },
      };

      console.log('📤 Request body:', JSON.stringify(requestBody, null, 2));

      const response = await axios.post(
        `${this.baseUrl}/projects/${this.appId}/join`,
        requestBody,
        {
          headers: {
            Authorization: this._getAuthHeader(),
            'Content-Type': 'application/json',
          },
        },
      );

      console.log('✅ Agent started successfully');
      console.log('📊 Agent ID:', response.data.agent_id);
      console.log('📊 Status:', response.data.status);
      
      return {
        success: true,
        agentId: response.data.agent_id,
        status: response.data.status,
        createdAt: response.data.create_ts,
      };
    } catch (error) {
      console.error('❌ Error starting agent:', error.message);
      if (error.response) {
        console.error('Response status:', error.response.status);
        console.error('Response data:', error.response.data);
      }
      throw error;
    }
  }

  /**
   * Stop a conversational AI agent
   * @param {string} agentId - The agent ID to stop
   * @returns {Promise<Object>} Stop response
   */
  async stopAgent(agentId) {
    try {
      if (!this.appId || !this.customerId || !this.customerSecret) {
        throw new Error('Agora credentials not configured');
      }

      console.log(`🛑 Stopping Agora Conversational AI agent: ${agentId}`);

      const response = await axios.post(
        `${this.baseUrl}/projects/${this.appId}/agents/${agentId}/leave`,
        {},
        {
          headers: {
            Authorization: this._getAuthHeader(),
            'Content-Type': 'application/json',
          },
        },
      );

      console.log('✅ Agent stopped successfully');
      return {
        success: true,
        message: 'Agent stopped',
      };
    } catch (error) {
      // Handle 404 - agent may have already been stopped by idle timeout
      if (error.response && error.response.status === 404) {
        console.warn('⚠️ Agent already stopped or not found (404)');
        return {
          success: true,
          message: 'Agent already stopped',
        };
      }

      console.error('❌ Error stopping agent:', error.message);
      if (error.response) {
        console.error('Response status:', error.response.status);
        console.error('Response data:', error.response.data);
      }
      throw error;
    }
  }

  /**
   * Query agent status
   * @param {string} agentId - The agent ID to query
   * @returns {Promise<Object>} Agent status
   */
  async queryAgentStatus(agentId) {
    try {
      if (!this.appId || !this.customerId || !this.customerSecret) {
        throw new Error('Agora credentials not configured');
      }

      const response = await axios.get(
        `${this.baseUrl}/projects/${this.appId}/agents/${agentId}`,
        {
          headers: {
            Authorization: this._getAuthHeader(),
            'Content-Type': 'application/json',
          },
        },
      );

      return {
        success: true,
        agentId: response.data.agent_id,
        status: response.data.status,
        createdAt: response.data.create_ts,
      };
    } catch (error) {
      console.error('❌ Error querying agent status:', error.message);
      throw error;
    }
  }

  /**
   * Update agent configuration
   * @param {string} agentId - The agent ID to update
   * @param {Object} updates - Configuration updates
   * @returns {Promise<Object>} Update response
   */
  async updateAgent(agentId, updates) {
    try {
      if (!this.appId || !this.customerId || !this.customerSecret) {
        throw new Error('Agora credentials not configured');
      }

      console.log(`🔄 Updating agent: ${agentId}`);

      const response = await axios.patch(
        `${this.baseUrl}/projects/${this.appId}/agents/${agentId}`,
        { properties: updates },
        {
          headers: {
            Authorization: this._getAuthHeader(),
            'Content-Type': 'application/json',
          },
        },
      );

      console.log('✅ Agent updated successfully');
      return {
        success: true,
        agentId: response.data.agent_id,
        status: response.data.status,
      };
    } catch (error) {
      console.error('❌ Error updating agent:', error.message);
      throw error;
    }
  }

  /**
   * Get a greeting message from the AI
   * Uses pre-defined greetings to avoid rate limits
   * @returns {Promise<string>} Greeting message
   */
  async generateGreeting() {
    try {
      // Use pre-defined greetings to avoid Gemini API rate limits
      const greetings = [
        'Hello! I\'m your health educator. Feel free to ask me anything about periods, menopause, or pregnancy.',
        'Hi there! I\'m here to help you learn about reproductive health. What would you like to know?',
        'Welcome! I\'m your AI health educator. Ask me anything about periods, menopause, or pregnancy.',
        'Hello! I\'m excited to chat with you about health and wellness. What\'s on your mind?',
        'Hi! I\'m here to provide friendly, educational information about your health. What can I help with?',
      ];

      // Select a random greeting
      const greeting = greetings[Math.floor(Math.random() * greetings.length)];

      console.log(`✅ Greeting selected: ${greeting}`);
      return greeting;
    } catch (error) {
      console.error('❌ Error getting greeting:', error.message);

      // Return a default greeting if anything fails
      return 'Hello! I\'m your health educator. Feel free to ask me anything about periods, menopause, or pregnancy.';
    }
  }

  /**
   * Get service status
   * @returns {Object} Service status
   */
  getStatus() {
    return {
      service: 'agora_conversational_ai',
      configured:
        !!this.appId && !!this.customerId && !!this.customerSecret,
      appId: this.appId ? '***' : 'not_set',
      llmModel: this.llmModel,
      llmVendor: 'gemini',
      ttsVendor: 'cartesia',
      ttsModelId: this.ttsModelId,
      asrVendor: 'ares',
      asrNote: 'Using Agora built-in Ares STT',
      greetingType: 'Pre-defined (no API calls)',
    };
  }
}

module.exports = new AgoraConversationalAIService();
