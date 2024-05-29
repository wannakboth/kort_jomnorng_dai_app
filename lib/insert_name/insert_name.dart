import 'package:flutter/material.dart';

import '../widget/app_widget.dart';
import '../widget/background.dart';
import '../widget/color.dart';
import '../widget/dismiss_keyboad.dart';

class InsertName extends StatefulWidget {
  const InsertName({super.key});

  @override
  State<InsertName> createState() => _InsertNameState();
}

class _InsertNameState extends State<InsertName> {
  @override
  Widget build(BuildContext context) {
    return Background(
      widgets: DismissKeyboard(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: buildAppBar(),
          body: buildBody(),
        ),
      ),
    );
  }

  buildBody() {
    return Container();
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      leading: BackButton(
        color: AppColor.WHITE,
      ),
    );
  }
}
