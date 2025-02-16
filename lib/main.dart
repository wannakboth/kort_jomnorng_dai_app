import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pages/home/home_screen.dart';
import 'service/gsheet/google_sheet.service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(GoogleSheetsService()); // Register service at app start
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

