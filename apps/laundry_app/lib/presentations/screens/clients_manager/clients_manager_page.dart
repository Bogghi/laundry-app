import 'package:flutter/material.dart';

import 'package:laundry_app/presentations/widgets/laundry_scaffold_padding.dart';
import 'package:laundry_app/presentations/widgets/laundry_title.dart';

class ClientsManagerPage extends StatelessWidget {
  const ClientsManagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LaundryTitle(text: "Gestione clienti"),
      ),
      body: LaundryScaffoldPadding(child: Placeholder()),
    );
  }
}