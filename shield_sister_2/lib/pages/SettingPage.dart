import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        //backgroundColor: Color(0xFFADDDC7),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),
          // Emergency Contacts
          SettingItem(
            icon: Icons.contacts,
            title: 'Emergency Contacts',
            subtitle: 'Manage trusted contacts for SOS alerts',
            color: Colors.blue,
            onTap: () {
              // Navigate to Emergency Contacts Page
            },
          ),
          Divider(),

          // Notifications
          SettingItem(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Enable or disable app notifications',
            color: Colors.deepPurpleAccent,
            onTap: () {
              // Navigate to Notification Settings
            },
          ),
          Divider(),

          // Location Sharing
          SettingItem(
            icon: Icons.location_on,
            title: 'Location Sharing',
            subtitle: 'Enable live location for emergency situations',
            color: Colors.yellow,
            onTap: () {
              // Toggle Location Sharing
            },
          ),
          Divider(),

          // SOS Settings
          SettingItem(
            icon: Icons.warning_amber_rounded,
            title: 'SOS Settings',
            subtitle: 'Customize SOS trigger and alerts',
            color: Colors.deepOrangeAccent,
            onTap: () {
              // Navigate to SOS Settings Page
            },
          ),
          Divider(),

          // Privacy Settings
          SettingItem(
            icon: Icons.lock,
            title: 'Privacy Settings',
            subtitle: 'Manage data and privacy preferences',
            color: Colors.green,
            onTap: () {
              // Navigate to Privacy Settings Page
            },
          ),
          Divider(),

          // Help & Support
          SettingItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get support or learn more about the app',
            color: Colors.grey.withOpacity(0.8),
            onTap: () {
              // Navigate to Help Page
            },
          ),
          Divider(),


        ],
      ),
    );
  }
}

// Reusable Setting Item Widget
class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        radius: 20,
        child: Icon(icon, color: Colors.white, size: 26,),
      ),
      title: Text(
        title,
        style: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 15,
            color: Colors.grey[500],
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
