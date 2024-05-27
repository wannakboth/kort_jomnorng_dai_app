// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'dart:ui';
import 'package:flutter/material.dart';

import 'color.dart';

class Background extends StatelessWidget {
  Background({
    super.key,
    required this.widgets,
  });

  Widget widgets;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.MAINCOLOR,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.4,
            child: Image.asset(
              height: MediaQuery.of(context).size.height,
              'assets/background/app_background.png',
              fit: BoxFit.fitHeight,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.15,
                vertical: MediaQuery.of(context).size.height * 0.025,
              ),
              child: Image.asset(
                'assets/background/app_cartoon.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.3, sigmaY: 2.3),
              child: Opacity(
                opacity: 0.5,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment(0, 1),
                      colors: [
                        Color(0xff2E7E98),
                        Color(0xff0F2932),
                      ],
                      tileMode: TileMode.mirror,
                    ),
                  ),
                ),
              ),
            ),
          ),
          widgets,
        ],
      ),
    );
  }
}
