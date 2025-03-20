import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shield_sister_2/backend/Authentication.dart';
import 'package:shield_sister_2/new_pages/contact_management_page.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

// Import the generated mocks
import 'contact_test.mocks.dart';

// Generate mocks for AuthService and SharedPreferences
@GenerateMocks([AuthService, SharedPreferences, mongo.Db, mongo.DbCollection])
void main() {
  late MockAuthService mockAuthService;
  late MockSharedPreferences mockSharedPreferences;
  late MockDb mockDb;
  late MockDbCollection mockCollection;

  setUp(() {
    mockAuthService = MockAuthService();
    mockSharedPreferences = MockSharedPreferences();
    mockDb = MockDb();
    mockCollection = MockDbCollection();

    // Stub SharedPreferences
    when(mockSharedPreferences.getString('userId')).thenReturn('507f1f77bcf86cd799439011');

    // Stub MongoDB interactions
    when(mockDb.open()).thenAnswer((_) async => null);
    when(mockDb.close()).thenAnswer((_) async => null);
    when(mockDb.collection('contacts')).thenReturn(mockCollection);
  });

  // Helper method to create the widget under test
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ContactManagementPage(),
    );
  }

  // Test Group for UI Rendering
  group('ContactManagementPage UI Tests', () {
    testWidgets('renders main UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Manage Contacts'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2)); // Name and Phone fields
      expect(find.text('Contact Name'), findsOneWidget);
      expect(find.text('Phone Number'), findsOneWidget);
      expect(find.text('Save Contact'), findsOneWidget);
      expect(find.text('No contacts found'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('shows loading indicator when _isLoading is true', (WidgetTester tester) async {
      // Simulate a scenario where _isLoading is true
      when(mockDb.collection('contacts')).thenReturn(mockCollection);
      when(mockCollection.find(any)).thenAnswer((_) async {
        await Future.delayed(Duration(seconds: 1)); // Simulate delay
        return [];
      } as Answering<Stream<Map<String, dynamic>>>);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(); // Trigger the loading state

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  // Test Group for _getUserData
  group('_getUserData Tests', () {
    testWidgets('loads userId from SharedPreferences', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final state = tester.state<ContactManagementPageState>(find.byType(ContactManagementPage));
      expect(state.userId, '507f1f77bcf86cd799439011');
    });

    testWidgets('handles empty userId from SharedPreferences', (WidgetTester tester) async {
      when(mockSharedPreferences.getString('userId')).thenReturn(null);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final state = tester.state<ContactManagementPageState>(find.byType(ContactManagementPage));
      expect(state.userId, '');
    });
  });

  // Test Group for _fetchContacts
  group('_fetchContacts Tests', () {
    testWidgets('fetches and displays contacts from MongoDB', (WidgetTester tester) async {
      // Mock MongoDB response
      when(mockCollection.find(any)).thenAnswer((_) async => [
        {'name': 'Alice', 'phone': '+91 9876543210'},
        {'name': 'Bob', 'phone': '+91 9123456789'},
      ] as Answering<Stream<Map<String, dynamic>>>);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('+91 9876543210'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('+91 9123456789'), findsOneWidget);
      expect(find.text('No contacts found'), findsNothing);
    });

    testWidgets('shows error message when fetching contacts fails', (WidgetTester tester) async {
      // Simulate an error in MongoDB fetch
      when(mockCollection.find(any)).thenThrow(Exception('Database connection failed'));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Error fetching contacts'), findsOneWidget);
    });
  });

  // Test Group for _addContact
  group('_addContact Tests', () {
    testWidgets('adds a new contact successfully', (WidgetTester tester) async {
      // Mock the backend response
      when(mockAuthService.SaveContact(any, any))
          .thenAnswer((_) async => {'message': 'Contacts saved successfully!'});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enter contact details
      await tester.enterText(find.byType(TextField).at(0), 'Alice');
      await tester.enterText(find.byType(TextField).at(1), '9876543210');
      await tester.tap(find.text('Save Contact'));
      await tester.pumpAndSettle();

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('+91 9876543210'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Contact successfully added'), findsOneWidget);
    });

    testWidgets('shows error message when adding contact fails', (WidgetTester tester) async {
      // Mock the backend response to fail
      when(mockAuthService.SaveContact(any, any))
          .thenAnswer((_) async => {'message': 'Failed to save contact'});

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Enter contact details
      await tester.enterText(find.byType(TextField).at(0), 'Alice');
      await tester.enterText(find.byType(TextField).at(1), '9876543210');
      await tester.tap(find.text('Save Contact'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Failed to add contact'), findsOneWidget);
    });

    testWidgets('does not add contact if fields are empty', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Leave fields empty and tap Save Contact
      await tester.tap(find.text('Save Contact'));
      await tester.pumpAndSettle();

      expect(find.text('No contacts found'), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
    });
  });

  // Test Group for _editContact
  group('_editContact Tests', () {
    testWidgets('edits an existing contact', (WidgetTester tester) async {
      // Mock initial contacts
      when(mockCollection.find(any)).thenAnswer((_) async => [
        {'name': 'Alice', 'phone': '+91 9876543210'},
      ] as Answering<Stream<Map<String, dynamic>>>);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap the menu and select Edit
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      // Verify the fields are populated with the contact's data
      expect(tester.widget<TextField>(find.byType(TextField).at(0)).controller!.text, 'Alice');
      expect(tester.widget<TextField>(find.byType(TextField).at(1)).controller!.text, '9876543210');

      // Verify the contact is removed from the list
      expect(find.text('Alice'), findsNothing);
    });
  });

  // Test Group for _deleteContact
  group('_deleteContact Tests', () {
    testWidgets('deletes a contact', (WidgetTester tester) async {
      // Mock initial contacts
      when(mockCollection.find(any)).thenAnswer((_) async => [
        {'name': 'Alice', 'phone': '+91 9876543210'},
      ] as Answering<Stream<Map<String, dynamic>>>);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap the menu and select Delete
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Verify the contact is removed and a SnackBar is shown
      expect(find.text('Alice'), findsNothing);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Contact deleted'), findsOneWidget);
    });
  });

  // Test Group for Refresh Functionality
  group('Refresh Functionality Tests', () {
    testWidgets('refreshes contacts when refresh button is tapped', (WidgetTester tester) async {
      // Mock initial contacts
      when(mockCollection.find(any)).thenAnswer((_) async => [
        {'name': 'Alice', 'phone': '+91 9876543210'},
      ] as Answering<Stream<Map<String, dynamic>>>);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Mock updated contacts after refresh
      when(mockCollection.find(any)).thenAnswer((_) async => [
        {'name': 'Bob', 'phone': '+91 9123456789'},
      ] as Answering<Stream<Map<String, dynamic>>>);

      // Tap the refresh button
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      // Verify the updated contacts are displayed
      expect(find.text('Alice'), findsNothing);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('+91 9123456789'), findsOneWidget);
    });
  });
}