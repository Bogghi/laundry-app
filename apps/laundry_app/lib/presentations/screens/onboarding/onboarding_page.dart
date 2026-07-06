import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:shared_assets/icons/washer_icon.dart';

import 'package:laundry_app/app_theme.dart';
import 'package:laundry_app/providers/onboarding_provider.dart';
import 'package:laundry_app/presentations/screens/onboarding/widgets/onboarding_slide.dart';
import 'package:laundry_app/utils/routes.dart';

const _slides = [
  (
    icon: null,
    iconWidget: WasherIcon(width: 64, height: 64),
    headline: 'Pristine',
    title: 'Gestisci i tuoi ordini',
    description: 'Tieni traccia di ogni capo, dal ritiro alla consegna, in un unico posto.',
  ),
  (
    icon: HugeIcons.strokeRoundedUserGroup,
    iconWidget: null,
    headline: null,
    title: 'Organizza i clienti',
    description: 'Registra i tuoi clienti e ritrova i loro dati in pochi tocchi.',
  ),
  (
    icon: HugeIcons.strokeRoundedCheckmarkCircle02,
    iconWidget: null,
    headline: null,
    title: 'Pronto per iniziare',
    description: 'Tutto quello che ti serve per gestire la lavanderia, sempre a portata di mano.',
  ),
];

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPage = ValueNotifier(0);

  @override
  void dispose() {
    _pageController.dispose();
    _currentPage.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    await completeOnboarding(ref);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: GestureDetector(
                  onTap: _completeOnboarding,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Salta',
                      style: TextStyle(
                        color: AppTheme.subHeadlineColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => _currentPage.value = index,
                children: [
                  for (final slide in _slides)
                    OnboardingSlide(
                      icon: slide.icon,
                      iconWidget: slide.iconWidget,
                      headline: slide.headline,
                      title: slide.title,
                      description: slide.description,
                    ),
                ],
              ),
            ),
            ValueListenableBuilder<int>(
              valueListenable: _currentPage,
              builder: (context, page, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < _slides.length; i++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: page == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: page == i
                              ? AppTheme.primaryColorTone1
                              : AppTheme.primaryBackgroundColorShade1,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: ValueListenableBuilder<int>(
                valueListenable: _currentPage,
                builder: (context, page, _) {
                  final isLast = page == _slides.length - 1;
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColorTone1,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        if (isLast) {
                          _completeOnboarding();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        isLast ? 'Inizia' : 'Avanti',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
