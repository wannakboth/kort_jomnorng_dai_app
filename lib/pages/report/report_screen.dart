import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khmer_fonts/khmer_fonts.dart';

import '../../widget/app_widget.dart';
import '../../widget/background.dart';
import '../../widget/button.dart';
import '../../widget/color.dart';
import '../../widget/stroke_text.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        title(),
        tabbar(),
      ],
    );
  }

  final List<String> _pageOptions = [
    'ទាំងអស់',
    'រៀល',
    'ដុល្លារ',
  ];
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  tabbar() {
    // return Column(
    //   children: <Widget>[
    //     TabBar(
    //       controller: _tabController,
    //       indicator: BoxDecoration(
    //         // color: Colors.white,
    //         borderRadius: BorderRadius.circular(25),
    //         boxShadow: [
    //           BoxShadow(
    //             color: AppColor.SHADOW,
    //             spreadRadius: 2,
    //             blurRadius: 4,
    //             offset: const Offset(0, 0),
    //           ),
    //         ],
    //       ),
    //       tabs: [
    //         Tab(text: 'Tab 1'),
    //         Tab(text: 'Tab 2'),
    //         Tab(text: 'Tab 3'),
    //       ],
    //     ),
    //     Expanded(
    //       child: TabBarView(
    //         controller: _tabController,
    //         children: <Widget>[
    //           Center(child: Text('Content of Tab 1')),
    //           Center(child: Text('Content of Tab 2')),
    //           Center(child: Text('Content of Tab 3')),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
    return TabBar(
      dividerColor: Colors.transparent,
      indicatorPadding: const EdgeInsets.all(2),
      unselectedLabelColor: Colors.black,
      unselectedLabelStyle: TextStyle(
        color: AppColor.PRIMARY,
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        package: 'khmer_fonts',
        fontFamily: KhmerFonts.fasthand,
      ),
      labelStyle: TextStyle(
        color: Colors.white,
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        package: 'khmer_fonts',
        fontFamily: KhmerFonts.fasthand,
      ),
      labelColor: Colors.white,
      controller: _tabController,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColor.SHADOW,
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: [
        // Tab(text: _pageOptions[0]),
        AppButton.smallButton(context,
            text: _pageOptions[0],
            backgroundColor: AppColor.BLACK_OPACITY, onTap: () {
          setState(() {
            _tabController.index;
          });
        }),
        Tab(text: _pageOptions[1]),
        Tab(text: _pageOptions[2]),
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
