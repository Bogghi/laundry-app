import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _hasOnboardedKey = 'has_onboarded';

final onboardingProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_hasOnboardedKey) ?? false;
});

Future<void> completeOnboarding(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_hasOnboardedKey, true);
  ref.invalidate(onboardingProvider);
}
