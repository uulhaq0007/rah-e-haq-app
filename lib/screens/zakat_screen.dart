import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../data/format.dart';
import '../models/zakat.dart';
import '../state/app_scope.dart';
import '../theme.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import '../widgets/hero.dart';

/// Zakat calculator with a live result. Same maths as the web backend:
/// metals valued per tola, silver-standard nisab, 2.5% of net wealth.
class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key, this.demo = false, this.openRates = false});

  /// Opens filled in with a typical household, for screenshots.
  final bool demo;

  /// Opens with the rates sheet showing.
  final bool openRates;

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  final _gold = TextEditingController();
  final _silver = TextEditingController();
  final _cash = TextEditingController();
  final _savings = TextEditingController();
  final _business = TextEditingController();
  final _debts = TextEditingController();

  List<TextEditingController> get _all => [
    _gold,
    _silver,
    _cash,
    _savings,
    _business,
    _debts,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.demo) {
      _gold.text = '40';
      _silver.text = '150';
      _cash.text = groupDigits(250000);
      _savings.text = groupDigits(600000);
      _business.text = groupDigits(400000);
      _debts.text = groupDigits(150000);
    }
    for (final controller in _all) {
      controller.addListener(_recalculate);
    }
    if (widget.openRates) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _editRates());
    }
  }

  @override
  void dispose() {
    for (final controller in _all) {
      controller.dispose();
    }
    super.dispose();
  }

  void _recalculate() => setState(() {});

  ZakatInput get _input => ZakatInput(
    goldGrams: parseAmount(_gold.text),
    silverGrams: parseAmount(_silver.text),
    cash: parseAmount(_cash.text),
    savings: parseAmount(_savings.text),
    business: parseAmount(_business.text),
    liabilities: parseAmount(_debts.text),
  );

  void _reset() {
    for (final controller in _all) {
      controller.clear();
    }
    FocusScope.of(context).unfocus();
  }

  Future<void> _editRates() => showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const RatesSheet(),
  );

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final rates = context.settings.rates;
    final input = _input;
    final result = calculateZakat(input, rates);
    final hasInput = !input.isEmpty;
    final palette = context.palette;

    final gramFormatter = [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
    ];
    const rupeeFormatter = [GroupedDigitsFormatter()];

    Widget metalHelper(double tolas, int value) => Text(
      s.tolaEquivalent(decimal(tolas), rs(value)),
      style: context.text.bodySmall?.copyWith(color: palette.brand),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ZakatHero(
                result: result,
                hasInput: hasInput,
                rates: rates,
                onEditRates: _editRates,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _InputSection(
                      title: s.metalsTitle,
                      hint: s.metalsHint,
                      icon: Icons.diamond_rounded,
                      color: AppColors.amber600,
                      children: [
                        AppTextField(
                          controller: _gold,
                          label: s.gold,
                          hint: '0',
                          ltr: true,
                          suffixText: s.grams,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: gramFormatter,
                          helper: input.goldGrams > 0
                              ? metalHelper(input.goldTolas, result.goldValue)
                              : null,
                        ),
                        AppTextField(
                          controller: _silver,
                          label: s.silver,
                          hint: '0',
                          ltr: true,
                          suffixText: s.grams,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: gramFormatter,
                          helper: input.silverGrams > 0
                              ? metalHelper(
                                  input.silverTolas,
                                  result.silverValue,
                                )
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _InputSection(
                      title: s.cashTitle,
                      hint: s.cashHint,
                      icon: Icons.payments_rounded,
                      color: AppColors.emerald600,
                      children: [
                        AppTextField(
                          controller: _cash,
                          label: s.cashInHand,
                          hint: '0',
                          ltr: true,
                          prefixText: 'Rs. ',
                          keyboardType: TextInputType.number,
                          inputFormatters: rupeeFormatter,
                        ),
                        AppTextField(
                          controller: _savings,
                          label: s.bankSavings,
                          hint: '0',
                          ltr: true,
                          prefixText: 'Rs. ',
                          keyboardType: TextInputType.number,
                          inputFormatters: rupeeFormatter,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _InputSection(
                      title: s.businessTitle,
                      hint: s.businessHint,
                      icon: Icons.storefront_rounded,
                      color: AppColors.blue500,
                      children: [
                        AppTextField(
                          controller: _business,
                          label: s.businessAssets,
                          hint: '0',
                          ltr: true,
                          prefixText: 'Rs. ',
                          keyboardType: TextInputType.number,
                          inputFormatters: rupeeFormatter,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _InputSection(
                      title: s.liabilitiesTitle,
                      hint: s.liabilitiesHint,
                      icon: Icons.receipt_long_rounded,
                      color: AppColors.red500,
                      children: [
                        AppTextField(
                          controller: _debts,
                          label: s.debtsDue,
                          hint: '0',
                          ltr: true,
                          prefixText: 'Rs. ',
                          keyboardType: TextInputType.number,
                          inputFormatters: rupeeFormatter,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _Breakdown(result: result),
                    const SizedBox(height: 20),
                    AppButton(
                      label: s.donateZakat,
                      icon: Icons.favorite_rounded,
                      onPressed: result.zakatPayable > 0
                          ? () => context.go(
                              '/donate?cause=zakat&amount=${result.zakatPayable}',
                            )
                          : null,
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                      label: s.startOver,
                      icon: Icons.refresh_rounded,
                      variant: AppButtonVariant.outline,
                      onPressed: hasInput ? _reset : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      s.zakatDisclaimer,
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

class _ZakatHero extends StatelessWidget {
  const _ZakatHero({
    required this.result,
    required this.hasInput,
    required this.rates,
    required this.onEditRates,
  });

  final ZakatResult result;
  final bool hasInput;
  final ZakatRates rates;
  final VoidCallback onEditRates;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final urdu = context.isUrdu;
    final top = MediaQuery.paddingOf(context).top;
    final white70 = Colors.white.withValues(alpha: 0.72);

    return HeroBackground(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, top + 12, 20, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: EyebrowPill(
                      label: s.zakatBadge,
                      icon: Icons.balance_rounded,
                      onDark: true,
                    ),
                  ),
                ),
                GlassIconButton(
                  icon: Icons.tune_rounded,
                  tooltip: s.editRates,
                  onPressed: onEditRates,
                ),
              ],
            ),
            const SizedBox(height: 12),
            HighlightTitle(
              lead: s.zakatTitleLead,
              highlight: s.zakatTitleHighlight,
              style: context.text.headlineMedium,
              color: Colors.white,
              highlightColor: AppColors.amber400,
            ),
            const SizedBox(height: 16),
            GlassPanel(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    urdu ? s.payable : s.payable.toUpperCase(),
                    style: context.text.labelSmall?.copyWith(color: white70),
                  ),
                  const SizedBox(height: 2),
                  TweenAnimationBuilder<double>(
                    tween: Tween(end: result.zakatPayable.toDouble()),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) => Text(
                      rs(value),
                      textDirection: TextDirection.ltr,
                      style: AppTheme.figure(
                        38,
                        color: Colors.white,
                        height: 1.15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasInput ? s.payableNote : s.zakatEmpty,
                    style: context.text.bodySmall?.copyWith(color: white70),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _HeroFigure(
                          label: s.netWorth,
                          value: rs(result.netWorth),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        color: Colors.white.withValues(alpha: 0.16),
                      ),
                      Expanded(
                        child: _HeroFigure(
                          label: s.nisab,
                          value: rs(result.nisabValue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GradientProgressBar(
                    value: result.nisabProgress,
                    height: 6,
                    gradient: AppColors.amberGradient,
                    trackColor: Colors.white.withValues(alpha: 0.14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    s.nisabBasis,
                    style: context.text.bodySmall?.copyWith(color: white70),
                  ),
                  if (hasInput) ...[
                    const SizedBox(height: 12),
                    _EligibilityNote(eligible: result.isEligible),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onEditRates,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.monetization_on_rounded,
                        size: 17,
                        color: AppColors.amber400,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          s.ratesPill(
                            rs(rates.goldPerTola),
                            rs(rates.silverPerTola),
                          ),
                          style: context.text.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                      Text(
                        s.editRates,
                        style: context.text.labelMedium?.copyWith(
                          color: AppColors.amber300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroFigure extends StatelessWidget {
  const _HeroFigure({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.text.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: context.isUrdu ? 6 : 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            value,
            textDirection: TextDirection.ltr,
            style: AppTheme.figure(17, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _EligibilityNote extends StatelessWidget {
  const _EligibilityNote({required this.eligible});

  final bool eligible;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final color = eligible ? const Color(0xFF4ADE80) : AppColors.amber300;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            eligible ? Icons.check_circle_rounded : Icons.info_rounded,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              eligible ? s.eligible : s.notEligible,
              style: context.text.bodySmall?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputSection extends StatelessWidget {
  const _InputSection({
    required this.title,
    required this.hint,
    required this.icon,
    required this.color,
    required this.children,
  });

  final String title;
  final String hint;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconTile(icon: icon, color: color, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.text.titleMedium),
                    Text(hint, style: context.text.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          for (final child in children) ...[const SizedBox(height: 14), child],
        ],
      ),
    );
  }
}

class _Breakdown extends StatelessWidget {
  const _Breakdown({required this.result});

  final ZakatResult result;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final palette = context.palette;
    return AppCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(s.breakdown, style: context.text.titleMedium),
          const SizedBox(height: 6),
          DetailRow(label: s.gold, value: rs(result.goldValue), figure: true),
          DetailRow(
            label: s.silver,
            value: rs(result.silverValue),
            figure: true,
          ),
          DetailRow(
            label: s.cashAndBank,
            value: rs(result.cash + result.savings),
            figure: true,
          ),
          DetailRow(
            label: s.businessTitle,
            value: rs(result.business),
            figure: true,
          ),
          DetailRow(
            label: s.debts,
            value: rs(-result.liabilities),
            figure: true,
            valueStyle: AppTheme.figure(
              14,
              weight: FontWeight.w600,
              color: AppColors.red500,
            ),
          ),
          const SoftDivider(height: 18),
          DetailRow(
            label: s.totalAssets,
            value: rs(result.totalAssets),
            figure: true,
          ),
          DetailRow(
            label: s.netWorth,
            value: rs(result.netWorth),
            figure: true,
            valueStyle: AppTheme.figure(15, color: palette.strong),
          ),
          DetailRow(
            label: s.nisab,
            value: rs(result.nisabValue),
            figure: true,
            valueStyle: AppTheme.figure(
              14,
              weight: FontWeight.w500,
              color: palette.muted,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: palette.brandSoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${s.payable} (2.5%)',
                    style: context.text.titleSmall?.copyWith(
                      color: palette.brand,
                    ),
                  ),
                ),
                Text(
                  rs(result.zakatPayable),
                  textDirection: TextDirection.ltr,
                  style: AppTheme.figure(18, color: palette.brand),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Edits the gold and silver prices the nisab is worked out from.
class RatesSheet extends StatefulWidget {
  const RatesSheet({super.key});

  @override
  State<RatesSheet> createState() => _RatesSheetState();
}

class _RatesSheetState extends State<RatesSheet> {
  late final TextEditingController _gold;
  late final TextEditingController _silver;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    final rates = SettingsScope.read(context).rates;
    _gold = TextEditingController(text: groupDigits(rates.goldPerTola))
      ..addListener(_changed);
    _silver = TextEditingController(text: groupDigits(rates.silverPerTola))
      ..addListener(_changed);
  }

  @override
  void dispose() {
    _gold.dispose();
    _silver.dispose();
    super.dispose();
  }

  void _changed() => setState(() => _showError = false);

  int get _goldValue => parseAmount(_gold.text).round();
  int get _silverValue => parseAmount(_silver.text).round();

  void _apply(ZakatRates rates) {
    final settings = SettingsScope.read(context);
    final messenger = ScaffoldMessenger.of(context);
    final message = settings.strings.ratesSaved;
    settings.updateRates(rates);
    Navigator.of(context).pop();
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _save() {
    if (_goldValue <= 0 || _silverValue <= 0) {
      setState(() => _showError = true);
      return;
    }
    _apply(ZakatRates(goldPerTola: _goldValue, silverPerTola: _silverValue));
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final palette = context.palette;
    final nisab = (silverNisabTola * _silverValue).round();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const IconTile(
                    icon: Icons.price_change_rounded,
                    color: AppColors.amber600,
                    size: 44,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.ratesTitle, style: context.text.titleLarge),
                        Text(s.ratesHint, style: context.text.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              AppTextField(
                controller: _gold,
                label: s.goldPrice,
                ltr: true,
                prefixText: 'Rs. ',
                keyboardType: TextInputType.number,
                inputFormatters: const [GroupedDigitsFormatter()],
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _silver,
                label: s.silverPrice,
                ltr: true,
                prefixText: 'Rs. ',
                keyboardType: TextInputType.number,
                inputFormatters: const [GroupedDigitsFormatter()],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: palette.surfaceAlt,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: palette.border),
                ),
                child: Column(
                  children: [
                    DetailRow(
                      label: s.nisab,
                      value: rs(nisab),
                      figure: true,
                      valueStyle: AppTheme.figure(15, color: palette.brand),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        '${s.nisabBasis} · ${s.tolaNote}',
                        style: context.text.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              if (_showError) ...[
                const SizedBox(height: 14),
                ErrorBanner(s.errRates),
              ],
              const SizedBox(height: 18),
              AppButton(
                label: s.saveRates,
                icon: Icons.check_rounded,
                onPressed: _save,
              ),
              const SizedBox(height: 10),
              AppButton(
                label: s.resetRates,
                icon: Icons.restart_alt_rounded,
                variant: AppButtonVariant.outline,
                onPressed: () => _apply(ZakatRates.defaults),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
