// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class FriendRequestsPage extends StatefulWidget {
//   const FriendRequestsPage({super.key});
//
//   @override
//   State<FriendRequestsPage> createState() => _FriendRequestsPageState();
// }
//
// class _FriendRequestsPageState extends State<FriendRequestsPage> {
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
//   Future<String?> getNameFromUserId(String fireID) async {
//     DocumentSnapshot doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(fireID)
//         .get();
//
//     if (doc.exists && doc.data() != null) {
//       return doc['name']; // or use: doc.get('name')
//     } else {
//       return null; // Document doesn't exist or no data
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> seeRequests() async {
//     print("Fire Id: $fireId");
//     // Wait for userId to be set
//     if (fireId.isEmpty) {
//       await _getUserData();
//     }
//
//     DocumentSnapshot doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(fireId)
//         .get();
//
//     if(doc.exists){
//       print("Document is found with first request: ${doc['friend_request'][0]}");
//     }else{
//       print("No document found for checking friend request");
//     }
//     Map<String, dynamic> friendRequests = Map<String, dynamic>.from(doc['friend_request']);
//
//     // Extract and filter pending requests
//     List<Map<String, dynamic>> pendingRequests = [];
//
//     friendRequests.forEach((key, value) {
//       if (value['status'] == 'pending') {
//         pendingRequests.add({
//           'userID': key,
//           'timestamp': value['timestamp'],
//           'status': value['status'],
//         });
//       }
//     });
//
//     return pendingRequests;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Pending Friend Requests')),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: seeRequests(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No pending requests.'));
//           }
//
//           List<Map<String, dynamic>> pendingRequests = snapshot.data!;
//
//           return ListView.builder(
//             itemCount: pendingRequests.length,
//             itemBuilder: (context, index) {
//               final request = pendingRequests[index];
//               final date = request['timestamp'] is Timestamp
//                   ? (request['timestamp'] as Timestamp).toDate()
//                   : null;
//
//               return Card(
//                 margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 child: FutureBuilder<String?>(
//                   future: getNameFromUserId(request['userID']),
//                   builder: (context, nameSnapshot) {
//                     if (nameSnapshot.connectionState == ConnectionState.waiting) {
//                       return const ListTile(
//                         title: Text('Loading...'),
//                         subtitle: Text('Fetching name...'),
//                       );
//                     }
//
//                     final friendName = nameSnapshot.data ?? 'Unknown';
//
//                     return ListTile(
//                       title: Text('Name: $friendName'),
//                       subtitle: date != null
//                           ? Text('Requested on: ${date.toLocal().toString().split('.')[0]}')
//                           : const Text('Requested on: Unknown'),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () async {
//                               // TODO: Add Accept logic here
//                               final friendId = request['userID'];
//
//                               DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(fireId);
//
//                               await FirebaseFirestore.instance.runTransaction((transaction) async {
//                                 DocumentSnapshot snapshot = await transaction.get(userDocRef);
//
//                                 if (!snapshot.exists) return;
//
//                                 Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//
//                                 // 1. Remove from friend_request
//                                 Map<String, dynamic> friendRequests = Map<String, dynamic>.from(data['friend_request']);
//                                 friendRequests.remove(friendId);
//
//                                 // 2. Add to friends array
//                                 List<dynamic> friends = List.from(data['friends'] ?? []);
//                                 if (!friends.contains(friendId)) {
//                                   friends.add(friendId);
//                                 }
//
//                                 transaction.update(userDocRef, {
//                                   'friend_request': friendRequests,
//                                   'friends': friends,
//                                 });
//                               });
//
//                               setState(() {}); // Refresh UI
//                             },
//                             child: const Text("Accept"),
//                           ),
//                           const SizedBox(width: 8),
//                           ElevatedButton(
//                             onPressed: () async{
//                               // TODO: Add Reject logic here
//                               final friendId = request['userID'];
//
//                               DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(fireId);
//
//                               await FirebaseFirestore.instance.runTransaction((transaction) async {
//                                 DocumentSnapshot snapshot = await transaction.get(userDocRef);
//
//                                 if (!snapshot.exists) return;
//
//                                 Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//
//                                 // Remove from friend_request
//                                 Map<String, dynamic> friendRequests = Map<String, dynamic>.from(data['friend_request']);
//                                 friendRequests.remove(friendId);
//
//                                 transaction.update(userDocRef, {
//                                   'friend_request': friendRequests,
//                                 });
//                               });
//
//                               setState(() {}); // Refresh UI
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red,
//                             ),
//                             child: const Text("Reject"),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
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

class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  State<FriendRequestsPage> createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
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
    });
  }

  Future<String?> getNameFromUserId(String fireID) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(fireID)
        .get();

    if (doc.exists && doc.data() != null) {
      return doc['name'];
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> seeRequests() async {
    print("Fire Id: $fireId");
    if (fireId.isEmpty) {
      await _getUserData();
    }

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(fireId)
        .get();

    if (doc.exists) {
      print("Document is found with first request: ${doc['friend_request'][0]}");
    } else {
      print("No document found for checking friend request");
    }
    Map<String, dynamic> friendRequests = Map<String, dynamic>.from(doc['friend_request']);

    List<Map<String, dynamic>> pendingRequests = [];

    friendRequests.forEach((key, value) {
      if (value['status'] == 'pending') {
        pendingRequests.add({
          'userID': key,
          'timestamp': value['timestamp'],
          'status': value['status'],
        });
      }
    });

    return pendingRequests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0F2F1), // Soft pink from theme
        title: const Text(
          'Pending Friend Requests',
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
              future: seeRequests(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFFF4D6D)));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No pending requests. 💌', style: TextStyle(color: Colors.black54)));
                }

                List<Map<String, dynamic>> pendingRequests = snapshot.data!;

                return ListView.builder(
                  itemCount: pendingRequests.length,
                  itemBuilder: (context, index) {
                    final request = pendingRequests[index];
                    final date = request['timestamp'] is Timestamp
                        ? (request['timestamp'] as Timestamp).toDate()
                        : null;

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.white,
                      child: FutureBuilder<String?>(
                        future: getNameFromUserId(request['userID']),
                        builder: (context, nameSnapshot) {
                          if (nameSnapshot.connectionState == ConnectionState.waiting) {
                            return const ListTile(
                              title: Text('Loading...'),
                              subtitle: Text('Fetching name...'),
                            );
                          }

                          final friendName = nameSnapshot.data ?? 'Unknown';

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFFAAF0D1),
                              child: Text(
                                friendName.isNotEmpty ? friendName[0].toUpperCase() : '?',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF009688),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text('Name: $friendName', style: const TextStyle(fontSize: 18, color: Colors.black87)),
                            subtitle: date != null
                                ? Text('Requested on: ${date.toLocal().toString().split('.')[0]}',
                                style: const TextStyle(fontSize: 14, color: Colors.grey))
                                : const Text('Requested on: Unknown', style: TextStyle(fontSize: 14, color: Colors.grey)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    final friendId = request['userID'];

                                    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(fireId);
                                    DocumentReference FriendDocRef = FirebaseFirestore.instance.collection('users').doc(friendId);

                                    await FirebaseFirestore.instance.runTransaction((transaction) async {
                                      DocumentSnapshot snapshot = await transaction.get(userDocRef);

                                      if (!snapshot.exists ) return;

                                      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

                                      Map<String, dynamic> friendRequests = Map<String, dynamic>.from(data['friend_request']);
                                      friendRequests.remove(friendId);


                                      List<dynamic> friends = List.from(data['friends'] ?? []);
                                      if (!friends.contains(friendId)) {
                                        friends.add(friendId);
                                      }

                                      transaction.update(userDocRef, {
                                        'friend_request': friendRequests,
                                        'friends': friends,
                                      });
                                    });

                                    await FirebaseFirestore.instance.runTransaction((transaction) async {
                                      DocumentSnapshot friendsnapshot = await transaction.get(FriendDocRef);

                                      if (!friendsnapshot.exists) return;

                                      Map<String, dynamic> friend_data = friendsnapshot.data() as Map<String, dynamic>;


                                      Map<String, dynamic> Friend_friendRequests = Map<String, dynamic>.from(friend_data['friend_request']);
                                      Friend_friendRequests.remove(fireId);


                                      List<dynamic> Friends_FriendList = List.from(friend_data['friends'] ?? []);
                                      if(!Friends_FriendList.contains(fireId)){
                                        Friends_FriendList.add(fireId);
                                      }

                                      transaction.update(FriendDocRef, {
                                        'friend_request': Friend_friendRequests,
                                        'friends': Friends_FriendList,
                                      });
                                    });

                                    setState(() {});
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFAAF0D1),
                                    foregroundColor: Color(0xFF009688),
                                  ),
                                  child: Icon(Icons.check),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () async {
                                    final friendId = request['userID'];

                                    DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(fireId);

                                    await FirebaseFirestore.instance.runTransaction((transaction) async {
                                      DocumentSnapshot snapshot = await transaction.get(userDocRef);

                                      if (!snapshot.exists) return;

                                      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

                                      Map<String, dynamic> friendRequests = Map<String, dynamic>.from(data['friend_request']);
                                      friendRequests.remove(friendId);

                                      transaction.update(userDocRef, {
                                        'friend_request': friendRequests,
                                      });
                                    });

                                    setState(() {});
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFF28B82),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Icon(Icons.cancel),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}