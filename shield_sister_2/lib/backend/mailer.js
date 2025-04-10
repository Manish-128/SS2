// routes/userRoutes.js or controllers/userController.js
const express = require("express");
const router = express.Router();
const sendOtpMail = require("../utils/sendOtpMail");

router.post("/users/forgot-password/sendotp", async (req, res) => {
const { email, otp } = req.body;

try {
const response = await sendOtpMail(email, otp);
if (response.success) {
res.status(200).json({ message: "OTP sent to email successfully" });
} else {
res.status(500).json({ message: "Failed to send OTP" });
}
} catch (err) {
res.status(500).json({ message: "Internal server error", error: err.message });
}
});