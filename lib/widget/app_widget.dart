import 'package:flutter/material.dart';

import 'color.dart';
import 'stroke_text.dart';

class AppWidget {
  static name(context, {double? fontSize, double? imageSize, MainAxisAlignment? mainAxisAlignment}) {
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(top: 2, right: 12),
              child: StrokeText(
                text: 'ឈ្មោះកូនកំលោះ',
                size: fontSize ?? 16,
                textColor: AppColor.RED,
                strokeColor: AppColor.WHITE_70,
              ),
            ),
            Image.asset(
              'assets/images/love.png',
              width: imageSize ?? MediaQuery.of(context).size.width * 0.13,
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 2, left: 12),
          child: StrokeText(
            text: 'ឈ្មោះកូនក្រមុំ',
            size: fontSize ?? 16,
            textColor: AppColor.RED,
            strokeColor: AppColor.WHITE_70,
          ),
        ),
      ],
    );
  }
}
