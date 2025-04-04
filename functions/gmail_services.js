const { google } = require("googleapis");
const functions = require("firebase-functions");

const auth = new google.auth.OAuth2(
  "YOUR_CLIENT_ID",
  "YOUR_CLIENT_SECRET",
  "YOUR_REDIRECT_URI"
);

auth.setCredentials({ refresh_token: "YOUR_REFRESH_TOKEN" });

async function getPlacementEmails() {
  const gmail = google.gmail({ version: "v1", auth });

  const response = await gmail.users.messages.list({
    userId: "me",
    q: "from:placementcell@college.edu",
  });

  const messages = response.data.messages || [];
  return messages;
}

exports.fetchPlacementEmails = functions.pubsub.schedule("every 10 minutes").onRun(async (context) => {
  const emails = await getPlacementEmails();
  console.log("Placement Emails:", emails);
});
