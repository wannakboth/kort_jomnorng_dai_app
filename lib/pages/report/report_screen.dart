import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khmer_fonts/khmer_fonts.dart';

import '../../service/controller.dart';
import '../../service/search_model.dart';
import '../../widget/app_widget.dart';
import '../../widget/background.dart';
import '../../widget/button.dart';
import '../../widget/color.dart';
import '../../widget/dismiss_keyboad.dart';
import '../../widget/format_number.dart';
import '../../widget/icon.dart';
import '../../widget/list_array.dart';
import '../../widget/stroke_text.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  final ApiController apiController = ApiController();

  List<Item> allItems = [];
  List<Item> rielItems = [];
  List<Item> dollarItems = [];

  int allCurrentPage = 1;
  int rielCurrentPage = 1;
  int dollarCurrentPage = 1;

  bool allIsLoading = false;
  bool rielIsLoading = false;
  bool dollarIsLoading = false;

  bool allHasMore = true;
  bool rielHasMore = true;
  bool dollarHasMore = true;

  double totalDollar = 0.0;
  double totalRiel = 0.0;

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    searchFocusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    fetchData(index: 0);
    searchController.addListener(_onSearchChanged);
    super.initState();
  }

  void _onSearchChanged() {
    setState(() {
      fetchData(index: _tabController.index, reset: true);
    });
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      return;
    }
    setState(() {
      fetchData(index: _tabController.index, reset: true);
    });
  }

  Future<void> fetchData({
    required int index,
    bool reset = false,
  }) async {
    if (isLoading(index) || !hasMore(index)) return;

    if (reset) {
      setState(() {
        clearItems(index);
        resetPage(index);
      });
    }

    setState(() {
      setLoading(index, true);
    });

    try {
      SearchResponse response = await apiController.fetchSearchData(
        search: searchController.text,
        currency: reportTabBar[index],
        page: currentPage(index),
        size: 15,
      );
      setState(() {
        addItems(index, response.data.items);
        incrementPage(index);
        setHasMore(index, response.data.items.length == 15);

        if (index == 0) {
          totalDollar = double.tryParse(response.data.totalDollar) ?? 0.0;
          totalRiel = double.tryParse(response.data.totalRiel) ?? 0.0;
        } else if (index == 1) {
          totalRiel = double.tryParse(response.data.totalRiel) ?? 0.0;
        } else if (index == 2) {
          totalDollar = double.tryParse(response.data.totalDollar) ?? 0.0;
        }
      });
    } catch (e) {
      print('Failed to load data: $e');
    } finally {
      setState(() {
        setLoading(index, false);
      });
    }
  }

  bool isLoading(int index) {
    switch (reportTabBar[index]) {
      case 'ទាំងអស់':
        return allIsLoading;
      case 'រៀល':
        return rielIsLoading;
      case 'ដុល្លារ':
        return dollarIsLoading;
      default:
        return false;
    }
  }

  void setLoading(int index, bool loading) {
    switch (reportTabBar[index]) {
      case 'ទាំងអស់':
        allIsLoading = loading;
        break;
      case 'រៀល':
        rielIsLoading = loading;
        break;
      case 'ដុល្លារ':
        dollarIsLoading = loading;
        break;
    }
  }

  bool hasMore(int index) {
    switch (reportTabBar[index]) {
      case 'ទាំងអស់':
        return allHasMore;
      case 'រៀល':
        return rielHasMore;
      case 'ដុល្លារ':
        return dollarHasMore;
      default:
        return false;
    }
  }

  void setHasMore(int index, bool hasMore) {
    switch (reportTabBar[index]) {
      case 'ទាំងអស់':
        allHasMore = hasMore;
        break;
      case 'រៀល':
        rielHasMore = hasMore;
        break;
      case 'ដុល្លារ':
        dollarHasMore = hasMore;
        break;
    }
  }

  int currentPage(int index) {
    switch (reportTabBar[index]) {
      case 'ទាំងអស់':
        return allCurrentPage;
      case 'រៀល':
        return rielCurrentPage;
      case 'ដុល្លារ':
        return dollarCurrentPage;
      default:
        return 1;
    }
  }

  void incrementPage(int index) {
    switch (reportTabBar[index]) {
      case 'ទាំងអស់':
        allCurrentPage++;
        break;
      case 'រៀល':
        rielCurrentPage++;
        break;
      case 'ដុល្លារ':
        dollarCurrentPage++;
        break;
    }
  }

  void resetPage(int index) {
    switch (reportTabBar[index]) {
      case 'ទាំងអស់':
        allCurrentPage = 1;
        break;
      case 'រៀល':
        rielCurrentPage = 1;
        break;
      case 'ដុល្លារ':
        dollarCurrentPage = 1;
        break;
    }
  }

  void addItems(int index, List<Item> newItems) {
    switch (reportTabBar[index]) {
      case 'ទាំងអស់':
        allItems.addAll(newItems);
        break;
      case 'រៀល':
        rielItems.addAll(newItems);
        break;
      case 'ដុល្លារ':
        dollarItems.addAll(newItems);
        break;
    }
  }

  void clearItems(int index) {
    switch (reportTabBar[index]) {
      case 'ទាំងអស់':
        allItems.clear();
        break;
      case 'រៀល':
        rielItems.clear();
        break;
      case 'ដុល្លារ':
        dollarItems.clear();
        break;
    }
  }

  List<Item> items(int index) {
    switch (reportTabBar[index]) {
      case 'ទាំងអស់':
        return allItems;
      case 'រៀល':
        return rielItems;
      case 'ដុល្លារ':
        return dollarItems;
      default:
        return [];
    }
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
              buildListView(0),
              buildListView(1),
              buildListView(2),
            ],
          ),
        ),
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
                              fetchData(
                                  index: _tabController.index, reset: true);
                            });
                          },
                        )
                      : null,
                ),
                onFieldSubmitted: (value) {
                  fetchData(index: _tabController.index, reset: true);
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
              fetchData(index: _tabController.index, reset: true);
            });
          },
        );
      });
    }
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
              borderColor: _tabController.index == 0
                  ? AppColor.WHITE
                  : AppColor.WHITE_60,
              shadow: _tabController.index == 0
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
              borderColor: _tabController.index == 1
                  ? AppColor.WHITE
                  : AppColor.WHITE_60,
              shadow: _tabController.index == 1
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
              borderColor: _tabController.index == 2
                  ? AppColor.WHITE
                  : AppColor.WHITE_60,
              shadow: _tabController.index == 2
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

  buildListView(int tabIdx) {
    List<Item> currentItems = items(tabIdx);
    bool currentLoading = isLoading(tabIdx);
    bool currentHasMore = hasMore(tabIdx);

    return RefreshIndicator(
      onRefresh: () => fetchData(index: tabIdx, reset: true),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!currentLoading &&
              currentHasMore &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            fetchData(index: tabIdx);
          }
          return false;
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StrokeText(
                    text: 'ទឹកប្រាក់សរុប',
                    size: 14.sp,
                    textColor: AppColor.WHITE,
                    strokeColor: Colors.transparent,
                  ),
                  tabIdx == 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              StrokeText(
                                text:
                                    '${FormatNumber.formatCurrency('$totalRiel', 'រៀល', view: true)} រៀល',
                                size: 9.sp,
                                textColor: AppColor.BLUE,
                              ),
                              const SizedBox(height: 4),
                              StrokeText(
                                text:
                                    '${FormatNumber.formatCurrency('$totalDollar', 'ដុល្លារ')} ដុល្លារ',
                                size: 9.sp,
                                textColor: AppColor.RED,
                              ),
                            ],
                          ),
                        )
                      : tabIdx == 1
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: StrokeText(
                                text:
                                    '${FormatNumber.formatCurrency('$totalRiel', 'រៀល', view: true)} រៀល',
                                size: 9.sp,
                                textColor: AppColor.BLUE,
                              ),
                            )
                          : tabIdx == 2
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: StrokeText(
                                    text:
                                        '${FormatNumber.formatCurrency('$totalDollar', 'ដុល្លារ')} ដុល្លារ',
                                    size: 9.sp,
                                    textColor: AppColor.RED,
                                  ),
                                )
                              : Container(),
                ],
              ),
            ),
            if (currentItems.isEmpty && !currentLoading)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'មិនមានទិន្នន័យ',
                    style: TextStyle(
                      color: AppColor.BLUE,
                      fontFamily: KhmerFonts.dangrek,
                      fontSize: 14.sp,
                      package: 'khmer_fonts',
                    ),
                  ),
                ),
              ),
            if (currentItems.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: currentItems.length + (currentHasMore ? 1 : 0),
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemBuilder: (_, index) {
                  if (index >= currentItems.length) {
                    return const Center();
                  }

                  final item = currentItems[index];

                  return Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColor.WHITE_70,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: item.currency == 'រៀល'
                            ? AppColor.BLUE_OPACITY_70
                            : AppColor.RED_OPACITY,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            StrokeText(
                              text:
                                  '${FormatNumber.formatNumberToKhmer(item.count.toString())}.',
                              size: 10.sp,
                              textColor: AppColor.BLACK,
                              strokeColor: Colors.transparent,
                            ),
                            const SizedBox(width: 8),
                            StrokeText(
                              text: item.name,
                              size: 12.sp,
                              textColor: item.currency == 'រៀល'
                                  ? AppColor.BLUE
                                  : AppColor.RED,
                              strokeColor: Colors.transparent,
                            ),
                          ],
                        ),
                        Text(
                          '${FormatNumber.formatCurrency(item.amount, item.currency, view: true)} ${item.currency}',
                          style: TextStyle(
                            color: item.currency == 'រៀល'
                                ? AppColor.BLUE
                                : AppColor.RED,
                            fontFamily: KhmerFonts.fasthand,
                            fontSize: 9.sp,
                            package: 'khmer_fonts',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            if (currentLoading)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator(
                    color: AppColor.WHITE,
                  ),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
