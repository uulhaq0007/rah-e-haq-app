import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../data/format.dart';
import '../data/sample_data.dart';
import '../models/campaign.dart';
import '../state/app_scope.dart';
import '../theme.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import '../widgets/visuals.dart';

class CampaignDetailScreen extends StatelessWidget {
  const CampaignDetailScreen({super.key, required this.campaignId});

  final String campaignId;

  @override
  Widget build(BuildContext context) {
    final campaign =
        SampleData.campaignById(campaignId) ?? SampleData.campaigns.first;
    final s = context.s;
    final urdu = context.isUrdu;
    final palette = context.palette;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 290,
              pinned: true,
              stretch: true,
              backgroundColor: AppColors.emerald800,
              foregroundColor: Colors.white,
              leading: Padding(
                padding: const EdgeInsetsDirectional.only(start: 12),
                child: _CircleButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () =>
                      context.canPop() ? context.pop() : context.go('/'),
                ),
              ),
              actions: [
                _CircleButton(
                  icon: Icons.ios_share_rounded,
                  onTap: () => _share(context, campaign),
                ),
                const SizedBox(width: 12),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(campaign.image, fit: BoxFit.cover),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x990F172A),
                            Color(0x000F172A),
                            Color(0x000F172A),
                            Color(0xB30F172A),
                          ],
                          stops: [0, 0.3, 0.6, 1],
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      start: 20,
                      end: 20,
                      bottom: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _Tag(
                                icon: campaign.cause.icon,
                                label: campaign.cause.label(s),
                              ),
                              const SizedBox(width: 8),
                              _Tag(
                                icon: Icons.place_rounded,
                                label: campaign.location.of(urdu),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            campaign.title.of(urdu),
                            style: context.text.headlineSmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              sliver: SliverList.list(
                children: [
                  _ProgressCard(campaign: campaign),
                  const SizedBox(height: 24),
                  Text(s.aboutCampaign, style: context.text.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    campaign.summary.of(urdu),
                    style: context.text.bodyLarge?.copyWith(
                      color: palette.strong,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(campaign.story.of(urdu), style: context.text.bodyLarge),
                  const SizedBox(height: 24),
                  Text(s.yourImpact, style: context.text.titleLarge),
                  const SizedBox(height: 12),
                  for (final use in campaign.uses) ...[
                    _UseTile(campaign: campaign, use: use),
                    const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: palette.brandSoft,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.verified_user_rounded,
                          color: palette.brand,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            s.verifiedNote,
                            style: context.text.bodyMedium?.copyWith(
                              color: palette.strong,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _DonateBar(
          onPressed: () => context.go('/donate?campaign=${campaign.id}'),
        ),
      ),
    );
  }

  Future<void> _share(BuildContext context, Campaign campaign) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = context.s.linkCopied;
    try {
      await Clipboard.setData(
        ClipboardData(
          text: 'https://rah-e-haq.example/campaign/${campaign.id}',
        ),
      );
    } on PlatformException {
      // Clipboard can be unavailable; nothing else to do.
    }
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.campaign});

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final palette = context.palette;
    final stats = [
      ('${campaign.percent}%', s.funded),
      ('${campaign.donors}', s.donorsLabel),
      ('${campaign.daysLeft}', s.daysLeftLabel),
    ];
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.raised, style: context.text.bodySmall),
                    Text(
                      rs(campaign.raised),
                      textDirection: TextDirection.ltr,
                      style: AppTheme.figure(26, color: palette.brand),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(s.goal, style: context.text.bodySmall),
                  Text(
                    rs(campaign.goal),
                    textDirection: TextDirection.ltr,
                    style: AppTheme.figure(15, color: palette.strong),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          GradientProgressBar(value: campaign.progress, height: 10),
          const SizedBox(height: 8),
          Text(
            s.stillNeeded(rs(campaign.remaining)),
            style: context.text.bodySmall,
          ),
          const SoftDivider(height: 28),
          Row(
            children: [
              for (final stat in stats)
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        stat.$1,
                        textDirection: TextDirection.ltr,
                        style: AppTheme.figure(19, color: palette.strong),
                      ),
                      Text(stat.$2, style: context.text.bodySmall),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UseTile extends StatelessWidget {
  const _UseTile({required this.campaign, required this.use});

  final Campaign campaign;
  final CampaignUse use;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      padding: const EdgeInsets.all(12),
      radius: 18,
      shadow: false,
      onTap: () =>
          context.go('/donate?campaign=${campaign.id}&amount=${use.amount}'),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: palette.brandSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              rs(use.amount),
              textDirection: TextDirection.ltr,
              style: AppTheme.figure(13.5, color: palette.brand),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              use.label.of(context.isUrdu),
              style: context.text.bodyMedium,
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: palette.muted),
        ],
      ),
    );
  }
}

class _DonateBar extends StatelessWidget {
  const _DonateBar({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: AppButton(
            label: context.s.donateToCampaign,
            icon: Icons.favorite_rounded,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.black.withValues(alpha: 0.32),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox.square(
            dimension: 40,
            child: Icon(icon, color: Colors.white, size: 21),
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: context.isUrdu ? 1 : 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            label,
            style: context.text.labelMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
