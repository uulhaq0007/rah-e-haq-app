import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/format.dart';
import '../data/sample_data.dart';
import '../models/donation.dart';
import '../state/app_scope.dart';
import '../theme.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import '../widgets/donation_tile.dart';
import '../widgets/hero.dart';
import '../widgets/visuals.dart';

/// Receipt for one submission, with its verification timeline.
class DonationDetailScreen extends StatelessWidget {
  const DonationDetailScreen({super.key, required this.reference});

  final String reference;

  void _back(BuildContext context) =>
      context.canPop() ? context.pop() : context.go('/profile/donations');

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final donation = context.donations.byReference(reference);
    final palette = context.palette;

    if (donation == null) {
      return Scaffold(
        appBar: AppBar(title: Text(s.receiptTitle)),
        body: Center(child: Text(s.emptyList, style: context.text.bodyLarge)),
      );
    }

    final prefill =
        '/donate?cause=${donation.cause.name}&amount=${donation.amount}'
        '${donation.campaignId == null ? '' : '&campaign=${donation.campaignId}'}';

    final Widget action = switch (donation.status) {
      DonationStatus.pending => AppButton(
        label: s.copyReference,
        icon: Icons.content_copy_rounded,
        variant: AppButtonVariant.outline,
        onPressed: () =>
            copyToClipboard(context, donation.reference, s.reference),
      ),
      DonationStatus.verified => AppButton(
        label: s.donateAgain,
        icon: Icons.favorite_rounded,
        onPressed: () => context.go(prefill),
      ),
      DonationStatus.rejected => AppButton(
        label: s.resubmit,
        icon: Icons.upload_rounded,
        onPressed: () => context.go(prefill),
      ),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(s.receiptTitle),
        leading: IconButton(
          tooltip: s.back,
          onPressed: () => _back(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          IconButton(
            tooltip: s.copyReference,
            onPressed: () =>
                copyToClipboard(context, donation.reference, s.reference),
            icon: Icon(Icons.content_copy_rounded, color: palette.brand),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          _Ticket(donation: donation),
          const SizedBox(height: 16),
          if (donation.status == DonationStatus.rejected &&
              donation.reviewNote != null) ...[
            _Note(
              color: DonationStatus.rejected.color(
                Theme.of(context).brightness == Brightness.dark,
              ),
              icon: Icons.feedback_rounded,
              title: s.adminNote,
              body: donation.reviewNote!.of(context.isUrdu),
            ),
            const SizedBox(height: 16),
          ],
          if (donation.status == DonationStatus.verified) ...[
            _Note(
              color: DonationStatus.verified.color(
                Theme.of(context).brightness == Brightness.dark,
              ),
              icon: Icons.volunteer_activism_rounded,
              title: s.verified,
              body: s.verifiedInfo,
            ),
            const SizedBox(height: 16),
          ],
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.statusLabel, style: context.text.titleMedium),
                const SizedBox(height: 14),
                VerificationTimeline(donation: donation),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                SizedBox(
                  width: 58,
                  child: ReceiptPreview(
                    method: donation.method,
                    amount: donation.amount,
                    transactionId: donation.reference
                        .replaceAll('RAH-', '')
                        .replaceAll('-', ' '),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.screenshotTitle, style: context.text.titleSmall),
                      const SizedBox(height: 2),
                      Text(
                        donation.screenshotName,
                        textDirection: TextDirection.ltr,
                        style: AppFonts.body(
                          fontSize: 12.5,
                          color: palette.body,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 15,
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            donation.method.label(s),
                            style: context.text.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: palette.surface,
          border: Border(top: BorderSide(color: palette.border)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: action,
          ),
        ),
      ),
    );
  }
}

class _Ticket extends StatelessWidget {
  const _Ticket({required this.donation});

  final Donation donation;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final urdu = context.isUrdu;
    final palette = context.palette;
    final campaign = SampleData.campaignById(donation.campaignId);
    final white70 = Colors.white.withValues(alpha: 0.72);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: palette.border),
        boxShadow: palette.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(gradient: AppColors.heroGradient),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const BrandMark(size: 34, showName: false),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          s.appName,
                          style: context.text.titleSmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: StatusBadge(donation.status, long: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    urdu ? s.amountLabel : s.amountLabel.toUpperCase(),
                    style: context.text.labelSmall?.copyWith(color: white70),
                  ),
                  Text(
                    rs(donation.amount),
                    textDirection: TextDirection.ltr,
                    style: AppTheme.figure(
                      34,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    campaign?.title.of(urdu) ?? donation.cause.label(s),
                    style: context.text.bodyMedium?.copyWith(color: white70),
                  ),
                ],
              ),
            ),
          ),
          _Perforation(background: palette.background, line: palette.border),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 16),
            child: Column(
              children: [
                DetailRow(
                  label: s.reference,
                  value: donation.reference,
                  figure: true,
                ),
                DetailRow(
                  label: s.dateLabel,
                  value:
                      '${formatDate(donation.date, s)} · ${formatTime(donation.date)}',
                ),
                DetailRow(label: s.causeLabel, value: donation.cause.label(s)),
                if (campaign != null)
                  DetailRow(
                    label: s.campaignLabel,
                    value: campaign.title.of(urdu),
                  ),
                DetailRow(
                  label: s.methodLabel,
                  value: donation.method.label(s),
                ),
                DetailRow(label: s.donorLabel, value: donation.donorName),
                DetailRow(label: s.email, value: donation.email, figure: true),
                if (donation.message.isNotEmpty)
                  DetailRow(label: s.message, value: donation.message),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Ticket-style notches with a dashed tear line.
class _Perforation extends StatelessWidget {
  const _Perforation({required this.background, required this.line});

  final Color background;
  final Color line;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: List.generate(
                  26,
                  (_) => Expanded(
                    child: Container(
                      height: 1.5,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      color: line,
                    ),
                  ),
                ),
              ),
            ),
          ),
          for (final start in [true, false])
            PositionedDirectional(
              start: start ? -13 : null,
              end: start ? null : -13,
              top: 0,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({
    required this.color,
    required this.icon,
    required this.title,
    required this.body,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.text.titleSmall?.copyWith(color: color),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: context.text.bodyMedium?.copyWith(
                    color: context.palette.strong,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
