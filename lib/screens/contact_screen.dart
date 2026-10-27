import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../state/app_scope.dart';
import '../theme.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import '../widgets/visuals.dart';

/// Contact details, working hours and a message form.
class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key, this.sent = false});

  /// Opens on the "message sent" confirmation.
  final bool sent;

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _name = TextEditingController(text: SampleData.donorName);
  final _email = TextEditingController(text: SampleData.donorEmail);
  final _subject = TextEditingController();
  final _message = TextEditingController();

  late bool _sent = widget.sent;
  bool _sending = false;
  bool _showErrors = false;

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void initState() {
    super.initState();
    for (final controller in [_name, _email, _message]) {
      controller.addListener(_onChanged);
    }
  }

  void _onChanged() {
    if (_showErrors) setState(() {});
  }

  @override
  void dispose() {
    for (final controller in [_name, _email, _subject, _message]) {
      controller.dispose();
    }
    super.dispose();
  }

  bool get _valid =>
      _name.text.trim().isNotEmpty &&
      _emailPattern.hasMatch(_email.text.trim()) &&
      _message.text.trim().isNotEmpty;

  Future<void> _send() async {
    FocusScope.of(context).unfocus();
    if (!_valid) {
      setState(() => _showErrors = true);
      return;
    }
    setState(() => _sending = true);
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() {
      _sending = false;
      _sent = true;
      _showErrors = false;
    });
  }

  void _writeAnother() {
    setState(() {
      _subject.clear();
      _message.clear();
      _sent = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final palette = context.palette;

    return Scaffold(
      appBar: AppBar(title: Text(s.contactUs)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: [
          EyebrowPill(label: s.contactUs, icon: Icons.support_agent_rounded),
          const SizedBox(height: 10),
          HighlightTitle(
            lead: s.contactTitleLead,
            highlight: s.contactTitleHighlight,
          ),
          const SizedBox(height: 8),
          Text(s.contactSubtitle, style: context.text.bodyMedium),
          const SizedBox(height: 18),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final phone in SampleData.phones) ...[
                  CopyRow(label: s.phone, value: phone),
                  const SizedBox(height: 8),
                ],
                CopyRow(label: s.email, value: SampleData.contactEmail),
                const SizedBox(height: 8),
                Text(
                  s.tapToCopy,
                  textAlign: TextAlign.center,
                  style: context.text.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconTile(
                      icon: Icons.schedule_rounded,
                      color: palette.brand,
                      size: 36,
                    ),
                    const SizedBox(width: 10),
                    Text(s.hoursLabel, style: context.text.titleMedium),
                  ],
                ),
                const SizedBox(height: 8),
                DetailRow(
                  label: s.mondayFriday,
                  value: SampleData.hoursWeekdays,
                  figure: true,
                ),
                DetailRow(
                  label: s.saturday,
                  value: SampleData.hoursSaturday,
                  figure: true,
                ),
                DetailRow(
                  label: s.sunday,
                  value: s.closed,
                  valueStyle: context.text.titleSmall?.copyWith(
                    color: AppColors.red500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _sent ? _sentCard(context) : _formCard(context),
          ),
        ],
      ),
    );
  }

  Widget _formCard(BuildContext context) {
    final s = context.s;
    String? error(bool invalid) => _showErrors && invalid ? '' : null;
    return AppCard(
      key: const ValueKey('form'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(s.sendUsMessage, style: context.text.titleMedium),
          const SizedBox(height: 14),
          AppTextField(
            controller: _name,
            label: s.fullName,
            required: true,
            errorText: error(_name.text.trim().isEmpty),
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _email,
            label: s.email,
            required: true,
            ltr: true,
            keyboardType: TextInputType.emailAddress,
            errorText: error(!_emailPattern.hasMatch(_email.text.trim())),
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _subject,
            label: s.subject,
            optional: s.optional,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _message,
            label: s.message,
            required: true,
            maxLines: 4,
            errorText: error(_message.text.trim().isEmpty),
          ),
          if (_showErrors && !_valid) ...[
            const SizedBox(height: 14),
            ErrorBanner(s.errContact),
          ],
          const SizedBox(height: 18),
          AppButton(
            label: _sending ? s.sending : s.sendMessage,
            icon: Icons.send_rounded,
            loading: _sending,
            onPressed: _send,
          ),
        ],
      ),
    );
  }

  Widget _sentCard(BuildContext context) {
    final s = context.s;
    return AppCard(
      key: const ValueKey('sent'),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        children: [
          const SuccessBadge(),
          const SizedBox(height: 14),
          Text(s.messageSentTitle, style: context.text.headlineSmall),
          const SizedBox(height: 6),
          Text(
            s.messageSentBody,
            textAlign: TextAlign.center,
            style: context.text.bodyMedium,
          ),
          const SizedBox(height: 18),
          AppButton(
            label: s.writeAnother,
            icon: Icons.edit_rounded,
            variant: AppButtonVariant.outline,
            onPressed: _writeAnother,
          ),
        ],
      ),
    );
  }
}
