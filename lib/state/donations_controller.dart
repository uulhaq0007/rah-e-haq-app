import 'package:flutter/foundation.dart';

import '../models/donation.dart';

/// The signed-in donor's submissions. New donations start as pending, exactly
/// like the web flow, until an admin checks the payment screenshot.
class DonationsController extends ChangeNotifier {
  DonationsController(List<Donation> initial) : _items = [...initial] {
    _sort();
  }

  final List<Donation> _items;
  int _nextNumber = 1049;

  List<Donation> get all => List.unmodifiable(_items);

  List<Donation> byStatus(DonationStatus? status) => status == null
      ? all
      : _items.where((donation) => donation.status == status).toList();

  Donation? byReference(String reference) {
    for (final donation in _items) {
      if (donation.reference == reference) return donation;
    }
    return null;
  }

  Donation? get latest => _items.isEmpty ? null : _items.first;

  int count([DonationStatus? status]) => byStatus(status).length;

  int total(DonationStatus status) =>
      byStatus(status).fold(0, (sum, donation) => sum + donation.amount);

  Donation submit({
    required int amount,
    required Cause cause,
    required PaymentMethod method,
    required String donorName,
    required String email,
    required String screenshotName,
    String phone = '',
    String message = '',
    String? campaignId,
  }) {
    final donation = Donation(
      reference: 'RAH-26-${_nextNumber++}',
      amount: amount,
      cause: cause,
      method: method,
      date: DateTime.now(),
      status: DonationStatus.pending,
      donorName: donorName,
      email: email,
      phone: phone,
      message: message,
      campaignId: campaignId,
      screenshotName: screenshotName,
    );
    _items.insert(0, donation);
    notifyListeners();
    return donation;
  }

  void _sort() => _items.sort((a, b) => b.date.compareTo(a.date));
}
