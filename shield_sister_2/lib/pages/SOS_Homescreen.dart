
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../new_pages/newhelplinepage.dart';
import '../services/location_service.dart';
import '/backend/Authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shield_sister_2/new_pages/ShareLocationNew.dart';
import 'package:shield_sister_2/new_pages/Tracker.dart';
import 'package:shield_sister_2/screens/webSocket.dart';
import '../new_pages/Code_Entry.dart';
import '../new_pages/FakeCall.dart';
import 'dart:math';
class SOSHomescreen extends StatefulWidget {
  const SOSHomescreen({super.key});

  @override
  State<SOSHomescreen> createState() => _SOSHomescreenState();
}

class _SOSHomescreenState extends State<SOSHomescreen> {
  final AuthService authService = AuthService();
  String userId = "";
  bool _isLoading = false;
  String fireId = "";
  final LocationService _locationService = LocationService();
  String shareId = "";

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? "";
      fireId = prefs.getString('fireId') ?? "";
      print("In Shared Prefs the profile number is ${prefs.getString('profileNumber')}");
    });
  }

  void _showMessage(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.black87 : Colors.grey.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<Position?> _getCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw 'Location services are disabled. Please enable them in settings.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied. Enable them manually.';
      }

      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      _showMessage(context, e.toString(), isError: true);
      return null;
    }
  }

  String _generateRandomCode() {
    final random = Random();
    const String digits = '0123456789';
    return String.fromCharCodes(
      Iterable.generate(4, (_) => digits.codeUnitAt(random.nextInt(digits.length))),
    );
  }

  Future<void> checkExistingSOS() async{
    final prefs = await SharedPreferences.getInstance();
    final sosExist = prefs.getString('isSOSPresent');
    if(sosExist == "true"){
      final sosCode = prefs.getString('SOSCode') ?? "";
      print("Existing SOS code: $sosCode");
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CodeEntryScreen(senderId: fireId, expectedCode: sosCode),
          ),
        );
      }
    }else{
      _sendSOS(context);
    }
  }

  void _sendSOS(BuildContext context) async {
    setState(() => _isLoading = true);
    Position? position = await _getCurrentLocation();
    if (position == null) {
      setState(() => _isLoading = false);
      return;
    }

    // Implementing the firebase's SOS

    String sosCode = _generateRandomCode();
    print('Generated SOS code: $sosCode');

    try {
      String id = await _locationService.startSharing();
      setState(() {
        shareId = id;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error starting location sharing: $e'),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }

    // Update sender's document with SOS details
    print("Changing sos parameters for docID: $fireId");
    await FirebaseFirestore.instance.collection('users').doc(fireId).update({
      'isSharingSOS': true,
      'sosCode': sosCode,
      'sosActive': true,
    });

    print("Updated SOS parameters");
    DocumentSnapshot senderDoc = await FirebaseFirestore.instance.collection('users').doc(fireId).get();
    print("Document found in firestore");
    List<dynamic>? friendsData = senderDoc['friends'];
    if (friendsData != null) {
      print('Notifying friends: $friendsData');
      // Add logic to send notifications (e.g., SMS or FCM) to friends' phone numbers
    }else{
      print("No Friends found");
    }


    final result = await authService.sendSOS(
      userId,
      position.latitude.toString(),
      position.longitude.toString(),
      sosCode,
    );

    setState(() => _isLoading = false);
    if (result['message'] == 'SOS processed!') {
      _showMessage(context, 'The S.O.S alert was sent successfully.');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('SOSCode', sosCode);
      await prefs.setString('isSOSPresent', "true");
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CodeEntryScreen(senderId: fireId, expectedCode: sosCode),
          ),
        );
      }
    } else {
      _showMessage(context, result['message'] ?? 'Failed to send S.O.S alert', isError: true);
    }
  }

  Future<void> _makeCall(String number) async {
    Uri dialerUri = Uri(scheme: 'tel', path: number);
    try {
      if (!await launchUrl(dialerUri)) throw 'Could not launch $number';
    } catch (e) {
      _showMessage(context, 'Error opening the dialer: $e', isError: true);
    }
  }


  void CommunityAlert() {

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebSocketPage(),
        ),
      );
    }

  }


  Future<void> scheduleFakeCall(BuildContext context, Duration delay) async {
    await Future.delayed(delay);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FakeCallScreen()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shield Sisters",
          style: GoogleFonts.openSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6F61)
          ),
        ),

      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade100],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: -50,
                left: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ),
              ),
              Positioned(
                bottom: -80,
                right: -80,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Column(
                      children: [
                        Text(
                          "Emergency Help?",
                          style: GoogleFonts.openSans(
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.bold,
                            fontSize: 34,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Alert loved ones and authorities\nwith live tracking",
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            height: 1.5,
                            color: Color(0xFF757575),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: GestureDetector(
                        onTap: () => checkExistingSOS(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.redAccent,
                              child: Text(
                                "SOS",
                                style: GoogleFonts.poppins(
                                  fontSize: 56,
                                  color: Colors.white,
                                  letterSpacing: 6,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0, left: 12.0, right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildActionButton(
                          'assets/icons/friends3.png',
                          "Friends",
                              () {
                            Navigator.pushNamed(context, '/friends');
                          },
                        ),
                        buildActionButton(
                          'assets/icons/helpingHand3.png',
                          "Requests",
                              () {
                            Navigator.pushNamed(context, '/requests');
                          },
                        ),
                        buildActionButton(
                          'assets/icons/notifications2.png',
                          "Notification",
                              () => Navigator.pushNamed(context, "/notifi"),
                        ),
                        buildActionButton(
                          'assets/icons/placeholder.png',
                          "Track Me",
                              () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ShareLocationNew()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0, left: 12.0, right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildActionButton(
                          'assets/icons/raiseHands.png',
                          "Community",
                              (){
                            CommunityAlert();
                          },
                        ),
                        buildActionButton(
                          'assets/icons/fakecall.png',
                          "Fake Call",
                              (){
                            scheduleFakeCall(context, Duration(seconds: 2));
                          },
                        ),
                        buildActionButton(
                          'assets/icons/call.png',
                          "HelpLine",
                              () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => newHelplinePage()),
                          ),
                        ),
                        buildActionButton(
                          'assets/icons/helpingHand2.png',
                          "View Loc",
                              () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Tracker()),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              if (_isLoading)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildActionButton(String iconPath, String label, VoidCallback callback) {
    return Column(
      children: [
        GestureDetector(
          onTap: callback,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset(
              iconPath,
              width: 44,  // Adjust size as needed
              height: 44,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}