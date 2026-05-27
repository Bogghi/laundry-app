import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class SettingOptionRow extends StatelessWidget {
  final String text;
  final List<List<dynamic>> hugeIcon;
  final VoidCallback onTap;

  const SettingOptionRow({
    super.key,
    required this.text,
    required this.hugeIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.grey.withValues(alpha: 0.3),
        highlightColor: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
          child: Row(
            spacing: 10,
            children: [
              HugeIcon(
                  icon: hugeIcon
              ),
              Text(
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                ),
                text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
