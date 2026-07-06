import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LaundryTextFormField extends ConsumerWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;

  const LaundryTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
        ),
      ),
    );
  }
}
