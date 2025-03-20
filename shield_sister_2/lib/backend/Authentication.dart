import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shield_sister_2/new_pages/Contact_Management_Page.dart';


class AuthService {
  // final String _baseUrl = "http://10.0.2.2:5000/api/sos/savecontacts";
  // final String link = "http://10.0.2.2:5000/api";
  // shield-sisters-dep-d4z8-18kdwkmex-rohits-projects-51c777d8.vercel.app
  final String _baseUrl = "https://shield-sisters-dep-d4z8-18kdwkmex-rohits-projects-51c777d8.vercel.app/api/sos/savecontacts";
  final String link = "https://shield-sisters-dep-d4z8-18kdwkmex-rohits-projects-51c777d8.vercel.app/api";

  Map<String, String> _headers() => {
        'Content-Type': 'application/json',
      };
   Future<Map<String, dynamic>> sendSOS(String userId, String latitude, String longitude) async {
    final url = Uri.parse('$link/sos/sendsos');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'latitude': latitude,
          'longitude': longitude,
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
      return {
        'message': 'An error occurred',
        'error': e.toString(),
      };
    }
  }

 
  Future<Map<String, dynamic>> register(String fullname, String email, String password) async {
    final url = Uri.parse('$link/users/signup');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullname': fullname,
          'email': email,
          'password': password,
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

      return _processResponse(response);
    } catch (e) {
      return {
        "message": "An error occurred",
        "error": e.toString(),
      };
    }
  }
  Future<Map<String, dynamic>> SaveContact(String userId, Contact contact) async {
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
    }  catch (e) {
      return {
        "message": "An error occurred",
        "error": e.toString(),
      };
    }

  }
}


Map<String, dynamic> _processResponse(http.Response response) {
    try {
      if (response.statusCode == 200) {
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

