import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khmer_fonts/khmer_fonts.dart';

import 'button.dart';
import 'color.dart';
import 'format_number.dart';
import 'icon.dart';

class InputNumMonitor extends StatefulWidget {
  const InputNumMonitor({super.key, required this.name});

  final Widget name;

  @override
  State<InputNumMonitor> createState() => _InputNumMonitorState();
}

class _InputNumMonitorState extends State<InputNumMonitor> {
  String amountValue = "0";
  String currency = '';

  @override
  void initState() {
    super.initState();
    amountValue = "0";
    currency = 'រៀល';
  }

  @override
  void dispose() {
    amountValue = "0";
    currency = 'រៀល';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.name,
              chooseCurrency(),
              amount(),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: numberKeyboard(
            value: amountValue,
            callback: (val) {
              setState(() {
                amountValue = val;
              });
            },
          ),
        ),
        confirmButton(),
      ],
    );
  }

  chooseCurrency() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppButton.smallButton(
          context,
          text: 'រៀល',
          icon: AppIcon.riel(),
          backgroundColor: AppColor.PRIMARY_OPACITY,
          borderColor: currency == 'រៀល' ? AppColor.WHITE : AppColor.WHITE_60,
          shadow: [
            BoxShadow(
              color: AppColor.SHADOW,
              spreadRadius: currency == 'រៀល' ? 4 : 0,
              blurRadius: 4,
            ),
          ],
          onTap: () {
            setState(() {
              currency = 'រៀល';
            });
          },
        ),
        const SizedBox(width: 12),
        AppButton.smallButton(
          context,
          text: 'ដុល្លារ',
          icon: AppIcon.dollar(),
          backgroundColor: AppColor.RED_OPACITY,
          borderColor:
              currency == 'ដុល្លារ' ? AppColor.WHITE : AppColor.WHITE_60,
          shadow: [
            BoxShadow(
              color: AppColor.SHADOW,
              spreadRadius: currency == 'ដុល្លារ' ? 4 : 0,
              blurRadius: 4,
            ),
          ],
          onTap: () {
            setState(() {
              currency = 'ដុល្លារ';
            });
          },
        ),
      ],
    );
  }

  amount() {
    return Center(
      child: Text(
        '${FormatNumber.formatCurrency(amountValue, currency)} ${currency}',
        style: TextStyle(
          color: AppColor.WHITE,
          fontSize: 42,
          fontWeight: FontWeight.w400,
          package: 'khmer_fonts',
          fontFamily: KhmerFonts.dangrek,
        ),
      ),
    );
  }

  List vrKeyboard = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '.',
    '0',
    '<',
  ];

  calculate(String input, String value) {
    if (!value.contains('.') && input != '.') {
      if ((value.length >= 8) && input != '<') {
        return value;
      }
    }

    if (input == '.' && (value.contains('.'))) return value;

    if (input == '<' && value.length == 1) {
      value = '0';
      return value;
    }
    if (input == '<' && value.length > 1) {
      value = value.substring(0, value.length - 1);
      return value;
    }
    if (input == '0' && value == '0') return value;
    if (input == '.' && value == '0') {
      value += input;
      return value;
    }
    if (value.contains('.') && value.indexOf('.') == value.length - 3) {
      return value;
    }
    if (input != '<' && value == '0') {
      value = input;
      return value;
    }
    if (input != '<' && value != '0') {
      value += input;
      return value;
    }
    return value;
  }

  numberKeyboard({
    required String value,
    required Function(String) callback,
  }) {
    return Center(
      child: GridView.count(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 1.1,
        padding: const EdgeInsets.symmetric(horizontal: 50),
        children: vrKeyboard.map(
          (input) {
            return TextButton(
              onPressed: () {
                callback(
                  calculate(input, value),
                );
              },
              child: input == '<'
                  ? Container(
                      decoration: BoxDecoration(
                        color: AppColor.WHITE.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: AppColor.BLUE),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.backspace_rounded,
                          color: AppColor.BLUE,
                        ),
                      ),
                    )
                  : input == '.'
                      ? Container(
                          decoration: BoxDecoration(
                            color: AppColor.WHITE.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: AppColor.BLUE),
                          ),
                          child: Center(
                            child: CircleAvatar(
                              radius: 4,
                              backgroundColor: AppColor.BLUE,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: AppColor.WHITE.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: AppColor.BLUE),
                          ),
                          child: Center(
                            child: Text(
                              FormatNumber.formatNumber(int.parse(input))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: AppColor.BLUE,
                                package: 'khmer_fonts',
                                fontFamily: KhmerFonts.dangrek,
                              ),
                            ),
                          ),
                        ),
            );
          },
        ).toList(),
      ),
    );
  }

  confirmButton() {
    return AppButton.longButton(
      context,
      text: amountValue == '0'
          ? 'សូមវាយបញ្ចូលចំនួនទឹកប្រាក់'
          : 'បញ្ជាក់ចំណងដៃ ${FormatNumber.formatCurrency(amountValue, currency)} $currency',
      backgroundColor: amountValue == '0'
          ? AppColor.BLACK.withOpacity(0.6)
          : AppColor.GREEN_OPACITY,
      marginHor: 0,
      paddingVer: 24,
      radius: 0,
      border: Border(top: BorderSide(color: AppColor.WHITE_60, width: 1.5)),
      onTap: amountValue == '0' ? () {} : () {},
    );
  }
}
