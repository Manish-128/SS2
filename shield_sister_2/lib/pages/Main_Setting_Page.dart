//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '/pages/SettingPage.dart';
// import '/pages/Apps_About_Page.dart';
// import '/pages/FAQsPage.dart';
// import 'Account_Setting_Page.dart';
//
// class MainSettingPage extends StatefulWidget {
//   const MainSettingPage({super.key});
//
//   @override
//   State<MainSettingPage> createState() => _MainSettingPageState();
// }
//
// class _MainSettingPageState extends State<MainSettingPage> {
//   String userName = "";
//   String userEmail = "";
//   String selectedImageIndex = "0";
//   String selectedImage = 'assets/profile/man1.png'; // Default profile
//   final List<String> profileImages = [
//     'assets/profile/man1.png',
//     'assets/profile/man2.png',
//     'assets/profile/man3.png',
//     'assets/profile/man4.png',
//     'assets/profile/man5.png',
//     'assets/profile/man6.png',
//     'assets/profile/wom1.png',
//     'assets/profile/wom2.png',
//     'assets/profile/wom3.png',
//     'assets/profile/wom4.png',
//     'assets/profile/wom5.png',
//     'assets/profile/wom6.png',
//   ];
//   String fireId = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserData();
//   }
//
//   Future<void> RemoveDetails() async{
//
//     await FirebaseFirestore.instance.collection('users').doc(fireId).update({
//       'myProf': int.parse(selectedImageIndex),
//     });
//   }
//
//   void _getUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userName = prefs.getString('username') ?? "User";
//       userEmail = prefs.getString('email') ?? "email@example.com";
//       selectedImageIndex = prefs.getString('profileNumber') ?? "0";
//       fireId = prefs.getString('fireId') ?? "";
//       print("Selected Image Index: $selectedImageIndex");
//     });
//   }
//
//   // Logout Confirmation Dialog
//   void _logoutAccount(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           title: Text(
//             'Logout',
//             style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
//           ),
//           content: Text(
//             'Are you sure you want to logout?',
//             style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade700),
//           ),
//           actions: [
//             TextButton(
//               child: Text(
//                 'Cancel',
//                 style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
//               ),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//             TextButton(
//               child: Text(
//                 'Logout',
//                 style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
//               ),
//               onPressed: () {
//                 RemoveDetails();
//                 Navigator.of(context).pop();
//                 _performLogout(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _performLogout(BuildContext context) async{
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Logged out successfully', style: GoogleFonts.poppins()),
//         backgroundColor: Colors.grey.shade800,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//     try {
//       if(mounted){
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.remove('jwtToken');
//         Navigator.pushReplacementNamed(context, '/log');
//       }
//     }catch(e){
//       print("Error Navigating to Login Page $e");
//     }
//   }
//
//
//   void _showPhotoPicker() {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Container(
//           padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//           height: 120,
//           child: ListView.separated(
//             scrollDirection: Axis.horizontal,
//             itemCount: profileImages.length,
//             separatorBuilder: (context, index) => SizedBox(width: 16),
//             itemBuilder: (context, index) {
//               final image = profileImages[index];
//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     selectedImage = image;
//                     selectedImageIndex = index.toString();
//                   });
//                   Navigator.pop(context);
//                 },
//                 child: CircleAvatar(
//                   backgroundImage: AssetImage(image),
//                   radius: 30, // Smaller radius
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Text(
//           "Settings 🛠️",
//           style: GoogleFonts.openSans(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.pinkAccent,
//           ),
//         ),
//         centerTitle: false,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings, color: Colors.black),
//             onPressed: (){
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => SettingsPage()),
//               );
//             },
//           ),
//         ],
//       ),
//       extendBodyBehindAppBar: true,
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Colors.white, Colors.grey.shade100],
//           ),
//         ),
//         child: SafeArea(
//           child: Stack(
//             children: [
//               // Light circular decorations
//               Positioned(
//                 top: -50,
//                 left: -50,
//                 child: Container(
//                   width: 200,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.black.withOpacity(0.05),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: -80,
//                 right: -80,
//                 child: Container(
//                   width: 250,
//                   height: 250,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.black.withOpacity(0.05),
//                   ),
//                 ),
//               ),
//
//               CustomScrollView(
//                 slivers: [
//                   SliverToBoxAdapter(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 24.0),
//                       child: Column(
//                         children: [
//                           Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.3),
//                                     spreadRadius: 5,
//                                     blurRadius: 15,
//                                   ),
//                                 ],
//                               ),
//                               child: GestureDetector(
//                                 onTap: _showPhotoPicker,
//                                 child: CircleAvatar(
//                                   radius: 60,
//                                   backgroundImage: AssetImage(profileImages[int.parse(selectedImageIndex)]),
//                                 ),
//                               )
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             userName,
//                             style: GoogleFonts.poppins(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                             ),
//                           ),
//                           Text(
//                             userEmail,
//                             style: GoogleFonts.poppins(
//                               fontSize: 16,
//                               color: Colors.grey.shade700,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   SliverPadding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
//                     sliver: SliverList(
//                       delegate: SliverChildListDelegate([
//                         ProfileWidget(
//                           icon: Icons.person,
//                           title: 'My Profile',
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => AccountSettingPage()),
//                             );
//                           },
//                         ),
//                         ProfileWidget(
//                           icon: Icons.chat,
//                           title: 'FAQs',
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => const FAQsPage()),
//                             );
//                           },
//                         ),
//                         ProfileWidget(
//                           icon: Icons.info_rounded,
//                           title: 'About',
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => const AppAboutPage()),
//                             );
//                           },
//                         ),
//                         ProfileWidget(
//                           icon: Icons.logout_outlined,
//                           title: 'Log Out',
//                           onPressed: () => _logoutAccount(context),
//                         ),
//                       ]),
//                     ),
//                   ),
//
//                   const SliverToBoxAdapter(child: SizedBox(height: 40)),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// }
//
// class ProfileWidget extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final VoidCallback onPressed;
//
//   const ProfileWidget({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.3),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: Colors.black, size: 26),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 title,
//                 style: GoogleFonts.poppins(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/pages/SettingPage.dart';
import '/pages/Apps_About_Page.dart';
import '/pages/FAQsPage.dart';
import 'Account_Setting_Page.dart';

class MainSettingPage extends StatefulWidget {
  const MainSettingPage({super.key});

  @override
  State<MainSettingPage> createState() => _MainSettingPageState();
}

class _MainSettingPageState extends State<MainSettingPage> {
  String userName = "";
  String userEmail = "";
  String fireId = "";
  String selectedImageIndex = "0";
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


  // TODO: Sort the logic for syncing the profile photo in this page !



  Future<void> RemoveDetails() async{

    await FirebaseFirestore.instance.collection('users').doc(fireId).update({
      'myProf': int.parse(selectedImageIndex),
    });
  }

  void _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username') ?? "User";
      userEmail = prefs.getString('email') ?? "email@example.com";
      selectedImageIndex = prefs.getString('profileNumber') ?? "0";
      fireId = prefs.getString('fireId') ?? "";
      print("Selected Image Index: $selectedImageIndex");
    });
  }

  // Logout Confirmation Dialog
  void _logoutAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Logout',
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade700),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                'Logout',
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
              ),
              onPressed: () {
                RemoveDetails();
                Navigator.of(context).pop();
                _performLogout(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout(BuildContext context) async{
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged out successfully', style: GoogleFonts.poppins()),
        backgroundColor: Colors.grey.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    try {
      if(mounted){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('jwtToken');
        Navigator.pushReplacementNamed(context, '/log');
      }
    }catch(e){
      print("Error Navigating to Login Page $e");
    }
  }


  // void _showPhotoPicker() {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return Container(
  //         padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
  //         height: 120,
  //         child: ListView.separated(
  //           scrollDirection: Axis.horizontal,
  //           itemCount: profileImages.length,
  //           separatorBuilder: (context, index) => SizedBox(width: 16),
  //           itemBuilder: (context, index) {
  //             final image = profileImages[index];
  //             return GestureDetector(
  //               onTap: () {
  //                 setState(() {
  //                   selectedImage = image;
  //                   selectedImageIndex = index.toString();
  //                 });
  //                 Navigator.pop(context);
  //               },
  //               child: CircleAvatar(
  //                 backgroundImage: AssetImage(image),
  //                 radius: 30, // Smaller radius
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Settings",
          style: GoogleFonts.openSans(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF6F61),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF009688)),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
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
              // Light circular decorations
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
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: AssetImage(profileImages[int.parse(selectedImageIndex)]),
                              )
                          ),
                          const SizedBox(height: 16),
                          Text(
                            userName,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF009688),
                            ),
                          ),
                          Text(
                            userEmail,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        ProfileWidget(
                          icon: Icons.person,
                          title: 'My Profile',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AccountSettingPage()),
                            ).then((_) {
                              _getUserData(); // Reload the image
                            });
                          },
                        ),
                        ProfileWidget(
                          icon: Icons.chat,
                          title: 'FAQs',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FAQsPage()),
                            );
                          },
                        ),
                        ProfileWidget(
                          icon: Icons.info_rounded,
                          title: 'About',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AppAboutPage()),
                            );
                          },
                        ),
                        ProfileWidget(
                          icon: Icons.logout_outlined,
                          title: 'Log Out',
                          onPressed: () => _logoutAccount(context),
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

  const ProfileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
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
            Icon(icon, color: Color(0xFFFF6F61), size: 26),
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