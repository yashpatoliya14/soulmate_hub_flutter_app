import 'package:flutter/material.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';

class AboutPage extends StatefulWidget  {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Text(
          "Meet Our Team",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),

      // Bordered container with the details
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Developed by
            const Text(
              "Developed by :",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            const Text("- Yash Patoliya (23010101206)"),
            const SizedBox(height: 16),

            // Mentored by
            const Text(
              "Mentored by :",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Prof. Mehul bhundiya,\n"
                  "Computer Engineering Department,\n"
                  "School of Computer Science",
            ),
            const SizedBox(height: 16),

            // Explored by
            const Text(
              "Explored by :",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "ASWDC, School Of Computer Science,\n"
                  "School of Computer Science",
            ),
            const SizedBox(height: 16),

            // Eulogized by
            const Text(
              "Eulogized by :",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Darshan University,\n"
                  "Rajkot, Gujarat - INDIA",
            ),
            const SizedBox(height: 8),

            // About Section
            const Text(
              "About ASWDC",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "ASWDC is an App, Software, and Website Development "
                  "Center at Darshan University. It is managed by "
                  "students and faculty of Computer Science & Engineering. "
                  "The purpose of ASWDC is to bridge the gap between "
                  "students and industry by developing real-world projects.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Contact / More Info Section
            const Text(
              "Contact & More",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Iconsax.message),
              title: const Text("yashpatoliya14@gmail.com"),
              onTap: () {
                // Implement email launch or other action
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.call),
              title: const Text("+91 70433 33359"),
              onTap: () {
                // Implement phone call or other action
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.link),
              title: const Text("http://www.darshan.ac.in"),
              onTap: () {
                // Implement website navigation
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Iconsax.mobile),
              title: const Text("1.0.0 version"),
              onTap: () {
                // Implement share functionality
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                "© 2025 Darshan University\nMade in India",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    ])));
  }
}
