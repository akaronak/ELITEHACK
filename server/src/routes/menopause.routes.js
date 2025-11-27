const express = require('express');
const router = express.Router();
const db = require('../services/database');

// Add or update menopause log (upsert)
router.post('/:userId/log', (req, res) => {
  try {
    const { userId } = req.params;
    const { date } = req.body;
    
    // Normalize date to start of day
    const logDate = new Date(date);
    const normalizedDate = new Date(logDate.getFullYear(), logDate.getMonth(), logDate.getDate()).toISOString();
    
    // Check if log exists for this date
    const existingLogIndex = db.get('menopauseLogs')
      .findIndex(log => log.user_id === userId && log.date === normalizedDate)
      .value();

    const logData = {
      ...req.body,
      user_id: userId,
      date: normalizedDate,
      updated_at: new Date().toISOString(),
    };

    if (existingLogIndex >= 0) {
      // Update existing log
      db.get('menopauseLogs')
        .nth(existingLogIndex)
        .assign(logData)
        .write();
      
      res.json({ success: true, message: 'Log updated successfully' });
    } else {
      // Create new log
      logData.created_at = new Date().toISOString();
      
      db.get('menopauseLogs')
        .push(logData)
        .write();

      res.json({ success: true, message: 'Log saved successfully' });
    }
  } catch (error) {
    console.error('Error saving menopause log:', error);
    res.status(500).json({ error: error.message });
  }
});

// Get menopause logs
router.get('/:userId/logs', (req, res) => {
  try {
    const { userId } = req.params;
    
    const logs = db.get('menopauseLogs')
      .filter({ user_id: userId })
      .sortBy('date')
      .reverse()
      .value();

    res.json(logs);
  } catch (error) {
    console.error('Error fetching menopause logs:', error);
    res.status(500).json({ error: error.message });
  }
});

// Generate menopause report
router.post('/:userId/generate-report', async (req, res) => {
  try {
    const { userId } = req.params;
    
    const logs = db.get('menopauseLogs')
      .filter({ user_id: userId })
      .sortBy('date')
      .reverse()
      .take(30) // Last 30 days
      .value();

    if (logs.length === 0) {
      return res.json({
        summary: 'Start tracking your symptoms to get personalized insights!',
        recommendations: [],
      });
    }

    // Calculate statistics
    const totalHotFlashes = logs.reduce((sum, log) => sum + (log.hot_flashes || 0), 0);
    const avgHotFlashes = (totalHotFlashes / logs.length).toFixed(1);
    
    const avgSleepQuality = (
      logs.reduce((sum, log) => sum + (log.sleep_quality || 0), 0) / logs.length
    ).toFixed(1);

    // Count symptom frequency
    const symptomCounts = {};
    logs.forEach(log => {
      if (log.symptoms) {
        log.symptoms.forEach(symptom => {
          symptomCounts[symptom] = (symptomCounts[symptom] || 0) + 1;
        });
      }
    });

    const topSymptoms = Object.entries(symptomCounts)
      .sort((a, b) => b[1] - a[1])
      .slice(0, 3)
      .map(([symptom]) => symptom);

    // Generate summary
    let summary = `Based on ${logs.length} days of tracking:\n\n`;
    summary += `• Average hot flashes: ${avgHotFlashes} per day\n`;
    summary += `• Average sleep quality: ${avgSleepQuality}/10\n`;
    
    if (topSymptoms.length > 0) {
      summary += `• Most common symptoms: ${topSymptoms.join(', ')}\n\n`;
    }

    // Add trend analysis
    if (logs.length >= 7) {
      const recentLogs = logs.slice(0, 7);
      const olderLogs = logs.slice(7, 14);
      
      if (olderLogs.length > 0) {
        const recentAvg = recentLogs.reduce((sum, log) => sum + (log.hot_flashes || 0), 0) / recentLogs.length;
        const olderAvg = olderLogs.reduce((sum, log) => sum + (log.hot_flashes || 0), 0) / olderLogs.length;
        
        if (recentAvg < olderAvg) {
          const decrease = (((olderAvg - recentAvg) / olderAvg) * 100).toFixed(0);
          summary += `Great news! Your hot flashes have decreased by ${decrease}% this week. `;
        } else if (recentAvg > olderAvg) {
          summary += `Your hot flashes have increased slightly this week. Consider stress management techniques. `;
        }
      }
    }

    summary += '\n\nKeep tracking to see more personalized insights!';

    res.json({
      summary,
      statistics: {
        totalDays: logs.length,
        avgHotFlashes,
        avgSleepQuality,
        topSymptoms,
      },
      recommendations: [
        'Maintain a consistent sleep schedule',
        'Stay hydrated throughout the day',
        'Practice stress-reduction techniques',
        'Consider light exercise like walking or yoga',
      ],
    });
  } catch (error) {
    console.error('Error generating menopause report:', error);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
