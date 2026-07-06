import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_assets/models/user_model.dart';
import 'package:shared_assets/models/laundry_model.dart';
import 'package:shared_assets/models/user_laundry_model.dart';
import 'package:shared_assets/services/supabase_service.dart';

import 'package:laundry_app/app_theme.dart';
import 'package:laundry_app/providers/auth_provider.dart';
import 'package:laundry_app/presentations/screens/onboarding/widgets/auth_step.dart';
import 'package:laundry_app/presentations/screens/onboarding/widgets/role_step.dart';
import 'package:laundry_app/presentations/screens/onboarding/widgets/business_name_step.dart';
import 'package:laundry_app/utils/routes.dart';

enum _OnboardingStep { auth, role, businessName }

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();

  _OnboardingStep _step = _OnboardingStep.auth;
  String? _errorText;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _businessNameController.dispose();
    super.dispose();
  }

  Future<void> _goHome() async {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });
    try {
      final user = await SupabaseService.instance.users.findByUsername(username);
      if (user == null || !SupabaseService.instance.users.verifyPassword(password, user.passwordHash)) {
        setState(() => _errorText = 'Nome utente o password non validi');
        return;
      }
      await ref.read(authProvider.notifier).login(user);
      await _goHome();
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _startSignup() {
    if (_usernameController.text.trim().isEmpty || _passwordController.text.isEmpty) {
      setState(() => _errorText = 'Inserisci nome utente e password');
      return;
    }
    setState(() {
      _errorText = null;
      _step = _OnboardingStep.role;
    });
  }

  Future<void> _selectRole(UserType type) async {
    if (type == UserType.owner) {
      setState(() => _step = _OnboardingStep.businessName);
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });
    try {
      final user = await SupabaseService.instance.users.create(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        type: UserType.employ,
      );
      await ref.read(authProvider.notifier).login(user);
      await _goHome();
    } catch (e) {
      setState(() {
        _step = _OnboardingStep.auth;
        _errorText = 'Nome utente già in uso';
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _createBusiness() async {
    final businessName = _businessNameController.text.trim();
    if (businessName.isEmpty) {
      setState(() => _errorText = 'Inserisci il nome dell\'attività');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });
    try {
      final user = await SupabaseService.instance.users.create(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        type: UserType.owner,
      );
      final laundry = await SupabaseService.instance.laundries.create(
        LaundryModel(name: businessName),
      );
      await SupabaseService.instance.userLaundries.create(
        userId: user.id!,
        laundryId: laundry.id!,
        status: UserLaundryStatus.approved,
      );
      await ref.read(authProvider.notifier).login(user);
      await _goHome();
    } catch (e) {
      setState(() {
        _step = _OnboardingStep.auth;
        _errorText = 'Nome utente già in uso';
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackgroundColor,
      body: SafeArea(
        child: switch (_step) {
          _OnboardingStep.auth => AuthStep(
              usernameController: _usernameController,
              passwordController: _passwordController,
              errorText: _errorText,
              isSubmitting: _isSubmitting,
              onLogin: _login,
              onSignup: _startSignup,
            ),
          _OnboardingStep.role => RoleStep(
              isSubmitting: _isSubmitting,
              onSelect: _selectRole,
              onBack: () => setState(() => _step = _OnboardingStep.auth),
            ),
          _OnboardingStep.businessName => BusinessNameStep(
              businessNameController: _businessNameController,
              errorText: _errorText,
              isSubmitting: _isSubmitting,
              onSubmit: _createBusiness,
            ),
        },
      ),
    );
  }
}
