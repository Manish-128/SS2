
import 'package:flutter/material.dart';
import '../services/location_service.dart';
import 'package:share_plus/share_plus.dart';


class ShareLocationScreen extends StatefulWidget {
  @override
  _ShareLocationScreenState createState() => _ShareLocationScreenState();
}

class _ShareLocationScreenState extends State<ShareLocationScreen> {
  final LocationService _locationService = LocationService();
  String? trackingId;
  bool _isLoading = false;

  void startSharing() async {
    setState(() => _isLoading = true);
    try {
      String id = await _locationService.startSharing();
      setState(() {
        trackingId = id;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error starting location sharing: $e'),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void stopSharing() async {
    if (trackingId != null) {
      setState(() => _isLoading = true);
      try {
        await _locationService.stopSharing(trackingId!);
        setState(() {
          trackingId = null;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error stopping location sharing: $e'),
            backgroundColor: Colors.black87,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    if (trackingId != null) {
      _locationService.stopSharing(trackingId!);
    }
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
                          'Share Location',
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
                              if (trackingId != null) ...[
                                // Tracking ID Display
                                Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.vpn_key, color: Colors.black),
                                      SizedBox(width: 8),
                                      Text(
                                        trackingId!,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24),

                                // Share Tracking Link Button
                                ElevatedButton(
                                  onPressed: () {
                                    // Implement sharing functionality here
                                    // For example: Share.share('Track my location with ID: $trackingId');
                                    Share.share('Check this out: $trackingId');
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
                                      Icon(Icons.share, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        'Share Tracking Link',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 24),

                                // Stop Sharing Button
                                ElevatedButton(
                                  onPressed: stopSharing,
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
                                      Icon(Icons.stop, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        'Stop Sharing',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ] else
                              // Start Sharing Button
                                ElevatedButton(
                                  onPressed: _isLoading ? null : startSharing,
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
                                      Icon(Icons.my_location, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        'Start Sharing Location',
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

              // Loading indicator
              if (_isLoading)
                Center(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CircularProgressIndicator(
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
}