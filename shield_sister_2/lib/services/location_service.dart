import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _locationUpdateTimer;

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

  Future<String> startSharing() async {
    String trackingId = generateTrackingId();
    Position position = await _determinePosition();

    await _firestore.collection('live_locations').doc(trackingId).set({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': FieldValue.serverTimestamp(),
    });

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
  }

  Future<void> stopSharing(String trackingId) async {
    _locationUpdateTimer?.cancel();
    await _firestore.collection('live_locations').doc(trackingId).delete();
  }
}