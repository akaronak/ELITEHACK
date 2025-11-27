const express = require('express');
const router = express.Router();
const db = require('../services/database');

// Add or update menstruation log (upsert)
router.post('/:userId/log', (req, res) => {
  try {
    const { userId } = req.params;
    const { date } = req.body;
    
    // Normalize date to start of day
    const logDate = new Date(date);
    const normalizedDate = new Date(logDate.getFullYear(), logDate.getMonth(), logDate.getDate()).toISOString();
    
    // Check if log exists for this date
    const existingLogIndex = db.get('menstruationLogs')
      .findIndex(log => log.user_id === userId && log.date === normalizedDate)
      .value();

    if (existingLogIndex >= 0) {
      // Update existing log
      const existingLog = db.get('menstruationLogs').nth(existingLogIndex).value();
      
      const updatedLog = {
        ...existingLog,
        ...req.body,
        date: normalizedDate,
        updated_at: new Date().toISOString(),
      };
      
      db.get('menstruationLogs')
        .nth(existingLogIndex)
        .assign(updatedLog)
        .write();
      
      // Update cycle data
      updateCycleData(userId);
      
      res.json(updatedLog);
    } else {
      // Create new log
      const log = {
        log_id: `log_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
        user_id: userId,
        ...req.body,
        date: normalizedDate,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
      };

      db.get('menstruationLogs')
        .push(log)
        .write();
      
      // Update cycle data
      updateCycleData(userId);

      res.status(201).json(log);
    }
  } catch (error) {
    console.error('Error adding/updating log:', error);
    res.status(500).json({ error: error.message });
  }
});

// Get menstruation logs
router.get('/:userId/logs', (req, res) => {
  try {
    const logs = db.get('menstruationLogs')
      .filter({ user_id: req.params.userId })
      .sortBy('date')
      .reverse()
      .value();
    
    res.json(logs);
  } catch (error) {
    console.error('Error fetching logs:', error);
    res.status(500).json({ error: error.message });
  }
});

// Get predictions
router.get('/:userId/predictions', (req, res) => {
  try {
    const data = db.get('cycleData')
      .find({ user_id: req.params.userId })
      .value();
    
    if (!data) {
      return res.json({
        predicted_next_period: null,
        average_cycle_length: 28,
        cycle_regularity: 0,
      });
    }

    res.json(data);
  } catch (error) {
    console.error('Error fetching predictions:', error);
    res.status(500).json({ error: error.message });
  }
});

// Get statistics
router.get('/:userId/stats', (req, res) => {
  try {
    const logs = db.get('menstruationLogs')
      .filter({ user_id: req.params.userId })
      .sortBy('date')
      .reverse()
      .value();
    
    if (logs.length === 0) {
      return res.json({
        total_logs: 0,
        common_symptoms: [],
        mood_patterns: {},
        flow_patterns: {},
        insights: [],
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
      insights: generateInsights(req.params.userId, logs, commonSymptoms),
    });
  } catch (error) {
    console.error('Error fetching stats:', error);
    res.status(500).json({ error: error.message });
  }
});

// Helper function to update cycle data
function updateCycleData(userId) {
  try {
    const logs = db.get('menstruationLogs')
      .filter({ user_id: userId })
      .sortBy('date')
      .reverse()
      .value();
  
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

      const cycleData = {
        user_id: userId,
        average_cycle_length: avgLength,
        last_period_start: lastPeriod.toISOString(),
        predicted_next_period: nextPeriod.toISOString(),
        cycle_regularity: Math.round(regularity),
        updated_at: new Date().toISOString(),
      };

      // Update or create cycle data
      const existing = db.get('cycleData')
        .find({ user_id: userId })
        .value();

      if (existing) {
        db.get('cycleData')
          .find({ user_id: userId })
          .assign(cycleData)
          .write();
      } else {
        db.get('cycleData')
          .push(cycleData)
          .write();
      }
    }
  } catch (error) {
    console.error('Error updating cycle data:', error);
  }
}

// Helper function to generate AI insights
function generateInsights(userId, logs, commonSymptoms) {
  const insights = [];

  try {
    // Cycle regularity insight
    const data = db.get('cycleData')
      .find({ user_id: userId })
      .value();
      
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
      } else {
        insights.push({
          type: 'info',
          title: 'Cycle Pattern',
          message: `Your cycle has an average length of ${data.average_cycle_length} days with ${data.cycle_regularity}% regularity.`,
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
  } catch (error) {
    console.error('Error generating insights:', error);
  }

  return insights;
}

module.exports = router;
