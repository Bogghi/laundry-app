import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:laundry_app/presentations/widgets/laundry_text_form_field.dart';
import 'package:laundry_app/presentations/widgets/laundry_title.dart';

class AddOrderPage extends ConsumerWidget {
  const AddOrderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 249, 250, 100),
      appBar: AppBar(
        title: LaundryTitle(text: "Nuovo ordine"),
      ),
      body: Form(
        child: Column(
          children: [
            LaundryTextFormField(
              controller: TextEditingController(),
              labelText: "Numero d'ordine",
            )
          ],
        ),
      )
    );
  }
}
