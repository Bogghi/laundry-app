import 'package:flutter/material.dart';

import 'package:laundry_app/presentations/widgets/laundry_sub_heading.dart';

/// A reusable card widget that displays content with optional title.
///
/// Renders differently based on the [title] parameter:
/// - Without title: [child] is displayed directly inside a white Card
/// - With title: [child] is displayed inside a nested gray Card below the [LaundrySubHeading] title
///
/// The [padding] parameter controls internal spacing (defaults to 18.0 on all sides).
/// Both cards have transparent shadows and the inner card has rounded corners.

class LaundryCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const LaundryCard({
    super.key,
    required this.child,
    this.title,
    this.padding = const EdgeInsets.all(18.0),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.grey.shade400,
            width: 1,
          ),
        ),
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
          ),
        ),
      ),
    );
  }
}
