import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khmer_fonts/khmer_fonts.dart';

import 'color.dart';

class StrokeText extends StatelessWidget {
  const StrokeText({
    super.key,
    required this.text,
    this.size,
    this.strokeWidth,
    this.strokeColor,
    required this.textColor,
    this.fontFamily,
  });

  final String text;
  final double? size;
  final double? strokeWidth;
  final Color? strokeColor;
  final Color textColor;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontFamily: fontFamily ?? KhmerFonts.dangrek,
            fontSize: (size ?? 14).sp,
            package: 'khmer_fonts',
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth ?? 2
              ..color = strokeColor ?? AppColor.WHITE,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontFamily: fontFamily ?? KhmerFonts.dangrek,
            fontSize: (size ?? 14).sp,
            package: 'khmer_fonts',
            color: textColor,
          ),
        ),
      ],
    );
  }
}
