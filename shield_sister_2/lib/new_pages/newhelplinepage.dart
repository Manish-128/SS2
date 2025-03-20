import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class newHelplinePage extends StatelessWidget {
  const newHelplinePage({super.key});

  Future<void> _callhelp(String number) async {
    Uri dialerUri = Uri(scheme: 'tel', path: number); // Blank tel: URI
    try {
      await launchUrl(dialerUri);
    } catch (e) {
      debugPrint('Error opening the dialer: $e');
    }
  }

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

    return Scaffold(
      appBar: AppBar(
        title: Text("Helpline Numbers"),
      ),
      body: SafeArea(
          child: ListView.builder(
              itemCount: helplines.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        helplines[index][0]
                            .substring(0, 1), // First digit of the number
                        style: GoogleFonts.workSans(
                          textStyle: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    title: Text(
                      helplines[index][0],
                      style: GoogleFonts.workSans(
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    subtitle: Text(
                      "Helpline: ${helplines[index][1]}",
                      style: GoogleFonts.workSans(
                        textStyle:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.call, color: Colors.green),
                      onPressed: () {
                        _callhelp(helplines[index][1]);
                      },
                    ),
                  ),
                );
              })),
    );
  }
}
