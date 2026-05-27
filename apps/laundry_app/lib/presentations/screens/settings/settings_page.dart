import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:laundry_app/app_theme.dart';
import 'package:laundry_app/utils/routes.dart';
import 'package:laundry_app/presentations/widgets/laundry_title.dart';
import 'package:laundry_app/presentations/screens/settings/widgets/setting_option_row.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const LaundryTitle(text: "Impostazioni"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryBackgroundColorShade1,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                children: [
                  SettingOptionRow(
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.itemsManager);
                    },
                    hugeIcon: HugeIcons.strokeRoundedShirt01,
                    text: "Capi",
                  ),
                ],
              ),
            ),
          )
        ]
      ),
    );
  }
}
