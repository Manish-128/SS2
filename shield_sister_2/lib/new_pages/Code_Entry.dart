// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class CodeEntryScreen extends StatefulWidget {
//   final String expectedCode;
//   final String senderId;
//   const CodeEntryScreen({super.key, required this.expectedCode, required this.senderId});
//
//   @override
//   State<CodeEntryScreen> createState() => _CodeEntryScreenState();
// }
//
// class _CodeEntryScreenState extends State<CodeEntryScreen> {
//   final TextEditingController _codeController = TextEditingController();
//   bool _isLoading = false;
//   String userId = "";
//   String fireId = "";
//   Future<void> _getUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userId = prefs.getString('userId') ?? "";
//       fireId = prefs.getString('fireId') ?? "";
//     });
//   }
//
//   void _verifyCode() async {
//     _getUserData();
//     setState(() => _isLoading = true);
//     String enteredCode = _codeController.text.trim();
//
//     // String expectedCode = senderDoc['sosCode'] ?? '';
//     print("Expected Code is ${widget.expectedCode}");
//     if (enteredCode == widget.expectedCode) {
//       await FirebaseFirestore.instance.collection('users').doc(fireId).update({
//         'sosActive': false,
//         'isSharingSOS': false,
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Code verified, SOS stopped!')),
//       );
//       Navigator.pop(context);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Incorrect code.'), backgroundColor: Colors.red),
//       );
//     }
//     setState(() => _isLoading = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Enter Verification Code'),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Enter the 4-digit code received by your SOS contact:',
//               style: TextStyle(fontSize: 18, color: Colors.black87),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _codeController,
//               keyboardType: TextInputType.number,
//               maxLength: 4,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Enter Code',
//                 counterText: '', // Hides character counter
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _isLoading ? null : _verifyCode,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.redAccent,
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//               ),
//               child: _isLoading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Text('Verify', style: TextStyle(fontSize: 18, color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _codeController.dispose();
//     super.dispose();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/location_service.dart';

class CodeEntryScreen extends StatefulWidget {
  final String senderId;
  final String expectedCode;

  const CodeEntryScreen({super.key, required this.senderId, required this.expectedCode});

  @override
  State<CodeEntryScreen> createState() => _CodeEntryScreenState();
}

class _CodeEntryScreenState extends State<CodeEntryScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  final LocationService _locationService = LocationService();
  String shareId = "";
  String fireId = "";

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fireId = prefs.getString('fireId') ?? "";
    });
  }

  Future<void> fetchShareId() async{
    if (fireId.isEmpty) {
      await _getUserData();
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(fireId)
        .get();

    print("Share ID in userDoc: ${userDoc['myTrackId']}");

    if(userDoc['myTrackId'] != ""){
      setState(() {
        shareId = userDoc['myTrackId'];
      });
    }
  }

  void _verifyCode() async {
    setState(() => _isLoading = true);
    String enteredCode = _codeController.text.trim();

    try {

      String expectedCode = widget.expectedCode;
      if (enteredCode == expectedCode) {
        await FirebaseFirestore.instance.collection('users').doc(widget.senderId).update({
          'sosActive': false,
          'isSharingSOS': false,
          'sosCode': 0,
        });
        try {
          await fetchShareId();
          print("Share ID: $shareId");
          await _locationService.stopSharing(shareId);
          setState(() {
            shareId = "";
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Code verified, SOS stopped!')),
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("SOSCode", "0000");
        await prefs.setString("isSOSPresent", "false");

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect code.'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print('Error verifying code: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Verification Code'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter the 4-digit code received for your friend\'s SOS:',
              style: TextStyle(fontSize: 18, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Code',
                counterText: '',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Verify', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}