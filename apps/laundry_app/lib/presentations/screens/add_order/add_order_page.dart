import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:laundry_app/app_theme.dart';
import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_card.dart';
import 'package:laundry_app/presentations/screens/add_order/widgets/section_title.dart';

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
              SectionTitle(text: "Informazini ordine"),
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
              Row(
                children: [
                  SectionTitle(text: "Cliente"),
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/register_client');
                    },
                    child: Icon(Icons.add, size: 20)
                  )
                ]
              ),
              LaundryCard(
                child: Text("ciao")
              )
            ],
          ),
        ),
      )
    );
  }
}
