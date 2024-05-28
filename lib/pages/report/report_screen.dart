import 'package:flutter/material.dart';

import '../../widget/app_widget.dart';
import '../../widget/background.dart';
import '../../widget/color.dart';
import '../../widget/stroke_text.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Background(
      widgets: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: buildAppBar(),
        body: buildBody(),
      ),
    );
  }

  buildBody() {
    return ListView(
      children: [
        title(),
      ],
    );
  }

  title() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 8),
      child: StrokeText(
        text: 'របាយការណ៍ចំណងដៃ',
        textColor: AppColor.BLUE,
        size: 20,
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      leading: BackButton(
        color: AppColor.WHITE,
      ),
      title: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1,
        ),
        child: AppWidget.name(
          context,
          fontSize: 12,
          imageSize: MediaQuery.of(context).size.width * 0.1,
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      ),
    );
  }
}
