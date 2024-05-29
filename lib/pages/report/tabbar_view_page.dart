import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khmer_fonts/khmer_fonts.dart';
import 'package:kort_jomnorng_dai_app/widget/stroke_text.dart';

import '../../widget/color.dart';
import '../../widget/format_number.dart';

class TabBarViewPage extends StatelessWidget {
  const TabBarViewPage({super.key, required this.page});

  final String page;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        total(),
        listItem(),
        const SizedBox(height: 16),
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
          page == 'ទាំងអស់'
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      StrokeText(
                        text:
                            '${FormatNumber.formatNumber(100023445508896)} រៀល',
                        size: 9.sp,
                        textColor: AppColor.BLUE,
                      ),
                      const SizedBox(height: 4),
                      StrokeText(
                        text: '${FormatNumber.formatNumber(500087)} ដុល្លារ',
                        size: 9.sp,
                        textColor: AppColor.RED,
                      ),
                    ],
                  ),
                )
              : page == 'រៀល'
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: StrokeText(
                        text:
                            '${FormatNumber.formatNumber(100023445508896)} រៀល',
                        size: 9.sp,
                        textColor: AppColor.BLUE,
                      ),
                    )
                  : page == 'ដុល្លារ'
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: StrokeText(
                            text:
                                '${FormatNumber.formatNumber(500087)} ដុល្លារ',
                            size: 9.sp,
                            textColor: AppColor.RED,
                          ),
                        )
                      : Container(),
        ],
      ),
    );
  }

  listItem() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 20,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemBuilder: (_, index) {
        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColor.WHITE_70,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: page == 'រៀល'
                  ? AppColor.BLUE_OPACITY_70
                  : AppColor.RED_OPACITY,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StrokeText(
                text: 'ឈ្មោះភ្ញៀវ',
                size: 10.sp,
                textColor: AppColor.BLACK,
                strokeColor: Colors.transparent,
              ),
              Text(
                '${FormatNumber.formatNumber(10000)} រៀល',
                style: TextStyle(
                  color: page == 'រៀល' ? AppColor.BLUE : AppColor.RED,
                  fontFamily: KhmerFonts.fasthand,
                  fontSize: 11.sp,
                  package: 'khmer_fonts',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
