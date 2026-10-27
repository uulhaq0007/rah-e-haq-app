import 'strings.dart';

/// Groups digits with commas the way the web platform's `toLocaleString()`
/// does: 1850000 -> 1,850,000.
String groupDigits(num value) {
  final negative = value < 0;
  final digits = value.abs().round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return '${negative ? '-' : ''}$buffer';
}

/// Rupee amount, e.g. `Rs. 5,000`.
String rs(num value) => 'Rs. ${groupDigits(value)}';

/// Short counter used in the hero stats: 15000 -> 15K.
String compact(int value) {
  if (value >= 1000000) return '${_trim(value / 1000000)}M';
  if (value >= 1000) return '${_trim(value / 1000)}K';
  return '$value';
}

/// A decimal with at most [digits] places and no trailing zeros.
String decimal(double value, {int digits = 2}) => _trim(value, digits: digits);

String _trim(double value, {int digits = 1}) {
  var text = value.toStringAsFixed(digits);
  if (text.contains('.')) {
    text = text.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }
  return text;
}

/// 25 Oct 2026 / 25 اکتوبر 2026
String formatDate(DateTime date, S s) =>
    '${date.day} ${s.months[date.month - 1]} ${date.year}';

/// 6:42 PM
String formatTime(DateTime date) {
  final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final minute = date.minute.toString().padLeft(2, '0');
  return '$hour:$minute ${date.hour < 12 ? 'AM' : 'PM'}';
}

/// Parses user input such as "1,50,000" or "12.5" into a number.
double parseAmount(String text) =>
    double.tryParse(text.replaceAll(',', '').trim()) ?? 0;
