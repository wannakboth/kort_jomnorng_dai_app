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

  static formatNumberToNormal(String input) {
    const khmerToArabic = {
      '០': '1',
      '១': '2',
      '២': '3',
      '៣': '4',
      '៤': '5',
      '៥': '6',
      '៦': '7',
      '៧': '8',
      '៨': '9',
      '៩': '0',
    };

    return input.split('').map((char) => khmerToArabic[char] ?? char).join('');
  }

  static formatNumber(int number) {
    String formattedNumber = formatWithCommas(number);
    return formatNumberToKhmer(formattedNumber);
  }

  static formatCurrency(String value, String currency) {
    if (currency == 'ដុល្លារ') {
      if (value.isEmpty || value == '0') return formatNumberToKhmer('0.00');

      value = value.replaceAll(',', '');

      double number = double.tryParse(value) ?? 0;

      final format = NumberFormat('#,##0.00');
      final formatter = format.format(number);
      return formatNumberToKhmer(formatter);
    }

    if (currency == 'រៀល') {
      if (value.isEmpty || value == '0') return formatNumberToKhmer('0​');

      final double parsedValue =
          double.tryParse(value.replaceAll(',', '')) ?? 0;

      final double shiftedValue = parsedValue * 100;

      final format = NumberFormat('#,###');
      final formatter = format.format(shiftedValue);
      return formatNumberToKhmer(formatter);
    }
  }

  static sentCurrency(String value, String currency) {
    if (currency == 'រៀល') {
      return formatNumberToNormal((int.parse(value) * 100).toString());
    }
    if (currency == 'ដុល្លារ') {
      final format = NumberFormat('#.00');
      final formatter = format.format(int.parse(value));
      return formatNumberToNormal(formatter);
    }
  }
}
