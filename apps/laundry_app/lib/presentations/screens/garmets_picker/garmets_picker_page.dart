import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_card.dart';
import 'package:laundry_app/presentations/widgets/laundry_scaffold_padding.dart';
import 'package:laundry_app/presentations/widgets/laundry_sub_heading.dart';
import 'package:laundry_app/presentations/widgets/laundry_display_list.dart';
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
        title: LaundryTitle(text: "Selezione capi"),
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
            LaundryCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10.0,
                children: [
                  LaundrySubHeading(text: "capi selezionati"),
                  LaundryDisplayList(children: [
                    Row(
                      children: [
                        Text("Camicia"),
                        Spacer(),
                        Text(
                          "X2",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text("Pantalone"),
                        Spacer(),
                        Text(
                          "X3",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text("Giacca"),
                        Spacer(),
                        Text(
                          "X4",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ])
                ],
              )
            ),

          ],
        ),
      )
    );
  }
}
