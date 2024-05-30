import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khmer_fonts/khmer_fonts.dart';
import 'package:kort_jomnorng_dai_app/widget/button.dart';

import '../../widget/background.dart';
import '../../widget/color.dart';
import '../../widget/dismiss_keyboad.dart';
import '../../widget/format_number.dart';
import '../../widget/icon.dart';

class InsertName extends StatefulWidget {
  const InsertName({super.key});

  @override
  State<InsertName> createState() => _InsertNameState();
}

class _InsertNameState extends State<InsertName> {
  final inputFocusNode = FocusNode();
  final inputController = TextEditingController();
  String amountValue = "0";

  @override
  void initState() {
    super.initState();
    amountValue = "0";
  }

  @override
  void dispose() {
    amountValue = "0";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      widgets: DismissKeyboard(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: buildAppBar(),
          body: buildBody(),
        ),
      ),
    );
  }

  buildBody() {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              insertName(),
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

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      leading: BackButton(
        color: AppColor.WHITE,
      ),
    );
  }

  insertName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextFormField(
        controller: inputController,
        focusNode: inputFocusNode,
        obscureText: false,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.done,
        style: TextStyle(
          fontSize: 26.sp,
          color: AppColor.BLUE,
          package: 'khmer_fonts',
          fontFamily: KhmerFonts.dangrek,
        ),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          labelStyle: TextStyle(
            fontSize: 26.sp,
            color: AppColor.WHITE,
            package: 'khmer_fonts',
            fontFamily: KhmerFonts.dangrek,
          ),
          hintText: 'បញ្ចូលឈ្មោះភ្ញៀវ',
          hintStyle: TextStyle(
            fontSize: 26.sp,
            color: AppColor.WHITE_60,
            package: 'khmer_fonts',
            fontFamily: KhmerFonts.dangrek,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.WHITE,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.BLUE,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.RED,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.RED,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          filled: true,
          isDense: true,
          fillColor: AppColor.PRIMARY_OPACITY,
          suffixIcon: inputController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: AppColor.WHITE,
                    size: 18,
                  ),
                  onPressed: () {
                    setState(() {
                      inputController.clear();
                    });
                  },
                )
              : null,
        ),
        onFieldSubmitted: (value) {
          // action.call();
        },
      ),
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
          onTap: () {},
        ),
        const SizedBox(width: 12),
        AppButton.smallButton(
          context,
          text: 'ដុល្លារ',
          icon: AppIcon.dollar(),
          backgroundColor: AppColor.RED_OPACITY,
          onTap: () {},
        ),
      ],
    );
  }

  amount() {
    return Center(
      child: Text(
        '${FormatNumber.formatRiel(amountValue)} រៀល',
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
                        color: AppColor.BLUE_OPACITY_40,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: AppColor.WHITE),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.backspace_rounded,
                          color: AppColor.WHITE,
                        ),
                      ),
                    )
                  : input == '.'
                      ? Container(
                          decoration: BoxDecoration(
                            color: AppColor.BLUE_OPACITY_40,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: AppColor.WHITE),
                          ),
                          child: Center(
                            child: CircleAvatar(
                              radius: 4,
                              backgroundColor: AppColor.WHITE,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: AppColor.BLUE_OPACITY_40,
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(color: AppColor.WHITE),
                          ),
                          child: Center(
                            child: Text(
                              FormatNumber.formatNumber(int.parse(input))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: AppColor.WHITE,
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
          : 'បញ្ជាក់ចំណងដៃ ${FormatNumber.formatRiel(amountValue)} រៀល',
      backgroundColor: amountValue == '0'
          ? AppColor.BLACK.withOpacity(0.7)
          : AppColor.GREEN_OPACITY,
      marginHor: 0,
      paddingVer: 24,
      radius: 0,
      border: Border(top: BorderSide(color: AppColor.WHITE_60, width: 1.5)),
      onTap: amountValue == '0'
          ? () {}
          : () {
              print(FormatNumber.formatRiel(amountValue));
            },
    );
  }
}
