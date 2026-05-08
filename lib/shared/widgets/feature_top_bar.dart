import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import 'icon_circle.dart';
import 'profile_avatar.dart';

class FeatureTopBar extends StatelessWidget {
  const FeatureTopBar({
    super.key,
    required this.title,
    this.leadingIcon = Icons.arrow_back_rounded,
    this.trailing,
  });

  final String title;
  final IconData leadingIcon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconCircle(icon: leadingIcon, size: 40, iconSize: 18),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        trailing ??
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconCircle(
                  icon: Icons.notifications_none_rounded,
                  size: 40,
                  iconSize: 18,
                ),
                SizedBox(width: AppSpacing.sm),
                ProfileAvatar(),
              ],
            ),
      ],
    );
  }
}
