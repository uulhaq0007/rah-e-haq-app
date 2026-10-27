import 'package:flutter/material.dart';

import '../data/format.dart';
import '../data/sample_data.dart';
import '../models/donation.dart';
import '../state/app_scope.dart';
import '../theme.dart';
import 'common.dart';
import 'visuals.dart';

/// Submitted → under review → verified/rejected, mirroring the admin flow.
class VerificationTimeline extends StatelessWidget {
  const VerificationTimeline({super.key, required this.donation});

  final Donation donation;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final palette = context.palette;
    final status = donation.status;
    final green = DonationStatus.verified.color(dark);
    final amber = DonationStatus.pending.color(dark);
    final red = DonationStatus.rejected.color(dark);
    String when(DateTime? date) =>
        date == null ? '' : '${formatDate(date, s)} · ${formatTime(date)}';

    final steps = [
      _Step(
        title: s.timelineSubmitted,
        subtitle: when(donation.date),
        icon: Icons.check_rounded,
        color: green,
        state: _StepState.done,
      ),
      _Step(
        title: s.timelineReview,
        subtitle: status == DonationStatus.pending ? s.pendingInfo : '',
        icon: status == DonationStatus.pending
            ? Icons.hourglass_top_rounded
            : Icons.check_rounded,
        color: status == DonationStatus.pending ? amber : green,
        state: status == DonationStatus.pending
            ? _StepState.current
            : _StepState.done,
      ),
      _Step(
        title: status == DonationStatus.rejected
            ? s.timelineRejected
            : s.timelineVerified,
        subtitle: when(donation.reviewedAt),
        icon: status == DonationStatus.rejected
            ? Icons.close_rounded
            : Icons.verified_rounded,
        color: switch (status) {
          DonationStatus.pending => palette.muted,
          DonationStatus.verified => green,
          DonationStatus.rejected => red,
        },
        state: status == DonationStatus.pending
            ? _StepState.upcoming
            : _StepState.done,
      ),
    ];

    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 30,
                  child: Column(
                    children: [
                      _Dot(step: steps[i]),
                      if (i < steps.length - 1)
                        Expanded(
                          child: Container(
                            width: 2,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            color: steps[i].state == _StepState.done &&
                                    steps[i + 1].state != _StepState.upcoming
                                ? green.withValues(alpha: 0.5)
                                : palette.border,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 3,
                      bottom: i < steps.length - 1 ? 16 : 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          steps[i].title,
                          style: context.text.titleSmall?.copyWith(
                            color: steps[i].state == _StepState.upcoming
                                ? palette.muted
                                : palette.strong,
                          ),
                        ),
                        if (steps[i].subtitle.isNotEmpty)
                          Text(steps[i].subtitle, style: context.text.bodySmall),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

enum _StepState { done, current, upcoming }

class _Step {
  const _Step({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.state,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final _StepState state;
}

class _Dot extends StatelessWidget {
  const _Dot({required this.step});

  final _Step step;

  @override
  Widget build(BuildContext context) {
    final upcoming = step.state == _StepState.upcoming;
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: upcoming ? Colors.transparent : step.color.withValues(alpha: 0.14),
        border: Border.all(
          color: upcoming ? context.palette.border : step.color,
          width: step.state == _StepState.current ? 2 : 1.5,
        ),
      ),
      child: Icon(step.icon, size: 16, color: step.color),
    );
  }
}

/// One row of the donation history.
class DonationTile extends StatelessWidget {
  const DonationTile({super.key, required this.donation, required this.onTap});

  final Donation donation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final urdu = context.isUrdu;
    final palette = context.palette;
    final campaign = SampleData.campaignById(donation.campaignId);
    final title = campaign?.title.of(urdu) ?? donation.cause.label(s);

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      radius: 20,
      child: Row(
        children: [
          IconTile(icon: donation.cause.icon, color: donation.cause.color, size: 46),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  '${formatDate(donation.date, s)} · ${donation.method.label(s)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                rs(donation.amount),
                textDirection: TextDirection.ltr,
                style: AppTheme.figure(14.5, color: palette.strong),
              ),
              const SizedBox(height: 5),
              StatusBadge(donation.status),
            ],
          ),
        ],
      ),
    );
  }
}
