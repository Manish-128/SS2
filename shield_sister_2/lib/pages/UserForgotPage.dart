
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Assuming email_validator package is added to pubspec.yaml
// import 'package:email_validator/email_validator.dart';
import '/backend/Authentication.dart'; // Assuming this path is correct

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
  final _formKey = GlobalKey<FormState>(); // Add a Form key for validation

  bool isOtpSent = false;
  bool isSendingOtp = false; // State for disabling Send OTP button
  bool isResettingPassword = false; // Renamed from isLoading for clarity

  // --- Dispose Controllers ---
  @override
  void dispose() {
    emailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  // --- Show Snackbar Safely ---
  void _showSnackBar(String message, {bool isError = false}) {
    // Check if the widget is still mounted before showing Snackbar
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
      ),
    );
  }

  // --- Send OTP Logic ---
  Future<void> sendOtp() async {
    // Basic email format validation (optional but recommended)
    final email = emailController.text.trim();
    // Uncomment the line below and add email_validator package if needed
    // if (email.isEmpty || !EmailValidator.validate(email)) {
    if (email.isEmpty) { // Simplified check
      _showSnackBar("Please enter a valid email address.", isError: true);
      return;
    }

    setState(() => isSendingOtp = true);

    try {
      final response = await authService.sendOtp(email);
      // Check mounted status *after* await
      if (!mounted) return;

      if (response['message'] == "OTP sent to your email") {
        setState(() => isOtpSent = true);
        _showSnackBar("OTP sent to email");
      } else {
        _showSnackBar(response['message'] ?? "Failed to send OTP", isError: true);
      }
    } catch (e) {
      // Handle potential exceptions during the API call
      if (!mounted) return;
      _showSnackBar("An error occurred: ${e.toString()}", isError: true);
    } finally {
      // Ensure the loading state is reset even if errors occur
      if (mounted) {
        setState(() => isSendingOtp = false);
      }
    }
  }

  // --- Verify OTP and Reset Password Logic ---
  Future<void> verifyOtpAndResetPassword() async {
    // Use Form key to validate inputs
    if (!_formKey.currentState!.validate()) {
      _showSnackBar("Please correct the errors above.", isError: true);
      return; // Don't proceed if validation fails
    }

    final email = emailController.text.trim(); // Already validated indirectly
    final otp = otpController.text.trim();
    final newPassword = newPasswordController.text.trim();

    setState(() => isResettingPassword = true);

    try {
      final result = await authService.resetPassword(email, otp, newPassword);
      // Check mounted status *after* await
      if (!mounted) return;

      if (result['message'] == "Password reset successfully") {
        _showSnackBar("Password reset successful", isError: false);
        // Use pushReplacementNamed safely
        Navigator.pushReplacementNamed(context, '/log');
      } else {
        _showSnackBar(result['message'] ?? "Password reset failed", isError: true);
      }
    } catch (e) {
      // Handle potential exceptions during the API call
      if (!mounted) return;
      _showSnackBar("An error occurred: ${e.toString()}", isError: true);
    } finally {
      // Ensure the loading state is reset even if errors occur
      if (mounted) {
        setState(() => isResettingPassword = false);
      }
    }
  }

  // --- Password Validation Logic (Example) ---
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    // Add more rules (uppercase, lowercase, number, symbol) if needed
    // if (!value.contains(RegExp(r'[A-Z]'))) {
    //   return 'Password must contain an uppercase letter';
    // }
    // if (!value.contains(RegExp(r'[a-z]'))) {
    //    return 'Password must contain a lowercase letter';
    // }
    // if (!value.contains(RegExp(r'[0-9]'))) {
    //    return 'Password must contain a number';
    // }
    return null; // Return null if validation passes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password", style: GoogleFonts.openSans(color: Colors.white)),
        backgroundColor: Colors.teal.shade200,
        iconTheme: const IconThemeData(color: Colors.white), // Make back button white
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        // Wrap content in Form for validation
        child: Form(
          key: _formKey,
          child: ListView( // Use ListView to prevent overflow on smaller screens
            children: [
              Text("Reset Your Password",
                  style: GoogleFonts.openSans(color: Colors.teal,fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(
                  isOtpSent
                      ? "Enter the OTP sent to your email and set a new password."
                      : "We'll send you an OTP to reset your password.",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.black)),
              const SizedBox(height: 30),

              // --- Email Field ---
              TextFormField( // Use TextFormField for validation
                controller: emailController,
                // Disable email field after OTP is sent
                readOnly: isOtpSent,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email, color: Color(0xFFFF6F61),),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) { // Add email validation
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Basic email format check (can be improved with regex or package)
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Please enter a valid email address';
                  }
                  // Uncomment below if using email_validator package
                  // if (!EmailValidator.validate(value)) {
                  //   return 'Please enter a valid email';
                  // }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // --- OTP and New Password Fields (Conditional) ---
              if (isOtpSent) ...[
                TextFormField( // Use TextFormField
                  controller: otpController,
                  decoration: InputDecoration(
                    labelText: "Enter OTP",
                    prefixIcon: Icon(Icons.lock_open, color: Color(0xFFFF6F61),),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) { // Add OTP validation
                    if (value == null || value.isEmpty) {
                      return 'Please enter the OTP';
                    }
                    if (value.length != 6) { // Example: Assuming 6-digit OTP
                      return 'OTP must be 6 digits';
                    }
                    // Add numeric check if needed
                    if (int.tryParse(value) == null) {
                      return 'OTP must contain only numbers';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField( // Use TextFormField
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    prefixIcon: Icon(Icons.lock, color: Color(0xFFFF6F61),),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    // Consider adding a toggle visibility icon
                  ),
                  validator: _validatePassword, // Use the validation function
                ),
                const SizedBox(height: 30),

                // --- Reset Password Button ---
                ElevatedButton(
                  // Disable button while resetting
                  onPressed: isResettingPassword ? null : verifyOtpAndResetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFAAF0D1),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    // Dim button when disabled
                    disabledBackgroundColor: Colors.black.withOpacity(0.5),
                  ),
                  child: Center(
                    child: isResettingPassword
                    // Show loading indicator inside the button
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Text("Reset Password",
                        style: GoogleFonts.poppins(fontSize: 16, color: Color(0xFF00695C))),
                  ),
                ),
                // Add Resend OTP option? (Optional)
                // TextButton(
                //   onPressed: () { /* Implement resend OTP logic */ },
                //   child: Text("Resend OTP"),
                // ),
              ]
              // --- Send OTP Button ---
              else
                ElevatedButton(
                  // Disable button while sending
                  onPressed: isSendingOtp ? null : sendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFAAF0D1),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    // Dim button when disabled
                    disabledBackgroundColor: Colors.black.withOpacity(0.5),
                  ),
                  child: Center(
                    child: isSendingOtp
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Text("Send OTP",
                        style: GoogleFonts.poppins(fontSize: 16, color: Color(0xFF00695C))),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}