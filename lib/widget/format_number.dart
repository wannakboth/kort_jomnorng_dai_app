import 'package:intl/intl.dart';

class FormatNumber {
  static formatWithCommas(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  static formatNumberToKhmer(String input) {
    const arabicToKhmer = {
      '0': '០',
      '1': '១',
      '2': '២',
      '3': '៣',
      '4': '៤',
      '5': '៥',
      '6': '៦',
      '7': '៧',
      '8': '៨',
      '9': '៩',
    };

    return input.split('').map((char) => arabicToKhmer[char] ?? char).join('');
  }

  static formatNumber(int number) {
    String formattedNumber = formatWithCommas(number);
    return formatNumberToKhmer(formattedNumber);
  }

  static formatDollar(String value) {
    if (value.isEmpty || value == '0') return formatNumberToKhmer('0.00');

    value = value.replaceAll(',', '');

    double number = double.tryParse(value) ?? 0;

    final format = NumberFormat('#,##0.00');
    final formatter = format.format(number);
    return formatNumberToKhmer(formatter);
  }

  static formatRiel(String value) {
    if (value.isEmpty || value == '0') return formatNumberToKhmer('000​');

    final double parsedValue = double.tryParse(value.replaceAll(',', '')) ?? 0;

    final double shiftedValue = parsedValue * 100;

    final format = NumberFormat('#,###');
    final formatter = format.format(shiftedValue);
    return formatNumberToKhmer(formatter);
  }
}
