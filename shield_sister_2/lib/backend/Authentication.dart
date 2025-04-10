import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shield_sister_2/new_pages/Contact_Management_Page.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'dart:math';

class AuthService {
  // final String _baseUrl = "http://10.0.2.2:5000/api/sos/savecontacts";
  // final String link = "http://10.0.2.2:5000/api";
  // shield-sisters-dep-d4z8-18kdwkmex-rohits-projects-51c777d8.vercel.app
  // final String _baseUrl = "https://shield-sisters-dep-d4z8-18kdwkmex-rohits-projects-51c777d8.vercel.app/api/sos/savecontacts";
  // final String link = "https://shield-sisters-dep-d4z8-18kdwkmex-rohits-projects-51c777d8.vercel.app/api";
  // final String _baseUrl2 = "https://shield-sisters-dep-d4z8.vercel.app/api/sos/sendsos";
  // final String _contactUrl = "https://shield-sisters-dep-d4z8.vercel.app/api/sos";
  final String _baseUrl = "https://shield-sisters-dep-d4z8.vercel.app/api/sos/savecontacts";
  final String link = "https://shield-sisters-dep-d4z8.vercel.app/api";
  final String _baseUrl2 = "https://shield-sisters-dep-d4z8.vercel.app/api/sos/sendsos";
  final String _contactUrl = "https://shield-sisters-dep-d4z8.vercel.app/api/sos";

  Map<String, String> _headers() =>
      {
        'Content-Type': 'application/json',
      };

  // Future<Map<String, dynamic>> sendSOS(String userId, String latitude,
  //     String longitude) async {
  //   final url = Uri.parse('$_baseUrl2');
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'userId': userId,
  //         'latitude': latitude,
  //         'longitude': longitude,
  //       }),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       return jsonDecode(response.body);
  //     } else {
  //       return {
  //         'message': 'Failed to send SOS',
  //         'details': jsonDecode(response.body),
  //       };
  //     }
  //   } catch (e) {
  //     return {
  //       'message': 'An error occurred',
  //       'error': e.toString(),
  //     };
  //   }
  // }

  Future<Map<String, dynamic>> sendSOS(String userId, String latitude, String longitude) async {
    final url = Uri.parse('$_baseUrl2');

    try {
      final battery = Battery();
      final connectivity = Connectivity();
      final deviceInfoPlugin = DeviceInfoPlugin();

      // Battery info
      int batteryLevel = await battery.batteryLevel;
      BatteryState batteryState = await battery.batteryState;

      // Connectivity
      List<ConnectivityResult> connectionResult = await connectivity.checkConnectivity();
      String connectionType = _getConnectionTypeFromList(connectionResult);

      // Charging status
      String chargingStatus = _getChargingStatus(batteryState);

      // Ringer Mode - Placeholder (platform-specific, not available by default in Flutter)
      String ringerMode = "Unavailable";

      // Device Info (optional)
      String deviceModel = "Unknown";
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        deviceModel = androidInfo.model ?? "Unknown";
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        deviceModel = iosInfo.utsname.machine ?? "Unknown";
      }

      // Timestamp
      String timestamp = DateFormat('yyyy-MM-dd – kk:mm:ss').format(DateTime.now());

      print("'userId': $userId, 'latitude': $latitude, 'longitude': $longitude, 'batteryLevel': '$batteryLevel%', 'chargingStatus': $chargingStatus,'networkStatus': $connectionType,'deviceModel': $deviceModel,'timestamp': $timestamp,'ringerMode': $ringerMode,");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'latitude': latitude,
          'longitude': longitude,
          'batteryLevel': '$batteryLevel%',
          'chargingStatus': chargingStatus,
          'networkStatus': connectionType,
          'deviceModel': deviceModel,
          'timestamp': timestamp,
          'ringerMode': ringerMode, // Optional, replace if you find platform plugin
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'message': 'Failed to send SOS',
          'details': jsonDecode(response.body),
        };
      }
    } catch (e) {
      print("Error sending sos ${e.toString()}");
      return {
        'message': 'An error occurred',
        'error': e.toString(),
      };
    }
  }

  String _getConnectionTypeFromList(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.mobile)) {
      return "Mobile Data";
    } else if (results.contains(ConnectivityResult.wifi)) {
      return "WiFi";
    } else if (results.contains(ConnectivityResult.ethernet)) {
      return "Ethernet";
    } else if (results.contains(ConnectivityResult.bluetooth)) {
      return "Bluetooth";
    } else if (results.contains(ConnectivityResult.vpn)) {
      return "VPN";
    } else if (results.contains(ConnectivityResult.none)) {
      return "No Internet";
    }
    return "Unknown";
  }

  String _getChargingStatus(BatteryState state) {
    switch (state) {
      case BatteryState.charging:
        return "Charging";
      case BatteryState.full:
        return "Full";
      case BatteryState.discharging:
      case BatteryState.unknown:
      default:
        return "Not Charging";
    }
  }


  Future<Map<String, dynamic>> register(String fullname, String email,
      String password,String phoneNumber) async {
    final url = Uri.parse('$link/users/signup');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullname': fullname,
          'email': email,
          'password': password,
          'phone' : phoneNumber,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          'message': 'Registration failed',
          'details': jsonDecode(response.body),
        };
      }
    } catch (e) {
      return {
        'message': 'An error occurred',
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    // final url = Uri.parse("$_baseUrl/user/login");
    final url = Uri.parse("$link/users/login");
    try {
      final response = await http
          .post(
        url,
        headers: _headers(),
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      )
          .timeout(const Duration(seconds: 10)); // Timeout after 10 seconds
      print(response.body);
      return _processResponse(response);
    } catch (e) {
      print(e);
      return {
        "message": "An error occurred",
        "error": e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> SaveContact(String userId,
      Contact contact) async {
    // final url = Uri.parse('$link/sos/savecontacts');
    final url = Uri.parse('$_baseUrl');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userId": userId, // Replace with the actual userId
          "contacts": [
            {
              "name": contact.name,
              "phone": contact.phone,
            }
          ],
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print("Error: ${response.statusCode}, ${response.body}");
      }
      return _processResponse(response);
    } catch (e) {
      return {
        "message": "An error occurred",
        "error": e.toString(),
      };
    }
  }


  Future<Map<String, dynamic>> updateContact(String userId, String contactId,
      String name, String phone) async {
    final url = Uri.parse('$_contactUrl/updatecontact/');
    try {
      final response = await http.post(
        url,
        headers: _headers(),
        body: jsonEncode({
          "userId": userId,
          "contactId": contactId,
          "name": name,
          "phone": phone,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error: ${response.statusCode}, ${response.body}");
        return {
          "message": "Failed to update contact",
          "details": jsonDecode(response.body),
        };
      }
    } catch (e) {
      return {
        "message": "An error occurred",
        "error": e.toString(),
      };
    }
  }

// New method: Delete Contact
  Future<Map<String, dynamic>> deleteContact(String userId,
      String contactId) async {
    final url = Uri.parse('$_contactUrl/deletecontact/');
    try {
      final response = await http.delete(
        url,
        headers: _headers(),
        body: jsonEncode({
          "userId": userId,
          "contactId": contactId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error: ${response.statusCode}, ${response.body}");
        return {
          "message": "Failed to delete contact",
          "details": jsonDecode(response.body),
        };
      }
    } catch (e) {
      return {
        "message": "An error occurred",
        "error": e.toString(),
      };
    }
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          "message": jsonDecode(response.body)['message'] ?? 'Error occurred',
        };
      }
    } catch (e) {
      // Handles cases where response is not valid JSON
      return {
        "message": "Failed to parse response",
        "error": e.toString(),
      };
    }
  }


  //TODO: Edit this for Sending OTP feature add vercel server link here !!
  Future<Map<String, dynamic>> sendOtp(String email) async {
    final res = await http.post(
      Uri.parse('https://your-vercel-app.vercel.app/api/users/forgot-password/sendotp'),
      body: jsonEncode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    final res = await http.post(
      Uri.parse('https://your-vercel-app.vercel.app/api/users/verify-otp'),
      body: jsonEncode({'email': email, 'otp': otp}),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }


  Future<Map<String, dynamic>> resetPassword(String email, String otp, String newPassword) async {
    final response = await http.post(
      Uri.parse('https://your-vercel-url/reset-password'),
      body: {'email': email, 'otp': otp, 'newPassword': newPassword},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'success': false, 'message': 'Failed to reset password'};
    }
  }


}