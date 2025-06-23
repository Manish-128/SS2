// import 'dart:async';
// import 'dart:math';
// import 'package:geolocator/geolocator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class LocationService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   Timer? _locationUpdateTimer;
//
//   String generateTrackingId() {
//     const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
//     final random = Random();
//     return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
//   }
//
//   Future<Position> _determinePosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) throw 'Location services are disabled';
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) throw 'Location permissions denied';
//     }
//
//     return await Geolocator.getCurrentPosition();
//   }
//
//   Future<String> startSharing() async {
//     String trackingId = generateTrackingId();
//     Position position = await _determinePosition();
//
//     await _firestore.collection('live_locations').doc(trackingId).set({
//       'latitude': position.latitude,
//       'longitude': position.longitude,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     // Start periodic updates every 10 seconds (adjust as needed)
//     _locationUpdateTimer = Timer.periodic(Duration(seconds: 10), (timer) {
//       updateLiveLocation(trackingId);
//     });
//
//     return trackingId;
//   }
//
//   Future<void> updateLiveLocation(String trackingId) async {
//     try {
//       Position position = await _determinePosition();
//       await _firestore.collection('live_locations').doc(trackingId).update({
//         'latitude': position.latitude,
//         'longitude': position.longitude,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print('Error updating location: $e');
//     }
//   }
//
//   Future<void> stopSharing(String trackingId) async {
//     _locationUpdateTimer?.cancel();
//     await _firestore.collection('live_locations').doc(trackingId).delete();
//   }
// }

import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _locationUpdateTimer;
  String userId = "";
  String fireId = "";


  Future<void> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    fireId = prefs.getString('fireId') ?? "";
  }

  String generateTrackingId() {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw 'Location services are disabled';

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) throw 'Location permissions denied';
    }

    return await Geolocator.getCurrentPosition();
  }
  Future<void> AppendUserIDtoFriends(String userId, String trackId) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (docSnapshot.exists) {
      List<String> friends = List<String>.from(docSnapshot.data()?['friends'] ?? []);

      for (String friendId in friends) {
        // Perform your operation here
        print('Performing operation for friend: $friendId');

        // Example: Fetch friend details
        DocumentSnapshot friendDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(friendId)
            .get();

        if (friendDoc.exists) {
          print("Friend's name: ${friendDoc['name']}");
          await _firestore.collection("users").doc(friendId).update({
            'TrackTo': FieldValue.arrayUnion([userId]),
          });
        }
      }
    } else {
      print('User not found');
    }
  }

  Future<String> startSharing() async {
    String trackingId = generateTrackingId();
    Position position = await _determinePosition();

    await _firestore.collection('live_locations').doc(trackingId).set({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _getUserData();
    // Tracking ID successfully updated
    await _firestore.collection("users").doc(fireId).update({
      'myTrackId': trackingId.toString(),
    });

    // Now update it to the persons we want to share
    AppendUserIDtoFriends(fireId, trackingId);


    // Start periodic updates every 10 seconds (adjust as needed)
    _locationUpdateTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      updateLiveLocation(trackingId);
    });

    return trackingId;
  }

  Future<void> updateLiveLocation(String trackingId) async {
    try {
      Position position = await _determinePosition();
      await _firestore.collection('live_locations').doc(trackingId).update({
        'latitude': position.latitude,
        'longitude': position.longitude,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  Future<void> stopSharing(String trackingId) async {
    _locationUpdateTimer?.cancel();
    await _firestore.collection('live_locations').doc(trackingId).delete();
    await _getUserData();
    print("In location Service fireId: $fireId");
    await _firestore.collection("users").doc(fireId).update(
        {
          'myTrackId' : "0",
        }
    );
  }
}