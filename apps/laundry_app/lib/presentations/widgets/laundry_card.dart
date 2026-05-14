import 'package:flutter/material.dart';

import 'package:laundry_app/presentations/widgets/laundry_sub_heading.dart';

class LaundryCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final EdgeInsetsGeometry? padding;

  const LaundryCard({
    super.key,
    required this.child,
    this.title,
    this.padding = const EdgeInsets.all(18.0)
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      shadowColor: Colors.transparent,
      child: Padding(
        padding: padding!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: title != null,
              child: LaundrySubHeading(text: title ?? ""),
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
                child: child
              ),
            )
          ],
        )
      )
    );
  }
}
