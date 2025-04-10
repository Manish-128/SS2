//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '/backend/Authentication.dart';
//
// class UserRegistrationPage extends StatefulWidget {
//   const UserRegistrationPage({Key? key}) : super(key: key);
//
//   @override
//   _UserRegistrationPageState createState() => _UserRegistrationPageState();
// }
//
// class _UserRegistrationPageState extends State<UserRegistrationPage> {
//   final AuthService authService = AuthService();
//   final TextEditingController fullnameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController(); // Optional
//   final TextEditingController addressController = TextEditingController(); // Optional
//   final TextEditingController passwordController = TextEditingController();
//   bool isLoading = false;
//
//   final FocusNode fullnameFocus = FocusNode();
//   final FocusNode emailFocus = FocusNode();
//   final FocusNode phoneFocus = FocusNode();
//   final FocusNode addressFocus = FocusNode();
//   final FocusNode passwordFocus = FocusNode();
//
//   @override
//   void dispose() {
//     fullnameController.dispose();
//     emailController.dispose();
//     phoneController.dispose();
//     addressController.dispose();
//     passwordController.dispose();
//     fullnameFocus.dispose();
//     emailFocus.dispose();
//     phoneFocus.dispose();
//     addressFocus.dispose();
//     passwordFocus.dispose();
//     super.dispose();
//   }
//
//   InputDecoration _inputDecoration({required String label, IconData? icon}) {
//     return InputDecoration(
//       labelText: label,
//       prefixIcon: icon != null ? Icon(icon, color: Colors.black) : null,
//       filled: true,
//       fillColor: Colors.grey.shade200,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide.none,
//       ),
//     );
//   }
//
//   void register() async {
//     final fullname = fullnameController.text.trim();
//     final email = emailController.text.trim();
//     final phone = phoneController.text.trim();
//     final address = addressController.text.trim();
//     final password = passwordController.text.trim();
//
//     if (fullname.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Full Name, Email,Phone and Password are required', style: TextStyle(color: Colors.white)),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 2),
//         ),
//       );
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//     });
//
//     final result = await authService.register(fullname, email, password,phone);
//
//     if (result['message'] == 'User registered successfully') {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Registration Successful', style: TextStyle(color: Colors.white)),
//           backgroundColor: Colors.green,
//           duration: Duration(seconds: 2),
//         ),
//       );
//       Navigator.pushReplacementNamed(context, '/log');
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(result['message'] ?? 'Registration failed', style: const TextStyle(color: Colors.white)),
//           backgroundColor: Colors.red,
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(), // Hide keyboard on tap outside
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () {
//               // Explicitly navigate to the login page
//               Navigator.pushReplacementNamed(context, '/log');
//             },
//           ),
//           title: Text('Sign Up', style: GoogleFonts.poppins(color: Colors.white)),
//           backgroundColor: Colors.black,
//         ),
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               return SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                   child: IntrinsicHeight(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Create an Account', style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
//                           const SizedBox(height: 10),
//                           Text('Sign up to get started', style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey)),
//                           const SizedBox(height: 30),
//                           Expanded(
//                             child: Column(
//                               children: [
//                                 TextField(
//                                   focusNode: fullnameFocus,
//                                   controller: fullnameController,
//                                   style: const TextStyle(color: Colors.black),
//                                   decoration: _inputDecoration(label: 'Full Name', icon: Icons.person),
//                                   textInputAction: TextInputAction.next,
//                                   onSubmitted: (_) => FocusScope.of(context).requestFocus(emailFocus),
//                                 ),
//                                 const SizedBox(height: 20),
//                                 TextField(
//                                   focusNode: emailFocus,
//                                   controller: emailController,
//                                   style: const TextStyle(color: Colors.black),
//                                   decoration: _inputDecoration(label: 'Email', icon: Icons.email),
//                                   keyboardType: TextInputType.emailAddress,
//                                   textInputAction: TextInputAction.next,
//                                   onSubmitted: (_) => FocusScope.of(context).requestFocus(phoneFocus),
//                                 ),
//                                 const SizedBox(height: 20),
//                                 TextField(
//                                   focusNode: phoneFocus,
//                                   controller: phoneController,
//                                   style: const TextStyle(color: Colors.black),
//                                   decoration: _inputDecoration(label: 'Phone', icon: Icons.phone),
//                                   keyboardType: TextInputType.phone,
//                                   textInputAction: TextInputAction.next,
//                                   onSubmitted: (_) => FocusScope.of(context).requestFocus(addressFocus),
//                                 ),
//                                 const SizedBox(height: 20),
//                                 TextField(
//                                   focusNode: addressFocus,
//                                   controller: addressController,
//                                   style: const TextStyle(color: Colors.black),
//                                   decoration: _inputDecoration(label: 'Address (optional)', icon: Icons.location_on),
//                                   textInputAction: TextInputAction.next,
//                                   onSubmitted: (_) => FocusScope.of(context).requestFocus(passwordFocus),
//                                 ),
//                                 const SizedBox(height: 20),
//                                 TextField(
//                                   focusNode: passwordFocus,
//                                   controller: passwordController,
//                                   obscureText: true,
//                                   style: const TextStyle(color: Colors.black),
//                                   decoration: _inputDecoration(label: 'Password', icon: Icons.lock),
//                                   textInputAction: TextInputAction.done,
//                                   onSubmitted: (_) => register(),
//                                 ),
//                                 const SizedBox(height: 30),
//                                 Center(
//                                   child: isLoading
//                                       ? const CircularProgressIndicator()
//                                       : ElevatedButton(
//                                     onPressed: register,
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.black,
//                                       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
//                                     ),
//                                     child: Text('Sign Up', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// TODO : When done, make changes here for the otp and see if it is running
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
    super.dispose();
  }

  InputDecoration _inputDecoration({required String label, IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, color: Colors.black) : null,
      filled: true,
      fillColor: Colors.grey.shade200,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> sendOtpToEmail() async {
    final email = emailController.text.trim();
    if (email.isEmpty) return;

    final response = await authService.sendOtp(email);
    if (response['success'] == true) {
      setState(() => isOtpSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent to email')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'OTP sending failed')),
      );
    }
  }

  Future<void> verifyOtp() async {
    final email = emailController.text.trim();
    final otp = otpController.text.trim();

    final result = await authService.verifyOtp(email, otp);
    if (result['success'] == true) {
      setState(() => isOtpVerified = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP verified')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP')),
      );
    }
  }

  void register() async {
    final fullname = fullnameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();
    final password = passwordController.text.trim();

    if (fullname.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Full Name, Email, Phone and Password are required', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!isOtpVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please verify the OTP before registering'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    final result = await authService.register(fullname, email, password, phone);

    if (result['message'] == 'User registered successfully') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Successful', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pushReplacementNamed(context, '/log');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Registration failed', style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    setState(() => isLoading = false);
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
          backgroundColor: Colors.black,
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
                              style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
                          const SizedBox(height: 10),
                          Text('Sign up to get started', style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey)),
                          const SizedBox(height: 30),
                          Expanded(
                            child: Column(
                              children: [
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
                                  onSubmitted: (_) => FocusScope.of(context).requestFocus(phoneFocus),
                                ),
                                const SizedBox(height: 10),
                                isOtpSent
                                    ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: otpController,
                                      keyboardType: TextInputType.number,
                                      decoration: _inputDecoration(label: 'Enter OTP', icon: Icons.lock_open),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: verifyOtp,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                                      ),
                                      child: Text(
                                        "Verify OTP",
                                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ],
                                )
                                    : ElevatedButton(
                                  onPressed: sendOtpToEmail,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                                  ),
                                  child: Text(
                                    "Send OTP to Email",
                                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  focusNode: phoneFocus,
                                  controller: phoneController,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: _inputDecoration(label: 'Phone', icon: Icons.phone),
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  onSubmitted: (_) => FocusScope.of(context).requestFocus(addressFocus),
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
                                  onSubmitted: (_) => register(),
                                ),
                                const SizedBox(height: 30),
                                Center(
                                  child: isLoading
                                      ? const CircularProgressIndicator()
                                      : ElevatedButton(
                                    onPressed: register,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                    ),
                                    child: Text('Sign Up',
                                        style: GoogleFonts.poppins(
                                            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                                  ),
                                ),
                              ],
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
