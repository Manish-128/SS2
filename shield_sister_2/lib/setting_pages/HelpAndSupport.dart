import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help & Support")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Contact Developer", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.email),
                SizedBox(width: 10),
                Text("manish@shieldapp.dev"),
              ],
            ),
            const SizedBox(height: 30),
            const Text("Send Feedback", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Write your feedback here...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Submit feedback logic
              },
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
