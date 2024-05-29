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
}
