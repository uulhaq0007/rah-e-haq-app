import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../data/sample_data.dart';
import '../models/volunteer.dart';
import '../state/app_scope.dart';
import '../theme.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import '../widgets/hero.dart';
import '../widgets/visuals.dart';

/// Three-step volunteer application: personal → skills & interests →
/// availability & motivation.
class VolunteerScreen extends StatefulWidget {
  const VolunteerScreen({
    super.key,
    this.demo = false,
    this.step,
    this.showSuccess = false,
  });

  /// Opens part-way through with earlier steps filled in.
  final bool demo;

  /// 1-based step to open on (implies demo values).
  final int? step;

  final bool showSuccess;

  @override
  State<VolunteerScreen> createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen> {
  final _form = VolunteerApplication();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _age = TextEditingController();
  final _motivation = TextEditingController();
  final _experience = TextEditingController();
  final _scroll = ScrollController();

  int _step = 0;
  bool _showErrors = false;
  bool _submitting = false;
  bool _submitted = false;

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void initState() {
    super.initState();
    if (widget.demo || widget.step != null || widget.showSuccess) {
      _fillDemo();
      _step = ((widget.step ?? 2) - 1).clamp(0, 2);
    }
    _submitted = widget.showSuccess;
    for (final controller in [_name, _email, _phone, _motivation]) {
      controller.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _name,
      _email,
      _phone,
      _age,
      _motivation,
      _experience,
    ]) {
      controller.dispose();
    }
    _scroll.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  void _fillDemo() {
    _name.text = 'Zainab Raza';
    _email.text = 'zainab.raza@example.com';
    _phone.text = '0300-7654321';
    _age.text = '24';
    _form.city = 'Lahore';
    _form.skills.addAll(['Teaching', 'Photography', 'Social Media']);
    _form.interests.addAll(['Education Support', 'Food Distribution']);
    _form.availability.addAll(['weekends', 'evenings']);
    _form.hoursPerWeek = 8;
    _motivation.text = 'I grew up near a community school in Lahore and want children there to get the same chances I had.';
    _experience.text =
        'Weekend tutor at a local learning centre for two years.';
  }

  bool get _personalValid =>
      _name.text.trim().isNotEmpty &&
      _emailPattern.hasMatch(_email.text.trim()) &&
      _phone.text.trim().length >= 7 &&
      _form.city != null;

  bool get _skillsValid =>
      _form.skills.isNotEmpty && _form.interests.isNotEmpty;

  bool get _availabilityValid =>
      _form.availability.isNotEmpty && _motivation.text.trim().isNotEmpty;

  bool get _stepValid => switch (_step) {
    0 => _personalValid,
    1 => _skillsValid,
    _ => _availabilityValid,
  };

  void _scrollToForm() {
    if (_scroll.hasClients) {
      _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _next() {
    FocusScope.of(context).unfocus();
    if (!_stepValid) {
      setState(() => _showErrors = true);
      return;
    }
    setState(() {
      _showErrors = false;
      _step++;
    });
    _scrollToForm();
  }

  void _back() {
    setState(() {
      _showErrors = false;
      _step--;
    });
    _scrollToForm();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_availabilityValid) {
      setState(() => _showErrors = true);
      return;
    }
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _submitted = true;
    });
  }

  void _restart() {
    setState(() {
      for (final controller in [
        _name,
        _email,
        _phone,
        _age,
        _motivation,
        _experience,
      ]) {
        controller.clear();
      }
      _form
        ..city = null
        ..hoursPerWeek = 6;
      _form.skills.clear();
      _form.interests.clear();
      _form.availability.clear();
      _step = 0;
      _showErrors = false;
      _submitted = false;
    });
  }

  Future<void> _pickCity() async {
    final s = context.s;
    final picked = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(s.cityHint, style: sheetContext.text.titleLarge),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 12),
                children: [
                  for (var i = 0; i < volunteerCities.length; i++)
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      leading: Icon(
                        Icons.location_city_rounded,
                        color: sheetContext.palette.muted,
                      ),
                      title: Text(
                        s.cityNames[i],
                        style: sheetContext.text.titleSmall,
                      ),
                      trailing: _form.city == volunteerCities[i]
                          ? Icon(
                              Icons.check_circle_rounded,
                              color: sheetContext.palette.brand,
                            )
                          : null,
                      onTap: () =>
                          Navigator.of(sheetContext).pop(volunteerCities[i]),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (picked != null) setState(() => _form.city = picked);
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return _VolunteerSuccess(
        form: _form,
        name: _name.text,
        onRestart: _restart,
      );
    }
    final s = context.s;
    final titles = [
      s.personalTitle,
      s.skillsStepTitle,
      s.availabilityStepTitle,
    ];
    final subtitles = [
      s.personalSubtitle,
      s.skillsStepSubtitle,
      s.availabilityStepSubtitle,
    ];
    final errors = [s.errPersonal, s.errSkills, s.errAvailability];
    final isLast = _step == 2;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SingleChildScrollView(
          controller: _scroll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _VolunteerHero(),
              Transform.translate(
                offset: const Offset(0, -34),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AppCard(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Stepper(step: _step, labels: s.volSteps),
                        const SizedBox(height: 22),
                        Text(
                          s.stepOf(_step + 1, 3),
                          style: context.text.labelMedium?.copyWith(
                            color: context.palette.brand,
                          ),
                        ),
                        Text(titles[_step], style: context.text.headlineSmall),
                        const SizedBox(height: 4),
                        Text(subtitles[_step], style: context.text.bodyMedium),
                        const SizedBox(height: 20),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: KeyedSubtree(
                            key: ValueKey(_step),
                            child: switch (_step) {
                              0 => _personalStep(context),
                              1 => _skillsStep(context),
                              _ => _availabilityStep(context),
                            },
                          ),
                        ),
                        if (_showErrors && !_stepValid) ...[
                          const SizedBox(height: 16),
                          ErrorBanner(errors[_step]),
                        ],
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            if (_step > 0) ...[
                              Expanded(
                                flex: 2,
                                child: AppButton(
                                  label: s.back,
                                  icon: Icons.arrow_back_rounded,
                                  variant: AppButtonVariant.outline,
                                  onPressed: _back,
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                            Expanded(
                              flex: 3,
                              child: isLast
                                  ? AppButton(
                                      label: s.volSubmit,
                                      icon: Icons.send_rounded,
                                      loading: _submitting,
                                      onPressed: _submit,
                                    )
                                  : AppButton(
                                      label: s.continueLabel,
                                      trailingIcon: Icons.arrow_forward_rounded,
                                      onPressed: _next,
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _personalStep(BuildContext context) {
    final s = context.s;
    final palette = context.palette;
    final cityIndex = _form.city == null
        ? -1
        : volunteerCities.indexOf(_form.city!);
    final cityMissing = _showErrors && _form.city == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _name,
          label: s.fullName,
          required: true,
          prefixIcon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: 14),
        AppTextField(
          controller: _email,
          label: s.email,
          required: true,
          ltr: true,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.alternate_email_rounded,
        ),
        const SizedBox(height: 14),
        AppTextField(
          controller: _phone,
          label: s.phone,
          required: true,
          ltr: true,
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone_outlined,
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FieldLabel(s.city, required: true),
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _pickCity,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          size: 20,
                          color: palette.muted,
                        ),
                        suffixIcon: Icon(
                          Icons.expand_more_rounded,
                          color: palette.muted,
                        ),
                        enabledBorder: cityMissing
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: AppColors.red500,
                                  width: 1.5,
                                ),
                              )
                            : null,
                      ),
                      child: Text(
                        cityIndex < 0 ? s.cityHint : s.cityNames[cityIndex],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.bodyLarge?.copyWith(
                          color: cityIndex < 0 ? palette.muted : palette.strong,
                          height: context.isUrdu ? 1.4 : 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: AppTextField(
                controller: _age,
                label: s.age,
                ltr: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _skillsStep(BuildContext context) {
    final s = context.s;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ChipGroupHeader(
          label: s.skills,
          hint: s.skillsHint,
          count: _form.skills.length,
        ),
        _ChipGroup(
          values: volunteerSkills,
          labels: s.skillOptions,
          selected: _form.skills,
          onToggle: (value) => setState(() => _toggle(_form.skills, value)),
        ),
        const SizedBox(height: 22),
        _ChipGroupHeader(label: s.interests, count: _form.interests.length),
        _ChipGroup(
          values: volunteerInterests,
          labels: s.interestOptions,
          selected: _form.interests,
          onToggle: (value) => setState(() => _toggle(_form.interests, value)),
        ),
      ],
    );
  }

  Widget _availabilityStep(BuildContext context) {
    final s = context.s;
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ChipGroupHeader(
          label: s.availability,
          count: _form.availability.length,
        ),
        _ChipGroup(
          values: volunteerAvailability,
          labels: s.availabilityOptions,
          selected: _form.availability,
          onToggle: (value) =>
              setState(() => _toggle(_form.availability, value)),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(child: FieldLabel(s.hoursPerWeek)),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                s.hoursValue(_form.hoursPerWeek.round()),
                style: context.text.labelLarge?.copyWith(color: palette.brand),
              ),
            ),
          ],
        ),
        Slider(
          value: _form.hoursPerWeek,
          min: 1,
          max: 40,
          divisions: 39,
          label: '${_form.hoursPerWeek.round()}',
          onChanged: (value) => setState(() => _form.hoursPerWeek = value),
        ),
        const SizedBox(height: 10),
        AppTextField(
          controller: _motivation,
          label: s.motivation,
          required: true,
          maxLines: 4,
        ),
        const SizedBox(height: 14),
        AppTextField(
          controller: _experience,
          label: s.experience,
          optional: s.optional,
          maxLines: 3,
        ),
      ],
    );
  }

  void _toggle(Set<String> set, String value) {
    if (!set.remove(value)) set.add(value);
  }
}

class _VolunteerHero extends StatelessWidget {
  const _VolunteerHero();

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final top = MediaQuery.paddingOf(context).top;
    final stats = [
      ('${SampleData.volunteers}+', s.activeVolunteers),
      ('${SampleData.citiesCovered}+', s.citiesCovered),
      ('100%', s.freeToJoin),
    ];
    return HeroBackground(
      image: SampleData.volunteerImage,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, top + 14, 20, 58),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EyebrowPill(
              label: s.volBadge,
              icon: Icons.groups_rounded,
              onDark: true,
            ),
            const SizedBox(height: 12),
            HighlightTitle(
              lead: s.volTitleLead,
              highlight: s.volTitleHighlight,
              style: context.text.headlineMedium,
              color: Colors.white,
              highlightColor: AppColors.amber400,
            ),
            const SizedBox(height: 6),
            Text(
              s.volSubtitle,
              style: context.text.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.82),
              ),
            ),
            const SizedBox(height: 16),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < stats.length; i++) ...[
                    if (i > 0) const SizedBox(width: 10),
                    Expanded(
                      child: GlassPanel(
                        radius: 18,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 6,
                        ),
                        child: Column(
                          children: [
                            Text(
                              stats[i].$1,
                              textDirection: TextDirection.ltr,
                              style: AppTheme.figure(18, color: Colors.white),
                            ),
                            Text(
                              stats[i].$2,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: context.text.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.72),
                                height: context.isUrdu ? 1.7 : 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.step, required this.labels});

  final int step;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    Widget item(int index) {
      final done = index < step;
      final current = index == step;
      return SizedBox(
        width: 82,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: done || current ? AppColors.brandGradient : null,
                color: done || current ? null : palette.surfaceAlt,
                border: Border.all(
                  color: current
                      ? AppColors.primary.withValues(alpha: 0.25)
                      : (done ? Colors.transparent : palette.border),
                  width: current ? 4 : 1.5,
                ),
              ),
              child: done
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 18,
                    )
                  : Text(
                      '${index + 1}',
                      style: AppTheme.figure(
                        13.5,
                        color: current ? Colors.white : palette.muted,
                        height: 1,
                      ),
                    ),
            ),
            const SizedBox(height: 6),
            Text(
              labels[index],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.labelMedium?.copyWith(
                color: done || current ? palette.strong : palette.muted,
              ),
            ),
          ],
        ),
      );
    }

    Widget line(int index) => Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 17),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 2,
          decoration: BoxDecoration(
            color: index < step ? AppColors.primary : palette.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [item(0), line(0), item(1), line(1), item(2)],
    );
  }
}

class _ChipGroupHeader extends StatelessWidget {
  const _ChipGroupHeader({required this.label, required this.count, this.hint});

  final String label;
  final String? hint;
  final int count;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.text.titleSmall),
                if (hint != null) Text(hint!, style: context.text.bodySmall),
              ],
            ),
          ),
          if (count > 0)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 9,
                vertical: context.isUrdu ? 0 : 3,
              ),
              decoration: BoxDecoration(
                color: palette.brandSoft,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                context.s.selectedCount(count),
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
}

class _ChipGroup extends StatelessWidget {
  const _ChipGroup({
    required this.values,
    required this.labels,
    required this.selected,
    required this.onToggle,
  });

  final List<String> values;
  final List<String> labels;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < values.length; i++)
          SelectChip(
            label: labels[i],
            selected: selected.contains(values[i]),
            onTap: () => onToggle(values[i]),
          ),
      ],
    );
  }
}

class _VolunteerSuccess extends StatelessWidget {
  const _VolunteerSuccess({
    required this.form,
    required this.name,
    required this.onRestart,
  });

  final VolunteerApplication form;
  final String name;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final palette = context.palette;
    final cityIndex = form.city == null
        ? -1
        : volunteerCities.indexOf(form.city!);
    final city = cityIndex < 0 ? '' : s.cityNames[cityIndex];
    String labelFor(List<String> values, List<String> labels, String value) =>
        labels[values.indexOf(value)];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: SuccessBadge()),
              const SizedBox(height: 18),
              Text(
                s.volSuccessTitle,
                textAlign: TextAlign.center,
                style: context.text.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                s.volSuccessBody,
                textAlign: TextAlign.center,
                style: context.text.bodyMedium,
              ),
              if (city.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  s.matchedCity(city),
                  textAlign: TextAlign.center,
                  style: context.text.bodyMedium?.copyWith(
                    color: palette.brand,
                  ),
                ),
              ],
              const SizedBox(height: 22),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Avatar(name: name.isEmpty ? '?' : name, size: 48),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: context.text.titleMedium),
                              Text(
                                '$city · ${s.hoursValue(form.hoursPerWeek.round())}',
                                style: context.text.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SoftDivider(height: 26),
                    Text(s.skills, style: context.text.titleSmall),
                    const SizedBox(height: 8),
                    _Pills([
                      for (final skill in form.skills)
                        labelFor(volunteerSkills, s.skillOptions, skill),
                    ]),
                    const SizedBox(height: 14),
                    Text(s.interests, style: context.text.titleSmall),
                    const SizedBox(height: 8),
                    _Pills([
                      for (final interest in form.interests)
                        labelFor(
                          volunteerInterests,
                          s.interestOptions,
                          interest,
                        ),
                    ]),
                    const SizedBox(height: 14),
                    Text(s.availability, style: context.text.titleSmall),
                    const SizedBox(height: 8),
                    _Pills([
                      for (final slot in form.availability)
                        labelFor(
                          volunteerAvailability,
                          s.availabilityOptions,
                          slot,
                        ),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              AppButton(
                label: s.backHome,
                icon: Icons.home_rounded,
                onPressed: () => context.go('/'),
              ),
              const SizedBox(height: 10),
              AppButton(
                label: s.newApplication,
                icon: Icons.refresh_rounded,
                variant: AppButtonVariant.outline,
                onPressed: onRestart,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pills extends StatelessWidget {
  const _Pills(this.labels);

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final label in labels)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: context.isUrdu ? 1 : 5,
            ),
            decoration: BoxDecoration(
              color: palette.brandSoft,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              label,
              style: context.text.labelMedium?.copyWith(color: palette.brand),
            ),
          ),
      ],
    );
  }
}
