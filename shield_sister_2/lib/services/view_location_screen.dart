

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewLocationScreen extends StatefulWidget {
  final String trackingId;
  bool isSOS;
  final String SOSCode;
  ViewLocationScreen({required this.trackingId, required this.isSOS, required this.SOSCode, Key? key}) : super(key: key);

  @override
  _ViewLocationScreenState createState() => _ViewLocationScreenState();
}

class _ViewLocationScreenState extends State<ViewLocationScreen> {
  GoogleMapController? _mapController;
  LatLng? currentLocation;

  Stream<DocumentSnapshot> getLiveLocationStream() {
    return FirebaseFirestore.instance
        .collection('live_locations')
        .doc(widget.trackingId)
        .snapshots();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  void dispose() {
    _mapController?.dispose();
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
              // Map with loading/error states
              StreamBuilder<DocumentSnapshot>(
                stream: getLiveLocationStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
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
                    );
                  }

                  if (!snapshot.hasData || snapshot.data?.data() == null) {
                    return Center(
                      child: Container(
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
                            Icon(Icons.error_outline, color: Colors.black, size: 48),
                            SizedBox(height: 16),
                            Text(
                              "No location data available",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  var data = snapshot.data!.data() as Map<String, dynamic>;
                  double latitude = data['latitude'];
                  double longitude = data['longitude'];
                  currentLocation = LatLng(latitude, longitude);

                  if (_mapController != null) {
                    _mapController!.animateCamera(
                      CameraUpdate.newLatLng(currentLocation!),
                    );
                  }

                  return GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: currentLocation!,
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId("trackedUser"),
                        position: currentLocation!,
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
                      ),
                    },
                    myLocationButtonEnabled: true,
                    mapType: MapType.normal,
                    compassEnabled: true,
                  );
                },
              ),

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

              // Custom AppBar-like header
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Tracking: ${widget.trackingId}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if(widget.isSOS)
                              Text("SOS code: ${widget.SOSCode}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )
                          ],
                        )
                      ),
                    ],
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