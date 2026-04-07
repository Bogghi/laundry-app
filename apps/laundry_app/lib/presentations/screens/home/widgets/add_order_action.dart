import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddOrderAction extends ConsumerWidget {
  const AddOrderAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () => Navigator.of(context).pushNamed('/add_order'),
      child: const Icon(Icons.add_rounded)
    );
  }
}
