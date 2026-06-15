import 'package:flutter/material.dart';

import 'package:laundry_app/app_theme.dart';

class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.headlineColor
      )
    );
  }
}
