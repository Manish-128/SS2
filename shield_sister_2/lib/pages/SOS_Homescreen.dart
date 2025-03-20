import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '/backend/Authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/location_choice_screen.dart';
import 'package:shield_sister_2/screens/ViewTrack2.dart';

class SOSHomescreen extends StatefulWidget {
  const SOSHomescreen({super.key});

  @override
  State<SOSHomescreen> createState() => SOSHomescreenState();
}

class SOSHomescreenState extends State<SOSHomescreen> {
  final AuthService authService = AuthService();
  String userId = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? "";
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

  Future<Position?> getCurrentLocation() async {
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

  void _sendSOS(BuildContext context) async {
    setState(() => _isLoading = true);
    Position? position = await getCurrentLocation();
    if (position == null) {
      setState(() => _isLoading = false);
      return;
    }

    final result = await authService.sendSOS(
      userId,
      position.latitude.toString(),
      position.longitude.toString(),
    );

    setState(() => _isLoading = false);
    if (result['message'] == 'SOS sent successfully') {
      _showMessage(context, 'The S.O.S alert was sent successfully.');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Decorative background elements
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

              // Main content
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute content vertically
                children: [
                  // Header Section
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Column(
                      children: [
                        Text(
                          "Emergency Help?",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.grey.withOpacity(0.5),
                                offset: const Offset(2, 2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Alert loved ones and authorities\nwith live tracking",
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  TextButton(onPressed: (){}, child: Text("jhbdcbh"),),

                  // SOS Button (Centered)
                  Expanded(
                    child: Center(
                      child: GestureDetector(
                        onTap: () => _sendSOS(context),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.redAccent,
                            child: Text(
                              "S.O.S",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0, left: 12.0, right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        buildActionButton(
                          Icons.local_police,
                          "Police",
                              () => _makeCall('100'),
                        ),
                        buildActionButton(
                          Icons.phone,
                          "Home",
                              () => _makeCall('your_home_number'), // Replace with actual number
                        ),
                        buildActionButton(
                          Icons.support_agent,
                          "Helpline",
                              () => Navigator.pushNamed(context, "/helpline"),
                        ),
                        buildActionButton(
                          Icons.location_on,
                          "Track",
                              () => Navigator.push(
                            context,  //TODO: Change this later
                              // MaterialPageRoute(builder: (context) =>  ViewTrack2()),

                            MaterialPageRoute(builder: (context) =>  LocationChoiceScreen()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Loading indicator
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

  Widget buildActionButton(IconData icon, String label, VoidCallback callback) {
    return Column(
      children: [
        GestureDetector(
          onTap: callback,
          child: Container(
            padding: const EdgeInsets.all(16),
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
            child: Icon(
              icon,
              size: 32,
              color: Colors.red,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}