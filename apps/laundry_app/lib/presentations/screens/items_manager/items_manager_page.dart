import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_app/presentations/widgets/laundry_title.dart';

class ItemsManagerPage extends ConsumerWidget {
  const ItemsManagerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: LaundryTitle(text: "Lista Capi"),
      ),
      
    );
  }
}
