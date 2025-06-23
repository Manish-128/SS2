// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shield_sister_2/backend/Authentication.dart'; // update path if needed
//
// class UpdateAccountPage extends StatefulWidget {
//   const UpdateAccountPage({super.key});
//
//   @override
//   State<UpdateAccountPage> createState() => _UpdateAccountPageState();
// }
//
// class _UpdateAccountPageState extends State<UpdateAccountPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   TextEditingController? _fullnameController;
//   TextEditingController? _emailController;
//   TextEditingController? _phoneController;
//   TextEditingController? _addressController;
//
//   bool _isLoading = false;
//   bool _isDataLoaded = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   Future<void> _loadUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//
//     final fullname = prefs.getString('username') ?? '';
//     final email = prefs.getString('email') ?? '';
//     final phone = prefs.getString('phone') ?? '';
//     final address = prefs.getString('address') ?? '';
//
//     setState(() {
//       _fullnameController = TextEditingController(text: fullname);
//       _emailController = TextEditingController(text: email);
//       _phoneController = TextEditingController(text: phone);
//       _addressController = TextEditingController(text: address);
//       _isDataLoaded = true;
//     });
//   }
//
//   @override
//   void dispose() {
//     _fullnameController?.dispose();
//     _emailController?.dispose();
//     _phoneController?.dispose();
//     _addressController?.dispose();
//     super.dispose();
//   }
//
//   Future<void> _updateProfile() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isLoading = true);
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userId = prefs.getString('userId');
//
//       if (userId == null) {
//         throw Exception('User ID not found in local storage');
//       }
//
//       final data = {
//         "userId": userId,
//         "fullname": _fullnameController!.text.trim(),
//         "email": _emailController!.text.trim(),
//         "phone": _phoneController!.text.trim(),
//         "address": _addressController!.text.trim(),
//       };
//
//       final result = await AuthService.updateUserProfile(data);
//
//       if (result['success']) {
//         // Optionally update shared preferences too
//         await prefs.setString('username', _fullnameController!.text.trim());
//         await prefs.setString('email', _emailController!.text.trim());
//         await prefs.setString('phone', _phoneController!.text.trim());
//         await prefs.setString('address', _addressController!.text.trim());
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(result['message'] ?? 'Profile updated')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: ${result['error'] ?? 'Something went wrong'}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update profile: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_isDataLoaded) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(title: const Text('Update Account')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _fullnameController,
//                 decoration: const InputDecoration(labelText: 'Full Name'),
//                 validator: (value) => value!.isEmpty ? 'Enter your name' : null,
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(labelText: 'Email'),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) => value!.isEmpty ? 'Enter your email' : null,
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _phoneController,
//                 decoration: const InputDecoration(labelText: 'Phone'),
//                 keyboardType: TextInputType.phone,
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _addressController,
//                 decoration: const InputDecoration(labelText: 'Address'),
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _updateProfile,
//                 child: _isLoading
//                     ? const CircularProgressIndicator()
//                     : const Text('Update Profile'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shield_sister_2/backend/Authentication.dart';

class UpdateAccountPage extends StatefulWidget {
  const UpdateAccountPage({super.key});

  @override
  State<UpdateAccountPage> createState() => _UpdateAccountPageState();
}

class _UpdateAccountPageState extends State<UpdateAccountPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController? _fullnameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneController;
  TextEditingController? _addressController;
  String fireId = "";

  bool _isLoading = false;
  bool _isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final fullname = prefs.getString('username') ?? '';
    final email = prefs.getString('email') ?? '';
    final phone = prefs.getString('phone') ?? '';
    final address = prefs.getString('address') ?? '';


    setState(() {
      _fullnameController = TextEditingController(text: fullname);
      _emailController = TextEditingController(text: email);
      _phoneController = TextEditingController(text: phone);
      _addressController = TextEditingController(text: address);
      _isDataLoaded = true;
      fireId = prefs.getString("fireId") ?? "";
    });
  }

  @override
  void dispose() {
    _fullnameController?.dispose();
    _emailController?.dispose();
    _phoneController?.dispose();
    _addressController?.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        throw Exception('User ID not found in local storage');
      }

      final data = {
        "userId": userId,
        "fullname": _fullnameController!.text.trim(),
        "email": _emailController!.text.trim(),
        "phone": _phoneController!.text.trim(),
        "address": _addressController!.text.trim(),
      };

      final result = await AuthService.updateUserProfile(data);

      if (result['success']) {
        await prefs.setString('username', _fullnameController!.text.trim());
        await prefs.setString('email', _emailController!.text.trim());
        await prefs.setString('phone', _phoneController!.text.trim());
        await prefs.setString('address', _addressController!.text.trim());

        await FirebaseFirestore.instance.collection('users').doc(fireId).update({
          'email': _emailController!.text.trim(),
          'name': _fullnameController!.text.trim(),
          'phone': _phoneController!.text.trim(),
        });


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.black87,
            content: Text(
              result['message'] ?? 'Profile updated successfully',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.black87,
            content: Text(
              'Error: ${result['error'] ?? 'Something went wrong'}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black87,
          content: Text(
            'Failed to update profile: $e',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
          labelMedium: TextStyle(color: Colors.black54),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black54),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black54),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Update Account',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: _isDataLoaded
            ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _fullnameController,
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: Icon(Icons.person, color: Colors.black54),
                            ),
                            validator: (value) => value!.isEmpty ? 'Enter your name' : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email, color: Colors.black54),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) return 'Enter your email';
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                              prefixIcon: Icon(Icons.phone, color: Colors.black54),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isNotEmpty && !RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(value)) {
                                return 'Enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _addressController,
                            decoration: const InputDecoration(
                              labelText: 'Address',
                              prefixIcon: Icon(Icons.location_on, color: Colors.black54),
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedOpacity(
                    opacity: _isLoading ? 0.5 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text(
                        'Update Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
            : const Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}