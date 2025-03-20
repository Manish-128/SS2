import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



void searchGoogle(String query) async {
  final url = Uri.parse('https://www.google.com/search?q=$query');
  print('Fetching data for query: $query');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }

}

void launchGoogleSearch(String query){
  launchUrl(Uri.parse(query));
}


Widget aManual(BuildContext context, AccessManual manual) => GestureDetector(
  onTap: () => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      backgroundColor: Colors.white, // Dialog background color
      title: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blueAccent, size: 28), // Icon for the title
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              manual.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Text(
          manual.content,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[800],
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close, color: Colors.red),
              label: Text(
                "Close",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Add action for the secondary button
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "More Info",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    ),
  ),
  child: Card(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    elevation: 4,
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            manual.imageUrl,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                manual.title,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);

Widget sManual(BuildContext context, SafetyBlogs manual) => GestureDetector(
  onTap: () => launchGoogleSearch(manual.searchable),
  child: Card(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    elevation: 4,
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            manual.imageUrl,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                manual.title,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);

Widget dManual(BuildContext context, DefenceManual manual) => GestureDetector(
  onTap: () => launchGoogleSearch(manual.searchable),
  child: Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    elevation: 4,
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            manual.imageUrl,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                manual.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);


Widget misc(BuildContext context, Misc manual) => GestureDetector(
  onTap: () => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      backgroundColor: Colors.white, // Dialog background color
      title: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blueAccent, size: 28), // Icon for the title
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              manual.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Text(
          manual.content,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[800],
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close, color: Colors.red),
              label: Text(
                "Close",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Add action for the secondary button
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "More Info",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    ),
  ),
  child: Card(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    elevation: 4,
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            manual.imageUrl,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                manual.title,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);


class SafetyBlogs {
  final String title;
  final String imageUrl;
  final String searchable;

  SafetyBlogs({
    required this.title,
    required this.imageUrl,
    required this.searchable,
  });
}

class AccessManual {
  final String title;
  final String imageUrl;
  final String content;

  AccessManual({
    required this.title,
    required this.imageUrl,
    required this.content,
  });
}

class DefenceManual {
  final String title;
  final String imageUrl;
  final String searchable;

  DefenceManual({
    required this.title,
    required this.imageUrl,
    required this.searchable,
  });
}

class Misc {
  final String title;
  final String imageUrl;
  final String content;

  Misc({
    required this.title,
    required this.imageUrl,
    required this.content,
  });
}