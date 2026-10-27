import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/format.dart';
import '../models/donation.dart';
import '../state/app_scope.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/donation_tile.dart';
import '../widgets/visuals.dart';

/// The donor's submissions with their verification status.
class DonationsScreen extends StatefulWidget {
  const DonationsScreen({super.key, this.filter});

  final DonationStatus? filter;

  @override
  State<DonationsScreen> createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
  late DonationStatus? _filter = widget.filter;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final donations = context.donations;
    final visible = donations.byStatus(_filter);
    final filters = <(DonationStatus?, String)>[
      (null, s.all),
      (DonationStatus.pending, s.pending),
      (DonationStatus.verified, s.verified),
      (DonationStatus.rejected, s.rejected),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(s.myDonations),
        actions: [
          IconButton(
            tooltip: s.newDonation,
            onPressed: () => context.go('/donate'),
            icon: Icon(
              Icons.add_circle_rounded,
              color: context.palette.brand,
              size: 28,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        children: [
          const _SummaryCard(),
          const SizedBox(height: 18),
          SizedBox(
            height: context.isUrdu ? 40 : 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: filters.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final (status, label) = filters[index];
                return SelectChip(
                  label: '$label  ${donations.count(status)}',
                  selected: _filter == status,
                  showCheck: false,
                  onTap: () => setState(() => _filter = status),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          if (visible.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  Icon(
                    Icons.inbox_rounded,
                    size: 48,
                    color: context.palette.muted,
                  ),
                  const SizedBox(height: 8),
                  Text(s.emptyList, style: context.text.bodyMedium),
                ],
              ),
            )
          else
            for (final donation in visible) ...[
              DonationTile(
                donation: donation,
                onTap: () =>
                    context.go('/profile/donations/${donation.reference}'),
              ),
              const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final donations = context.donations;
    final white70 = Colors.white.withValues(alpha: 0.72);
    final breakdown = [
      (DonationStatus.verified, donations.total(DonationStatus.verified)),
      (DonationStatus.pending, donations.total(DonationStatus.pending)),
      (DonationStatus.rejected, donations.total(DonationStatus.rejected)),
    ];
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.emerald800.withValues(alpha: 0.3),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            end: -60,
            top: -60,
            child: Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.3),
                    AppColors.secondary.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.isUrdu
                            ? s.totalGiven
                            : s.totalGiven.toUpperCase(),
                        style: context.text.labelSmall?.copyWith(
                          color: white70,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.verified_rounded,
                      size: 18,
                      color: DonationStatus.verified.color(true),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  rs(donations.total(DonationStatus.verified)),
                  textDirection: TextDirection.ltr,
                  style: AppTheme.figure(34, color: Colors.white, height: 1.15),
                ),
                Text(
                  '${s.donationsCount(donations.count())} · ${s.countsNote}',
                  style: context.text.bodySmall?.copyWith(color: white70),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    for (var i = 0; i < breakdown.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    breakdown[i].$1.icon,
                                    size: 13,
                                    color: breakdown[i].$1.color(true),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      breakdown[i].$1.label(s),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.text.bodySmall?.copyWith(
                                        color: white70,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  rs(breakdown[i].$2),
                                  textDirection: TextDirection.ltr,
                                  style: AppTheme.figure(
                                    14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
