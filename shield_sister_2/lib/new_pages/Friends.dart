// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class FriendsListPage extends StatefulWidget {
//   const FriendsListPage({super.key});
//
//   @override
//   State<FriendsListPage> createState() => _FriendsListPageState();
// }
//
// class _FriendsListPageState extends State<FriendsListPage> {
//   String fireId = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _getUserData();
//   }
//
//   Future<void> _getUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       fireId = prefs.getString('fireId') ?? "";
//     });
//   }
//
//   Future<List<Map<String, dynamic>>> fetchFriendsDetails() async {
//     if (fireId.isEmpty) {
//       await _getUserData();
//     }
//
//     DocumentSnapshot userDoc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(fireId)
//         .get();
//
//     List<dynamic> friendIds = userDoc['friends'] ?? [];
//
//     List<Map<String, dynamic>> friendsDetails = [];
//
//     for (String friendId in friendIds) {
//       DocumentSnapshot friendDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(friendId)
//           .get();
//
//       if (friendDoc.exists) {
//         var data = friendDoc.data() as Map<String, dynamic>;
//         friendsDetails.add({
//           'name': data['name'] ?? 'Unknown',
//           'phone': data['phone'] ?? 'Not Available',
//         });
//       }
//     }
//
//     return friendsDetails;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFFDEFF4),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFFFC0CB),
//         title: const Text("My Friends 💕"),
//         elevation: 0,
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: fetchFriendsDetails(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator(color: Colors.pinkAccent));
//           }
//
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No friends added yet 💌'));
//           }
//
//           final friends = snapshot.data!;
//
//           return Padding(
//             padding: const EdgeInsets.all(12),
//             child: GridView.builder(
//               itemCount: friends.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2, // 2 cards per row
//                 childAspectRatio: 3 / 2, // Rectangular style
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//               ),
//               itemBuilder: (context, index) {
//                 final friend = friends[index];
//                 final name = friend['name'];
//                 final phone = friend['phone'];
//                 final avatarLetter = name.isNotEmpty ? name[0].toUpperCase() : '?';
//
//                 return Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.pinkAccent,
//                         blurRadius: 4,
//                         offset: Offset(2, 3),
//                         spreadRadius: 0.5,
//                       )
//                     ],
//                   ),
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         name,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 20,
//                           color: Colors.black87,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         phone,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendsListPage extends StatefulWidget {
  const FriendsListPage({super.key});

  @override
  State<FriendsListPage> createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  String fireId = "";

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fireId = prefs.getString('fireId') ?? "";
      print("FireID: $fireId");
    });
  }

  Future<List<Map<String, dynamic>>> fetchFriendsDetails() async {
    if (fireId.isEmpty) {
      await _getUserData();
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(fireId)
        .get();

    List<dynamic> friendIds = userDoc['friends'] ?? [];

    List<Map<String, dynamic>> friendsDetails = [];

    for (String friendId in friendIds) {
      DocumentSnapshot friendDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(friendId)
          .get();

      if (friendDoc.exists) {
        var data = friendDoc.data() as Map<String, dynamic>;
        friendsDetails.add({
          'name': data['name'] ?? 'Unknown',
          'phone': data['phone'] ?? 'Not Available',
        });
      }
    }

    return friendsDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFDFD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0F2F1),
        title: const Text(
          "My Friends",
          style: TextStyle(color: Color(0xFF009688)),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help, color: Color(0xFFFFD180)),
            onPressed: () {
              // SOS or Help action
            },
          ),
        ],
      ),
      body: Column(
        children: [

          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchFriendsDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFFF4D6D)));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No friends added yet 💌', style: TextStyle(color: Color(0xFF757575))));
                }

                final friends = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    itemCount: friends.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final friend = friends[index];
                      final name = friend['name'];
                      final phone = friend['phone'];
                      final avatarLetter = name.isNotEmpty ? name[0].toUpperCase() : '?';

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE0F2F1),
                              blurRadius: 4,
                              offset: const Offset(2, 3),
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Color(0xFFAAF0D1),
                              child: Text(
                                avatarLetter,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF009688),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Color(0xFF212121),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              phone,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}