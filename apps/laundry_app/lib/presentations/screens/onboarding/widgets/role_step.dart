import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import 'package:shared_assets/models/user_model.dart';

import 'package:laundry_app/app_theme.dart';

class RoleStep extends StatelessWidget {
  final bool isSubmitting;
  final ValueChanged<UserType> onSelect;
  final VoidCallback onBack;

  const RoleStep({
    super.key,
    required this.isSubmitting,
    required this.onSelect,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Che ruolo hai?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.headlineColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              _RoleCard(
                icon: HugeIcons.strokeRoundedStore01,
                title: 'Proprietario',
                description: 'Gestisci la tua attività di lavanderia',
                onTap: isSubmitting ? null : () => onSelect(UserType.owner),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                icon: HugeIcons.strokeRoundedUserGroup,
                title: 'Dipendente',
                description: 'Lavori per una lavanderia già esistente',
                onTap: isSubmitting ? null : () => onSelect(UserType.employ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: GestureDetector(
            onTap: isSubmitting ? null : onBack,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft01,
                color: AppTheme.headlineColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final List<List<dynamic>> icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.primaryBackgroundColorShade2,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            HugeIcon(icon: icon, color: AppTheme.primaryColorTone1, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppTheme.headlineColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(color: AppTheme.subHeadlineColor, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
