// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '/backend/Authentication.dart';
// import 'package:uuid/uuid.dart';
//
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
//   String userId = "";
//
//   String generateUserId() {
//     var uuid = Uuid();
//     return uuid.v4(); // Generates a random unique ID
//   }
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
//     if (fullname.isEmpty || email.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Full Name, Email, and Password are required', style: TextStyle(color: Colors.white)),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 2),
//         ),
//       );
//       return;
//     }
//
//     setState(() {
//       isLoading = true;
//       userId = generateUserId();
//     });
//
//     final ref = FirebaseFirestore.instance.collection('users').doc(userId);
//
//     await ref.set({
//       "name": fullname,
//       "username": email,
//       "password": password,  // ⚠️ In real-world apps, NEVER store passwords as plain text.
//       "isSharing": false,
//       "sharingTo": [],
//       "location_lat": 0.0,
//       "location_long": 0.0,
//       "createdAt": FieldValue.serverTimestamp()
//     });
//
//     print("User created successfully in firebase!");
//
//     final result = await authService.register(fullname, email, password);
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
//                                   decoration: _inputDecoration(label: 'Phone (optional)', icon: Icons.phone),
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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/Authentication.dart';
import 'package:uuid/uuid.dart';

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
  bool isLoading = false;

  final FocusNode fullnameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  String userId = "";
  Map<String, dynamic>? userData; // To store fetched user data

  String generateUserId() {
    var uuid = Uuid();
    return uuid.v4();
  }

  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
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

  // Fetch user data from Firestore after registration
  Future<void> fetchUserData(String userId) async {
    final ref = FirebaseFirestore.instance.collection('users').doc(userId);
    final doc = await ref.get();
    if (doc.exists) {
      setState(() {
        userData = doc.data();
      });
    }
  }

  // Card widget to display sharing status and shared users
  Widget buildSharingCard() {
    if (userData == null) {
      return const SizedBox.shrink(); // Return empty widget if no data
    }

    bool isSharing = userData!['isSharing'] ?? false;
    List<dynamic> sharingTo = userData!['sharingTo'] ?? [];

    if (!isSharing || sharingTo.isEmpty) {
      return Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Not sharing location with anyone.',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sharing Location With:',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            ...sharingTo.asMap().entries.map((entry) {
              int index = entry.key;
              String userId = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Text(
                      '${index + 1}. ',
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                    Expanded(
                      child: Text(
                        userId,
                        style: GoogleFonts.poppins(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void register() async {
    final fullname = fullnameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();
    final password = passwordController.text.trim();

    if (fullname.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Full Name, Email, and Password are required',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
      userId = generateUserId();
    });

    final ref = FirebaseFirestore.instance.collection('users').doc(userId);

    await ref.set({
      "name": fullname,
      "username": email,
      "password": password,
      "isSharing": false,
      "sharingTo": [],
      "location_lat": 0.0,
      "location_long": 0.0,
      "createdAt": FieldValue.serverTimestamp(),
    });

    print("User created successfully in firebase!");

    // Fetch the user data after registration
    await fetchUserData(userId);

    final result = await authService.register(fullname, email, password);

    if (result['message'] == 'User registered successfully') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Successful',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      // Optionally navigate to login page
      // Navigator.pushReplacementNamed(context, '/log');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Registration failed',
              style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/log');
            },
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Create an Account',
                              style: GoogleFonts.poppins(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          const SizedBox(height: 10),
                          Text('Sign up to get started',
                              style: GoogleFonts.poppins(
                                  fontSize: 18, color: Colors.grey)),
                          const SizedBox(height: 30),
                          Column(
                            children: [
                              TextField(
                                focusNode: fullnameFocus,
                                controller: fullnameController,
                                style: const TextStyle(color: Colors.black),
                                decoration: _inputDecoration(
                                    label: 'Full Name', icon: Icons.person),
                                textInputAction: TextInputAction.next,
                                onSubmitted: (_) =>
                                    FocusScope.of(context).requestFocus(emailFocus),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                focusNode: emailFocus,
                                controller: emailController,
                                style: const TextStyle(color: Colors.black),
                                decoration: _inputDecoration(
                                    label: 'Email', icon: Icons.email),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (_) =>
                                    FocusScope.of(context).requestFocus(phoneFocus),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                focusNode: phoneFocus,
                                controller: phoneController,
                                style: const TextStyle(color: Colors.black),
                                decoration: _inputDecoration(
                                    label: 'Phone (optional)', icon: Icons.phone),
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (_) =>
                                    FocusScope.of(context).requestFocus(addressFocus),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                focusNode: addressFocus,
                                controller: addressController,
                                style: const TextStyle(color: Colors.black),
                                decoration: _inputDecoration(
                                    label: 'Address (optional)',
                                    icon: Icons.location_on),
                                textInputAction: TextInputAction.next,
                                onSubmitted: (_) =>
                                    FocusScope.of(context).requestFocus(passwordFocus),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                focusNode: passwordFocus,
                                controller: passwordController,
                                obscureText: true,
                                style: const TextStyle(color: Colors.black),
                                decoration: _inputDecoration(
                                    label: 'Password', icon: Icons.lock),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(50)),
                                  ),
                                  child: Text('Sign Up',
                                      style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Add the sharing card here
                              buildSharingCard(),
                            ],
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