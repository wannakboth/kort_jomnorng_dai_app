import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khmer_fonts/khmer_fonts.dart';

import '../../widget/app_widget.dart';
import '../../widget/background.dart';
import '../../widget/button.dart';
import '../../widget/color.dart';
import '../../widget/dismiss_keyboad.dart';
import '../../widget/icon.dart';
import '../../widget/list_array.dart';
import '../../widget/stroke_text.dart';
import 'tabbar_view_page.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  final searchFocusNode = FocusNode();
  final searchController = TextEditingController();

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });

    searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

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
    return Column(
      children: [
        title(),
        const SizedBox(height: 8),
        searchField(),
        const SizedBox(height: 8),
        tabbar(),
        const SizedBox(height: 24),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              TabBarViewPage(page: reportTabBar[0]),
              TabBarViewPage(page: reportTabBar[1]),
              TabBarViewPage(page: reportTabBar[2]),
            ],
          ),
        ),
      ],
    );
  }

  tabbar() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.1),
      child: TabBar(
        dividerColor: Colors.transparent,
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
        labelPadding: const EdgeInsets.all(0),
        controller: _tabController,
        indicator: const BoxDecoration(),
        tabs: [
          Tab(
            child: AppButton.smallButton(
              context,
              text: reportTabBar[0],
              icon: AppIcon.money(width: 0, height: 0),
              space: 0,
              horizontal: 22,
              backgroundColor: AppColor.BLACK_OPACITY,
              borderColor:
                  _selectedIndex == 0 ? AppColor.WHITE : AppColor.WHITE_60,
              shadow: _selectedIndex == 0
                  ? [
                      BoxShadow(
                        color: AppColor.SHADOW,
                        spreadRadius: 4,
                        blurRadius: 4,
                        offset: const Offset(0, 0),
                      ),
                    ]
                  : [],
              onTap: () {
                _tabController.animateTo(0);
              },
            ),
          ),
          Tab(
            child: AppButton.smallButton(
              context,
              text: reportTabBar[1],
              icon: AppIcon.riel(),
              backgroundColor: AppColor.PRIMARY_OPACITY,
              borderColor:
                  _selectedIndex == 1 ? AppColor.WHITE : AppColor.WHITE_60,
              shadow: _selectedIndex == 1
                  ? [
                      BoxShadow(
                        color: AppColor.SHADOW,
                        spreadRadius: 4,
                        blurRadius: 4,
                        offset: const Offset(0, 0),
                      ),
                    ]
                  : [],
              onTap: () {
                _tabController.animateTo(1);
              },
            ),
          ),
          Tab(
            child: AppButton.smallButton(
              context,
              text: reportTabBar[2],
              icon: AppIcon.dollar(),
              backgroundColor: AppColor.RED_OPACITY,
              borderColor:
                  _selectedIndex == 2 ? AppColor.WHITE : AppColor.WHITE_60,
              shadow: _selectedIndex == 2
                  ? [
                      BoxShadow(
                        color: AppColor.SHADOW,
                        spreadRadius: 4,
                        blurRadius: 4,
                        offset: const Offset(0, 0),
                      ),
                    ]
                  : [],
              onTap: () {
                _tabController.animateTo(2);
              },
            ),
          ),
        ],
      ),
    );
  }

  searchField() {
    return Container(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextFormField(
                controller: searchController,
                focusNode: searchFocusNode,
                obscureText: false,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.search,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColor.WHITE,
                  package: 'khmer_fonts',
                  fontFamily: KhmerFonts.fasthand,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  labelStyle: TextStyle(
                    fontSize: 11.sp,
                    color: AppColor.WHITE,
                    package: 'khmer_fonts',
                    fontFamily: KhmerFonts.fasthand,
                  ),
                  hintText: 'ស្វែងរកឈ្មោះភ្ញៀវ...',
                  hintStyle: TextStyle(
                    fontSize: 11.sp,
                    color: AppColor.WHITE_60,
                    package: 'khmer_fonts',
                    fontFamily: KhmerFonts.fasthand,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.WHITE,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.PRIMARY,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.RED,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor.RED,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: AppColor.BLUE_OPACITY_40,
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: AppColor.WHITE,
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: AppColor.WHITE,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              searchController.clear();
                            });
                          },
                        )
                      : null,
                ),
                onFieldSubmitted: (value) {
                  // action.call();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  suffix() {
    if (searchController.text.isNotEmpty) {
      setState(() {
        IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: AppColor.WHITE,
            size: 18,
          ),
          onPressed: () {
            setState(() {
              searchController.clear();
            });
          },
        );
      });
    }
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
