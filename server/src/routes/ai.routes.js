const express = require('express');
const router = express.Router();
const symptomAnalyzer = require('../services/aiSymptomAnalyzer');
const chatAssistant = require('../services/chatAssistant');

// Symptom analysis
router.post('/symptom-analysis', async (req, res) => {
  try {
    const { userId, symptoms, week } = req.body;
    
    if (!symptoms || !week) {
      return res.status(400).json({ error: 'Missing required fields' });
    }
    
    const analysis = await symptomAnalyzer.analyze(symptoms, week);
    res.json(analysis);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Chat with AI assistant (pregnancy - existing)
router.post('/chat', async (req, res) => {
  try {
    const { userId, message, context } = req.body;
    
    if (!userId || !message) {
      return res.status(400).json({ error: 'Missing required fields' });
    }
    
    const response = await chatAssistant.chat(userId, message, context);
    res.json({ response });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Menstruation AI Chat (Gemini-powered)
router.post('/chat/menstruation', async (req, res) => {
  try {
    const { userId, message, history } = req.body;
    
    if (!userId || !message) {
      return res.status(400).json({ error: 'Missing required fields' });
    }
    
    const geminiService = require('../services/geminiService');
    const response = await geminiService.chatMenstruation(userId, message, history || []);
    
    res.json({ response });
  } catch (error) {
    console.error('Menstruation chat error:', error);
    res.status(500).json({ 
      error: error.message,
      fallback: 'I apologize, but I\'m having trouble connecting to the AI service. Please try again later.'
    });
  }
});

// Menopause AI Chat (Gemini-powered)
router.post('/chat/menopause', async (req, res) => {
  try {
    const { userId, message, history } = req.body;
    
    if (!userId || !message) {
      return res.status(400).json({ error: 'Missing required fields' });
    }
    
    const geminiService = require('../services/geminiService');
    const response = await geminiService.chatMenopause(userId, message, history || []);
    
    res.json({ response });
  } catch (error) {
    console.error('Menopause chat error:', error);
    res.status(500).json({ 
      error: error.message,
      fallback: 'I apologize, but I\'m having trouble connecting to the AI service. Please try again later.'
    });
  }
});

module.exports = router;
