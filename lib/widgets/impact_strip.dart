import 'package:flutter/material.dart';

import '../data/format.dart';
import '../data/sample_data.dart';
import '../state/app_scope.dart';
import '../theme.dart';

/// Founded / communities / lives impacted strip from the web impact section.
class ImpactStrip extends StatelessWidget {
  const ImpactStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final items = [
      (s.foundedIn, '${SampleData.foundedYear}'),
      (s.communities, '${SampleData.communitiesServed}+'),
      (s.livesImpacted, '${compact(SampleData.livesImpacted)}+'),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: AlignmentDirectional.centerStart,
          end: AlignmentDirectional.centerEnd,
          colors: [AppColors.primary, AppColors.emerald700],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: Column(
                children: [
                  Text(
                    context.isUrdu ? item.$1 : item.$1.toUpperCase(),
                    style: context.text.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.72),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.$2,
                    textDirection: TextDirection.ltr,
                    style: AppTheme.figure(24, color: Colors.white),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
