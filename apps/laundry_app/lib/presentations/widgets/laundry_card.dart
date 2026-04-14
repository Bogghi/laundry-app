import 'package:flutter/material.dart';

import 'package:laundry_app/app_theme.dart';

class LaundryCard extends StatelessWidget {
  final Widget child;
  final String? title;

  const LaundryCard({
    super.key,
    required this.child,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      shadowColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: title != null,
              child: Text(
                (title ?? "").toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.subHeadlineColor,
                )
              )
            ),
            Visibility(
              visible: title == null,
              child: child
            ),
            Visibility(
              visible: title != null,
              child: Card(
                margin: EdgeInsets.only(top: 10),
                color: Color.fromRGBO(243, 244, 245, 100),
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: child,
                )
              )
            )
          ],
        )
      )
    );
  }
}
