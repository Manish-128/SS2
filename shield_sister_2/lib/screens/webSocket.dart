//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// class WebSocketPage extends StatefulWidget {
//   const WebSocketPage({super.key});
//
//   @override
//   State<WebSocketPage> createState() => _WebSocketPageState();
// }
//
// class _WebSocketPageState extends State<WebSocketPage> {
//   late GoogleMapController _mapController;
//   Position? currentPosition;
//   String fireId = '';
//   String status = 'Not connected';
//   late IO.Socket socket;
//   String userName = '';
//   final Set<Marker> _sosMarkers = {};
//   Timer? _retryTimer;
//
//   @override
//   void initState() {
//     super.initState();
//     _requestPermissions();
//     _getUserData();
//   }
//
//   @override
//   void dispose() {
//     // Cancel retry timer
//     _retryTimer?.cancel();
//     // Clean up socket listeners and disconnect
//     socket.off('connect');
//     socket.off('receive_alert');
//     socket.off('disconnect');
//     socket.off('error');
//     socket.disconnect();
//     socket.dispose();
//     // Dispose map controller
//     _mapController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _getUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (!mounted) return;
//     setState(() {
//       fireId = prefs.getString('fireId') ?? 'default_user_id';
//       userName = prefs.getString('email') ?? 'Unknown';
//       debugPrint('📋 User Data: fireId=$fireId, userName=$userName');
//     });
//   }
//
//   Future<void> _requestPermissions() async {
//     await Permission.location.request();
//     await Permission.notification.request();
//     await _getLocation();
//     if (!mounted) return;
//     if (currentPosition != null) {
//       _connectToSocket();
//     } else {
//       debugPrint('❌ Location not available. Retrying...');
//       _retryTimer = Timer(const Duration(seconds: 2), () {
//         if (mounted) _requestPermissions();
//       });
//     }
//   }
//
//   Future<void> _getLocation() async {
//     try {
//       currentPosition = await Geolocator.getCurrentPosition();
//       debugPrint('📍 Location: Lat=${currentPosition?.latitude}, Lon=${currentPosition?.longitude}');
//       if (!mounted) return;
//       setState(() {});
//       if (currentPosition != null && mounted) {
//         _mapController.animateCamera(
//           CameraUpdate.newLatLng(
//             LatLng(currentPosition!.latitude, currentPosition!.longitude),
//           ),
//         );
//       }
//     } catch (e) {
//       debugPrint('Error getting location: $e');
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to get location: $e')),
//       );
//     }
//   }
//
//   void _connectToSocket() {
//     socket = IO.io('https://websocket-for-shield-sister.onrender.com', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//     });
//
//     socket.connect();
//
//     socket.onConnect((_) {
//       if (!mounted) return;
//       setState(() => status = 'Connected');
//       debugPrint('✅ Socket Connected');
//       socket.emit('register', {
//         'userId': fireId,
//         'lat': currentPosition?.latitude,
//         'lon': currentPosition?.longitude,
//         'name': userName,
//       });
//       debugPrint('📤 Emitted register: userId=$fireId, lat=${currentPosition?.latitude}, lon=${currentPosition?.longitude}, name=$userName');
//     });
//
//     socket.on('receive_alert', (data) {
//       debugPrint('📥 Received alert: $data');
//       final double? lat = double.tryParse(data['lat'].toString());
//       final double? lon = double.tryParse(data['lon'].toString());
//       final String message = data['message']?.toString() ?? 'SOS Alert';
//       final String from = data['name']?.toString() ?? data['from']?.toString() ?? 'Unknown';
//
//       if (lat == null || lon == null) {
//         debugPrint('❌ Invalid lat/lon in alert: $data');
//         return;
//       }
//
//       final marker = Marker(
//         markerId: MarkerId('sos_${DateTime.now().toIso8601String()}'),
//         position: LatLng(lat, lon),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         infoWindow: InfoWindow(
//           title: '🚨 $message',
//           snippet: 'From: $from',
//         ),
//       );
//
//       if (!mounted) return;
//       setState(() {
//         _sosMarkers.add(marker);
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('New SOS received from $from: $message')),
//       );
//     });
//
//     socket.onDisconnect((_) {
//       if (!mounted) return;
//       setState(() => status = 'Disconnected');
//       debugPrint('❌ Socket Disconnected');
//     });
//
//     socket.onError((error) {
//       debugPrint('❌ Socket Error: $error');
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Connection error: $error')),
//       );
//     });
//   }
//
//   Future<void> _sendAlert() async {
//     if (currentPosition == null) {
//       debugPrint('❌ Cannot send alert: No location available');
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Cannot send SOS: Location unavailable')),
//       );
//       return;
//     }
//
//     final TextEditingController controller = TextEditingController();
//     final String? message = await showDialog<String>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Send SOS'),
//         content: TextField(
//           controller: controller,
//           decoration: const InputDecoration(
//             hintText: 'E.g., Help, Chain Snatching, Emergency',
//             labelText: 'Describe your emergency',
//           ),
//           style: GoogleFonts.poppins(),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Cancel', style: GoogleFonts.poppins()),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, controller.text.trim()),
//             child: Text('Send', style: GoogleFonts.poppins()),
//           ),
//         ],
//       ),
//     );
//
//     if (message == null || message.isEmpty) {
//       debugPrint('❌ Alert canceled or empty message');
//       return;
//     }
//
//     final alertData = {
//       'userId': fireId,
//       'lat': currentPosition!.latitude,
//       'lon': currentPosition!.longitude,
//       'message': message,
//       'name': userName,
//     };
//
//     socket.emit('send_alert', alertData);
//     debugPrint('📤 Emitted send_alert: $alertData');
//
//     final marker = Marker(
//       markerId: MarkerId('my_alert_${DateTime.now().toIso8601String()}'),
//       position: LatLng(currentPosition!.latitude, currentPosition!.longitude),
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//       infoWindow: InfoWindow(
//         title: '📤 Your SOS',
//         snippet: message,
//       ),
//     );
//
//     if (!mounted) return;
//     setState(() {
//       _sosMarkers.add(marker);
//     });
//
//     // Haptic feedback for SOS
//     HapticFeedback.vibrate();
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('SOS sent: $message')),
//     );
//   }
//
//   void _stopAlert() {
//     socket.emit('stop_alert', {'userId': fireId});
//     debugPrint('📤 Emitted stop_alert: userId=$fireId');
//     if (!mounted) return;
//     setState(() {
//       _sosMarkers.removeWhere((marker) => marker.markerId.value.contains('my_alert'));
//     });
//     HapticFeedback.lightImpact();
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('SOS stopped')),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Google Map
//           currentPosition == null
//               ? Center(child: CircularProgressIndicator(color: Colors.pink.shade300))
//               : GoogleMap(
//             onMapCreated: (controller) {
//               _mapController = controller;
//               if (currentPosition != null) {
//                 _mapController.animateCamera(
//                   CameraUpdate.newLatLng(
//                     LatLng(currentPosition!.latitude, currentPosition!.longitude),
//                   ),
//                 );
//               }
//             },
//             initialCameraPosition: CameraPosition(
//               target: currentPosition != null
//                   ? LatLng(currentPosition!.latitude, currentPosition!.longitude)
//                   : const LatLng(0, 0),
//               zoom: 15,
//             ),
//             markers: _sosMarkers,
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//           ),
//           // Status Bar
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.pink.shade300, Colors.purple.shade300],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: SafeArea(
//                 child: Row(
//                   children: [
//                     Icon(
//                       status == 'Connected' ? Icons.check_circle : Icons.error_outline,
//                       color: status == 'Connected' ? Colors.green.shade400 : Colors.red.shade400,
//                       size: 28,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         status == 'Connected' ? 'Safe & Connected' : 'Disconnected',
//                         style: GoogleFonts.poppins(
//                           color: Colors.white,
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           // Control Panel
//           Positioned(
//             bottom: 100,
//             left: 20,
//             right: 20,
//             child: Card(
//               elevation: 10,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.purple.shade200,
//                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       ),
//                       onPressed: _requestPermissions,
//                       child: Row(
//                         children: [
//                           const Icon(Icons.link, size: 20),
//                           const SizedBox(width: 8),
//                           Text('Connect', style: GoogleFonts.poppins(fontSize: 16)),
//                         ],
//                       ),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey.shade300,
//                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       ),
//                       onPressed: _stopAlert,
//                       child: Row(
//                         children: [
//                           const Icon(Icons.cancel, size: 20),
//                           const SizedBox(width: 8),
//                           Text('Stop SOS', style: GoogleFonts.poppins(fontSize: 16)),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _sendAlert,
//         backgroundColor: Colors.redAccent,
//         elevation: 10,
//         icon: const Icon(Icons.sos, size: 30),
//         label: Text(
//           'SEND SOS',
//           style: GoogleFonts.poppins(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketPage extends StatefulWidget {
  const WebSocketPage({super.key});

  @override
  State<WebSocketPage> createState() => _WebSocketPageState();
}

class _WebSocketPageState extends State<WebSocketPage> {
  late GoogleMapController _mapController;
  Position? currentPosition;
  String fireId = '';
  String status = 'Not connected';
  late IO.Socket socket;
  String userName = '';
  final Set<Marker> _sosMarkers = {};
  Timer? _retryTimer;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _getUserData();
    await _handlePermissions();
  }

  Future<void> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fireId = prefs.getString('fireId') ?? 'default_user_id';
    userName = prefs.getString('email') ?? 'Unknown';
    debugPrint('📋 User Data: fireId=$fireId, userName=$userName');
  }

  Future<void> _handlePermissions() async {
    final locationStatus = await Permission.locationWhenInUse.request();
    final notificationStatus = await Permission.notification.request();

    if (locationStatus.isGranted) {
      await _getLocation();
      if (currentPosition != null) {
        _connectToSocket();
      } else {
        debugPrint('❌ Location not fetched, retrying...');
        _retryTimer = Timer(const Duration(seconds: 2), _handlePermissions);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required to use SOS')),
      );
    }
  }

  Future<void> _getLocation() async {
    try {
      currentPosition = await Geolocator.getCurrentPosition();
      debugPrint('📍 Location: Lat=${currentPosition?.latitude}, Lon=${currentPosition?.longitude}');
      setState(() {});
      if (currentPosition != null) {
        _mapController.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(currentPosition!.latitude, currentPosition!.longitude),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
    }
  }

  void _connectToSocket() {
    socket = IO.io('https://websocket-for-shield-sister.onrender.com', {
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      setState(() => status = 'Connected');
      debugPrint('✅ Connected to socket');

      socket.emit('register', {
        'userId': fireId,
        'lat': currentPosition?.latitude,
        'lon': currentPosition?.longitude,
        'name': userName,
      });
    });

    socket
      ..on('receive_alert', _handleReceiveAlert)
      ..onDisconnect((_) {
        setState(() => status = 'Disconnected');
        debugPrint('❌ Disconnected');
      })
      ..onError((error) {
        debugPrint('❌ Socket error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection error: $error')),
        );
      });
  }

  void _handleReceiveAlert(dynamic data) {
    final double? lat = double.tryParse(data['lat'].toString());
    final double? lon = double.tryParse(data['lon'].toString());
    final String message = data['message']?.toString() ?? 'SOS Alert';
    final String from = data['name']?.toString() ?? data['from']?.toString() ?? 'Unknown';

    if (lat == null || lon == null) {
      debugPrint('❌ Invalid lat/lon in alert: $data');
      return;
    }

    final marker = Marker(
      markerId: MarkerId('sos_${DateTime.now().millisecondsSinceEpoch}'),
      position: LatLng(lat, lon),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
        title: '🚨 $message',
        snippet: 'From: $from',
      ),
    );

    setState(() => _sosMarkers.add(marker));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('🚨 SOS from $from: $message')),
    );
  }

  Future<void> _sendAlert() async {
    if (currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot send SOS: Location unavailable')),
      );
      return;
    }

    final controller = TextEditingController();
    final String? message = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send SOS'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'E.g., Help, Chain Snatching, Emergency',
            labelText: 'Describe your emergency',
          ),
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text('Send', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );

    if (message == null || message.isEmpty) return;

    final alertData = {
      'userId': fireId,
      'lat': currentPosition!.latitude,
      'lon': currentPosition!.longitude,
      'message': message,
      'name': userName,
    };

    socket.emit('send_alert', alertData);

    final marker = Marker(
      markerId: MarkerId('my_alert_${DateTime.now().millisecondsSinceEpoch}'),
      position: LatLng(currentPosition!.latitude, currentPosition!.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: InfoWindow(title: '📤 Your SOS', snippet: message),
    );

    setState(() => _sosMarkers.add(marker));

    HapticFeedback.vibrate();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('SOS sent: $message')),
    );
  }

  void _stopAlert() {
    socket.emit('stop_alert', {'userId': fireId});
    setState(() {
      _sosMarkers.removeWhere((marker) => marker.markerId.value.contains('my_alert'));
    });
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('SOS stopped')),
    );
  }

  @override
  Future<void> dispose() async{
    _retryTimer?.cancel();
    socket.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF009688)),
          onPressed: () async{
            await dispose();
            Future.delayed(Duration(seconds: 2));
            Navigator.pushReplacementNamed(context, '/bot');
          },
        ),
        title: Text('Community Alert', style: GoogleFonts.poppins(color: Color(0xFF009688))),
        backgroundColor: Color(0xFFE0F2F1),
      ),
      body: Stack(
        children: [
          currentPosition == null
              ? Center(child: CircularProgressIndicator(color: Colors.pink.shade300))
              : GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(
              target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
              zoom: 15,
            ),
            markers: _sosMarkers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink.shade300, Colors.purple.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Icon(
                      status == 'Connected' ? Icons.check_circle : Icons.error_outline,
                      color: status == 'Connected' ? Colors.green : Colors.red,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        status == 'Connected' ? 'Safe & Connected' : 'Disconnected',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade200,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _handlePermissions,
                      child: Row(
                        children: [
                          const Icon(Icons.link, size: 20),
                          const SizedBox(width: 8),
                          Text('Connect', style: GoogleFonts.poppins(fontSize: 16)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _stopAlert,
                      child: Row(
                        children: [
                          const Icon(Icons.cancel, size: 20),
                          const SizedBox(width: 8),
                          Text('Stop SOS', style: GoogleFonts.poppins(fontSize: 16)),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _sendAlert,
        backgroundColor: Colors.redAccent,
        elevation: 10,
        icon: const Icon(Icons.sos, size: 30),
        label: Text(
          'SEND SOS',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
