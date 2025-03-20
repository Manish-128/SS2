// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
//
// class ViewTrack2 extends StatefulWidget {
//   const ViewTrack2({super.key});
//
//   @override
//   State<ViewTrack2> createState() => ViewTrack2State();
// }
//
// class ViewTrack2State extends State<ViewTrack2> {
//
//   TextEditingController getUserController = TextEditingController();
//   String username = "";  // To store the username of sender
//   String DocId = "";  // To store doc ID of the sender
//
//   String ReceiverUserID = "";  //To store username of the receiver
//
//   // Get the user's username from shared preference
//   Future<void> getUserNameFromSharedPref() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String em = prefs.getString('email') ?? "";
//     setState(() {
//       ReceiverUserID = prefs.getString('email') ?? "";
//     });
//     print("------Email is $em------");
//   }
//   // Add the searched user's userID into sharedId's array
//   Future<String> getUserID(String newUser) async {  // Function to get document ID of the sender
//     // setState(() {
//     //   username = getUserController.text;
//     // });
//     String uN = newUser;
//     String uID = "";
//     final ref = FirebaseFirestore.instance.collection('users');
//
//     final querySnapshot = await ref.where("username", isEqualTo: uN).get();
//
//     if (querySnapshot.docs.isNotEmpty) {
//       var userDoc = querySnapshot.docs.first; // Get the first matching document
//       uID = userDoc.id; // Document ID
//       Map<String, dynamic> userData = userDoc.data(); // User data
//
//       print("User found! Document ID: $uID");
//       // setState(() {
//       //   DocId = docId;
//       // });
//     } else {
//       print("No user found with username: $username");
//     }
//
//     return uID;
//
//   }
//   Future<void> getUserByUsernameAddtoSharedID(String senderUserID, String uN) async {
//     final ref = FirebaseFirestore.instance.collection('users');
//
//     final querySnapshot = await ref.where("username", isEqualTo: uN).get();
//     // final querySnapshotUser = await ref.where("username", isEqualTo: userId).get(); // Original user's query snapshot
//
//
//     if (querySnapshot.docs.isNotEmpty) {
//       var userDoc = querySnapshot.docs.first; // Get the first matching document
//       String docId = userDoc.id; // Document ID
//       Map<String, dynamic> userData = userDoc.data(); // User data
//       getUserNameFromSharedPref();
//       print("Checkpoint 1");
//       String RID = await getUserID(ReceiverUserID);
//       print("User ID is $RID");
//       await ref.doc(RID).update({
//         "sharingTo": FieldValue.arrayUnion([senderUserID]) // Append userID of location sender to the array
//       });
//       print("Checkpoint 2");
//
//       print("User found! Document ID: $docId");
//
//     } else {
//       print("No user found with username: $username");
//     }
//
//
//   }
//   // Put a button, which will be able to scan the array and present cards
//   //
//
//
//
//   Future<void> checkisSharing(QuerySnapshot query) async{
//
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getUserNameFromSharedPref();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//         child: Column(
//           children: [
//             SizedBox(height: 50,),
//             Row(
//               children: [
//                 SizedBox(
//                   width: 300,
//                   height: 60,
//                   child: TextField(
//                     controller: getUserController,
//                     decoration: InputDecoration(
//                       labelText: 'Enter Username',
//                       labelStyle: TextStyle(color: Colors.grey.shade600),
//                       filled: true,
//                       fillColor: Colors.grey.shade100,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       prefixIcon: Icon(
//                         Icons.vpn_key,
//                         color: Colors.black,
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                           color: Colors.black,
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                     style: TextStyle(color: Colors.black),
//                     cursorColor: Colors.black,
//                   ),
//                 ),
//                 TextButton(onPressed: () async {
//                   String textFromCont = getUserController.text;
//                   String senderUserID = await getUserID(textFromCont);
//                   setState(() {
//                     DocId = senderUserID;
//                   });
//                   getUserByUsernameAddtoSharedID(senderUserID, textFromCont);
//                 }, child: Text("GET")),   //TODO: Important function of the page
//               ],
//             ),
//             SizedBox(height: 24),
//
//             Text(DocId),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/view_location_screen.dart';

class ViewTrack2 extends StatefulWidget {
  const ViewTrack2({super.key});

  @override
  State<ViewTrack2> createState() => ViewTrack2State();
}

class ViewTrack2State extends State<ViewTrack2> {
  TextEditingController getUserController = TextEditingController();
  String username = ""; // To store the username of sender
  String DocId = ""; // To store doc ID of the sender
  String ReceiverUserID = ""; // To store username of the receiver
  List<Map<String, dynamic>> sharingUsers = []; // To store users who are sharing their location

  // Get the user's username from shared preference
  Future<void> getUserNameFromSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String em = prefs.getString('email') ?? "";
    setState(() {
      ReceiverUserID = em;
    });
    print("------Email is $em------");
  }

  // Get the document ID of a user by their username
  Future<String> getUserID(String newUser) async {
    String uN = newUser;
    String uID = "";
    final ref = FirebaseFirestore.instance.collection('users');

    final querySnapshot = await ref.where("username", isEqualTo: uN).get();

    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first;
      uID = userDoc.id;
      print("User found! Document ID: $uID");
    } else {
      print("No user found with username: $uN");
    }

    return uID;
  }

  // Add the searched user's userID into the receiver's sharingTo array
  Future<void> getUserByUsernameAddtoSharedID(
      String senderUserID, String uN) async {
    final ref = FirebaseFirestore.instance.collection('users');

    final querySnapshot = await ref.where("username", isEqualTo: uN).get();

    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first;
      String docId = userDoc.id;
      await getUserNameFromSharedPref();
      print("Checkpoint 1");
      String RID = await getUserID(ReceiverUserID);
      print("User ID is $RID");
      await ref.doc(RID).update({
        "sharingTo": FieldValue.arrayUnion([senderUserID])
      });
      print("Checkpoint 2");
      print("User found! Document ID: $docId");
    } else {
      print("No user found with username: $uN");
    }
  }

  // Check the sharingTo array and fetch users who are sharing their location
  Future<void> checkIsSharing() async {
    setState(() {
      sharingUsers.clear(); // Clear previous results
    });

    final ref = FirebaseFirestore.instance.collection('users');
    String receiverDocId = await getUserID(ReceiverUserID);

    if (receiverDocId.isEmpty) {
      print("Receiver document ID not found.");
      return;
    }

    // Fetch the receiver's document to get the sharingTo array
    final receiverDoc = await ref.doc(receiverDocId).get();
    if (!receiverDoc.exists) {
      print("Receiver document does not exist.");
      return;
    }

    Map<String, dynamic> receiverData = receiverDoc.data() as Map<String, dynamic>;
    List<dynamic> sharingTo = receiverData['sharingTo'] ?? [];

    if (sharingTo.isEmpty) {
      print("No users in sharingTo array.");
      return;
    }

    // Check each user in sharingTo
    for (String senderId in sharingTo) {
      final senderDoc = await ref.doc(senderId).get();
      if (senderDoc.exists) {
        Map<String, dynamic> senderData = senderDoc.data() as Map<String, dynamic>;
        bool isSharing = senderData['isSharing'] ?? false;
        if (isSharing) {
          setState(() {
            sharingUsers.add({
              'userId': senderId,
              'username': senderData['username'] ?? 'Unknown',
            });
          });
        }
      }
    }
  }

  // Build a card for each user who is sharing their location
  Widget buildSharingCard(Map<String, dynamic> user) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.person, color: Colors.black, size: 30),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username: ${user['username']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'User ID: ${user['userId']}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(onPressed: (){
              Navigator.push(
                context,  //TODO: Change this later
                MaterialPageRoute(builder: (context) =>  ViewLocationScreen(trackingId: user['userId'],)),);
            } ,
                icon: const Icon(Icons.location_on), color: Colors.green, iconSize: 30),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getUserNameFromSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Row(
              children: [
                SizedBox(
                  width: 300,
                  height: 60,
                  child: TextField(
                    controller: getUserController,
                    decoration: InputDecoration(
                      labelText: 'Enter Username',
                      labelStyle: TextStyle(color: Colors.grey.shade600),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(
                        Icons.vpn_key,
                        color: Colors.black,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    String textFromCont = getUserController.text;
                    String senderUserID = await getUserID(textFromCont);
                    setState(() {
                      DocId = senderUserID;
                    });
                    await getUserByUsernameAddtoSharedID(senderUserID, textFromCont);
                  },
                  child: const Text("GET"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text("Sender Doc ID: $DocId"),
            const SizedBox(height: 24),
            // Button to check sharing status and display cards
            ElevatedButton(
              onPressed: checkIsSharing,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Check Sharing Users",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
            // Display cards for users who are sharing their location
            sharingUsers.isEmpty
                ? const Text(
              "No users are sharing their location with you.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: sharingUsers.length,
                itemBuilder: (context, index) {
                  return buildSharingCard(sharingUsers[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}