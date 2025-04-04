const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const gmailService = require("./gmail_service");
const twilioService = require("./twilio_service");

exports.fetchPlacementEmails = gmailService.fetchPlacementEmails;
exports.makeCall = twilioService.makeCall;
