import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AccountSettingPage extends StatelessWidget {
  AccountSettingPage({super.key});

  // Function to handle Edit Account (Navigate to Edit Page)
  void _editAccount(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Edit Account Page')),
    );
  }

  // Function to handle Change Password
  void _changePassword(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Change Password Page')),
    );
  }

  // Function to handle Update Photo
  void _updatePhoto(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Update Profile Photo Functionality')),
    );
  }

  // Function to handle Delete Account
  void _deleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account Deleted Successfully')),
                );
              },
            ),
          ],
        );
      },
    );
  }
  String userName = "Add User";
  String userEmail = "Kindly Register";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20,40,20,0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft, // Aligns the row to the left
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 28,
                    ),
                    onPressed: () {
                      // Back navigation logic
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context); // Go back if a previous route exists
                      } else {
                        // Optionally handle when there's no previous screen
                        print("No previous screen to go back to.");
                      }
                    },
                  ),
                  const SizedBox(width: 8), // Adds spacing between the button and title
                  const Text(
                    'Account', // Title text
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),



            // Profile Photo
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage("https://img.freepik.com/premium-vector/women-beauty-face-clipart-vector-illustration_1123392-5133.jpg?semt=ais_hybrid"), // Default Image
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _updatePhoto(context),
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.camera_alt_outlined, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Account Details Section
            Text(
              userName,
              style: GoogleFonts.sourceCodePro(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Text(
              userEmail,
              style: GoogleFonts.sourceCodePro(
                fontSize: 18,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 30),
            // Buttons Section
            _buildAccountOption(
              context: context,
              icon: Icons.edit,
              title: 'Edit Account',
              color: Colors.green,
              onPressed: () => _editAccount(context),
            ),
            const SizedBox(height: 10),
            _buildAccountOption(
              context: context,
              icon: Icons.lock,
              title: 'Change Password',
              color: Colors.deepOrangeAccent,
              onPressed: () => _changePassword(context),
            ),
            const SizedBox(height: 10),
            _buildAccountOption(
              context: context,
              icon: Icons.camera_alt_outlined,
              title: 'Update Profile Photo',
              color: Colors.black,
              onPressed: () => _updatePhoto(context),
            ),
            const SizedBox(height: 10),
            _buildAccountOption(
              context: context,
              icon: Icons.delete,
              title: 'Delete Account',
              color: Colors.red,
              onPressed: () => _deleteAccount(context),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget to Build Account Options
  Widget _buildAccountOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onPressed,
    Color? iconColor,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: GoogleFonts.openSans(
          textStyle: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onPressed,
      ),
    );
  }
}
