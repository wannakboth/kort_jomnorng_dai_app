// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kort_jomnorng_dai_app/widget/color.dart';

class AppIcon {
  static dollar({double? width, double? height, Color? color}) {
    return SvgPicture.asset(
      'assets/icons/dollar.svg',
      width: (width ?? 18).sp,
      height: (height ?? 18).sp,
      color: color ?? AppColor.WHITE,
    );
  }

  static riel({double? width, double? height, Color? color}) {
    return SvgPicture.asset(
      'assets/icons/riel.svg',
      width: (width ?? 18).sp,
      height: (height ?? 18).sp,
      color: color ?? AppColor.WHITE,
    );
  }

  static flash({double? width, double? height, Color? color}) {
    return SvgPicture.asset(
      'assets/icons/flash.svg',
      width: (width ?? 18).sp,
      height: (height ?? 18).sp,
      color: color ?? AppColor.WHITE,
    );
  }

  static report({double? width, double? height, Color? color}) {
    return SvgPicture.asset(
      'assets/icons/invoice.svg',
      width: (width ?? 18).sp,
      height: (height ?? 18).sp,
      color: color ?? AppColor.WHITE,
    );
  }

  static picture({double? width, double? height, Color? color}) {
    return SvgPicture.asset(
      'assets/icons/picture.svg',
      width: (width ?? 18).sp,
      height: (height ?? 18).sp,
      color: color ?? AppColor.WHITE,
    );
  }

  static search({double? width, double? height, Color? color}) {
    return SvgPicture.asset(
      'assets/icons/search.svg',
      width: (width ?? 18).sp,
      height: (height ?? 18).sp,
      color: color ?? AppColor.WHITE,
    );
  }

  static card({double? width, double? height, Color? color}) {
    return SvgPicture.asset(
      'assets/icons/card.svg',
      width: (width ?? 18).sp,
      height: (height ?? 18).sp,
      color: color ?? AppColor.WHITE,
    );
  }

  static money({double? width, double? height, Color? color}) {
    return SvgPicture.asset(
      'assets/icons/money.svg',
      width: (width ?? 18).sp,
      height: (height ?? 18).sp,
      color: color ?? AppColor.WHITE,
    );
  }
}
