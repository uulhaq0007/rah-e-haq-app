import 'package:flutter/material.dart';

import '../data/format.dart';
import '../data/strings.dart';
import '../models/donation.dart';
import '../state/app_scope.dart';
import '../theme.dart';

extension CauseVisuals on Cause {
  IconData get icon => switch (this) {
        Cause.general => Icons.volunteer_activism_rounded,
        Cause.zakat => Icons.mosque_rounded,
        Cause.food => Icons.restaurant_rounded,
        Cause.education => Icons.school_rounded,
        Cause.healthcare => Icons.medical_services_rounded,
        Cause.relief => Icons.health_and_safety_rounded,
      };

  Color get color => switch (this) {
        Cause.general => AppColors.primary,
        Cause.zakat => AppColors.amber600,
        Cause.food => AppColors.emerald600,
        Cause.education => const Color(0xFFA855F7),
        Cause.healthcare => const Color(0xFFF43F5E),
        Cause.relief => AppColors.blue500,
      };

  String label(S s) => s.causeNames[index];
}

extension MethodVisuals on PaymentMethod {
  IconData get icon => switch (this) {
        PaymentMethod.bank => Icons.account_balance_rounded,
        PaymentMethod.jazzcash => Icons.bolt_rounded,
        PaymentMethod.easypaisa => Icons.account_balance_wallet_rounded,
      };

  Color get color => switch (this) {
        PaymentMethod.bank => AppColors.primary,
        PaymentMethod.jazzcash => const Color(0xFFE11D48),
        PaymentMethod.easypaisa => const Color(0xFF16A34A),
      };

  String label(S s) => s.methodNames[index];
}

extension StatusVisuals on DonationStatus {
  IconData get icon => switch (this) {
        DonationStatus.pending => Icons.hourglass_top_rounded,
        DonationStatus.verified => Icons.verified_rounded,
        DonationStatus.rejected => Icons.cancel_rounded,
      };

  Color color(bool dark) => switch (this) {
        DonationStatus.pending =>
          dark ? AppColors.amber400 : AppColors.amber600,
        DonationStatus.verified =>
          dark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
        DonationStatus.rejected =>
          dark ? const Color(0xFFF87171) : AppColors.red500,
      };

  String label(S s, {bool long = false}) => switch (this) {
        DonationStatus.pending => long ? s.statusPending : s.pending,
        DonationStatus.verified => s.verified,
        DonationStatus.rejected => s.rejected,
      };
}

/// Coloured pill showing a donation's verification status.
class StatusBadge extends StatelessWidget {
  const StatusBadge(this.status, {super.key, this.long = false});

  final DonationStatus status;
  final bool long;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final color = status.color(dark);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 9,
        vertical: context.isUrdu ? 1 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: dark ? 0.16 : 0.1),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            status.label(context.s, long: long),
            style: context.text.labelSmall?.copyWith(
              color: color,
              letterSpacing: 0,
              fontSize: context.isUrdu ? 11 : 11.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// A drawn stand-in for a payment confirmation screenshot. The app never
/// touches real receipts; this illustration is what the mock picker attaches.
class ReceiptPreview extends StatelessWidget {
  const ReceiptPreview({
    super.key,
    required this.method,
    required this.amount,
    required this.transactionId,
  });

  final PaymentMethod method;
  final int amount;
  final String transactionId;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: 180,
          height: 320,
          child: _ReceiptArt(
            method: method,
            amount: amount,
            transactionId: transactionId,
          ),
        ),
      ),
    );
  }
}

class _ReceiptArt extends StatelessWidget {
  const _ReceiptArt({
    required this.method,
    required this.amount,
    required this.transactionId,
  });

  final PaymentMethod method;
  final int amount;
  final String transactionId;

  @override
  Widget build(BuildContext context) {
    final color = method.color;
    Widget line(double width, {double opacity = 0.12}) => Container(
          width: width,
          height: 7,
          margin: const EdgeInsets.only(bottom: 9),
          decoration: BoxDecoration(
            color: AppColors.slate900.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(4),
          ),
        );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.slate200),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              height: 64,
              width: double.infinity,
              color: color,
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(method.icon, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    const S(false).methodNames[method.index],
                    style: AppFonts.display(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -22),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Icon(Icons.check_circle_rounded,
                    color: Color(0xFF16A34A), size: 38),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -14),
              child: Column(
                children: [
                  Text(
                    const S(false).transferSuccessful,
                    style: AppFonts.body(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.slate500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rs(amount),
                    style: AppFonts.display(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.slate900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'TID $transactionId',
                    style: AppFonts.body(
                      fontSize: 9.5,
                      color: AppColors.slate400,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final width in [120.0, 90.0, 132.0, 70.0, 110.0])
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [line(width * 0.4, opacity: 0.08), line(width * 0.5)],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Initials in a gradient disc.
class Avatar extends StatelessWidget {
  const Avatar({super.key, required this.name, this.size = 64});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final initials = name
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.amber400, AppColors.amber600],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 3),
      ),
      child: Text(
        initials,
        style: AppTheme.figure(size * 0.34, color: Colors.white),
      ),
    );
  }
}

/// Big green tick used on success states.
class SuccessBadge extends StatelessWidget {
  const SuccessBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.6, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
      child: Container(
        width: 104,
        height: 104,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accent.withValues(alpha: 0.14),
        ),
        child: Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.accent, AppColors.emerald600],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 44),
        ),
      ),
    );
  }
}
