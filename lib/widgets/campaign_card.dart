import 'package:flutter/material.dart';

import '../data/format.dart';
import '../models/campaign.dart';
import '../state/app_scope.dart';
import '../theme.dart';
import 'common.dart';
import 'visuals.dart';

/// Photo card for the home carousel and the campaigns list.
class CampaignCard extends StatelessWidget {
  const CampaignCard({
    super.key,
    required this.campaign,
    required this.onTap,
    this.imageHeight,
  });

  final Campaign campaign;
  final VoidCallback onTap;

  /// Fixed photo height; when null the photo fills whatever height the
  /// parent gives the card (the home carousel).
  final double? imageHeight;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final urdu = context.isUrdu;
    final palette = context.palette;
    final photo = ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SizedBox(
        height: imageHeight,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(campaign.image, fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00000000), Color(0x8C0F172A)],
                  stops: [0.45, 1],
                ),
              ),
            ),
            PositionedDirectional(
              top: 12,
              start: 12,
              child: _ImageChip(
                icon: campaign.cause.icon,
                label: campaign.cause.label(s),
                color: campaign.cause.color,
              ),
            ),
            PositionedDirectional(
              bottom: 10,
              start: 12,
              child: Row(
                children: [
                  const Icon(
                    Icons.place_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    campaign.location.of(urdu),
                    style: context.text.labelMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              bottom: 10,
              end: 12,
              child: Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    s.daysLeft(campaign.daysLeft),
                    style: context.text.labelMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageHeight == null) Expanded(child: photo) else photo,
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign.title.of(urdu),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleMedium,
                ),
                SizedBox(height: urdu ? 6 : 12),
                GradientProgressBar(value: campaign.progress),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rs(campaign.raised),
                            textDirection: TextDirection.ltr,
                            style: AppTheme.figure(15.5, color: palette.strong),
                          ),
                          Text(
                            '${s.goal} ${rs(campaign.goal)}',
                            style: context.text.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${campaign.percent}%',
                      style: AppTheme.figure(15.5, color: palette.brand),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageChip extends StatelessWidget {
  const _ImageChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: context.isUrdu ? 2 : 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: context.text.labelMedium?.copyWith(
              color: AppColors.slate800,
            ),
          ),
        ],
      ),
    );
  }
}
