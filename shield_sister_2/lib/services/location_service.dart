import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _locationUpdateTimer;
  String SenderUserID = "";

  Future<void> getUserNameFromSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String em = prefs.getString('email') ?? "";
    SenderUserID = prefs.getString('email') ?? "";
    print("------Email is $em------");
  }

  String generateTrackingId() {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  Future<String> getUserID(String newUser) async {  // Function to get document ID of the sender
    String uN = newUser;
    String uID = "";
    final ref = FirebaseFirestore.instance.collection('users');

    final querySnapshot = await ref.where("username", isEqualTo: uN).get();

    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first; // Get the first matching document
      uID = userDoc.id; // Document ID
      Map<String, dynamic> userData = userDoc.data(); // User data

      print("User found! Document ID: $uID");
    } else {
      print("No user found with username: $uN");
    }

    return uID;

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

  Future<String> startSharing() async {
    String trackingId = generateTrackingId();
    Position position = await _determinePosition();

    await _firestore.collection('live_locations').doc(trackingId).set({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': FieldValue.serverTimestamp(),
    });

    final ref = FirebaseFirestore.instance.collection('users');
    getUserNameFromSharedPref();
    getUserNameFromSharedPref();

    final querySnapshot = await ref.where("username", isEqualTo: SenderUserID).get();


    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first; // Get the first matching document
      String docId = userDoc.id; // Document ID
      Map<String, dynamic> userData = userDoc.data(); // User data
      getUserNameFromSharedPref();
      print("Checkpoint 1");
      String RID = await getUserID(SenderUserID);
      print("User ID is $RID");

      await ref.doc(RID).update({"isSharing": true});
      print("Checkpoint 2");

      print("Sharing is on for : $docId");

    } else {
      print("Sharing is Off for : $SenderUserID");
    }


    // Start periodic updates every 10 seconds (adjust as needed)
    _locationUpdateTimer = Timer.periodic(Duration(seconds: 10), (timer) {
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
    final ref = FirebaseFirestore.instance.collection('users');

    final querySnapshot = await ref.where("username", isEqualTo: SenderUserID).get();


    if (querySnapshot.docs.isNotEmpty) {
      Position position = await _determinePosition();
      var userDoc = querySnapshot.docs.first; // Get the first matching document
      String docId = userDoc.id; // Document ID
      Map<String, dynamic> userData = userDoc.data(); // User data
      getUserNameFromSharedPref();
      print("Checkpoint 1");
      String RID = await getUserID(SenderUserID);
      print("User ID is $RID");

      await ref.doc(RID).update({"location_lat": position.latitude});
      await ref.doc(RID).update({"location_long": position.longitude});


      print("Location Service is running for : $docId");

    } else {
      print("Location Service is not Going for : $SenderUserID");
    }
  }

  Future<void> stopSharing(String trackingId) async {
    _locationUpdateTimer?.cancel();
    await _firestore.collection('live_locations').doc(trackingId).delete();
    final ref = FirebaseFirestore.instance.collection('users');

    final querySnapshot = await ref.where("username", isEqualTo: SenderUserID).get();


    if (querySnapshot.docs.isNotEmpty) {
      var userDoc = querySnapshot.docs.first; // Get the first matching document
      String docId = userDoc.id; // Document ID
      Map<String, dynamic> userData = userDoc.data(); // User data
      getUserNameFromSharedPref();
      print("Checkpoint 1");
      String RID = await getUserID(SenderUserID);
      print("User ID is $RID");

      await ref.doc(RID).update({"isSharing": false});
      print("Checkpoint 2");

      print("User found! Document ID: $docId");

    } else {
      print("No user found with username: $SenderUserID");
    }
  }
}