import 'localized.dart';

/// Purposes a donation can be earmarked for. Mirrors the `purpose` enum of the
/// web backend's Donation model.
enum Cause { general, zakat, food, education, healthcare, relief }

/// Ways a donor can transfer money before uploading the screenshot.
enum PaymentMethod { bank, jazzcash, easypaisa }

/// Donations only count toward totals once an admin has checked the
/// payment screenshot.
enum DonationStatus { pending, verified, rejected }

class Donation {
  const Donation({
    required this.reference,
    required this.amount,
    required this.cause,
    required this.method,
    required this.date,
    required this.status,
    required this.donorName,
    required this.email,
    this.phone = '',
    this.message = '',
    this.campaignId,
    this.screenshotName = 'payment-screenshot.jpg',
    this.reviewedAt,
    this.reviewNote,
  });

  final String reference;
  final int amount;
  final Cause cause;
  final PaymentMethod method;
  final DateTime date;
  final DonationStatus status;
  final String donorName;
  final String email;
  final String phone;
  final String message;
  final String? campaignId;
  final String screenshotName;
  final DateTime? reviewedAt;
  final Localized? reviewNote;
}
