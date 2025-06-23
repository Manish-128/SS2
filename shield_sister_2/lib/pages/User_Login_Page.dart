
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/Authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({Key? key}) : super(key: key);

  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  int img_ind = 0;

  Future<void> NecessaryDetails(String fireIDs) async{
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(fireIDs)
        .get();

    setState(() {
      img_ind = userDoc['myProf'] ?? 0;
    });
  }

  Future<String?> getUserIdByemail(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1) // optional, in case you expect only one match
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      print("User Id to be searched for email: $email is ${querySnapshot.docs.first.id}");
      return querySnapshot.docs.first.id; // <-- document ID
    } else {
      return null; // Not found
    }
  }


  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email and Password cannot be empty'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await authService.login(email, password);

      print("Message for login: ${result['message']}");

      if (result.containsKey('message') && result['message'] == 'Login successful') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', result['user']['_id']);
        await prefs.setString('jwtToken', result['token']);
        await prefs.setString('username', result['user']['fullname']);
        await prefs.setString('phone', result['user']['phone'] ?? '');
        await prefs.setString('address', result['user']['address'] ?? '');
        await prefs.setString('email', result['user']['email']);
        String? fireId = await getUserIdByemail(result['user']['email']);
        await prefs.setString('fireId', fireId!);
        await NecessaryDetails(fireId);
        await prefs.setString('profileNumber', img_ind.toString());


        Navigator.pushReplacementNamed(context, '/bot');
      } else {
        print("result[message][error]: ${result['message']['error']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']['error'] ?? 'Unknown error occurred'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome Back!',
                  style: GoogleFonts.openSans(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00695C),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Login to continue',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.teal.shade300,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email, color: Color(0xFFFF6F61)),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock, color: Color(0xFFFF6F61)),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFAAF0D1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: GoogleFonts.poppins(
                      color: Color(0xFF00695C),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: GoogleFonts.poppins()),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/reg'),
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Color(0xFF00695C)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/forget'),
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Color(0xFF00695C)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
