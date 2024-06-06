import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khmer_fonts/khmer_fonts.dart';

import '../../widget/app_widget.dart';
import '../../widget/background.dart';
import '../../widget/button.dart';
import '../../widget/color.dart';
import '../../widget/dismiss_keyboad.dart';
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
  final controller = TextEditingController();
  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Background(
      widgets: DismissKeyboard(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          appBar: buildAppBar(),
          drawer: buildDrawer(context),
          body: buildBody(),
        ),
      ),
    );
  }

  buildBody() {
    final controller = TextEditingController();
    final focus = FocusNode();

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
                // GoNavigate.pushNamed('/insert-name');
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        child: StrokeText(
                          text: 'ឈ្មោះភ្ញៀវ',
                          textColor: AppColor.BLUE,
                          size: 18,
                          strokeColor: Colors.transparent,
                        ),
                      ),
                      content: TextField(
                        controller: controller,
                        focusNode: focus,
                        onSubmitted: (value) {
                          setState(() {
                            focus.unfocus();
                          });
                        },
                        onTapOutside: (event) {
                          setState(() {
                            focus.unfocus();
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus &&
                                currentFocus.focusedChild != null) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            }
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          labelStyle: TextStyle(
                            fontFamily: KhmerFonts.fasthand,
                            fontSize: 11.sp,
                            package: 'khmer_fonts',
                            color: AppColor.BLUE,
                          ),
                          hintText: 'បញ្ចូលឈ្មោះភ្ញៀវ...',
                          fillColor: Colors.white,
                          filled: true,
                          hintStyle: TextStyle(
                            fontFamily: KhmerFonts.fasthand,
                            fontSize: 11.sp,
                            package: 'khmer_fonts',
                            color: AppColor.BLUE_OPACITY_70,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColor.BLUE,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColor.PRIMARY,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            'clear'.toUpperCase(),
                            style: TextStyle(
                              color: AppColor.PRIMARY,
                            ),
                          ),
                          onPressed: () {
                            // setState(() {
                            //   _billNumberTEC.text = '';
                            // });
                            // _billNumberController.billNumber.value =
                            //     '';
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColor.PRIMARY,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'okay'.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            // _billNumberController.billNumber.value =
                            //     _billNumberTEC.text;
                            // _billNumberTEC.clear();
                            GoNavigate.goBack();
                            GoNavigate.pushNamedWithArguments('/insert-name',
                                {'name': controller.text.toString()});
                          },
                        ),
                      ],
                    );
                  },
                );
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
