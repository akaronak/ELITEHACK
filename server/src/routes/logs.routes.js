const express = require('express');
const router = express.Router();
const DailyLog = require('../models/dailyLogs.model');

// Get all logs for a user
router.get('/:userId', (req, res) => {
  try {
    const logs = DailyLog.findByUserId(req.params.userId);
    res.json(logs);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Add a daily log
router.post('/:userId', (req, res) => {
  try {
    const log = DailyLog.create({
      ...req.body,
      user_id: req.params.userId,
    });
    
    res.status(201).json(log);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
