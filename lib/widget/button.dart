// ignore_for_file: prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khmer_fonts/khmer_fonts.dart';
import 'package:kort_jomnorng_dai_app/widget/color.dart';

class AppButton {
  static longButton(
    BuildContext context, {
    required String text,
    String? fontFamily,
    double? textSize,
    dynamic icon,
    Color? textColor,
    required Color backgroundColor,
    Color? iconColor,
    Color? borderColor,
    Color? shadowColor,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap.call(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        margin: EdgeInsets.symmetric(horizontal: 32.sp),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.WHITE_60),
          boxShadow: [
            BoxShadow(
              color: AppColor.SHADOW,
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon == null ? Container() : icon,
              SizedBox(width: 8.w),
              Text(
                text,
                style: TextStyle(
                  color: textColor ?? AppColor.WHITE,
                  fontSize: (textSize ?? 11).sp,
                  package: 'khmer_fonts',
                  fontFamily: fontFamily ?? KhmerFonts.fasthand,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static smallButton() {
    return Container();
  }

  static bigButton(
    BuildContext context, {
    required String text,
    String? fontFamily,
    double? textSize,
    dynamic icon,
    Widget? widget,
    Color? textColor,
    required Color backgroundColor,
    Color? iconColor,
    Color? borderColor,
    Color? shadowColor,
    required Function onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap.call(),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.WHITE_60),
          boxShadow: [
            BoxShadow(
              color: AppColor.SHADOW,
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon == null ? widget : icon,
              SizedBox(height: 12.sp),
              Text(
                text,
                style: TextStyle(
                  color: textColor ?? AppColor.WHITE,
                  fontSize: (textSize ?? 18).sp,
                  package: 'khmer_fonts',
                  fontFamily: fontFamily ?? KhmerFonts.fasthand,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}