import 'package:flutter/material.dart';

import 'package:laundry_app/app_theme.dart';
import 'package:laundry_app/presentations/widgets/laundry_text_form_field.dart';

class AuthStep extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final String? errorText;
  final bool isSubmitting;
  final VoidCallback onLogin;
  final VoidCallback onSignup;

  const AuthStep({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.errorText,
    required this.isSubmitting,
    required this.onLogin,
    required this.onSignup,
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
            'Pristine',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          LaundryTextFormField(
            controller: usernameController,
            labelText: 'Nome utente',
          ),
          LaundryTextFormField(
            controller: passwordController,
            labelText: 'Password',
            obscureText: true,
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
              onPressed: isSubmitting ? null : onLogin,
              child: isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Accedi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 52,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColorTone1,
                side: BorderSide(color: AppTheme.primaryColorTone1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: isSubmitting ? null : onSignup,
              child: const Text('Registrati', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
