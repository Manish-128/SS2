import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQsPage extends StatelessWidget {
  const FAQsPage({super.key});




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom AppBar Replacement
          Container(
            padding: const EdgeInsets.fromLTRB(20,40,20,0),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Back navigation
                  },
                ),
                const SizedBox(width: 10),
                const Text(
                  'FAQs',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],

            ),

          ),
          // FAQ Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: const [
                FAQTile(
                  question: 'What is this app about?',
                  answer:
                  'This app is designed to provide safety features for women, including emergency contacts, real-time location sharing, and quick SOS alerts.',
                ),
                FAQTile(
                  question: 'How do I update my profile?',
                  answer:
                  'Go to the Profile section, click on Edit Profile, and update your details such as name, email, or profile photo.',
                ),
                FAQTile(
                  question: 'How can I add emergency contacts?',
                  answer:
                  'You can add emergency contacts under the Emergency Contacts section in the app settings.',
                ),
                FAQTile(
                  question: 'What happens when I press the SOS button?',
                  answer:
                  'Pressing the SOS button will send your real-time location to your emergency contacts and notify them that you need help.',
                ),
                FAQTile(
                  question: 'Is my data secure?',
                  answer:
                  'Yes, we prioritize your privacy and security. All your data is encrypted and stored securely.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FAQTile extends StatelessWidget {
  final String question;
  final String answer;

  const FAQTile({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        title: Text(
          question,
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              answer,
              style: GoogleFonts.workSans(
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              ),
            ),
        ],
      ),
    );
  }
}
