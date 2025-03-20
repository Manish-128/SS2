import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shield_sister_2/backend/Authentication.dart';
import 'package:shield_sister_2/pages/SOS_Homescreen.dart';
import 'package:shield_sister_2/screens/location_choice_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MockAuthService extends Mock implements AuthService {}
class MockGeolocator extends Mock implements Geolocator {}
class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockUrlLauncher extends Mock {
  Future<bool> launchMock(String url) async => true;
}

void main() {

  group('SOSHomescreen Tests', () {
    late MockAuthService mockAuthService;
    late MockUrlLauncher mockUrlLauncher;

    setUp(() {
      mockAuthService = MockAuthService();
      mockUrlLauncher = MockUrlLauncher();
    });

    testWidgets('Displays emergency text and SOS button', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SOSHomescreen()));
      expect(find.text("Emergency Help?"), findsOneWidget);
      expect(find.text("S.O.S"), findsOneWidget);
    });

    testWidgets('Tapping SOS button triggers SOS sending process', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SOSHomescreen()));
      await tester.tap(find.text("S.O.S"));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Tapping call buttons should launch dialer', (WidgetTester tester) async {
      when(mockUrlLauncher.launchMock("")).thenAnswer((_) async => true);

      await tester.pumpWidget(MaterialApp(home: SOSHomescreen()));
      await tester.tap(find.text("Police"));
      await tester.pump();

      verify(mockUrlLauncher.launchMock('tel:100')).called(1);
    });

    testWidgets('Tapping Track button navigates to location choice screen', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: SOSHomescreen()));
      await tester.tap(find.text("Track"));
      await tester.pumpAndSettle();
      expect(find.byType(LocationChoiceScreen), findsOneWidget);
    });
  });
}
