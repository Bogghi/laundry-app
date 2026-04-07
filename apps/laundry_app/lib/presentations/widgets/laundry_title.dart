import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LaundryTitle extends ConsumerWidget {
  final String text;

  const LaundryTitle({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
        style: TextStyle(
          color: Color.fromARGB(255, 30, 58, 138),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        text
    );
  }
}
