


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/Authentication.dart';

class UserRegistrationPage extends StatefulWidget {
  const UserRegistrationPage({Key? key}) : super(key: key);

  @override
  _UserRegistrationPageState createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  final AuthService authService = AuthService();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final FocusNode fullnameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode otpFocus = FocusNode();

  bool isLoading = false;
  bool isOtpSent = false;
  bool isOtpVerified = false;

  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    otpController.dispose();
    fullnameFocus.dispose();
    emailFocus.dispose();
    phoneFocus.dispose();
    addressFocus.dispose();
    passwordFocus.dispose();
    otpFocus.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({required String label, IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, color: Color(0xFFFF6F61)) : null,
      filled: true,
      fillColor: Colors.grey.shade200,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> sendOtpToEmail() async {
    final email = emailController.text.trim();
    final fullname = fullnameController.text.trim();
    final phone = phoneController.text.trim();

    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      _showSnackBar('Please enter a valid email', isError: true);
      return;
    }
    if (fullname.isEmpty) {
      _showSnackBar('Please enter your full name', isError: true);
      return;
    }
    if (phone.isEmpty) {
      _showSnackBar('Please enter your phone number', isError: true);
      return;
    }

    setState(() => isLoading = true);
    try {
      final response = await authService.sendRegistrationOtp(email, fullname, phone);
      if (!mounted) return;
      if (response['message'] == 'OTP sent to your email') {
        setState(() => isOtpSent = true);
        _showSnackBar('OTP sent to email');
      } else {
        _showSnackBar(response['error'] ?? 'Failed to send OTP', isError: true);
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Error: ${e.toString()}', isError: true);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> verifyOtp() async {
    final email = emailController.text.trim();
    final otp = otpController.text.trim();

    if (otp.isEmpty || otp.length != 6) {
      _showSnackBar('Please enter a valid 6-digit OTP', isError: true);
      return;
    }

    setState(() => isLoading = true);
    try {
      final response = await authService.verifyRegistrationOtp(email, otp);
      if (!mounted) return;
      if (response['message'] == 'OTP verified successfully') {
        setState(() => isOtpVerified = true);
        _showSnackBar('OTP verified');
      } else {
        _showSnackBar(response['error'] ?? 'Invalid OTP', isError: true);
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Error: ${e.toString()}', isError: true);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> register() async {
    final fullname = fullnameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (fullname.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
      _showSnackBar('Full Name, Email, Phone, and Password are required', isError: true);
      return;
    }

    if (!isOtpVerified) {
      _showSnackBar('Please verify the OTP before registering', isError: true);
      return;
    }

    setState(() => isLoading = true);
    try {
      final result = await authService.register(fullname, email, password, phone);
      if (!mounted) return;
      if (result['message'] == 'User registered successfully') {
        // Saving things in Firestore after successful registration in mongoDB
        await firestore.collection('users').add({
          'name': fullname,
          'email': email,
          'phone': phone,
          'friend_request': {},
          'friends': [],
          'isSharingSOS': false,
          'sosCode': 0000,
          'sosActive': false,
          'myTrackId': 0,
          'TrackTo': [],
          'myProf': 0,
        });
        _showSnackBar('Registration Successful');
        Navigator.pushReplacementNamed(context, '/log');
      } else {
        _showSnackBar(result['error'] ?? 'Registration failed', isError: true);
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Error: ${e.toString()}', isError: true);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushReplacementNamed(context, '/log'),
          ),
          title: Text('Sign Up', style: GoogleFonts.poppins(color: Colors.white)),
          backgroundColor: Colors.grey,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Create an Account',
                              style: GoogleFonts.openSans(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.teal)),
                          const SizedBox(height: 10),
                          Text('Sign up to get started', style: GoogleFonts.poppins(fontSize: 18, color: Colors.teal.shade300)),
                          const SizedBox(height: 30),
                          TextField(
                            focusNode: fullnameFocus,
                            controller: fullnameController,
                            style: const TextStyle(color: Colors.black),
                            decoration: _inputDecoration(label: 'Full Name', icon: Icons.person),
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) => FocusScope.of(context).requestFocus(emailFocus),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            focusNode: emailFocus,
                            controller: emailController,
                            style: const TextStyle(color: Colors.black),
                            decoration: _inputDecoration(label: 'Email', icon: Icons.email),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            readOnly: isOtpVerified, // Lock email after verification
                            onSubmitted: (_) => FocusScope.of(context).requestFocus(phoneFocus),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            focusNode: phoneFocus,
                            controller: phoneController,
                            style: const TextStyle(color: Colors.black),
                            decoration: _inputDecoration(label: 'Phone', icon: Icons.phone),
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) => isOtpSent ? FocusScope.of(context).requestFocus(otpFocus) : sendOtpToEmail(),
                          ),
                          const SizedBox(height: 10),
                          if (isOtpSent && !isOtpVerified)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  focusNode: otpFocus,
                                  controller: otpController,
                                  keyboardType: TextInputType.number,
                                  decoration: _inputDecoration(label: 'Enter OTP', icon: Icons.lock_open),
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (_) => verifyOtp(),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: isLoading ? null : verifyOtp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFAAF0D1),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                      : Text(
                                    'Verify OTP',
                                    style: GoogleFonts.poppins(color: Color(0xFF00695C), fontSize: 16),
                                  ),
                                ),
                              ],
                            )
                          else if (!isOtpSent)
                            ElevatedButton(
                              onPressed: isLoading ? null : sendOtpToEmail,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFAAF0D1),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                                  : Text(
                                'Send OTP to Email',
                                style: GoogleFonts.poppins(color: Color(0xFF00695C), fontSize: 16),
                              ),
                            ),
                          const SizedBox(height: 20),
                          TextField(
                            focusNode: addressFocus,
                            controller: addressController,
                            style: const TextStyle(color: Colors.black),
                            decoration: _inputDecoration(label: 'Address (optional)', icon: Icons.location_on),
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) => FocusScope.of(context).requestFocus(passwordFocus),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            focusNode: passwordFocus,
                            controller: passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.black),
                            decoration: _inputDecoration(label: 'Password', icon: Icons.lock),
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => isOtpVerified ? register() : null,
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: ElevatedButton(
                              onPressed: isLoading || !isOtpVerified ? null : register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFAAF0D1),
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                // disabledBackgroundColor: Colors.deepOrange.shade,
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                                  : Text(
                                'Sign Up',
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00695C),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}