import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kort_jomnorng_dai_app/widget/color.dart';

import '../widget/background.dart';
import '../widget/button.dart';
import '../widget/icon.dart';
import '../widget/stroke_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      widgets: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: const DrawerButton(
              color: Colors.white,
            )),
        drawer: buildDrawer(context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                name(context),
                date(),
              ],
            ),
            AppButton.bigButton(
              context,
              text: 'ស្កេន QR Code',
              backgroundColor: AppColor.PRIMARY_OPACITY,
              widget: Icon(
                Icons.qr_code_rounded,
                color: AppColor.WHITE,
                size: 56.sp,
              ),
              onTap: () {},
            ),
            Column(
              children: [
                AppButton.longButton(
                  context,
                  text: 'មិនមានធៀប',
                  backgroundColor: AppColor.GREEN_OPACITY,
                  icon: AppIcon.card(),
                  onTap: () {},
                ),
                SizedBox(height: 12.h),
                AppButton.longButton(
                  context,
                  text: 'មើលរបាយការណ៍',
                  icon: AppIcon.report(),
                  backgroundColor: AppColor.RED_OPACITY,
                  onTap: () {},
                ),
              ],
            ),
            Container(),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }

  date() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 12),
      child: StrokeText(
        text: '០១ មករា ២០២៥',
        size: 14,
        textColor: AppColor.BLUE,
        strokeColor: AppColor.WHITE_70,
      ),
    );
  }

  name(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
                size: 16,
                textColor: AppColor.RED,
                strokeColor: AppColor.WHITE_70,
              ),
            ),
            Image.asset(
              'assets/images/love.png',
              width: MediaQuery.of(context).size.width * 0.13,
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 2, left: 12),
          child: StrokeText(
            text: 'ឈ្មោះកូនក្រមុំ',
            size: 16,
            textColor: AppColor.RED,
            strokeColor: AppColor.WHITE_70,
          ),
        ),
      ],
    );
  }

  buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Handle the tap
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Handle the tap
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text('Contact'),
            onTap: () {
              // Handle the tap
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
