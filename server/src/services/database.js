const low = require('lowdb');
const FileSync = require('lowdb/adapters/FileSync');
const path = require('path');

// Create database file in server directory
const adapter = new FileSync(path.join(__dirname, '../../data/db.json'));
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
