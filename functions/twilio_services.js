const functions = require("firebase-functions");
const twilio = require("twilio");

const client = new twilio("TWILIO_ACCOUNT_SID", "TWILIO_AUTH_TOKEN");

exports.makeCall = functions.https.onCall(async (data, context) => {
  const studentPhone = data.phone;

  const call = await client.calls.create({
    url: "http://twimlets.com/holdmusic?Bucket=com.twilio.music.ambient",
    to: studentPhone,
    from: "YOUR_TWILIO_PHONE_NUMBER",
  });

  return { message: "Call initiated", callSid: call.sid };
});
