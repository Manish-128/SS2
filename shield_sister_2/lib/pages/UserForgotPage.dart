import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/Authentication.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final AuthService authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool isOtpSent = false;
  bool isOtpVerified = false;
  bool isLoading = false;

  Future<void> sendOtp() async {
    final email = emailController.text.trim();
    if (email.isEmpty) return;

    final response = await authService.sendOtp(email);
    if (response['success'] == true) {
      setState(() => isOtpSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP sent to email")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Failed to send OTP")),
      );
    }
  }

  Future<void> verifyOtpAndResetPassword() async {
    final email = emailController.text.trim();
    final otp = otpController.text.trim();
    final newPassword = newPasswordController.text.trim();

    if (otp.isEmpty || newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter OTP and new password")),
      );
      return;
    }

    setState(() => isLoading = true);

    final result = await authService.resetPassword(email, otp, newPassword);
    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset successful")),
      );
      Navigator.pushReplacementNamed(context, '/log');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Password reset failed")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password", style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Reset Your Password",
                style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("We'll send you an OTP to reset your password.",
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade700)),
            const SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            if (isOtpSent) ...[
              TextField(
                controller: otpController,
                decoration: InputDecoration(
                  labelText: "Enter OTP",
                  prefixIcon: const Icon(Icons.lock_open),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "New Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 30),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: verifyOtpAndResetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Center(
                  child: Text("Reset Password",
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                ),
              ),
            ] else
              ElevatedButton(
                onPressed: sendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Center(
                  child: Text("Send OTP",
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
