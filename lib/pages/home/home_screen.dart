import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widget/app_widget.dart';
import '../../widget/background.dart';
import '../../widget/button.dart';
import '../../widget/color.dart';
import '../../widget/format_khmer_date.dart';
import '../../widget/go_navigate.dart';
import '../../widget/icon.dart';
import '../../widget/stroke_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Background(
      widgets: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: buildAppBar(),
        drawer: buildDrawer(context),
        body: buildBody(),
      ),
    );
  }

  buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            AppWidget.name(context),
            date(),
          ],
        ),
        AppButton.bigButton(
          context,
          text: 'ស្កេន QR Code',
          backgroundColor: AppColor.BLUE.withOpacity(0.5),
          widget: Icon(
            Icons.qr_code_rounded,
            color: AppColor.WHITE,
            size: 56.sp,
          ),
          onTap: () {
            GoNavigate.pushNamed('/scan-qr');
            print('object');
          },
        ),
        Column(
          children: [
            AppButton.longButton(
              context,
              text: 'មិនមានធៀប',
              backgroundColor: AppColor.GREEN_OPACITY,
              icon: AppIcon.card(),
              onTap: () {
                GoNavigate.pushNamed('/insert-name');
              },
            ),
            SizedBox(height: 12.h),
            AppButton.longButton(
              context,
              text: 'មើលរបាយការណ៍',
              icon: AppIcon.report(),
              backgroundColor: AppColor.RED_OPACITY,
              onTap: () {
                GoNavigate.pushNamed('/report');
              },
            ),
          ],
        ),
        Container(),
        Container(),
        Container(),
      ],
    );
  }

  date() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 12),
      child: StrokeText(
        text: formatKhmerDate(),
        size: 10.sp,
        textAlign: TextAlign.center,
        textColor: AppColor.BLUE,
        strokeColor: AppColor.WHITE_70,
      ),
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

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: DrawerButton(
        color: AppColor.WHITE,
      ),
    );
  }
}
