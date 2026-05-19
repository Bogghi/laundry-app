import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_card.dart';
import 'package:laundry_app/presentations/widgets/laundry_scaffold_padding.dart';
import 'package:laundry_app/utils/routes.dart';

class GarmetsPickerPage extends ConsumerStatefulWidget {
  const GarmetsPickerPage({super.key});

  @override
  ConsumerState<GarmetsPickerPage> createState() => _GarmetsPickerPageState();
}

class _GarmetsPickerPageState extends ConsumerState<GarmetsPickerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LaundryTitle(text: "Seleziona capi"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary
              ),
              onPressed: (){
                Navigator.of(context).pushNamed(Routes.addOrder);
              },
              child: Icon(
                Icons.check,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          )
        ],
      ),
      body: LaundryScaffoldPadding(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: LaundryCard(
                title: "capi selezionati",
                child: Text("test"),
              ),
            )
          ],
        ),
      )
    );
  }
}
