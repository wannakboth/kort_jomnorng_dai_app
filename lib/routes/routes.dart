import 'package:flutter/material.dart';

import '../pages/home/home_screen.dart';
import '../pages/report/report_screen.dart';

Map<String, Widget Function(BuildContext)> routes = <String, WidgetBuilder>{
  // '/': (context) => const SplashScreen(),
  '/home': (context) => const HomeScreen(),
  '/report': (context) => const ReportScreen(),
};
