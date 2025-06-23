
import 'package:flutter/material.dart';
import 'Manual_Page_Schemas.dart';
import 'package:google_fonts/google_fonts.dart';

class MainManualPage extends StatefulWidget {
  const MainManualPage({super.key});

  @override
  State<MainManualPage> createState() => _MainManualPageState();
}

class _MainManualPageState extends State<MainManualPage> {
  final List<DefenceManual> defenceManuals = [
    DefenceManual(
      title: "8 Self-Defense Moves Every Woman Needs to Know",
      imageUrl: "https://i0.wp.com/post.healthline.com/wp-content/uploads/2022/01/Nicole-Davis-500x500-Bio.png?w=105&h=105",
      searchable: "https://www.healthline.com/health/womens-health/self-defense-tips-escape",
    ),
    DefenceManual(
      title: "Women’s Safety: Self-Defense Tips and Why Is It Important",
      imageUrl: "https://media.seniority.in/mageplaza/blog/post/ktpl_blog/main_image_-_self_defense.jpg",
      searchable: "https://seniority.in/blog/womens-safety-self-defense-tips-and-why-is-it-important",
    ),
    DefenceManual(
      title: "Top 3 Most Effective Self Defence Moves for Women",
      imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSg-GW5mC_J15eIBlKz5MzhldMFIPIKh4QB_g&s",
      searchable: "https://youtu.be/SSnnte5cVIo?si=w9KFPF8fASWx0xnP",
    ),
  ];

  final List<SafetyBlogs> safetyBlogs = [
    SafetyBlogs(
      title: "Women's safety at workplace",
      imageUrl: "https://blogimage.vantagecircle.com/vcblogimage/en/2024/10/Women-s-safety-at-workplace.jpg",
      searchable: "https://www.vantagecircle.com/en/blog/womens-safety-workplace/",
    ),
    SafetyBlogs(
      title: "Women's Safety: Building confidence",
      imageUrl: "https://zhl.org.in/blog/wp-content/uploads/2023/07/WOMEN-SAFETY-1-1-2-1-1-1.jpeg",
      searchable: "https://zhl.org.in/blog/growing-need-women-safety-india/",
    ),
    SafetyBlogs(
      title: "Women's Safety: Law and policies",
      imageUrl: "https://www.khanglobalstudies.com/blog/wp-content/uploads/2024/09/Women-Safety-1024x576.jpg",
      searchable: "https://www.khanglobalstudies.com/blog/women-safety/",
    ),
    SafetyBlogs(
      title: "Women’s Safety: Initiatives and Challenges",
      imageUrl: "https://sleepyclasses.com/wp-content/uploads/2024/05/LogoCompressed.png",
      searchable: "https://sleepyclasses.com/womens-safety-in-india/",
    ),
  ];

  final List<AccessManual> accessManual = [
    AccessManual(
      title: "What is a SOS?",
      imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcST4Yzb80_jIgbz17IQ2I18qii1gqDneHZfnw&s",
      content:
      "The SOS (Save our Souls) feature sends an alert to emergency services or contacts when a user needs immediate assistance.\nThe alert includes the user's location, battery percentage, and other information.",
    ),
    AccessManual(
      title: "How to make SOS alert?",
      imageUrl: "https://img.freepik.com/premium-vector/sos-notification-screen-phone-sos-emergency-call-phone-911-call-screen-smartphone-cry-help-calling-help-vector-stock-illustration_435184-1303.jpg",
      content:
      "The SOS feature is embedded in our home page.\n\nFollow the steps:\n1. Open the homepage.\n2. Click on the SOS button in the center\n3. If a dropdown message is received then the SOS is successfully sent",
    ),
    AccessManual(
      title: "How to add Contacts?",
      imageUrl: "https://img.freepik.com/free-vector/mobile-inbox-concept-illustration_114360-4014.jpg",
      content:
      "Follow the simple steps to add contact:\n1. Visit Contact page from Navigation bar on the bottom\n2. Add contact details and hit save\n3. The card will appear with name and details.",
    ),
    AccessManual(
      title: "How to locate Safe-Zones?",
      imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPfNxeXYCh6YJS_mZGGh-8HE6FQEUlHAOB2g&s",
      content:
      "Safe zones are safety locations marked on the map.\n\nFollow the steps to track safe zones\n1. Go to Map section from bottom Navigation bar\n2. Click on the track safe zones button\n3. The nearest safe zone will be tracked on the map screen.",
    ),
  ];

  int selected = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Safety Manuals',
          style: GoogleFonts.openSans(
            color: Color(0xFFFF6F61),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        elevation: 0.5,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Custom header
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Text(
                    //   "Safety Manuals",
                    //   style: TextStyle(
                    //     fontSize: 32,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.black87,
                    //     letterSpacing: 1.5,
                    //   ),
                    // ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        _topButton("How to Access", selected == 1, () => setState(() => selected = 1)),
                        _topButton("Safety Blogs", selected == 2, () => setState(() => selected = 2)),
                        _topButton("Quick Manuals", selected == 3, () => setState(() => selected = 3)),
                        _topButton("Misc", selected == 4, () => setState(() => selected = 4)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Content based on selection
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              sliver: selected == 1
                  ? SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => aManual(context, accessManual[index]),
                  childCount: accessManual.length,
                ),
              )
                  : selected == 2
                  ? SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => sManual(context, safetyBlogs[index]),
                  childCount: safetyBlogs.length,
                ),
              )
                  : selected == 3
                  ? SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => dManual(context, defenceManuals[index]),
                  childCount: defenceManuals.length,
                ),
              )
                  : selected == 4
                  ? SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => aManual(context, accessManual[index]),
                  childCount: accessManual.length,
                ),
              )
                  : SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    "Please select a type of article...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 50)), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _topButton(String name, bool isSelected, VoidCallback callback) {
    return GestureDetector(
      onTap: callback,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFAAF0D1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF009688).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              color: isSelected ? Color(0xFF009688) : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}