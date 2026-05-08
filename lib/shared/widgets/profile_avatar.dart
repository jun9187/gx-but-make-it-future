import 'package:flutter/material.dart';

import '../../core/constants/app_radius.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.label = 'Y'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF9DB), Color(0xFF6FCF97)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAF3),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF2B7A4B),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
