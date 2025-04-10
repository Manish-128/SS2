import 'package:flutter/material.dart';

class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy Settings")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          ListTile(
            title: Text("Data Usage"),
            subtitle: Text("Control how your data is collected and stored."),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          ListTile(
            title: Text("Permissions"),
            subtitle: Text("Manage app permissions."),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          ListTile(
            title: Text("Clear Personal Data"),
            subtitle: Text("Erase all saved information."),
            trailing: Icon(Icons.delete, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
