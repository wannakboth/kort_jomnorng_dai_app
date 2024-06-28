import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khmer_fonts/khmer_fonts.dart';
import 'package:kort_jomnorng_dai_app/widget/stroke_text.dart';
import 'package:quickalert/quickalert.dart';
import '../../service/controller.dart';
import '../../service/create_model.dart';
import '../../widget/app_widget.dart';
import '../../widget/background.dart';
import '../../widget/button.dart';
import '../../widget/color.dart';
import '../../widget/dismiss_keyboad.dart';
import '../../widget/format_number.dart';
import '../../widget/go_navigate.dart';
import '../../widget/icon.dart';

class InsertName extends StatefulWidget {
  const InsertName({super.key});

  @override
  State<InsertName> createState() => _InsertNameState();
}

class _InsertNameState extends State<InsertName> {
  String amountValue = "0";
  String currency = '';

  final ApiController apiController = ApiController();

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

  Future<void> _postData() async {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    if (args['name'] != '' && amountValue != '0') {
      final transaction = Transaction(
        name: args['name'],
        amount:
            double.parse('${FormatNumber.sentCurrency(amountValue, currency)}'),
        currency: currency,
      );

      final CreateResponse response =
          await apiController.postInsertAmount(transaction);

      try {
        AppWidget.showDialog(
          context,
          title: 'ជោគជ័យ',
          alertType: QuickAlertType.success,
        );
        log(response.status, name: 'Confirm');
      } catch (e) {
        AppWidget.showDialog(
          context,
          title: 'Error',
          content: 'Failed to post data: $e',
          alertType: QuickAlertType.error,
        );
        log('Failed to send data: $e', name: 'Error');
      }
    } else {
      AppWidget.showDialog(
        context,
        title: 'Error',
        content: 'Please fill in all fields',
        alertType: QuickAlertType.error,
      );
      log('Validation failed', name: 'Validation');
    }
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
              nameItem(),
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
        onPressed: () => GoNavigate.goBack(),
      ),
    );
  }

  nameItem() {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: StrokeText(
        text: args['name'],
        textColor: AppColor.BLUE,
        size: 26,
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
        '${FormatNumber.formatCurrency(amountValue, currency)} $currency',
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
      onTap: amountValue == '0'
          ? () {}
          : () {
              _postData();
            },
    );
  }
}
