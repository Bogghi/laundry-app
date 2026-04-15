import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:laundry_app/app_theme.dart';
import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_card.dart';
import 'package:laundry_app/presentations/screens/add_order/widgets/section_title.dart';

class AddOrderPage extends ConsumerStatefulWidget {
  const AddOrderPage({super.key});

  @override
  ConsumerState<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends ConsumerState<AddOrderPage> {
  @override
  Widget build(BuildContext context) {
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
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
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
                child: Column(
                  spacing: 18,
                  children: [
                    Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        // Replace with your logic to fetch/filter client suggestions
                        // For example, from a provider: ref.watch(clientsProvider).where(...)
                        final options = ['Client 1', 'Client 2', 'Client 3']; // Placeholder
                        return options.where((option) =>
                            option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
                      },
                      onSelected: (String selection) {
                        // Handle selection, e.g., update form state
                        print('Selected: $selection');
                      },
                      fieldViewBuilder: (
                          BuildContext context,
                          TextEditingController textEditingController,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted
                      ) {
                        return TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            icon: Icon(Icons.search, color: AppTheme.primaryColorTone1),
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            hintText: "Cerca un cliente esistente",
                            hintStyle: TextStyle(
                              color: AppTheme.primaryColorTone1,
                              fontSize: 18,
                            ),
                          ),
                          style: TextStyle(
                            color: AppTheme.primaryColorTone1,
                            fontSize: 18,
                          ),
                        );
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Icon(Icons.account_circle, size: 50, color: AppTheme.primaryColorTone1),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Mario Rossi"),
                              Text("m.rossi@gmail.com")
                            ],
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: IconButton(
                            onPressed: (){},
                            icon: Icon(Icons.cancel_outlined)
                          ),
                          flex: 1,
                        )
                      ],
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      )
    );
  }
}
