const express = require('express');
const router = express.Router();
const db = require('../services/database');

// Save or update user profile
router.post('/:userId/profile', (req, res) => {
  try {
    const { userId } = req.params;
    const profile = {
      ...req.body,
      user_id: userId,
      updated_at: new Date().toISOString(),
    };

    // Check if profile exists
    const existing = db.get('userProfiles')
      .find({ user_id: userId })
      .value();

    if (existing) {
      // Update existing profile
      db.get('userProfiles')
        .find({ user_id: userId })
        .assign(profile)
        .write();
    } else {
      // Create new profile
      profile.created_at = new Date().toISOString();
      db.get('userProfiles')
        .push(profile)
        .write();
    }

    res.status(200).json(profile);
  } catch (error) {
    console.error('Error saving user profile:', error);
    res.status(500).json({ error: error.message });
  }
});

// Get user profile
router.get('/:userId/profile', (req, res) => {
  try {
    const profile = db.get('userProfiles')
      .find({ user_id: req.params.userId })
      .value();

    if (!profile) {
      return res.status(404).json({ error: 'Profile not found' });
    }

    res.json(profile);
  } catch (error) {
    console.error('Error fetching user profile:', error);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
