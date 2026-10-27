import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../data/format.dart';
import '../data/sample_data.dart';
import '../models/campaign.dart';
import '../models/donation.dart';
import '../state/app_scope.dart';
import '../theme.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import '../widgets/donation_tile.dart';
import '../widgets/visuals.dart';

/// Manual donation flow, as on the web: transfer the money, screenshot the
/// confirmation, then submit it for an admin to verify.
class DonateScreen extends StatefulWidget {
  const DonateScreen({
    super.key,
    this.campaignId,
    this.cause,
    this.amount,
    this.demo = false,
    this.showSuccess = false,
  });

  final String? campaignId;
  final Cause? cause;
  final int? amount;

  /// Opens with the form filled in, for screenshots.
  final bool demo;

  /// Opens on the confirmation of the most recent submission.
  final bool showSuccess;

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

/// The payment screenshot the donor picked in the mock picker.
class _Attachment {
  const _Attachment({
    required this.fileName,
    required this.sizeKb,
    required this.method,
    required this.amount,
    required this.transactionId,
  });

  final String fileName;
  final int sizeKb;
  final PaymentMethod method;
  final int amount;
  final String transactionId;
}

class _DonateScreenState extends State<DonateScreen> {
  final _amount = TextEditingController();
  final _name = TextEditingController(text: SampleData.donorName);
  final _email = TextEditingController(text: SampleData.donorEmail);
  final _phone = TextEditingController();
  final _message = TextEditingController();

  Cause _cause = Cause.general;
  Campaign? _campaign;
  PaymentMethod _method = PaymentMethod.bank;
  _Attachment? _attachment;
  bool _showErrors = false;
  bool _submitting = false;
  Donation? _submitted;

  @override
  void initState() {
    super.initState();
    _amount.addListener(_onAmountChanged);
    _applyParams();
    if (widget.demo) _fillDemo();
    if (widget.showSuccess) _submitted = DonationsScope.read(context).latest;
  }

  @override
  void didUpdateWidget(DonateScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Arriving from a campaign, a programme or the Zakat result pre-fills
    // the form even if this tab was already open.
    if (oldWidget.campaignId != widget.campaignId ||
        oldWidget.cause != widget.cause ||
        oldWidget.amount != widget.amount) {
      _submitted = null;
      _applyParams();
    }
  }

  @override
  void dispose() {
    for (final controller in [_amount, _name, _email, _phone, _message]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onAmountChanged() => setState(() {});

  void _applyParams() {
    _campaign = SampleData.campaignById(widget.campaignId);
    if (_campaign != null) _cause = _campaign!.cause;
    if (widget.cause != null) _cause = widget.cause!;
    if (widget.amount != null && widget.amount! > 0) {
      _amount.text = groupDigits(widget.amount!);
    }
  }

  void _fillDemo() {
    _campaign = SampleData.campaigns.first;
    _cause = _campaign!.cause;
    _amount.text = groupDigits(5000);
    _method = PaymentMethod.jazzcash;
    _phone.text = SampleData.donorPhone;
    _attachment = const _Attachment(
      fileName: 'IMG_2041.jpg',
      sizeKb: 248,
      method: PaymentMethod.jazzcash,
      amount: 5000,
      transactionId: '4829 1037 55',
    );
  }

  int get _amountValue => parseAmount(_amount.text).round();

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  String? _amountError(BuildContext context) =>
      _showErrors && _amountValue <= 0 ? context.s.errAmount : null;
  String? _nameError(BuildContext context) =>
      _showErrors && _name.text.trim().isEmpty ? context.s.errName : null;
  String? _emailError(BuildContext context) =>
      _showErrors && !_emailPattern.hasMatch(_email.text.trim())
      ? context.s.errEmail
      : null;
  String? _screenshotError(BuildContext context) =>
      _showErrors && _attachment == null ? context.s.errScreenshot : null;

  bool get _isValid =>
      _amountValue > 0 &&
      _name.text.trim().isNotEmpty &&
      _emailPattern.hasMatch(_email.text.trim()) &&
      _attachment != null;

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_isValid) {
      setState(() => _showErrors = true);
      return;
    }
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    final donation = DonationsScope.read(context).submit(
      amount: _amountValue,
      cause: _cause,
      method: _method,
      donorName: _name.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
      message: _message.text.trim(),
      campaignId: _campaign?.id,
      screenshotName: _attachment!.fileName,
    );
    setState(() {
      _submitting = false;
      _showErrors = false;
      _submitted = donation;
    });
  }

  void _reset() {
    setState(() {
      _submitted = null;
      _amount.clear();
      _message.clear();
      _attachment = null;
      _campaign = null;
      _cause = Cause.general;
      _method = PaymentMethod.bank;
      _showErrors = false;
    });
  }

  Future<void> _pickScreenshot() async {
    final amount = _amountValue > 0 ? _amountValue : 5000;
    final options = [
      _Attachment(
        fileName: 'IMG_2041.jpg',
        sizeKb: 248,
        method: _method,
        amount: amount,
        transactionId: '4829 1037 55',
      ),
      const _Attachment(
        fileName: 'Screenshot_1026.png',
        sizeKb: 312,
        method: PaymentMethod.bank,
        amount: 2000,
        transactionId: '7710 2290 18',
      ),
      const _Attachment(
        fileName: 'IMG_1988.jpg',
        sizeKb: 196,
        method: PaymentMethod.easypaisa,
        amount: 1000,
        transactionId: '3305 8812 40',
      ),
    ];
    final picked = await showModalBottomSheet<_Attachment>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        final s = sheetContext.s;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.pickerTitle, style: sheetContext.text.titleLarge),
                const SizedBox(height: 4),
                Text(s.pickerSubtitle, style: sheetContext.text.bodyMedium),
                const SizedBox(height: 18),
                Row(
                  children: [
                    for (var i = 0; i < options.length; i++) ...[
                      if (i > 0) const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () =>
                              Navigator.of(sheetContext).pop(options[i]),
                          child: Column(
                            children: [
                              ReceiptPreview(
                                method: options[i].method,
                                amount: options[i].amount,
                                transactionId: options[i].transactionId,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                options[i].fileName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textDirection: TextDirection.ltr,
                                style: AppFonts.body(
                                  fontSize: 11,
                                  color: sheetContext.palette.muted,
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
        );
      },
    );
    if (picked != null) setState(() => _attachment = picked);
  }

  @override
  Widget build(BuildContext context) {
    final submitted = _submitted;
    if (submitted != null) {
      return _DonateSuccess(donation: submitted, onAnother: _reset);
    }
    final s = context.s;

    final firstError = [
      _amountError(context),
      _nameError(context),
      _emailError(context),
      _screenshotError(context),
    ].whereType<String>().firstOrNull;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(onHistory: () => context.go('/profile/donations')),
                const SizedBox(height: 16),
                const _StepsStrip(),
                const SizedBox(height: 16),
                _AmountCard(
                  controller: _amount,
                  amount: _amountValue,
                  error: _amountError(context),
                ),
                const SizedBox(height: 16),
                _FormSection(
                  title: s.causeTitle,
                  icon: Icons.favorite_rounded,
                  child: Column(
                    children: [
                      if (_campaign != null) ...[
                        _CampaignBanner(
                          campaign: _campaign!,
                          onClear: () => setState(() => _campaign = null),
                        ),
                        const SizedBox(height: 12),
                      ],
                      _CauseGrid(
                        selected: _cause,
                        onSelected: (cause) => setState(() {
                          _cause = cause;
                          if (_campaign?.cause != cause) _campaign = null;
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _FormSection(
                  title: s.methodTitle,
                  icon: Icons.account_balance_wallet_rounded,
                  child: _MethodPicker(
                    selected: _method,
                    onSelected: (method) => setState(() => _method = method),
                  ),
                ),
                const SizedBox(height: 16),
                _FormSection(
                  title: s.detailsTitle,
                  icon: Icons.person_rounded,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _name,
                        label: s.fullName,
                        required: true,
                        errorText: _nameError(context),
                        prefixIcon: Icons.person_outline_rounded,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _email,
                        label: s.email,
                        required: true,
                        ltr: true,
                        keyboardType: TextInputType.emailAddress,
                        errorText: _emailError(context),
                        prefixIcon: Icons.alternate_email_rounded,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _phone,
                        label: s.phone,
                        optional: s.optional,
                        ltr: true,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_outlined,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _message,
                        label: s.message,
                        optional: s.optional,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _FormSection(
                  title: s.screenshotTitle,
                  icon: Icons.image_rounded,
                  child: _ScreenshotField(
                    attachment: _attachment,
                    hasError: _screenshotError(context) != null,
                    onPick: _pickScreenshot,
                    onRemove: () => setState(() => _attachment = null),
                  ),
                ),
                if (firstError != null) ...[
                  const SizedBox(height: 16),
                  ErrorBanner(firstError),
                ],
                const SizedBox(height: 20),
                AppButton(
                  label: _submitting ? s.submitting : s.submitDonation,
                  icon: Icons.upload_rounded,
                  loading: _submitting,
                  onPressed: _submit,
                ),
                const SizedBox(height: 12),
                Text(
                  s.donateDisclaimer,
                  textAlign: TextAlign.center,
                  style: context.text.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onHistory});

  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EyebrowPill(
                    label: s.donateBadge,
                    icon: Icons.favorite_rounded,
                  ),
                  const SizedBox(height: 10),
                  HighlightTitle(
                    lead: s.donateTitleLead,
                    highlight: s.donateTitleHighlight,
                    style: context.text.headlineMedium,
                  ),
                ],
              ),
            ),
            Tooltip(
              message: s.myDonations,
              child: Material(
                color: palette.surface,
                shape: CircleBorder(side: BorderSide(color: palette.border)),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onHistory,
                  child: SizedBox.square(
                    dimension: 44,
                    child: Icon(
                      Icons.receipt_long_rounded,
                      color: palette.brand,
                      size: 21,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(s.donateSubtitle, style: context.text.bodyMedium),
      ],
    );
  }
}

class _StepsStrip extends StatelessWidget {
  const _StepsStrip();

  @override
  Widget build(BuildContext context) {
    final steps = context.s.donateSteps;
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: palette.muted,
                ),
              ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: AppTheme.figure(
                        12.5,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    steps[i],
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: context.text.labelMedium?.copyWith(
                      color: palette.strong,
                      height: context.isUrdu ? 1.5 : 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.controller,
    required this.amount,
    required this.error,
  });

  final TextEditingController controller;
  final int amount;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final urdu = context.isUrdu;
    final tier = SampleData.tierFor(amount);
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.emerald800.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            end: -70,
            top: -70,
            child: Container(
              width: 200,
              height: 200,
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
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  urdu ? s.amountTitle : s.amountTitle.toUpperCase(),
                  style: context.text.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Rs.',
                        style: AppTheme.figure(
                          22,
                          weight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          inputFormatters: const [GroupedDigitsFormatter()],
                          cursorColor: AppColors.amber300,
                          style: AppTheme.figure(38, color: Colors.white),
                          decoration: InputDecoration(
                            filled: false,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 6,
                            ),
                            hintText: '0',
                            hintStyle: AppTheme.figure(
                              38,
                              color: Colors.white.withValues(alpha: 0.35),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.18),
                ),
                if (error != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    error!,
                    style: context.text.bodySmall?.copyWith(
                      color: AppColors.amber300,
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final quick in SampleData.quickAmounts)
                      SelectChip(
                        label: rs(quick),
                        selected: amount == quick,
                        figure: true,
                        showCheck: false,
                        onDark: true,
                        onTap: () => controller.text = groupDigits(quick),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  child: tier == null
                      ? Text(
                          s.customAmountHint,
                          style: context.text.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.14),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.volunteer_activism_rounded,
                                color: AppColors.amber400,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${s.impactLabel}: ',
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.7,
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: tier.impact.of(urdu),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: context.text.bodySmall,
                                ),
                              ),
                            ],
                          ),
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

class _FormSection extends StatelessWidget {
  const _FormSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconTile(icon: icon, color: palette.brand, size: 32),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: context.text.titleMedium)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _CampaignBanner extends StatelessWidget {
  const _CampaignBanner({required this.campaign, required this.onClear});

  final Campaign campaign;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final urdu = context.isUrdu;
    final palette = context.palette;
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 4, 8),
      decoration: BoxDecoration(
        color: palette.brandSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              campaign.image,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.forCampaign(campaign.title.of(urdu)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.titleSmall,
                ),
                Text(
                  '${campaign.location.of(urdu)} · ${s.percentFunded(campaign.percent)}',
                  style: context.text.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClear,
            tooltip: s.removeFile,
            icon: Icon(Icons.close_rounded, color: palette.body, size: 20),
          ),
        ],
      ),
    );
  }
}

class _CauseGrid extends StatelessWidget {
  const _CauseGrid({required this.selected, required this.onSelected});

  final Cause selected;
  final ValueChanged<Cause> onSelected;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final palette = context.palette;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: context.isUrdu ? 92 : 86,
      ),
      itemCount: Cause.values.length,
      itemBuilder: (context, index) {
        final cause = Cause.values[index];
        final isSelected = cause == selected;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected
                ? cause.color.withValues(alpha: 0.1)
                : palette.surfaceAlt,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? cause.color : palette.border,
              width: isSelected ? 1.8 : 1,
            ),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => onSelected(cause),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconTile(
                    icon: cause.icon,
                    color: cause.color,
                    size: 36,
                    solid: isSelected,
                  ),
                  const SizedBox(height: 7),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      cause.label(s),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: context.text.labelMedium?.copyWith(
                        color: isSelected ? palette.strong : palette.body,
                        height: context.isUrdu ? 1.5 : 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MethodPicker extends StatelessWidget {
  const _MethodPicker({required this.selected, required this.onSelected});

  final PaymentMethod selected;
  final ValueChanged<PaymentMethod> onSelected;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final palette = context.palette;
    final rows = switch (selected) {
      PaymentMethod.bank => [
        CopyRow(label: s.iban, value: SampleData.bankIban),
        CopyRow(label: s.accountTitle, value: SampleData.bankAccountTitle),
        CopyRow(label: s.bankName, value: SampleData.bankName),
      ],
      PaymentMethod.jazzcash => [
        CopyRow(label: s.mobileNumber, value: SampleData.jazzcashNumber),
        CopyRow(label: s.accountName, value: SampleData.jazzcashName),
      ],
      PaymentMethod.easypaisa => [
        CopyRow(label: s.mobileNumber, value: SampleData.easypaisaNumber),
        CopyRow(label: s.accountName, value: SampleData.easypaisaName),
      ],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (final method in PaymentMethod.values) ...[
              if (method.index > 0) const SizedBox(width: 10),
              Expanded(
                child: _MethodTile(
                  method: method,
                  selected: method == selected,
                  onTap: () => onSelected(method),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 14),
        Text(
          s.transferTo,
          style: context.text.bodySmall?.copyWith(color: palette.body),
        ),
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: Column(
            key: ValueKey(selected),
            children: [
              for (final row in rows) ...[row, const SizedBox(height: 8)],
            ],
          ),
        ),
      ],
    );
  }
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected ? palette.brandSoft : palette.surfaceAlt,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? palette.brand : palette.border,
          width: selected ? 1.8 : 1,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            child: Column(
              children: [
                IconTile(
                  icon: method.icon,
                  color: method.color,
                  size: 34,
                  solid: true,
                ),
                const SizedBox(height: 7),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    method.label(context.s),
                    maxLines: 1,
                    style: context.text.labelMedium?.copyWith(
                      color: selected ? palette.strong : palette.body,
                      height: context.isUrdu ? 1.5 : 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScreenshotField extends StatelessWidget {
  const _ScreenshotField({
    required this.attachment,
    required this.hasError,
    required this.onPick,
    required this.onRemove,
  });

  final _Attachment? attachment;
  final bool hasError;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final palette = context.palette;
    final file = attachment;

    if (file == null) {
      return DashedBorder(
        color: hasError
            ? AppColors.red500
            : palette.muted.withValues(alpha: 0.6),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onPick,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: palette.brandSoft,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add_photo_alternate_rounded,
                      color: palette.brand,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    s.uploadPrompt,
                    textAlign: TextAlign.center,
                    style: context.text.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    s.uploadHint,
                    textAlign: TextAlign.center,
                    style: context.text.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: palette.surfaceAlt,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: palette.brand.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 62,
            child: ReceiptPreview(
              method: file.method,
              amount: file.amount,
              transactionId: file.transactionId,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.accent,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        file.fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.start,
                        style: AppTheme.figure(
                          14,
                          weight: FontWeight.w600,
                          color: palette.strong,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${file.sizeKb} KB · ${file.method.label(s)}',
                  style: context.text.bodySmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _SmallAction(
                      icon: Icons.swap_horiz_rounded,
                      label: s.changeFile,
                      onTap: onPick,
                    ),
                    const SizedBox(width: 8),
                    _SmallAction(
                      icon: Icons.delete_outline_rounded,
                      label: s.removeFile,
                      onTap: onRemove,
                      color: AppColors.red500,
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

class _SmallAction extends StatelessWidget {
  const _SmallAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final foreground = color ?? context.palette.brand;
    return Material(
      color: foreground.withValues(alpha: 0.1),
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: context.isUrdu ? 2 : 7,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: foreground),
              const SizedBox(width: 5),
              Text(
                label,
                style: context.text.labelMedium?.copyWith(color: foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DonateSuccess extends StatelessWidget {
  const _DonateSuccess({required this.donation, required this.onAnother});

  final Donation donation;
  final VoidCallback onAnother;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final urdu = context.isUrdu;
    final palette = context.palette;
    final campaign = SampleData.campaignById(donation.campaignId);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: SuccessBadge()),
              const SizedBox(height: 18),
              Text(
                s.donateSuccessTitle,
                textAlign: TextAlign.center,
                style: context.text.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                s.donateSuccessBody,
                textAlign: TextAlign.center,
                style: context.text.bodyMedium,
              ),
              const SizedBox(height: 14),
              Center(child: StatusBadge(donation.status, long: true)),
              const SizedBox(height: 22),
              AppCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.reference, style: context.text.bodySmall),
                              Text(
                                donation.reference,
                                textDirection: TextDirection.ltr,
                                style: AppTheme.figure(
                                  18,
                                  color: palette.strong,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton.filledTonal(
                          tooltip: s.copyReference,
                          style: IconButton.styleFrom(
                            backgroundColor: palette.brandSoft,
                            foregroundColor: palette.brand,
                          ),
                          onPressed: () => copyToClipboard(
                            context,
                            donation.reference,
                            s.reference,
                          ),
                          icon: const Icon(
                            Icons.content_copy_rounded,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    const SoftDivider(),
                    DetailRow(
                      label: s.amountLabel,
                      value: rs(donation.amount),
                      figure: true,
                      valueStyle: AppTheme.figure(16, color: palette.brand),
                    ),
                    DetailRow(
                      label: s.causeLabel,
                      value: donation.cause.label(s),
                    ),
                    if (campaign != null)
                      DetailRow(
                        label: s.campaignLabel,
                        value: campaign.title.of(urdu),
                      ),
                    DetailRow(
                      label: s.methodLabel,
                      value: donation.method.label(s),
                    ),
                    DetailRow(
                      label: s.dateLabel,
                      value:
                          '${formatDate(donation.date, s)} · ${formatTime(donation.date)}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              AppCard(child: VerificationTimeline(donation: donation)),
              const SizedBox(height: 22),
              AppButton(
                label: s.viewDonations,
                icon: Icons.receipt_long_rounded,
                onPressed: () => context.go('/profile/donations'),
              ),
              const SizedBox(height: 10),
              AppButton(
                label: s.anotherDonation,
                icon: Icons.add_rounded,
                variant: AppButtonVariant.outline,
                onPressed: onAnother,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
