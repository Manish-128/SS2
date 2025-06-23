// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'Code_Entry.dart';
//
// class NotificationsPage extends StatefulWidget {
//   const NotificationsPage({super.key});
//
//   @override
//   State<NotificationsPage> createState() => _NotificationsPageState();
// }
//
// class _NotificationsPageState extends State<NotificationsPage> {
//   String currentUserId = "";
//   List<dynamic>? currentUserFriends;
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserData();
//   }
//
//   Future<void> _getUserData() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       setState(() {
//         currentUserId = prefs.getString('fireId') ?? "";
//       });
//       if (currentUserId.isNotEmpty) {
//         DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
//         setState(() {
//           currentUserFriends = (userDoc['friends'] as List<dynamic>?) ?? [];
//         });
//       }
//     } catch (e) {
//       _showMessage('Error fetching user data: $e', isError: true);
//     }
//   }
//
//   void _showMessage(String message, {bool isError = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: isError ? Colors.black87 : Colors.grey.shade800,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SOS Notifications'),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: currentUserId.isEmpty || currentUserFriends == null
//           ? const Center(child: CircularProgressIndicator())
//           : StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('users')
//             .where('isSharingSOS', isEqualTo: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             _showMessage('Error loading SOS requests: ${snapshot.error}', isError: true);
//             return const Center(child: Text('Error loading data.'));
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(child: Text('No SOS requests at this time.'));
//           }
//
//           final sosRequests = snapshot.data!.docs.where((doc) {
//             String senderId = doc.id;
//             print('Checking friend: $senderId against $currentUserFriends');
//             return currentUserFriends!.contains(senderId) && senderId != currentUserId;
//           }).toList();
//
//           if (sosRequests.isEmpty) {
//             return const Center(child: Text('No SOS requests from friends.'));
//           }
//
//           return ListView.builder(
//             padding: const EdgeInsets.all(16.0),
//             itemCount: sosRequests.length,
//             itemBuilder: (context, index) {
//               final senderData = sosRequests[index].data() as Map<String, dynamic>? ?? {};
//               final senderId = sosRequests[index].id;
//               final senderName = senderData['name'] ?? 'Unknown';
//               final sosCode = senderData['sosCode'] ?? 'N/A';
//               final isActive = senderData['sosActive'] ?? false;
//
//               if (!isActive) return const SizedBox.shrink();
//
//               return Card(
//                 elevation: 5,
//                 margin: const EdgeInsets.symmetric(vertical: 8.0),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: ListTile(
//                   contentPadding: const EdgeInsets.all(16.0),
//                   leading: CircleAvatar(
//                     backgroundColor: Colors.redAccent,
//                     child: Text(
//                       senderName[0].toUpperCase(),
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   title: Text(
//                     'Your friend $senderName needs your help!',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   subtitle: Text(
//                     'Code: $sosCode',
//                     style: const TextStyle(fontSize: 14, color: Colors.grey),
//                   ),
//                   // onTap: () {
//                   //   Navigator.push(
//                   //     context,
//                   //     MaterialPageRoute(
//                   //       builder: (context) => CodeEntryScreen(
//                   //         senderId: senderId,
//                   //         expectedCode: sosCode,
//                   //       ),
//                   //     ),
//                   //   ).catchError((e) {
//                   //     _showMessage('Navigation error: $e', isError: true);
//                   //   });
//                   // },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/view_location_screen.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String currentUserId = "";
  List<dynamic>? currentUserFriends;
  String SOSCode = "";
  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        currentUserId = prefs.getString('fireId') ?? "";
      });
      if (currentUserId.isNotEmpty) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
        setState(() {
          currentUserFriends = (userDoc['friends'] as List<dynamic>?) ?? [];
        });
      }
    } catch (e) {
      _showMessage('Error fetching user data: $e', isError: true);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.black87 : Colors.grey.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFDFD),
      appBar: AppBar(
        title: const Text(
          'SOS Notifications',
          style: TextStyle(color: Color(0xFF009688)),
        ),
        backgroundColor: const Color(0xFFE0F2F1),
        elevation: 0,
      ),
      body: currentUserId.isEmpty || currentUserFriends == null
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF4D6D)))
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('isSharingSOS', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFFF4D6D)));
          }
          if (snapshot.hasError) {
            _showMessage('Error loading SOS requests: ${snapshot.error}', isError: true);
            return const Center(child: Text('Error loading data.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('No SOS requests at this time.', style: TextStyle(color: Colors.black54)));
          }

          final sosRequests = snapshot.data!.docs.where((doc) {
            String senderId = doc.id;
            print('Checking friend: $senderId against $currentUserFriends');
            return currentUserFriends!.contains(senderId) && senderId != currentUserId;
          }).toList();

          if (sosRequests.isEmpty) {
            return const Center(
                child: Text('Recieve Notifications here...', style: TextStyle(color: Colors.black54)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: sosRequests.length,
            itemBuilder: (context, index) {
              final senderData = sosRequests[index].data() as Map<String, dynamic>? ?? {};
              final senderId = sosRequests[index].id;
              final senderName = senderData['name'] ?? 'Unknown';
              final sosCode = senderData['sosCode'] ?? 'N/A';
              final isActive = senderData['sosActive'] ?? false;
              final trackID = senderData['myTrackId'] ?? "";

              if (!isActive) return const SizedBox.shrink();

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFAAF0D1), // Theme pink
                    child: Text(
                      senderName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFF009688),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    'Your friend $senderName needs your help!',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    'Code: $sosCode',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewLocationScreen(
                          trackingId: trackID.toString(),
                          isSOS: true,
                          SOSCode: sosCode.toString(),
                        ),
                      ),
                    ).catchError((e) {
                      _showMessage('Navigation error: $e', isError: true);
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}