import 'package:flutter/material.dart';

import '../pages/insert_name/insert_name.dart';
import '../pages/home/home_screen.dart';
import '../pages/report/report_screen.dart';
import '../pages/scan/scan_qr_screen.dart';

Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
  // '/': (context) => const SplashScreen(),
  '/home': (context) => const HomeScreen(),
  '/scan-qr': (context) => const QRViewExample(),
  '/report': (context) => const ReportScreen(),
  '/insert-name': (context) => const InsertName(),
};
