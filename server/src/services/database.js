const low = require('lowdb');
const FileSync = require('lowdb/adapters/FileSync');
const path = require('path');
const fs = require('fs');

// Ensure data directory exists
const dataDir = path.join(__dirname, '../../data');
if (!fs.existsSync(dataDir)) {
  fs.mkdirSync(dataDir, { recursive: true });
}

// Create database file in server directory
const adapter = new FileSync(path.join(dataDir, 'db.json'));
const db = low(adapter);

// Initialize database with default structure
db.defaults({
  userProfiles: [],
  menstruationLogs: [],
  cycleData: [],
  pregnancyProfiles: [],
  dailyLogs: [],
  menopauseLogs: [],
  fcmTokens: [],
}).write();

module.exports = db;
