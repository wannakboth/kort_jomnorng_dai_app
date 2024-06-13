import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'routes/routes.dart';
import 'widget/go_navigate.dart';
import 'widget/url.dart';

void main() {
  _initialize();
  runApp(const MyApp());
}

Future<void> _initialize() async {
  await initializeIpAddress(); // Ensure the IP address and URLs are set
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        ScreenUtil.init(_);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: GoNavigate.navigatorKey,
          initialRoute: '/home',
          routes: routes,
        );
      },
    );
  }
}
