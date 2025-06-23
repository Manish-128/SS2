// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shield_sister_2/screens/UpdateProfilePage.dart'; // update the path to where your file is
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
//
// import '../backend/Authentication.dart'; // for jsonDecode
//
//
// class AccountSettingPage extends StatelessWidget {
//   AccountSettingPage({super.key});
//
//
//   // Function to handle Edit Account (Navigate to Edit Page)
//   void _editAccount(BuildContext context) async {
//     final prefs = await SharedPreferences.getInstance();
//
//     final userData = {
//       'fullname': prefs.getString('username') ?? '',
//       'email': prefs.getString('email') ?? '',
//       'phone': '', // Add if you store it
//       'address': '', // Add if you store it
//       '_id': prefs.getString('userId') ?? '',
//     };
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => UpdateAccountPage(
//         ),
//       ),
//     );
//   }
//
//   // Function to handle Change Password
//   void _changePassword(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Navigate to Change Password Page')),
//     );
//   }
//
//   // Function to handle Update Photo
//   void _updatePhoto(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Update Profile Photo Functionality')),
//     );
//   }
//
//
//   // Function to handle Delete Account
//   void _deleteAccount(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Delete Account'),
//           content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Delete', style: TextStyle(color: Colors.red)),
//               onPressed: () async {
//                 Navigator.of(context).pop(); // Close dialog
//                 try {
//                   final result = await AuthService().deleteUserProfile();
//
//                   if (result['success']) {
//                     final prefs = await SharedPreferences.getInstance();
//                     await prefs.clear(); // Clear all stored data
//
//                     if (context.mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text(result['message'])),
//                       );
//
//                       Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//                     }
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Error: ${result['error']}')),
//                     );
//                   }
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Failed to delete account: $e')),
//                   );
//                 }
//               },
//
//             ),
//           ],
//         );
//       },
//     );
//   }
//   String userName = "Add User";
//   String userEmail = "Kindly Register";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(20,40,20,0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Align(
//               alignment: Alignment.centerLeft, // Aligns the row to the left
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(
//                       Icons.arrow_back,
//                       color: Colors.black,
//                       size: 28,
//                     ),
//                     onPressed: () {
//                       // Back navigation logic
//                       if (Navigator.canPop(context)) {
//                         Navigator.pop(context); // Go back if a previous route exists
//                       } else {
//                         // Optionally handle when there's no previous screen
//                         print("No previous screen to go back to.");
//                       }
//                     },
//                   ),
//                   const SizedBox(width: 8), // Adds spacing between the button and title
//                   const Text(
//                     'Account', // Title text
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//
//
//             // Profile Photo
//             Center(
//               child: Stack(
//                 children: [
//                   const CircleAvatar(
//                     radius: 60,
//                     backgroundImage: NetworkImage("https://img.freepik.com/premium-vector/women-beauty-face-clipart-vector-illustration_1123392-5133.jpg?semt=ais_hybrid"), // Default Image
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: GestureDetector(
//                       onTap: () => _updatePhoto(context),
//                       child: const CircleAvatar(
//                         radius: 18,
//                         backgroundColor: Colors.green,
//                         child: Icon(Icons.camera_alt_outlined, color: Colors.black),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Account Details Section
//             Text(
//               userName,
//               style: GoogleFonts.sourceCodePro(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black,
//               ),
//             ),
//             Text(
//               userEmail,
//               style: GoogleFonts.sourceCodePro(
//                 fontSize: 18,
//                 color: Colors.black.withOpacity(0.7),
//               ),
//             ),
//             const SizedBox(height: 30),
//             // Buttons Section
//             _buildAccountOption(
//               context: context,
//               icon: Icons.edit,
//               title: 'Edit Account',
//               color: Colors.green,
//               onPressed: () => _editAccount(context),
//             ),
//             const SizedBox(height: 10),
//             _buildAccountOption(
//               context: context,
//               icon: Icons.lock,
//               title: 'Change Password',
//               color: Colors.deepOrangeAccent,
//
//               onPressed: () => Navigator.pushNamed(context, '/forget'),
//             ),
//             const SizedBox(height: 10),
//             _buildAccountOption(
//               context: context,
//               icon: Icons.camera_alt_outlined,
//               title: 'Update Profile Photo',
//               color: Colors.black,
//               onPressed: () => _updatePhoto(context),
//             ),
//             const SizedBox(height: 10),
//             _buildAccountOption(
//               context: context,
//               icon: Icons.delete,
//               title: 'Delete Account',
//               color: Colors.red,
//               onPressed: () => _deleteAccount(context),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Helper Widget to Build Account Options
//   Widget _buildAccountOption({
//     required BuildContext context,
//     required IconData icon,
//     required String title,
//     required Color color,
//     required VoidCallback onPressed,
//     Color? iconColor,
//   }) {
//     return Card(
//       elevation: 2,
//       child: ListTile(
//         leading: Icon(icon, color: color),
//         title: Text(title, style: GoogleFonts.openSans(
//           textStyle: TextStyle(
//             fontSize: 19,
//             fontWeight: FontWeight.w600,
//             color: Colors.black,
//           ),
//         ),
//         ),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
//         onTap: onPressed,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/Authentication.dart'; // Update with correct
import 'package:shield_sister_2/screens/UpdateProfilePage.dart'; // update the path to where your file is
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettingPage extends StatefulWidget {
  const AccountSettingPage({super.key});

  @override
  State<AccountSettingPage> createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  String userName = "Add User";
  String userEmail = "Kindly Register";
  String selectedImageIndex = "0";
  String fireId = "";
  final List<String> profileImages = [
    'assets/profile/man1.png',
    'assets/profile/man2.png',
    'assets/profile/man3.png',
    'assets/profile/man4.png',
    'assets/profile/man5.png',
    'assets/profile/man6.png',
    'assets/profile/wom1.png',
    'assets/profile/wom2.png',
    'assets/profile/wom3.png',
    'assets/profile/wom4.png',
    'assets/profile/wom5.png',
    'assets/profile/wom6.png',
  ];

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username') ?? "Add User";
      userEmail = prefs.getString('email') ?? "Kindly Register";
      selectedImageIndex = prefs.getString('profileNumber') ?? "0";
      fireId = prefs.getString('fireId') ?? "";
    });
  }

  Future<void> _performDelete(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Account Deleted  successfully', style: GoogleFonts.poppins()),
        backgroundColor: Colors.grey.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    try {
      if (context.mounted) {
        print("Before log out the widget is mounted");
        Navigator.pushReplacementNamed(context, '/log');
      }
    } catch (e) {
      print("Error Navigating to Login Page $e");
    }
  }

  Future<void> _updateProfileInFirestore() async {
    await FirebaseFirestore.instance.collection('users').doc(fireId).update({
      'myProf': int.parse(selectedImageIndex),
    });
  }

  void _showPhotoPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: profileImages.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final image = profileImages[index];
              return GestureDetector(
                onTap: () async {
                  setState(() {
                    selectedImageIndex = index.toString();
                  });
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString('profileNumber', selectedImageIndex);
                  await _updateProfileInFirestore();
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  backgroundImage: AssetImage(image),
                  radius: 30,
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _editAccount(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = {
      'fullname': prefs.getString('username') ?? '',
      'email': prefs.getString('email') ?? '',
      'phone': '',
      'address': '',
      '_id': prefs.getString('userId') ?? '',
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UpdateAccountPage(),
      ),
    );
  }

  void _changePassword(BuildContext context) {
    Navigator.pushNamed(context, '/forget');
  }

  void _deleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Delete Account',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
            style:
                GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade700),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
              ),
              // onPressed: () => Navigator.of(context).pop(),

              onPressed: ()=> Navigator.pop(context),
            ),
            TextButton(
              child: Text(
                'Delete',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
              ),
              onPressed: () async {
                // Navigator.of(context).pop();
                // Navigator.pop(context);
                try {
                  final result = await AuthService().deleteUserProfile();
                  if (result['success']) {
                    final prefs = await SharedPreferences.getInstance();

                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(fireId)
                        .delete();

                    await prefs.clear();

                    print("The value of mounted: ${mounted}");

                    //   if (mounted) {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(
                    //         content: Text(
                    //           result['message'],
                    //           style: GoogleFonts.poppins(),
                    //         ),
                    //         backgroundColor: Colors.grey.shade800,
                    //         behavior: SnackBarBehavior.floating,
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(10),
                    //         ),
                    //       ),
                    //     );
                    //     await _performDelete(context);
                    //   }
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       content: Text(
                    //         'Error: ${result['error']}',
                    //         style: GoogleFonts.poppins(),
                    //       ),
                    //       backgroundColor: Colors.grey.shade800,
                    //       behavior: SnackBarBehavior.floating,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //     ),
                    //   );
                    // }
                    await _performDelete(context);
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Failed to delete account: $e',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: Colors.grey.shade800,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Account",
          style: GoogleFonts.openSans(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.pinkAccent,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade100],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: -50,
                left: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ),
              ),
              Positioned(
                bottom: -80,
                right: -80,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ),
              ),
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 5,
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: AssetImage(
                                    profileImages[
                                        int.parse(selectedImageIndex)],
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _showPhotoPicker,
                                    child: const CircleAvatar(
                                      radius: 18,
                                      backgroundColor: Colors.green,
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            userName,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            userEmail,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 24.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        ProfileWidget(
                          icon: Icons.edit,
                          title: 'Edit Account',
                          color: Colors.green,
                          onPressed: () => _editAccount(context),
                        ),
                        ProfileWidget(
                          icon: Icons.lock,
                          title: 'Change Password',
                          color: Colors.deepOrangeAccent,
                          onPressed: () => _changePassword(context),
                        ),
                        ProfileWidget(
                          icon: Icons.delete,
                          title: 'Delete Account',
                          color: Colors.red,
                          onPressed: () => _deleteAccount(context),
                        ),
                      ]),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;
  final Color color;

  const ProfileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
