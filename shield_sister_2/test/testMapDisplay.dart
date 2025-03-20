import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shield_sister_2/new_pages/Map_Display_Page.dart'; // Adjust this import as needed

// Mock classes
class MockHttpClient extends Mock implements http.Client {}
class MockGeolocator extends Mock implements GeolocatorPlatform {}

void main() {
  group('fetchLandmarks', () {
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
    });

    test('returns a list of landmarks when API call is successful', () async {
      final testLocation = LatLng(37.7749, -122.4194);
      final testResponse = {
        "places": [
          {
            "displayName": {"text": "Test Landmark"},
            "formattedAddress": "123 Test Street",
            "location": {"latitude": 37.7749, "longitude": -122.4194}
          }
        ]
      };

      when(mockHttpClient.post(Uri.parse(""), headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response(jsonEncode(testResponse), 200));

      final result = await fetchLandmarks(testLocation, 'hospital');

      expect(result, isNotEmpty);
      expect(result.first.name, equals('Test Landmark'));
    });

    test('returns an empty list when API call fails', () async {
      final testLocation = LatLng(37.7749, -122.4194);
      when(mockHttpClient.post(Uri(), headers: anyNamed('headers'), body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('Error', 400));

      final result = await fetchLandmarks(testLocation, 'hospital');

      expect(result, isEmpty);
    });
  });

  group('Location Updates', () {
    late MockGeolocator mockGeolocator;

    setUp(() {
      mockGeolocator = MockGeolocator();
    });

    test('fetches user location successfully', () async {
      final testPosition = Position(
        latitude: 37.7749,
        longitude: -122.4194,
        accuracy: 1.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        timestamp: DateTime.now(), altitudeAccuracy: 0.0, headingAccuracy: 0.0,
      );

      when(mockGeolocator.getCurrentPosition())
          .thenAnswer((_) async => testPosition);

      final result = await Geolocator.getCurrentPosition();

      expect(result.latitude, equals(37.7749));
      expect(result.longitude, equals(-122.4194));
    });
  });

  group('User Zone Classification', () {
    test('detects Safe Zone correctly', () {
      final userLocation = LatLng(37.7749, -122.4194);
      final safeZone = Landmark(
        name: 'Hospital',
        description: 'Nearby hospital',
        location: LatLng(37.7750, -122.4195),
      );
      final distance = _calculateDistance(userLocation, safeZone.location);

      expect(distance, lessThanOrEqualTo(50)); // 50m radius for safe zone
    });

    test('detects Unsafe Zone correctly', () {
      final userLocation = LatLng(37.7749, -122.4194);
      final unsafeZone = LatLng(37.7755, -122.4199);
      final distance = _calculateDistance(userLocation, unsafeZone);

      expect(distance, lessThanOrEqualTo(50));
    });
  });
}

// Helper function
double _calculateDistance(LatLng loc1, LatLng loc2) {
  const double earthRadius = 6371000;
  final dLat = (loc2.latitude - loc1.latitude) * (3.141592653589793 / 180);
  final dLon = (loc2.longitude - loc1.longitude) * (3.141592653589793 / 180);
  final a = (sin(dLat / 2) * sin(dLat / 2)) +
      cos(loc1.latitude * (3.141592653589793 / 180)) *
          cos(loc2.latitude * (3.141592653589793 / 180)) *
          sin(dLon / 2) *
          sin(dLon / 2);
  return earthRadius * 2 * atan2(sqrt(a), sqrt(1 - a));
}
