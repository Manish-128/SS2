// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
// import 'package:flutter/material.dart';
//
// class FakeCallScreen extends StatefulWidget {
//   @override
//   _FakeCallScreenState createState() => _FakeCallScreenState();
// }
//
// class _FakeCallScreenState extends State<FakeCallScreen> {
//   final FlutterRingtonePlayer _ringtonePlayer = FlutterRingtonePlayer();
//
//   @override
//   void initState() {
//     super.initState();
//     try {
//       FlutterRingtonePlayer().play(
//         android: AndroidSounds.ringtone,
//         ios: IosSounds.glass,
//         looping: true,
//         volume: 1.0,
//         asAlarm: false,
//       );
//       print('System ringtone play initiated');
//     } catch (e) {
//       print('Error playing system ringtone: $e');
//     }
//   }
//
//   @override
//   void dispose() {
//     FlutterRingtonePlayer().stop();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green.shade900,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Incoming Call',
//               style: TextStyle(color: Colors.white, fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             CircleAvatar(
//               radius: 50,
//               backgroundImage: AssetImage('assets/fake_caller.jpg'),
//             ),
//             SizedBox(height: 10),
//             Text(
//               'ACP Pradyuman',
//               style: TextStyle(color: Colors.white, fontSize: 30),
//             ),
//             SizedBox(height: 30),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 FloatingActionButton(
//                   heroTag: 'end_call_${UniqueKey().toString()}',
//                   backgroundColor: Colors.red,
//                   child: Icon(Icons.call_end),
//                   onPressed: () {
//                     FlutterRingtonePlayer().stop();
//                     Navigator.pop(context);
//                   },
//                 ),
//                 FloatingActionButton( // Fixed typo from 'Floating نمActionButton'
//                   heroTag: 'accept_call_${UniqueKey().toString()}',
//                   backgroundColor: Colors.green,
//                   child: Icon(Icons.call),
//                   onPressed: () {
//                     FlutterRingtonePlayer().stop();
//                     Navigator.pop(context);
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// Future<void> scheduleFakeCall(BuildContext context, Duration delay) async {
//   await Future.delayed(delay);
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => FakeCallScreen()),
//   );
// }

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter/material.dart';

class FakeCallScreen extends StatefulWidget {
  @override
  _FakeCallScreenState createState() => _FakeCallScreenState();
}

class _FakeCallScreenState extends State<FakeCallScreen> {
  final FlutterRingtonePlayer _ringtonePlayer = FlutterRingtonePlayer();
  bool _isCallActive = false; // Track call state

  @override
  void initState() {
    super.initState();
    try {
      FlutterRingtonePlayer().play(
        android: AndroidSounds.ringtone,
        ios: IosSounds.glass,
        looping: true,
        volume: 1.0,
        asAlarm: false,
      );
      print('System ringtone play initiated');
    } catch (e) {
      print('Error playing system ringtone: $e');
    }
  }

  @override
  void dispose() {
    FlutterRingtonePlayer().stop();
    super.dispose();
  }

  void _acceptCall() {
    setState(() {
      _isCallActive = true; // Switch to active call state
    });
    FlutterRingtonePlayer().stop(); // Stop ringtone
  }

  void _endCall() {
    FlutterRingtonePlayer().stop();
    Navigator.pop(context); // End call and go back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _isCallActive ? _buildActiveCallScreen() : _buildIncomingCallScreen(),
      ),
    );
  }

  Widget _buildIncomingCallScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Incoming Call',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        SizedBox(height: 20),
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/icons/profile.png'),
        ),
        SizedBox(height: 10),
        Text(
          'Mahila Helpline 📞',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              heroTag: 'end_call_${UniqueKey().toString()}',
              backgroundColor: Colors.red,
              child: Icon(Icons.call_end),
              onPressed: _endCall,
            ),
            FloatingActionButton(
              heroTag: 'accept_call_${UniqueKey().toString()}',
              backgroundColor: Colors.green,
              child: Icon(Icons.call),
              onPressed: _acceptCall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveCallScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Call in Progress',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        SizedBox(height: 20),
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/icons/profile1.png'),
        ),
        SizedBox(height: 10),
        Text(
          'Mahila Helpline 📞',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        SizedBox(height: 10),
        Text(
          '00:15', // Simulated call timer
          style: TextStyle(color: Colors.white70, fontSize: 20),
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: 'mute_${UniqueKey().toString()}',
              backgroundColor: Colors.grey,
              child: Icon(Icons.mic_off),
              onPressed: () {
                // Add mute functionality if needed
              },
            ),
            SizedBox(width: 20),
            FloatingActionButton(
              heroTag: 'end_call_${UniqueKey().toString()}',
              backgroundColor: Colors.red,
              child: Icon(Icons.call_end),
              onPressed: _endCall,
            ),
            SizedBox(width: 20),
            FloatingActionButton(
              heroTag: 'speaker_${UniqueKey().toString()}',
              backgroundColor: Colors.grey,
              child: Icon(Icons.volume_up),
              onPressed: () {
                // Add speaker functionality if needed
              },
            ),
          ],
        ),
      ],
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