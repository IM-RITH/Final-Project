const express = require("express");
const { GoogleAuth } = require("google-auth-library");
const path = require("path");
const schedule = require("node-schedule");
const cors = require("cors");

const app = express();
const PORT = process.env.PORT || 3000;

let currentAccessToken = null;

// Middleware to handle CORS
app.use(cors());

// Function to retrieve the access token
async function retrieveAccessToken() {
  const keyFilePath = path.join(__dirname, "service-account.json");
  const client = new GoogleAuth({
    keyFile: keyFilePath,
    scopes: "https://www.googleapis.com/auth/firebase.messaging",
  });

  try {
    currentAccessToken = await client.getAccessToken();
    console.log("Access Token retrieved:", currentAccessToken);

    // Save the token to an environment variable for redundancy
    process.env.CURRENT_ACCESS_TOKEN = currentAccessToken;
  } catch (error) {
    console.error("Error retrieving access token:", error);
  }
}

// Schedule the token retrieval to run every 10 seconds
schedule.scheduleJob("*/10 * * * * *", retrieveAccessToken);

// Initial token retrieval
retrieveAccessToken();

// Root endpoint
app.get("/", (req, res) => {
  res.redirect("/getAccessToken");
});

// Endpoint to get the current access token
app.get("/getAccessToken", (req, res) => {
  if (currentAccessToken) {
    res.json({ access_token: currentAccessToken });
  } else if (process.env.CURRENT_ACCESS_TOKEN) {
    res.json({ access_token: process.env.CURRENT_ACCESS_TOKEN });
  } else {
    res.status(500).json({ error: "Access token not available" });
  }
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
