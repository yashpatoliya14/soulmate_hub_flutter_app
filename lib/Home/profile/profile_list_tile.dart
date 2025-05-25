import 'package:flutter/material.dart';
import 'package:matrimony_flutter/User_Detail/user_detail.dart';
import 'package:matrimony_flutter/Utils/importFiles.dart';

class ProfileListTile extends StatelessWidget {
  String label;
  String data;
  IconData icon;
  ProfileListTile({
    super.key,
    required this.label,
    required this.data,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(label, style: GoogleFonts.nunito()),
          SizedBox(width: 2),
          Icon(icon, size: 15),
        ],
      ),
      subtitle: Text(
        data,
        style: GoogleFonts.quicksand(fontWeight: FontWeight.w500),
      ),
    );
  }
}
