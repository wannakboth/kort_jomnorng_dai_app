import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:khmer_fonts/khmer_fonts.dart';

import '../../service/controller.dart';
import '../../service/model.dart';
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

  // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(length: 3, vsync: this);
  //   _tabController.addListener(_onTabChanged);
  //   fetchData(currentCurrency: 'all');
  // }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    searchFocusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0:
            if (allItems.isEmpty) fetchData(currentCurrency: 'all');
            break;
          case 1:
            if (rielItems.isEmpty) fetchData(currentCurrency: 'riel');
            break;
          case 2:
            if (dollarItems.isEmpty) fetchData(currentCurrency: 'dollar');
            break;
        }
      });
    }
  }

  Future<void> fetchData(
      {required String currentCurrency, bool reset = false}) async {
    if (isLoading(currentCurrency) || !hasMore(currentCurrency)) return;

    if (reset) {
      setState(() {
        clearItems(currentCurrency);
        resetPage(currentCurrency);
      });
    }

    setState(() {
      setLoading(currentCurrency, true);
    });

    try {
      ApiResponse response = await apiController.fetchData(
          currency: currentCurrency,
          page: currentPage(currentCurrency),
          size: 15);
      setState(() {
        addItems(currentCurrency, response.data.items);
        incrementPage(currentCurrency);
        setHasMore(currentCurrency, response.data.items.length == 15);
      });
    } catch (e) {
      print('Failed to load data: $e');
    } finally {
      setState(() {
        setLoading(currentCurrency, false);
      });
    }
  }

  bool isLoading(String currency) {
    switch (currency) {
      case 'all':
        return allIsLoading;
      case 'riel':
        return rielIsLoading;
      case 'dollar':
        return dollarIsLoading;
      default:
        return false;
    }
  }

  void setLoading(String currency, bool loading) {
    switch (currency) {
      case 'all':
        allIsLoading = loading;
        break;
      case 'riel':
        rielIsLoading = loading;
        break;
      case 'dollar':
        dollarIsLoading = loading;
        break;
    }
  }

  bool hasMore(String currency) {
    switch (currency) {
      case 'all':
        return allHasMore;
      case 'riel':
        return rielHasMore;
      case 'dollar':
        return dollarHasMore;
      default:
        return false;
    }
  }

  void setHasMore(String currency, bool hasMore) {
    switch (currency) {
      case 'all':
        allHasMore = hasMore;
        break;
      case 'riel':
        rielHasMore = hasMore;
        break;
      case 'dollar':
        dollarHasMore = hasMore;
        break;
    }
  }

  int currentPage(String currency) {
    switch (currency) {
      case 'all':
        return allCurrentPage;
      case 'riel':
        return rielCurrentPage;
      case 'dollar':
        return dollarCurrentPage;
      default:
        return 1;
    }
  }

  void incrementPage(String currency) {
    switch (currency) {
      case 'all':
        allCurrentPage++;
        break;
      case 'riel':
        rielCurrentPage++;
        break;
      case 'dollar':
        dollarCurrentPage++;
        break;
    }
  }

  void resetPage(String currency) {
    switch (currency) {
      case 'all':
        allCurrentPage = 1;
        break;
      case 'riel':
        rielCurrentPage = 1;
        break;
      case 'dollar':
        dollarCurrentPage = 1;
        break;
    }
  }

  void addItems(String currency, List<Item> newItems) {
    switch (currency) {
      case 'all':
        allItems.addAll(newItems);
        break;
      case 'riel':
        rielItems.addAll(newItems);
        break;
      case 'dollar':
        dollarItems.addAll(newItems);
        break;
    }
  }

  void clearItems(String currency) {
    switch (currency) {
      case 'all':
        allItems.clear();
        break;
      case 'riel':
        rielItems.clear();
        break;
      case 'dollar':
        dollarItems.clear();
        break;
    }
  }

  List<Item> items(String currency) {
    switch (currency) {
      case 'all':
        return allItems;
      case 'riel':
        return rielItems;
      case 'dollar':
        return dollarItems;
      default:
        return [];
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    fetchData(currentCurrency: 'all');

    searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    setState(() {});
  }

  // void _onTabChanged() {
  //   if (_tabController.indexIsChanging) {
  //     setState(() {
  //       currentPage = 1;
  //       items.clear();
  //       hasMore = true;
  //       if (_tabController.index == 0) {
  //         currentCurrency = 'all';
  //       } else if (_tabController.index == 1) {
  //         currentCurrency = 'riel';
  //       } else {
  //         currentCurrency = 'dollar';
  //       }
  //       fetchData();
  //     });
  //   }
  // }

  // Future<void> fetchData() async {
  //   if (isLoading || !hasMore) return;

  //   setState(() {
  //     isLoading = true;
  //   });

  //   try {
  //     ApiResponse response = await apiController.fetchData(
  //         currency: currentCurrency, page: currentPage, size: 15);
  //     setState(() {
  //       items.addAll(response.data.items);
  //       totalItems = response.data.items.length;
  //       currentPage++;
  //       hasMore = response.data.items.length == 15;
  //     });
  //   } catch (e) {
  //     print('Failed to load data: $e');
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // Future<ApiResponse> fetchDataForTab(int index) {
  //   return apiController.fetchData(
  //     search: searchController.text,
  //     currency: reportTabBar[index],
  //   );
  // }

  // @override
  // void dispose() {
  //   searchController.removeListener(_onSearchChanged);
  //   searchController.dispose();
  //   searchFocusNode.dispose();
  //   _tabController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Screen'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'All'),
            Tab(text: 'Riel'),
            Tab(text: 'Dollar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildListView('all'),
          _buildListView('riel'),
          _buildListView('dollar'),
        ],
      ),
    );
    // return Background(
    //   widgets: DismissKeyboard(
    //     child: Scaffold(
    //       backgroundColor: Colors.transparent,
    //       appBar: buildAppBar(),
    //       body: buildBody(),
    //     ),
    //   ),
    // );
  }

  Widget _buildListView(String currency) {
    List<Item> currentItems = items(currency);
    bool currentLoading = isLoading(currency);
    bool currentHasMore = hasMore(currency);

    return RefreshIndicator(
      onRefresh: () => fetchData(currentCurrency: currency, reset: true),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!currentLoading &&
              currentHasMore &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            fetchData(currentCurrency: currency);
          }
          return false;
        },
        child: currentItems.isEmpty && currentLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: currentItems.length + (currentHasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == currentItems.length) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final item = currentItems[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('${item.amount} ${item.currency}'),
                  );
                },
              ),
      ),
    );
  }

  // buildBody() {
  //   return Column(
  //     children: [
  //       title(),
  //       const SizedBox(height: 8),
  //       searchField(),
  //       const SizedBox(height: 8),
  //       tabbar(),
  //       const SizedBox(height: 24),
  //       Expanded(
  //         child: TabBarView(
  //           controller: _tabController,
  //           children: [
  //             buildTabContent(0),
  //             buildTabContent(1),
  //             buildTabContent(2),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 50),
  //     ],
  //   );
  // }

  // Widget buildTabContent(int index) {
  //   return FutureBuilder<ApiResponse>(
  //     future: fetchDataForTab(index),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(
  //           child: CircularProgressIndicator(
  //             color: AppColor.WHITE,
  //           ),
  //         );
  //       } else if (snapshot.data?.data == null || snapshot.data == null) {
  //         return const Center(child: Text('No data found'));
  //       } else if (snapshot.hasError) {
  //         return Center(child: Text('Error: ${snapshot.error}'));
  //       } else if (snapshot.hasData) {
  //         final data = snapshot.data!.data;
  //         final item = data?.items;

  //         return TabBarViewPage(
  //           page: reportTabBar[index],
  //           data: data,
  //           items: item,
  //         );
  //       } else {
  //         return const Center(child: Text('No data found'));
  //       }
  //     },
  //   );
  // }

  // tabbar() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(
  //         horizontal: MediaQuery.of(context).size.width * 0.1),
  //     child: TabBar(
  //       dividerColor: Colors.transparent,
  //       unselectedLabelColor: Colors.black,
  //       unselectedLabelStyle: TextStyle(
  //         color: AppColor.PRIMARY,
  //         fontSize: 11.sp,
  //         fontWeight: FontWeight.w500,
  //         package: 'khmer_fonts',
  //         fontFamily: KhmerFonts.fasthand,
  //       ),
  //       labelStyle: TextStyle(
  //         color: Colors.white,
  //         fontSize: 11.sp,
  //         fontWeight: FontWeight.w500,
  //         package: 'khmer_fonts',
  //         fontFamily: KhmerFonts.fasthand,
  //       ),
  //       labelColor: Colors.white,
  //       labelPadding: const EdgeInsets.all(0),
  //       controller: _tabController,
  //       indicator: const BoxDecoration(),
  //       tabs: [
  //         Tab(
  //           child: AppButton.smallButton(
  //             context,
  //             text: reportTabBar[0],
  //             icon: AppIcon.money(width: 0, height: 0),
  //             space: 0,
  //             horizontal: 22,
  //             backgroundColor: AppColor.BLACK_OPACITY,
  //             borderColor:
  //                 _selectedIndex == 0 ? AppColor.WHITE : AppColor.WHITE_60,
  //             shadow: _selectedIndex == 0
  //                 ? [
  //                     BoxShadow(
  //                       color: AppColor.SHADOW,
  //                       spreadRadius: 4,
  //                       blurRadius: 4,
  //                       offset: const Offset(0, 0),
  //                     ),
  //                   ]
  //                 : [],
  //             onTap: () {
  //               _tabController.animateTo(0);
  //             },
  //           ),
  //         ),
  //         Tab(
  //           child: AppButton.smallButton(
  //             context,
  //             text: reportTabBar[1],
  //             icon: AppIcon.riel(),
  //             backgroundColor: AppColor.PRIMARY_OPACITY,
  //             borderColor:
  //                 _selectedIndex == 1 ? AppColor.WHITE : AppColor.WHITE_60,
  //             shadow: _selectedIndex == 1
  //                 ? [
  //                     BoxShadow(
  //                       color: AppColor.SHADOW,
  //                       spreadRadius: 4,
  //                       blurRadius: 4,
  //                       offset: const Offset(0, 0),
  //                     ),
  //                   ]
  //                 : [],
  //             onTap: () {
  //               _tabController.animateTo(1);
  //             },
  //           ),
  //         ),
  //         Tab(
  //           child: AppButton.smallButton(
  //             context,
  //             text: reportTabBar[2],
  //             icon: AppIcon.dollar(),
  //             backgroundColor: AppColor.RED_OPACITY,
  //             borderColor:
  //                 _selectedIndex == 2 ? AppColor.WHITE : AppColor.WHITE_60,
  //             shadow: _selectedIndex == 2
  //                 ? [
  //                     BoxShadow(
  //                       color: AppColor.SHADOW,
  //                       spreadRadius: 4,
  //                       blurRadius: 4,
  //                       offset: const Offset(0, 0),
  //                     ),
  //                   ]
  //                 : [],
  //             onTap: () {
  //               _tabController.animateTo(2);
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // searchField() {
  //   return Container(
  //     padding: const EdgeInsets.only(top: 6),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 24),
  //             child: TextFormField(
  //               controller: searchController,
  //               focusNode: searchFocusNode,
  //               obscureText: false,
  //               textCapitalization: TextCapitalization.sentences,
  //               textInputAction: TextInputAction.search,
  //               style: TextStyle(
  //                 fontSize: 11.sp,
  //                 color: AppColor.WHITE,
  //                 package: 'khmer_fonts',
  //                 fontFamily: KhmerFonts.fasthand,
  //               ),
  //               decoration: InputDecoration(
  //                 contentPadding: const EdgeInsets.symmetric(horizontal: 16),
  //                 labelStyle: TextStyle(
  //                   fontSize: 11.sp,
  //                   color: AppColor.WHITE,
  //                   package: 'khmer_fonts',
  //                   fontFamily: KhmerFonts.fasthand,
  //                 ),
  //                 hintText: 'ស្វែងរកឈ្មោះភ្ញៀវ...',
  //                 hintStyle: TextStyle(
  //                   fontSize: 11.sp,
  //                   color: AppColor.WHITE_60,
  //                   package: 'khmer_fonts',
  //                   fontFamily: KhmerFonts.fasthand,
  //                 ),
  //                 enabledBorder: OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: AppColor.WHITE,
  //                     width: 1,
  //                   ),
  //                   borderRadius: BorderRadius.circular(16),
  //                 ),
  //                 focusedBorder: OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: AppColor.PRIMARY,
  //                     width: 1,
  //                   ),
  //                   borderRadius: BorderRadius.circular(16),
  //                 ),
  //                 errorBorder: OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: AppColor.RED,
  //                     width: 1,
  //                   ),
  //                   borderRadius: BorderRadius.circular(16),
  //                 ),
  //                 focusedErrorBorder: OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: AppColor.RED,
  //                     width: 1,
  //                   ),
  //                   borderRadius: BorderRadius.circular(16),
  //                 ),
  //                 filled: true,
  //                 fillColor: AppColor.BLUE_OPACITY_40,
  //                 prefixIcon: Icon(
  //                   CupertinoIcons.search,
  //                   color: AppColor.WHITE,
  //                 ),
  //                 suffixIcon: searchController.text.isNotEmpty
  //                     ? IconButton(
  //                         icon: Icon(
  //                           Icons.close_rounded,
  //                           color: AppColor.WHITE,
  //                           size: 18,
  //                         ),
  //                         onPressed: () {
  //                           setState(() {
  //                             searchController.clear();
  //                           });
  //                         },
  //                       )
  //                     : null,
  //               ),
  //               onFieldSubmitted: (value) {
  //                 // action.call();
  //               },
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // suffix() {
  //   if (searchController.text.isNotEmpty) {
  //     setState(() {
  //       IconButton(
  //         icon: Icon(
  //           Icons.close_rounded,
  //           color: AppColor.WHITE,
  //           size: 18,
  //         ),
  //         onPressed: () {
  //           setState(() {
  //             searchController.clear();
  //           });
  //         },
  //       );
  //     });
  //   }
  // }

  // title() {
  //   return Container(
  //     alignment: Alignment.center,
  //     margin: const EdgeInsets.only(top: 8),
  //     child: StrokeText(
  //       text: 'របាយការណ៍ចំណងដៃ',
  //       textColor: AppColor.BLUE,
  //       size: 20,
  //     ),
  //   );
  // }

  // AppBar buildAppBar() {
  //   return AppBar(
  //     elevation: 0,
  //     centerTitle: false,
  //     backgroundColor: Colors.transparent,
  //     leading: BackButton(
  //       color: AppColor.WHITE,
  //     ),
  //     title: Container(
  //       margin: EdgeInsets.symmetric(
  //         horizontal: MediaQuery.of(context).size.width * 0.1,
  //       ),
  //       child: AppWidget.name(
  //         context,
  //         fontSize: 12,
  //         imageSize: MediaQuery.of(context).size.width * 0.1,
  //         mainAxisAlignment: MainAxisAlignment.start,
  //       ),
  //     ),
  //   );
  // }
}
