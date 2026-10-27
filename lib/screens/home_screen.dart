import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../data/format.dart';
import '../data/sample_data.dart';
import '../models/campaign.dart';
import '../state/app_scope.dart';
import '../theme.dart';
import '../widgets/buttons.dart';
import '../widgets/campaign_card.dart';
import '../widgets/common.dart';
import '../widgets/hero.dart';
import '../widgets/impact_strip.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Hero(),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(
                  title: s.campaignsTitle,
                  subtitle: s.campaignsSubtitle,
                  actionLabel: s.seeAll,
                  onAction: () => context.go('/campaigns'),
                ),
              ),
              const SizedBox(height: 14),
              const _CampaignCarousel(),
              const SizedBox(height: 18),
              const _Programs(),
              const SizedBox(height: 22),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ImpactStrip(),
              ),
              const SizedBox(height: 30),
              const _StorySection(),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _VolunteerCta(),
              ),
              const SizedBox(height: 22),
              const _TrustedLine(),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final settings = context.settings;
    final top = MediaQuery.paddingOf(context).top;
    const overlap = 46.0;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeroBackground(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, top + 10, 20, overlap + 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: BrandMark(),
                          ),
                        ),
                        const LanguagePill(),
                        const SizedBox(width: 8),
                        GlassIconButton(
                          icon: settings.isDark
                              ? Icons.light_mode_rounded
                              : Icons.dark_mode_rounded,
                          tooltip: s.toggleTheme,
                          onPressed: settings.toggleTheme,
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    EyebrowPill(
                      label: s.heroBadge,
                      icon: Icons.auto_awesome_rounded,
                      onDark: true,
                    ),
                    const SizedBox(height: 14),
                    HighlightTitle(
                      lead: s.heroTitleLead,
                      highlight: s.heroTitleHighlight,
                      tail: s.heroTitleTail,
                      style: context.text.displaySmall,
                      color: Colors.white,
                      highlightColor: AppColors.amber400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      s.heroSubtitle,
                      style: context.text.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.82),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          flex: 9,
                          child: AppButton(
                            label: s.heroDonate,
                            icon: Icons.favorite_rounded,
                            variant: AppButtonVariant.amber,
                            horizontalPadding: 14,
                            onPressed: () => context.go('/donate'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 11,
                          child: AppButton(
                            label: s.heroVolunteer,
                            variant: AppButtonVariant.glass,
                            horizontalPadding: 14,
                            onPressed: () => context.go('/volunteer'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
        const PositionedDirectional(
          start: 20,
          end: 20,
          bottom: 0,
          child: _StatsCard(),
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard();

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final palette = context.palette;
    final stats = [
      ('${compact(SampleData.mealsServed)}+', s.statMeals),
      ('${SampleData.volunteers}+', s.statVolunteers),
      ('${SampleData.communityEvents}+', s.statEvents),
      ('${SampleData.welfareInstitutions}', s.statInstitutions),
    ];
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < stats.length; i++) ...[
              if (i > 0) VerticalDivider(width: 1, color: palette.border),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      stats[i].$1,
                      textDirection: TextDirection.ltr,
                      style: AppTheme.figure(20, color: palette.brand),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      stats[i].$2,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: context.text.bodySmall?.copyWith(
                        height: context.isUrdu ? 1.7 : 1.25,
                        fontSize: context.isUrdu ? 10.5 : 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CampaignCarousel extends StatelessWidget {
  const _CampaignCarousel();

  @override
  Widget build(BuildContext context) {
    final urdu = context.isUrdu;
    return SizedBox(
      height: urdu ? 312 : 296,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
        itemCount: SampleData.campaigns.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final campaign = SampleData.campaigns[index];
          return SizedBox(
            width: 282,
            child: CampaignCard(
              campaign: campaign,
              onTap: () => context.go('/campaign/${campaign.id}'),
            ),
          );
        },
      ),
    );
  }
}

class _Programs extends StatelessWidget {
  const _Programs();

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final urdu = context.isUrdu;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EyebrowPill(
            label: s.programsEyebrow,
            icon: Icons.track_changes_rounded,
          ),
          const SizedBox(height: 10),
          HighlightTitle(
            lead: s.programsTitleLead,
            highlight: s.programsTitleHighlight,
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: urdu ? 176 : 158,
            ),
            itemCount: SampleData.programs.length,
            itemBuilder: (context, index) => _ProgramCard(index: index),
          ),
        ],
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final program = SampleData.programs[index];
    final urdu = context.isUrdu;
    final palette = context.palette;
    return AppCard(
      padding: const EdgeInsets.all(16),
      radius: 22,
      onTap: () => _showProgram(context, program, index),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(
            icon: program.icon,
            color: program.gradient.first,
            gradient: program.gradient,
          ),
          const SizedBox(height: 12),
          Text(
            program.title.of(urdu),
            maxLines: 2,
            style: context.text.titleSmall,
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 9,
              vertical: urdu ? 0 : 4,
            ),
            decoration: BoxDecoration(
              color: palette.brandSoft,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              program.metric.of(urdu),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.labelSmall?.copyWith(
                color: palette.brand,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProgram(BuildContext context, Program program, int index) {
    final urdu = context.isUrdu;
    final s = context.s;
    final cause = SampleData.programCauses[index];
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTile(
                icon: program.icon,
                color: program.gradient.first,
                gradient: program.gradient,
                size: 56,
              ),
              const SizedBox(height: 16),
              Text(
                program.title.of(urdu),
                style: sheetContext.text.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                program.description.of(urdu),
                style: sheetContext.text.bodyLarge,
              ),
              const SizedBox(height: 14),
              EyebrowPill(
                label: program.metric.of(urdu),
                icon: Icons.insights_rounded,
              ),
              const SizedBox(height: 24),
              AppButton(
                label: s.donateToCause,
                icon: Icons.favorite_rounded,
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  context.go('/donate?cause=${cause.name}');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StorySection extends StatelessWidget {
  const _StorySection();

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final urdu = context.isUrdu;
    final palette = context.palette;
    const story = SampleData.story;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EyebrowPill(label: s.storiesEyebrow, icon: Icons.star_rounded),
          const SizedBox(height: 10),
          HighlightTitle(
            lead: s.storiesTitleLead,
            highlight: s.storiesTitleHighlight,
          ),
          const SizedBox(height: 14),
          AppCard(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.format_quote_rounded,
                  size: 40,
                  color: palette.brand.withValues(alpha: 0.25),
                ),
                Text(
                  story.quote.of(urdu),
                  style: context.text.bodyLarge?.copyWith(
                    color: palette.strong,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: palette.brandSoft,
                      ),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(story.photo),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            story.name,
                            style: AppTheme.figure(15, color: palette.strong),
                          ),
                          Text(
                            '${story.role.of(urdu)} · ${story.location.of(urdu)}',
                            style: context.text.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (_) => const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: AppColors.secondary,
                        ),
                      ),
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

class _VolunteerCta extends StatelessWidget {
  const _VolunteerCta();

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(SampleData.missionImage, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.slate900.withValues(alpha: 0.35),
                    AppColors.emerald800.withValues(alpha: 0.9),
                    AppColors.slate900.withValues(alpha: 0.96),
                  ],
                  stops: const [0, 0.5, 1],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 96, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EyebrowPill(
                  label: s.ctaEyebrow,
                  icon: Icons.favorite_rounded,
                  onDark: true,
                ),
                const SizedBox(height: 12),
                HighlightTitle(
                  lead: s.ctaTitleLead,
                  highlight: s.ctaTitleHighlight,
                  color: Colors.white,
                  highlightColor: AppColors.amber400,
                ),
                const SizedBox(height: 8),
                Text(
                  s.ctaSubtitle,
                  style: context.text.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                  ),
                ),
                const SizedBox(height: 18),
                AppButton(
                  label: s.heroVolunteer,
                  icon: Icons.group_add_rounded,
                  variant: AppButtonVariant.amber,
                  onPressed: () => context.go('/volunteer'),
                ),
                const SizedBox(height: 10),
                AppButton(
                  label: s.heroDonate,
                  icon: Icons.favorite_rounded,
                  variant: AppButtonVariant.glass,
                  onPressed: () => context.go('/donate'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustedLine extends StatelessWidget {
  const _TrustedLine();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.star_rounded, size: 18, color: AppColors.secondary),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            context.s.trusted(groupDigits(SampleData.totalDonors)),
            textAlign: TextAlign.center,
            style: context.text.bodySmall?.copyWith(
              color: context.palette.body,
            ),
          ),
        ),
      ],
    );
  }
}
