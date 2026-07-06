import 'package:flutter/material.dart';

import 'package:laundry_app/app_theme.dart';
import 'package:laundry_app/presentations/widgets/laundry_text_form_field.dart';

class BusinessNameStep extends StatelessWidget {
  final TextEditingController businessNameController;
  final String? errorText;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const BusinessNameStep({
    super.key,
    required this.businessNameController,
    required this.errorText,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Come si chiama la tua attività?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.headlineColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          LaundryTextFormField(
            controller: businessNameController,
            labelText: 'Nome dell\'attività',
          ),
          if (errorText != null) ...[
            const SizedBox(height: 8),
            Text(
              errorText!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red.shade600, fontSize: 14),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColorTone1,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: isSubmitting ? null : onSubmit,
              child: isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Crea', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
