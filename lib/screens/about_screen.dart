import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../data/format.dart';
import '../data/sample_data.dart';
import '../state/app_scope.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/impact_strip.dart';

/// Mission, transparency figures, recent activities and the photo gallery —
/// the web homepage's About, Credibility and Gallery sections.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final urdu = context.isUrdu;
    final palette = context.palette;

    final metrics = [
      ('${SampleData.fundsToPrograms}%', s.fundsToPrograms, AppColors.accent),
      ('${SampleData.administrative}%', s.administrative, AppColors.secondary),
      ('${SampleData.transparencyScore}%', s.transparency, palette.brand),
      ('${SampleData.donorRating}/5', s.donorRating, AppColors.blue500),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              backgroundColor: AppColors.emerald800,
              foregroundColor: Colors.white,
              title: Text(
                s.aboutUs,
                style: context.text.titleLarge?.copyWith(color: Colors.white),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      SampleData.missionImage,
                      fit: BoxFit.cover,
                      alignment: const Alignment(0, -0.4),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.slate900.withValues(alpha: 0.7),
                            AppColors.slate900.withValues(alpha: 0.05),
                            AppColors.emerald800.withValues(alpha: 0.85),
                          ],
                          stops: const [0, 0.45, 1],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
              sliver: SliverList.list(
                children: [
                  EyebrowPill(
                    label: s.missionEyebrow,
                    icon: Icons.visibility_rounded,
                  ),
                  const SizedBox(height: 10),
                  HighlightTitle(
                    lead: s.missionTitleLead,
                    highlight: s.missionTitleHighlight,
                  ),
                  const SizedBox(height: 10),
                  Text(s.missionBody, style: context.text.bodyLarge),
                  const SizedBox(height: 18),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: 5,
                            decoration: BoxDecoration(
                              color: palette.brand,
                              borderRadius:
                                  const BorderRadiusDirectional.horizontal(
                                    start: Radius.circular(24),
                                  ).resolve(Directionality.of(context)),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 18,
                                        color: palette.brand,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        s.visionTitle,
                                        style: context.text.titleSmall,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    s.visionBody,
                                    style: context.text.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(s.valuesTitle, style: context.text.titleMedium),
                  const SizedBox(height: 8),
                  for (final value in s.values)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.accent,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              value,
                              style: context.text.bodyMedium?.copyWith(
                                color: palette.strong,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 22),
                  const ImpactStrip(),
                  const SizedBox(height: 30),
                  EyebrowPill(
                    label: s.transparency,
                    icon: Icons.shield_rounded,
                  ),
                  const SizedBox(height: 10),
                  HighlightTitle(
                    lead: s.credTitleLead,
                    highlight: s.credTitleHighlight,
                  ),
                  const SizedBox(height: 6),
                  Text(s.credSubtitle, style: context.text.bodyMedium),
                  const SizedBox(height: 14),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      mainAxisExtent: urdu ? 100 : 92,
                    ),
                    itemCount: metrics.length,
                    itemBuilder: (context, index) {
                      final (value, label, color) = metrics[index];
                      return AppCard(
                        padding: const EdgeInsets.all(14),
                        radius: 20,
                        shadow: false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              value,
                              textDirection: TextDirection.ltr,
                              style: AppTheme.figure(26, color: color),
                            ),
                            Text(
                              label,
                              textAlign: TextAlign.center,
                              style: context.text.bodySmall,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 26),
                  Text(s.scaleTitle, style: context.text.titleLarge),
                  Text(s.campaignsSubtitle, style: context.text.bodySmall),
                  const SizedBox(height: 12),
                  AppCard(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      children: [
                        for (final tier in SampleData.tiers)
                          InkWell(
                            onTap: () =>
                                context.go('/donate?amount=${tier.amount}'),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 92,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: palette.brandSoft,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      rs(tier.amount),
                                      textDirection: TextDirection.ltr,
                                      style: AppTheme.figure(
                                        13,
                                        color: palette.brand,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      tier.impact.of(urdu),
                                      style: context.text.bodyMedium,
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: palette.muted,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(s.activitiesTitle, style: context.text.titleLarge),
                  Text(s.activitiesSubtitle, style: context.text.bodySmall),
                  const SizedBox(height: 12),
                  AppCard(
                    child: Column(
                      children: [
                        for (var i = 0; i < SampleData.activities.length; i++)
                          _ActivityRow(
                            index: i,
                            isLast: i == SampleData.activities.length - 1,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  HighlightTitle(
                    lead: s.galleryTitleLead,
                    highlight: s.galleryTitleHighlight,
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                    itemCount: SampleData.gallery.length,
                    itemBuilder: (context, index) =>
                        _GalleryTile(image: SampleData.gallery[index]),
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

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.index, required this.isLast});

  final int index;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final activity = SampleData.activities[index];
    final urdu = context.isUrdu;
    final palette = context.palette;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 16,
            child: Column(
              children: [
                const SizedBox(height: 5),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.25),
                      width: 3,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.only(top: 6),
                      color: palette.border,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        urdu
                            ? activity.period.ur
                            : activity.period.en.toUpperCase(),
                        style: context.text.labelSmall,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: urdu ? 0 : 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          activity.reach.of(urdu),
                          style: context.text.labelSmall?.copyWith(
                            color: const Color(0xFF16A34A),
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(activity.title.of(urdu), style: context.text.titleSmall),
                  Text(
                    activity.description.of(urdu),
                    style: context.text.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryTile extends StatelessWidget {
  const _GalleryTile({required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Material(
        child: Ink.image(
          image: AssetImage(image),
          fit: BoxFit.cover,
          child: InkWell(onTap: () => _open(context)),
        ),
      ),
    );
  }

  void _open(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: InteractiveViewer(
                child: Image.asset(image, fit: BoxFit.contain),
              ),
            ),
            PositionedDirectional(
              top: 10,
              end: 10,
              child: Material(
                color: Colors.black.withValues(alpha: 0.45),
                shape: const CircleBorder(),
                child: IconButton(
                  tooltip: dialogContext.s.close,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
