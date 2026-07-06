import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:laundry_app/app_theme.dart';

class OnboardingSlide extends StatelessWidget {
  final List<List<dynamic>>? icon;
  final Widget? iconWidget;
  final String? headline;
  final String title;
  final String description;

  const OnboardingSlide({
    super.key,
    this.icon,
    this.iconWidget,
    this.headline,
    required this.title,
    required this.description,
  }) : assert(icon != null || iconWidget != null,
            'Either icon or iconWidget must be provided');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (headline != null) ...[
            Text(
              headline!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
          ],
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: AppTheme.primaryBackgroundColorShade2,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: iconWidget ??
                  HugeIcon(
                    icon: icon!,
                    size: 64,
                    color: AppTheme.primaryColorTone1,
                  ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.headlineColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.subHeadlineColor,
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
