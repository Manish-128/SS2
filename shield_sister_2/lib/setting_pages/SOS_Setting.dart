import 'package:flutter/material.dart';

class SOSSettingsPage extends StatefulWidget {
  const SOSSettingsPage({super.key});

  @override
  State<SOSSettingsPage> createState() => _SOSSettingsPageState();
}

class _SOSSettingsPageState extends State<SOSSettingsPage> {
  bool sendBattery = true;
  bool sendNetwork = true;
  bool sendTimestamp = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SOS Details Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSwitchTile(
            title: 'Send Battery Percentage',
            value: sendBattery,
            onChanged: (val) => setState(() => sendBattery = val),
          ),
          _buildSwitchTile(
            title: 'Send Network Info',
            value: sendNetwork,
            onChanged: (val) => setState(() => sendNetwork = val),
          ),
          _buildSwitchTile(
            title: 'Send Timestamp',
            value: sendTimestamp,
            onChanged: (val) => setState(() => sendTimestamp = val),
          ),
          const SizedBox(height: 20),
          Text(
            'These settings control what information is included in your SOS message.',
            style: TextStyle(color: Colors.grey[600]),
          )
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
