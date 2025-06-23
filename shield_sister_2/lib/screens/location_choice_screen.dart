
import 'package:flutter/material.dart';
import '../services/share_location_screen.dart'; // Adjust path as needed
import '../services/view_location_screen.dart';   // Adjust path as needed

class LocationChoiceScreen extends StatefulWidget {
  @override
  _LocationChoiceScreenState createState() => _LocationChoiceScreenState();
}

class _LocationChoiceScreenState extends State<LocationChoiceScreen> {
  final TextEditingController _trackingIdController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _trackingIdController.addListener(() {
      setState(() {
        _isButtonEnabled = _trackingIdController.text.isNotEmpty;
      });
    });
  }

  void openViewScreen() {
    if (_trackingIdController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewLocationScreen(
            trackingId: _trackingIdController.text.trim(),
            isSOS: false,
            SOSCode: "0000",
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a Tracking ID'),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  void dispose() {
    _trackingIdController.dispose();
    super.dispose();
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
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                          'Location Hub',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.grey.withOpacity(0.5),
                                offset: Offset(2, 2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40),

                        // Card container
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Share Location Button
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShareLocationScreen(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 8,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.share_location, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'Share My Location',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24),

                              // Tracking ID Input
                              TextField(
                                controller: _trackingIdController,
                                decoration: InputDecoration(
                                  labelText: 'Enter Tracking ID',
                                  labelStyle: TextStyle(color: Colors.grey.shade600),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.black,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                style: TextStyle(color: Colors.black),
                                cursorColor: Colors.black,
                              ),
                              SizedBox(height: 24),

                              // Track Location Button
                              ElevatedButton(
                                onPressed: _isButtonEnabled ? openViewScreen : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 8,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.location_searching, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'Track Location',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}