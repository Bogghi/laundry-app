import 'package:flutter/material.dart';
import 'package:laundry_app/app_theme.dart';

class LaundrySubHeading extends StatelessWidget {
  final String text;

  const LaundrySubHeading({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppTheme.subHeadlineColor,
      ),
    );
  }
}
