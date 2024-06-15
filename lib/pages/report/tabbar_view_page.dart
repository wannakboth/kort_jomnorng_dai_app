import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khmer_fonts/khmer_fonts.dart';
import 'package:kort_jomnorng_dai_app/widget/stroke_text.dart';

import '../../widget/color.dart';
import '../../widget/format_number.dart';

class TabBarViewPage extends StatelessWidget {
  const TabBarViewPage({
    super.key,
    required this.page,
    required this.items,
    required this.totalRiel,
    required this.totalDollar,
    // required this.hasMore,
    required this.length,
    // required this.data,
  });

  final String page;
  // final dynamic data;
  final dynamic items;
  final double totalRiel;
  final double totalDollar;
  // final bool hasMore;
  final int length;

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
                            '${FormatNumber.formatCurrency('$totalRiel', 'រៀល')} រៀល',
                        size: 9.sp,
                        textColor: AppColor.BLUE,
                      ),
                      const SizedBox(height: 4),
                      StrokeText(
                        text:
                            '${FormatNumber.formatCurrency('$totalDollar', 'ដុល្លារ')} ដុល្លារ',
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
                            '${FormatNumber.formatCurrency('$totalRiel', 'រៀល')} រៀល',
                        size: 9.sp,
                        textColor: AppColor.BLUE,
                      ),
                    )
                  : page == 'ដុល្លារ'
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: StrokeText(
                            text:
                                '${FormatNumber.formatCurrency('$totalDollar', 'ដុល្លារ')} ដុល្លារ',
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
      itemCount: length,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemBuilder: (_, index) {
        if (index == items.length) {
          return Center(child: CircularProgressIndicator());
        }
        final item = items[index];
        return Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColor.WHITE_70,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: item.currency == 'រៀល'
                  ? AppColor.BLUE_OPACITY_70
                  : AppColor.RED_OPACITY,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StrokeText(
                text: item.name,
                size: 12.sp,
                textColor:
                    item.currency == 'រៀល' ? AppColor.BLUE : AppColor.RED,
                strokeColor: Colors.transparent,
              ),
              Text(
                '${FormatNumber.formatCurrency('${item.amount}', '${item.currency}')} ${item.currency}',
                style: TextStyle(
                  color: item.currency == 'រៀល' ? AppColor.BLUE : AppColor.RED,
                  fontFamily: KhmerFonts.fasthand,
                  fontSize: 9.sp,
                  package: 'khmer_fonts',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
