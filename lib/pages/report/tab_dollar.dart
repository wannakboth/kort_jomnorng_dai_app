import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widget/color.dart';
import '../../widget/stroke_text.dart';
import 'list_item.dart';

class TabDollar extends StatelessWidget {
  const TabDollar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        total(),
        ListItem(),
      ],
    );
  }

  total() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StrokeText(
            text: 'ទឹកប្រាក់សរុប',
            size: 14.sp,
            textColor: AppColor.BLACK,
            strokeColor: Colors.transparent,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StrokeText(
                text: '១០,០០០,០០០ រៀល',
                size: 10.sp,
                textColor: AppColor.BLUE,
              ),
              const SizedBox(height: 4),
              StrokeText(
                text: '១០,០០០ ដុល្លារ',
                size: 10.sp,
                textColor: AppColor.RED,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
