
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class newHelplinePage extends StatelessWidget {
  newHelplinePage({super.key});

  Future<void> _callhelp(String number) async {
    Uri dialerUri = Uri(scheme: 'tel', path: number);
    try {
      await launchUrl(dialerUri);
    } catch (e) {
      debugPrint('Error opening the dialer: $e');
    }
  }

  // List of warm colors
  final List<Color> warmColors = [
    const Color(0xFFFF4D6D), // Strong pink/red
    const Color(0xFFFF6F61), // Coral
    const Color(0xFFFF8C42), // Orange
    const Color(0xFFFFA726), // Deep orange
    const Color(0xFFFFAB91), // Light salmon
  ];

  @override
  Widget build(BuildContext context) {
    List<List> helplines = [
      ["Police", "100"],
      ["Women Helpline (All India)", "181"],
      ["National Commission for Women (NCW)", "011-26942369"],
      ["Women’s Domestic Abuse Helpline", "1091"],
      ["Child Helpline (For girls below 18)", "1098"],
      ["Cyber Crime Helpline", "1930"],
      ["Emergency Response Support System (ERSS)", "112"],
      ["Sexual Harassment at Workplace (SHe-Box)", "011-23381212"],
      ["Acid Attack Victim Support", "07533000733"],
      ["Anti-Stalking Helpline", "1096"],
      ["Human Trafficking Helpline", "011-24368638"],
      ["Legal Aid for Women (Free Legal Assistance)", "15100"],
    ];

    // Shuffle warm colors randomly
    warmColors.shuffle();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Helpline Numbers',
          style: TextStyle(color: Color(0xFF009688)),
        ),
        backgroundColor: const Color(0xFFE0F2F1), // Soft pink from theme
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: helplines.length,
          itemBuilder: (context, index) {
            // Use shuffled warm colors with a cycle (repeat if needed)
            Color avatarColor = warmColors[index % warmColors.length];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: CircleAvatar(
                  backgroundColor: avatarColor,
                  child: Text(
                    helplines[index][0].substring(0, 1),
                    style: GoogleFonts.workSans(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  helplines[index][0],
                  style: GoogleFonts.workSans(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                subtitle: Text(
                  "Helpline: ${helplines[index][1]}",
                  style: GoogleFonts.workSans(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.call, color: Color(0xFF009688)),
                  onPressed: () {
                    _callhelp(helplines[index][1]);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}