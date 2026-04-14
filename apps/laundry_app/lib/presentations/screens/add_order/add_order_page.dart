import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:laundry_app/app_theme.dart';
import 'package:laundry_app/presentations/widgets/laundry_text_form_field.dart';
import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_card.dart';

class AddOrderPage extends ConsumerWidget {
  const AddOrderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: LaundryTitle(text: "Nuovo ordine"),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Informazini ordine",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.headlineColor
                )
              ),
              LaundryCard(
                title: "numero ordine",
                child: TextFormField(
                  decoration: InputDecoration(
                    // contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: "#98",
                    hintStyle: TextStyle(
                      color: AppTheme.primaryColorTone1,
                      fontSize: 18
                    ),
                  ),
                  style: TextStyle(
                    color: AppTheme.primaryColorTone1,
                    fontSize: 18
                  ),
                )
              ),
            ],
          ),
        ),
      )
    );
  }
}
