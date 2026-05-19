import 'package:flutter/material.dart';

class LaundryScaffoldPadding extends StatelessWidget {
  final Widget child;

  const LaundryScaffoldPadding({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: child,
    );
  }
}
