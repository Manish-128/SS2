import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/location_service.dart';

class ShareLocationNew extends StatefulWidget {
  const ShareLocationNew({super.key});

  @override
  State<ShareLocationNew> createState() => _ShareLocationNewState();
}

class _ShareLocationNewState extends State<ShareLocationNew> {
  final LocationService _locationService = LocationService();
  bool isSharing = false;
  String shareId = "";
  String fireId = "";

  @override
  void initState() {
    super.initState();
    checkIsSharing();
  }

  Future<void> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fireId = prefs.getString('fireId') ?? "";
      print("FireID in setState: $fireId");
    });
  }

  Future<void> checkIsSharing() async{
    await _getUserData();
    try{
      print("fireId: $fireId");
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(fireId)
          .get();

      if(userDoc['myTrackId'] != "0"){
        setState(() {
          isSharing = true;
          shareId = userDoc['myTrackId'] ?? "";
        });
      }
    }catch(e){
      print("Is sharing error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // warm background
      appBar: AppBar(
        title: Text('Shield Sister' , style: GoogleFonts.openSans(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.pinkAccent
        ),),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ActionButton(
              label: 'Share Location',
              icon: Icons.location_on,
              color: const Color(0xFF009688), // green
              onPressed: () async {
                try {
                  String id = await _locationService.startSharing();
                  setState(() {
                    shareId = id;
                    isSharing = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Location is shared'),
                        backgroundColor: Colors.black87,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      )
                  );
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
              },
            ),
            const SizedBox(height: 20),
            if(isSharing)
              ActionButton(
                label: 'Stop Sharing',
                icon: Icons.stop_circle,
                color: const Color(0xFFEF5350), // red
                onPressed: () async{
                  try {
                    checkIsSharing();
                    print("Share ID: $shareId");
                    await _locationService.stopSharing(shareId);
                    setState(() {
                      shareId = "";
                      isSharing = false;
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error stopping location sharing: $e'),
                        backgroundColor: Colors.black87,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        backgroundColor: color,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
      ),
      icon: Icon(icon, size: 24),
      label: Text(label),
      onPressed: onPressed,
    );
  }
}
