import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laundry_app/presentations/widgets/laundry_sub_heading.dart';

import 'package:shared_assets/models/client_model.dart';

import 'package:laundry_app/app_theme.dart';
import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/presentations/widgets/laundry_card.dart';
import 'package:laundry_app/presentations/widgets/laundry_scaffold_padding.dart';
import 'package:laundry_app/presentations/screens/add_order/widgets/section_title.dart';
import 'package:laundry_app/presentations/screens/add_order/widgets/associate_client.dart';
import 'package:laundry_app/utils/routes.dart';

class AddOrderPage extends ConsumerStatefulWidget {
  const AddOrderPage({super.key});

  @override
  ConsumerState<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends ConsumerState<AddOrderPage> {
  DateTime? selectedDate;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController orderNumberController = TextEditingController();
  late ClientModel orderClient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LaundryTitle(text: "Nuovo ordine"),
      ),
      body: LaundryScaffoldPadding(
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(text: "CAPI"),
              LaundryCard(
                padding: EdgeInsets.zero,
                child: LaundryCard(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        LaundrySubHeading(text: 'capi selezionati'),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13.0)
                            ),
                            backgroundColor: Theme.of(context).colorScheme.primary
                          ),
                          onPressed: (){
                            Navigator.of(context).pushNamed(Routes.itemsPicker);
                          },
                          child: Text(
                            "Aggiungi Capo",
                            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SectionTitle(text: "INFORMAZIONI"),
              LaundryCard(
                title: "numero ordine",
                child: TextFormField(
                  controller: orderNumberController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    border: InputBorder.none,
                    hintText: "#98",
                    hintStyle: TextStyle(
                      color: AppTheme.primaryColorTone1,
                      fontSize: 18,
                    ),
                  ),
                  style: TextStyle(
                    color: AppTheme.primaryColorTone1,
                    fontSize: 18,
                  ),
                ),
              ),
              AssociateClient(
                onSelectedClient: (client) {
                  setState(() {
                    orderClient = client;
                  });
                },
              ),
              LaundryCard(
                title: "data consegna",
                child: TextFormField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: AppTheme.primaryColorTone1,
                      fontSize: 18,
                    ),
                  ),
                  style: TextStyle(
                    color: AppTheme.primaryColorTone1,
                    fontSize: 18,
                  ),
                  onTap: () => {
                    _selectDate(),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }
}
