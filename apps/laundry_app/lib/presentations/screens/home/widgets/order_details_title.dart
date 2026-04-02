import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderDetailsTitle extends ConsumerWidget {
  final String title;

  const OrderDetailsTitle({
    required this.title,
    super.key
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(113, 119, 130, 100)
      ),
      title
    );
  }
}
