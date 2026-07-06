import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/user_laundry_model.dart';
import 'package:shared_assets/services/supabase_service.dart';

import 'package:laundry_app/app_theme.dart';
import 'package:laundry_app/providers/auth_provider.dart';
import 'package:laundry_app/presentations/widgets/laundry_text_form_field.dart';
import 'package:laundry_app/presentations/widgets/laundry_toast.dart';

class LaundryAccessRequestDialog extends ConsumerStatefulWidget {
  const LaundryAccessRequestDialog({super.key});

  @override
  ConsumerState<LaundryAccessRequestDialog> createState() => _LaundryAccessRequestDialogState();
}

class _LaundryAccessRequestDialogState extends ConsumerState<LaundryAccessRequestDialog> {
  final TextEditingController _laundryNameController = TextEditingController();
  String? _errorText;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _laundryNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _laundryNameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorText = 'Inserisci il nome della lavanderia');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });
    try {
      final laundry = await SupabaseService.instance.laundries.findByNameCaseInsensitive(name);
      if (laundry == null) {
        setState(() => _errorText = 'Nessuna lavanderia trovata con questo nome');
        return;
      }

      final auth = ref.read(authProvider);
      await SupabaseService.instance.userLaundries.create(
        userId: auth!.user.id!,
        laundryId: laundry.id!,
        status: UserLaundryStatus.pending,
      );
      await ref.read(authProvider.notifier).refreshUserLaundry();

      if (!mounted) return;
      Navigator.of(context).pop();
      LaundryToast.show(context, 'Richiesta inviata al proprietario');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Richiedi accesso'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Inserisci il nome della lavanderia per cui lavori.'),
          const SizedBox(height: 12),
          LaundryTextFormField(
            controller: _laundryNameController,
            labelText: 'Nome lavanderia',
          ),
          if (_errorText != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorText!,
              style: TextStyle(color: Colors.red.shade600, fontSize: 14),
            ),
          ],
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColorTone1,
            foregroundColor: Colors.white,
          ),
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text('Invia richiesta'),
        ),
      ],
    );
  }
}
