import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../data/format.dart';
import '../data/sample_data.dart';
import '../models/donation.dart';
import '../state/app_scope.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/hero.dart';
import '../widgets/visuals.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final settings = context.settings;
    final donations = context.donations;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _ProfileHero(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _GroupTitle(s.myActivity),
                    _MenuCard(
                      children: [
                        _MenuTile(
                          icon: Icons.receipt_long_rounded,
                          color: AppColors.primary,
                          title: s.myDonations,
                          subtitle: s.donationsCount(donations.count()),
                          badge: donations.count(DonationStatus.pending) > 0
                              ? '${donations.count(DonationStatus.pending)} ${s.pending}'
                              : null,
                          onTap: () => context.go('/profile/donations'),
                        ),
                        _MenuTile(
                          icon: Icons.calculate_rounded,
                          color: AppColors.amber600,
                          title: s.zakatCalculator,
                          subtitle: s.ratesPill(
                            rs(settings.rates.goldPerTola),
                            rs(settings.rates.silverPerTola),
                          ),
                          onTap: () => context.go('/zakat'),
                        ),
                        _MenuTile(
                          icon: Icons.group_add_rounded,
                          color: AppColors.blue500,
                          title: s.volunteerWithUs,
                          subtitle: s.volBadge,
                          onTap: () => context.go('/volunteer'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _GroupTitle(s.preferences),
                    _MenuCard(
                      children: [
                        _PreferenceRow(
                          icon: Icons.translate_rounded,
                          color: const Color(0xFFA855F7),
                          title: s.language,
                          subtitle: s.languageHint,
                          trailing: const _LanguageSwitch(),
                        ),
                        _PreferenceRow(
                          icon: Icons.dark_mode_rounded,
                          color: AppColors.slate600,
                          title: s.darkMode,
                          subtitle: s.darkModeHint,
                          trailing: Switch(
                            value: settings.isDark,
                            onChanged: settings.setDark,
                          ),
                          onTap: settings.toggleTheme,
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _GroupTitle(s.organisation),
                    _MenuCard(
                      children: [
                        _MenuTile(
                          icon: Icons.favorite_rounded,
                          color: const Color(0xFFF43F5E),
                          title: s.aboutUs,
                          subtitle: s.aboutUsHint,
                          onTap: () => context.go('/profile/about'),
                        ),
                        _MenuTile(
                          icon: Icons.support_agent_rounded,
                          color: AppColors.emerald600,
                          title: s.contactUs,
                          subtitle: s.contactUsHint,
                          onTap: () => context.go('/profile/contact'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    const Center(child: BrandMark(size: 36, onDark: false)),
                    const SizedBox(height: 8),
                    Text(
                      s.version('1.0.0'),
                      textAlign: TextAlign.center,
                      style: context.text.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero();

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final donations = context.donations;
    final top = MediaQuery.paddingOf(context).top;
    final stats = [
      (rs(donations.total(DonationStatus.verified)), s.totalGiven),
      ('${donations.count()}', s.donationsLabel),
      ('${donations.count(DonationStatus.pending)}', s.pending),
    ];
    return HeroBackground(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, top + 18, 20, 22),
        child: Column(
          children: [
            Row(
              children: [
                const Avatar(name: SampleData.donorName, size: 64),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        SampleData.donorName,
                        style: AppTheme.figure(20, color: Colors.white),
                      ),
                      Text(
                        SampleData.donorEmail,
                        style: AppFonts.body(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                      const SizedBox(height: 6),
                      EyebrowPill(
                        label: s.donorSince(SampleData.donorSince),
                        icon: Icons.workspace_premium_rounded,
                        onDark: true,
                      ),
                    ],
                  ),
                ),
                const LanguagePill(),
              ],
            ),
            const SizedBox(height: 18),
            GlassPanel(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    for (var i = 0; i < stats.length; i++) ...[
                      if (i > 0)
                        VerticalDivider(
                          width: 1,
                          color: Colors.white.withValues(alpha: 0.16),
                        ),
                      Expanded(
                        flex: i == 0 ? 4 : 3,
                        child: Column(
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                stats[i].$1,
                                textDirection: TextDirection.ltr,
                                style: AppTheme.figure(18, color: Colors.white),
                              ),
                            ),
                            Text(
                              stats[i].$2,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupTitle extends StatelessWidget {
  const _GroupTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 4, bottom: 8),
      child: Text(
        context.isUrdu ? title : title.toUpperCase(),
        style: context.text.labelSmall,
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 70),
                child: Divider(height: 1, color: context.palette.border),
              ),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            IconTile(icon: icon, color: color, size: 40),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.text.titleSmall),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.bodySmall,
                  ),
                ],
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: context.isUrdu ? 0 : 3,
                ),
                decoration: BoxDecoration(
                  color: DonationStatus.pending
                      .color(dark)
                      .withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  badge!,
                  style: context.text.labelSmall?.copyWith(
                    color: DonationStatus.pending.color(dark),
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, color: palette.muted),
          ],
        ),
      ),
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            IconTile(icon: icon, color: color, size: 40),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.text.titleSmall),
                  Text(subtitle, style: context.text.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: 8),
            trailing,
          ],
        ),
      ),
    );
  }
}

/// EN | اردو segmented switch.
class _LanguageSwitch extends StatelessWidget {
  const _LanguageSwitch();

  @override
  Widget build(BuildContext context) {
    final settings = context.settings;
    final palette = context.palette;
    Widget option(String label, bool urdu, TextStyle style) {
      final selected = settings.isUrdu == urdu;
      return GestureDetector(
        onTap: () => settings.setUrdu(urdu),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: selected ? AppColors.brandGradient : null,
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            label,
            style: style.copyWith(
              color: selected ? Colors.white : palette.body,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: palette.surfaceAlt,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: palette.border),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            option(
              'EN',
              false,
              AppFonts.display(fontSize: 12.5, fontWeight: FontWeight.w600),
            ),
            option(
              'اردو',
              true,
              AppFonts.urdu(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
