const express = require('express');
const router = express.Router();

// In-memory storage for demo
const menstruationLogs = new Map();
const cycleData = new Map();

// Add menstruation log
router.post('/:userId/log', (req, res) => {
  try {
    const { userId } = req.params;
    const log = {
      log_id: `log_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
      user_id: userId,
      ...req.body,
      created_at: new Date().toISOString(),
    };

    if (!menstruationLogs.has(userId)) {
      menstruationLogs.set(userId, []);
    }

    menstruationLogs.get(userId).push(log);
    
    // Update cycle data
    updateCycleData(userId);

    res.status(201).json(log);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get menstruation logs
router.get('/:userId/logs', (req, res) => {
  try {
    const logs = menstruationLogs.get(req.params.userId) || [];
    res.json(logs.sort((a, b) => new Date(b.date) - new Date(a.date)));
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get predictions
router.get('/:userId/predictions', (req, res) => {
  try {
    const data = cycleData.get(req.params.userId);
    
    if (!data) {
      return res.json({
        predicted_next_period: null,
        average_cycle_length: 28,
        cycle_regularity: 0,
      });
    }

    res.json(data);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get statistics
router.get('/:userId/stats', (req, res) => {
  try {
    const logs = menstruationLogs.get(req.params.userId) || [];
    
    if (logs.length === 0) {
      return res.json({
        total_logs: 0,
        common_symptoms: [],
        mood_patterns: {},
        flow_patterns: {},
      });
    }

    // Calculate statistics
    const symptoms = {};
    const moods = {};
    const flows = {};

    logs.forEach(log => {
      // Count symptoms
      log.symptoms?.forEach(symptom => {
        symptoms[symptom] = (symptoms[symptom] || 0) + 1;
      });

      // Count moods
      moods[log.mood] = (moods[log.mood] || 0) + 1;

      // Count flow levels
      flows[log.flow_level] = (flows[log.flow_level] || 0) + 1;
    });

    // Get top symptoms
    const commonSymptoms = Object.entries(symptoms)
      .sort((a, b) => b[1] - a[1])
      .slice(0, 5)
      .map(([symptom, count]) => ({
        symptom,
        count,
        percentage: Math.round((count / logs.length) * 100),
      }));

    res.json({
      total_logs: logs.length,
      common_symptoms: commonSymptoms,
      mood_patterns: moods,
      flow_patterns: flows,
      insights: generateInsights(logs, commonSymptoms),
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Helper function to update cycle data
function updateCycleData(userId) {
  const logs = menstruationLogs.get(userId) || [];
  
  if (logs.length < 2) return;

  // Find period start dates (when flow changes from None to any flow)
  const periodStarts = [];
  for (let i = 0; i < logs.length - 1; i++) {
    const current = logs[i];
    const previous = logs[i + 1];
    
    if (current.flow_level !== 'None' && 
        (previous.flow_level === 'None' || i === logs.length - 2)) {
      periodStarts.push(new Date(current.date));
    }
  }

  if (periodStarts.length >= 2) {
    // Calculate average cycle length
    const cycleLengths = [];
    for (let i = 0; i < periodStarts.length - 1; i++) {
      const diff = Math.abs(periodStarts[i] - periodStarts[i + 1]);
      const days = Math.ceil(diff / (1000 * 60 * 60 * 24));
      cycleLengths.push(days);
    }

    const avgLength = Math.round(
      cycleLengths.reduce((a, b) => a + b, 0) / cycleLengths.length
    );

    // Calculate regularity (how consistent the cycles are)
    const variance = cycleLengths.reduce((sum, length) => {
      return sum + Math.pow(length - avgLength, 2);
    }, 0) / cycleLengths.length;
    
    const regularity = Math.max(0, 100 - (variance * 5));

    // Predict next period
    const lastPeriod = periodStarts[0];
    const nextPeriod = new Date(lastPeriod);
    nextPeriod.setDate(nextPeriod.getDate() + avgLength);

    cycleData.set(userId, {
      user_id: userId,
      average_cycle_length: avgLength,
      last_period_start: lastPeriod.toISOString(),
      predicted_next_period: nextPeriod.toISOString(),
      cycle_regularity: Math.round(regularity),
      updated_at: new Date().toISOString(),
    });
  }
}

// Helper function to generate AI insights
function generateInsights(logs, commonSymptoms) {
  const insights = [];

  // Cycle regularity insight
  const data = cycleData.get(logs[0].user_id);
  if (data) {
    if (data.cycle_regularity >= 90) {
      insights.push({
        type: 'positive',
        title: 'Regular Cycle',
        message: `Your cycle has been very regular with an average length of ${data.average_cycle_length} days. This is a good sign of hormonal balance.`,
      });
    } else if (data.cycle_regularity < 70) {
      insights.push({
        type: 'warning',
        title: 'Irregular Cycle',
        message: 'Your cycle shows some irregularity. Consider tracking for a few more months. If it persists, consult your healthcare provider.',
      });
    }
  }

  // Symptom insights
  if (commonSymptoms.length > 0) {
    const topSymptom = commonSymptoms[0];
    insights.push({
      type: 'info',
      title: 'Common Symptoms',
      message: `You most frequently experience ${topSymptom.symptom.toLowerCase()} (${topSymptom.percentage}% of logged days). This is common during menstruation.`,
    });
  }

  // Recommendations
  insights.push({
    type: 'recommendation',
    title: 'Health Tips',
    message: '• Stay hydrated during your period\n• Light exercise can help with cramps\n• Iron-rich foods can help prevent fatigue\n• Track symptoms for better predictions',
  });

  return insights;
}

module.exports = router;
