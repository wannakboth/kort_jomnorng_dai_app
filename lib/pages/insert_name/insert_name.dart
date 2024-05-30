import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khmer_fonts/khmer_fonts.dart';

import '../../widget/background.dart';
import '../../widget/color.dart';
import '../../widget/dismiss_keyboad.dart';
import '../../widget/input_num_monitor.dart';

class InsertName extends StatefulWidget {
  const InsertName({super.key});

  @override
  State<InsertName> createState() => _InsertNameState();
}

class _InsertNameState extends State<InsertName> {
  final inputFocusNode = FocusNode();
  final inputController = TextEditingController();

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
    return InputNumMonitor(
      name: insertName(),
    );
    // return Column(
    //   children: [
    //     Expanded(
    //       flex: 1,
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           insertName(),
    //           chooseCurrency(),
    //           amount(),
    //         ],
    //       ),
    //     ),
    //     Expanded(
    //       flex: 2,
    //       child: numberKeyboard(
    //         value: amountValue,
    //         callback: (val) {
    //           setState(() {
    //             amountValue = val;
    //           });
    //         },
    //       ),
    //     ),
    //     confirmButton(),
    //   ],
    // );
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
}
