import 'package:flutter/material.dart';

import 'package:laundry_app/app_theme.dart';

class UserRow extends StatelessWidget {
  final String name;
  final String phoneNumber;

  const UserRow({
    super.key,
    required this.name,
    required this.phoneNumber
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Icon(Icons.account_circle, size: 50, color: AppTheme.primaryColorTone1),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )
              ),
              Text(phoneNumber)
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
              onPressed: (){},
              icon: Icon(Icons.cancel_outlined)
          ),
        )
      ],
    );
  }
}
