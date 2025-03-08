import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khmer_fonts/khmer_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../service/gsheet/google_sheet.service.dart';
import '../../version.dart';
import '../../widget/color.dart';
import '../../widget/dismiss_keyboad.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSheetsService _sheetsService = Get.put(GoogleSheetsService());
  final TextEditingController noController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rielController = TextEditingController();
  final TextEditingController dollarController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  final FocusNode nameFN = FocusNode();
  final FocusNode rielFN = FocusNode();
  final FocusNode dollarFN = FocusNode();
  final FocusNode searchFN = FocusNode();

  List<Map<String, dynamic>> fetchedData = [];
  String searchMessage = "Type a keyword to search or press 'Show All'";
  bool isSearching = false;
  bool isLoadingInsert = false;
  bool isLoadingSearch = false;
  String selectedStatus = 'ផ្សេងៗ';

  bool isKHQR = false;
  bool isRiel = true;

  /// Toggle search mode with animation
  void toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        searchController.clear();
        fetchedData.clear();
      }
    });
  }

  /// **Fetch all records or search based on query**
  void fetchData({String? query}) async {
    setState(() {
      isLoadingSearch = true;
    });

    var data = await _sheetsService.fetchRecords(searchQuery: query);

    setState(() {
      fetchedData = data
          .map((item) => {
                'no': item['no'],
                'name': item['name'],
                'status': item['status'],
                'riel': item['riel'] != null
                    ? int.tryParse(item['riel'].toString()) ?? 0
                    : 0,
                'dollar': item['dollar'] != null
                    ? double.tryParse(item['dollar'].toString()) ?? 0.0
                    : 0.0,
                'khqrRiel': item['khqrRiel'] != null
                    ? int.tryParse(item['khqrRiel'].toString()) ?? 0
                    : 0,
                'khqrDollar': item['khqrDollar'] != null
                    ? double.tryParse(item['khqrDollar'].toString()) ?? 0.0
                    : 0.0,
              })
          .toList();

      searchMessage = fetchedData.isEmpty ? "No records found" : "";
      isLoadingSearch = false;
    });
  }

  /// **Handle search input change**
  void fetchSearchResults() {
    String query = searchController.text.trim().toLowerCase();
    fetchData(query: query.isEmpty ? null : query);
  }

  /// **Show All Data**
  void fetchAllData() {
    searchController.clear();
    fetchData();
  }

  /// Insert data with a loading state that remains until insertion succeeds
  void insertData() async {
    String formattedRiel = rielController.text.isNotEmpty
        ? '៛ ${_sheetsService.formatMoney(int.tryParse(rielController.text) ?? 0)}'
        : '';

    String formattedDollar = dollarController.text.isNotEmpty
        ? '\$ ${_sheetsService.formatMoney(double.tryParse(dollarController.text) ?? 0.0, isDollar: true)}'
        : '';

    if (nameController.text.isEmpty ||
        (rielController.text.isEmpty && dollarController.text.isEmpty)) {
      Get.snackbar("Missing Information", "Please enter name and amount.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // 🟡 Show confirmation popup before inserting data
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: Get.width, // ✅ Full width of the screen
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFD9EDFF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // ✅ Avoid excess height
            children: [
              Text(
                "ពិនិត្យមើលម្តងទៀត",
                style: TextStyle(
                  color: AppColor.BLACK,
                  fontSize: 18,
                  fontFamily: KhmerFonts.preahvihear,
                  package: 'khmer_fonts',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24),
              confirmInfo(
                fontSize: 36,
                isBold: true,
                value: '$formattedRiel $formattedDollar',
              ),
              SizedBox(height: 24),
              confirmInfo(
                value: nameController.text,
                fontSize: 18,
              ),
              SizedBox(height: 12),
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isKHQR
                        ? AppColor.RED_OPACITY
                        : AppColor.BLACK.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Image.asset(
                      'assets/icons/khqr_logo.png',
                      height: 12,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back(); // Close dialog
                    },
                    style: TextButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // ✅ Button Radius 16
                      ),
                    ),
                    child: Text(
                      "ថយក្រោយ",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontFamily: KhmerFonts.preahvihear,
                        package: 'khmer_fonts',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back(); // Close the popup
                      proceedInsertData(); // Continue inserting data
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.PRIMARY,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16), // ✅ Button Radius 16
                      ),
                    ),
                    child: Text(
                      "យល់ព្រម",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: KhmerFonts.preahvihear,
                        package: 'khmer_fonts',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  confirmInfo({value, double? fontSize, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Center(
        child: Text(
          value,
          style: TextStyle(
            color: AppColor.PRIMARY,
            fontSize: fontSize ?? 14,
            fontFamily: KhmerFonts.preahvihear,
            package: 'khmer_fonts',
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// **Proceeds with Data Insertion after Confirmation**
  void proceedInsertData() async {
    setState(() {
      isLoadingInsert = true;
    });

    try {
      await _sheetsService.insertData(
        noController.text,
        nameController.text,
        selectedStatus,
        rielController.text,
        dollarController.text,
        isKHQR,
      );

      _sheetsService.buttonText.value = 'ជោគជ័យ';

      // ✅ Clear fields after successful insert
      noController.clear();
      nameController.clear();
      rielController.clear();
      dollarController.clear();
      selectedStatus = 'ផ្សេងៗ';
      isKHQR = false;
      isRiel = true;
    } catch (e) {
      print("🔴 Error inserting data: $e");
    } finally {
      setState(() {
        isLoadingInsert = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // ✅ Reset button text to "បញ្ចូល" when name is changed
    nameController.addListener(() {
      if (nameController.text.isNotEmpty) {
        _sheetsService.buttonText.value = 'បញ្ចូល';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/background/background.JPG',
                fit: BoxFit.cover,
              ),
            ),
            Container(
              color: AppColor.SECONDARY.withOpacity(0.75),
            ),
            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 20),

                  /// **Title & Search Bar with Show All Button**
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0.0, -0.1),
                            end: Offset(0.0, 0.0),
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      key: ValueKey(isSearching),
                      height: 80,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      child: isSearching
                          ? Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppColor.WHITE_60,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: textField(
                                            label: 'ស្វែងរក...',
                                            controller: searchController,
                                            focusNode: searchFN,
                                            onChanged: (value) {
                                              if (value.isNotEmpty)
                                                fetchSearchResults();
                                            },
                                            onFieldSubmitted: (value) {
                                              if (value.isNotEmpty)
                                                fetchSearchResults();
                                            },
                                            onEditingComplete: () {
                                              searchFN.unfocus();
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColor.BLUE,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () {
                                            searchController.clear();
                                            fetchAllData(); // Fetch all records when button is clicked
                                          },
                                          child: Text(
                                            'ទាំងអស់', // "Show All" in Khmer
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontFamily:
                                                  KhmerFonts.preahvihear,
                                              package: 'khmer_fonts',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: toggleSearch,
                                  icon: Icon(
                                    Icons.close_rounded,
                                    size: 26,
                                    color: AppColor.WHITE,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'កត់ចំណងដៃ',
                                  key: ValueKey("titleText"),
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: AppColor.WHITE,
                                    fontFamily: KhmerFonts.preahvihear,
                                    package: 'khmer_fonts',
                                  ),
                                ),
                                IconButton(
                                  onPressed: toggleSearch,
                                  icon: Icon(
                                    Icons.search_rounded,
                                    size: 26,
                                    color: AppColor.WHITE,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  SizedBox(height: 10),

                  /// **Animated Container for Form & Search Results**
                  Expanded(
                    child: SingleChildScrollView(
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(0.0, -0.1),
                                end: Offset(0.0, 0.0),
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: isSearching
                            ? FutureBuilder<List<Map<String, dynamic>>>(
                                future: _sheetsService.fetchRecords(
                                    searchQuery: searchController.text
                                        .trim()), // ✅ Use optimized function
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      key: ValueKey("loading"),
                                      child: Container(
                                        height: 42,
                                        margin: const EdgeInsets.only(top: 16),
                                        child: loading(),
                                      ),
                                    );
                                  }

                                  if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return Center(
                                      key: ValueKey("noResults"),
                                      child: Text(
                                        searchMessage,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  }

                                  /// ✅ Assign fetched data correctly
                                  fetchedData = snapshot.data!;

                                  return ListView.builder(
                                    key: ValueKey("searchResults"),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: fetchedData.length,
                                    itemBuilder: (context, index) {
                                      bool isInserted =
                                          fetchedData[index]['isInserted'];
                                      bool isInNameSheet =
                                          fetchedData[index]['isInNameSheet'];

                                      // ✅ Build money display string
                                      String moneyText = "";
                                      if ((fetchedData[index]['riel'] ?? 0) > 0)
                                        moneyText +=
                                            '៛ ${_sheetsService.formatMoney(double.parse('${fetchedData[index]['riel']}'))}';
                                      if ((fetchedData[index]['dollar'] ??
                                              0.0) >
                                          0)
                                        moneyText +=
                                            '\$ ${_sheetsService.formatMoney(double.parse('${fetchedData[index]['dollar']}'), isDollar: true)}';
                                      if ((fetchedData[index]['khqrRiel'] ??
                                              0) >
                                          0)
                                        moneyText +=
                                            "  ៛ ${_sheetsService.formatMoney(double.parse('${fetchedData[index]['khqrRiel']}'))}";
                                      if ((fetchedData[index]['khqrDollar'] ??
                                              0.0) >
                                          0)
                                        moneyText +=
                                            "  \$ ${_sheetsService.formatMoney(double.parse('${fetchedData[index]['khqrDollar']}'), isDollar: true)}";

                                      return ListTile(
                                        onTap: isInserted
                                            ? null
                                            : () {
                                                setState(() {
                                                  nameController.text =
                                                      fetchedData[index]
                                                          ['name'];
                                                  selectedStatus =
                                                      fetchedData[index]
                                                          ['status'];
                                                  isSearching = false;
                                                  searchController.clear();
                                                  fetchedData.clear();
                                                });
                                              },
                                        title: Text(
                                          fetchedData[index]['name'],
                                          style: TextStyle(
                                            color: isInserted
                                                ? AppColor.LIGHTBLUE
                                                : (isInNameSheet
                                                    ? AppColor.WHITE
                                                    : Colors.blue),
                                            fontSize: 18,
                                            fontFamily: KhmerFonts.preahvihear,
                                            package: 'khmer_fonts',
                                            decoration: isInserted
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                            decorationColor: AppColor.LIGHTBLUE,
                                            decorationThickness: 2,
                                          ),
                                        ),
                                        subtitle: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Display status
                                            Text(
                                              "ចំណាត់: ${fetchedData[index]['status']}",
                                              style: TextStyle(
                                                color: isInserted
                                                    ? AppColor.LIGHTBLUE
                                                    : AppColor.WHITE_60,
                                                fontSize: 14,
                                                fontFamily:
                                                    KhmerFonts.preahvihear,
                                                package: 'khmer_fonts',
                                                decoration: isInserted
                                                    ? TextDecoration.lineThrough
                                                    : TextDecoration.none,
                                                decorationColor:
                                                    AppColor.LIGHTBLUE,
                                                decorationThickness: 2,
                                              ),
                                            ),
                                            // Display money only if it is not empty
                                            if (moneyText.isNotEmpty)
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  if ((fetchedData[index]
                                                                  ['riel'] ??
                                                              0) >
                                                          0 ||
                                                      (fetchedData[index]
                                                                  ['dollar'] ??
                                                              0.0) >
                                                          0)
                                                    Text(
                                                      "💰  ",
                                                    ),
                                                  if ((fetchedData[index][
                                                                  'khqrRiel'] ??
                                                              0) >
                                                          0 ||
                                                      (fetchedData[index][
                                                                  'khqrDollar'] ??
                                                              0.0) >
                                                          0)
                                                    Image.asset(
                                                      'assets/icons/khqr_logo.png',
                                                      height: 10,
                                                      color: AppColor.WHITE,
                                                    ),
                                                  Text(
                                                    moneyText,
                                                    style: TextStyle(
                                                      color:
                                                          AppColor.LIGHTBLUE1,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: KhmerFonts
                                                          .preahvihear,
                                                      package: 'khmer_fonts',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              )
                            : Column(
                                key: ValueKey("formFields"),
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: AppColor.WHITE.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Column(
                                      spacing: 12,
                                      children: [
                                        textField(
                                          label: 'ឈ្មោះភ្ញៀវ',
                                          controller: nameController,
                                          focusNode: nameFN,
                                          onEditingComplete: () {
                                            nameFN.unfocus();
                                          },
                                        ),
                                        // Replace the status text field with a radio button group.
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedStatus = 'ផ្សេងៗ';
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Radio<String>(
                                                    value: 'ផ្សេងៗ',
                                                    groupValue: selectedStatus,
                                                    activeColor: AppColor
                                                        .BLUE_OPACITY_70,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedStatus = value!;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    'ផ្សេងៗ',
                                                    style: TextStyle(
                                                      color: AppColor.WHITE,
                                                      fontSize: 14,
                                                      fontFamily: KhmerFonts
                                                          .preahvihear,
                                                      package: 'khmer_fonts',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedStatus = 'ខាងប្រុស';
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Radio<String>(
                                                    value: 'ខាងប្រុស',
                                                    groupValue: selectedStatus,
                                                    activeColor: AppColor
                                                        .BLUE_OPACITY_70,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedStatus = value!;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    'ខាងប្រុស',
                                                    style: TextStyle(
                                                      color: AppColor.WHITE,
                                                      fontSize: 14,
                                                      fontFamily: KhmerFonts
                                                          .preahvihear,
                                                      package: 'khmer_fonts',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedStatus = 'ខាងស្រី';
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Radio<String>(
                                                    value: 'ខាងស្រី',
                                                    groupValue: selectedStatus,
                                                    activeColor: AppColor
                                                        .BLUE_OPACITY_70,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedStatus = value!;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    'ខាងស្រី',
                                                    style: TextStyle(
                                                      color: AppColor.WHITE,
                                                      fontSize: 14,
                                                      fontFamily: KhmerFonts
                                                          .preahvihear,
                                                      package: 'khmer_fonts',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedStatus =
                                                  selectedStatus == 'KHQR'
                                                      ? ''
                                                      : 'KHQR';
                                            });
                                          },
                                          child: AnimatedSwitcher(
                                            duration:
                                                Duration(milliseconds: 400),
                                            transitionBuilder: (Widget child,
                                                Animation<double> animation) {
                                              return ScaleTransition(
                                                  scale: animation,
                                                  child: child);
                                            },
                                            child: GestureDetector(
                                              key: ValueKey(
                                                  isKHQR ? true : false),
                                              onTap: () {
                                                setState(() {
                                                  isKHQR = !isKHQR;
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: isKHQR
                                                      ? AppColor.RED_OPACITY
                                                      : AppColor.WHITE
                                                          .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        'តាម',
                                                        style: TextStyle(
                                                          color: AppColor.WHITE,
                                                          fontSize: 16,
                                                          fontFamily: KhmerFonts
                                                              .preahvihear,
                                                          package:
                                                              'khmer_fonts',
                                                        ),
                                                      ),
                                                      SizedBox(width: 18),
                                                      Image.asset(
                                                        'assets/icons/khqr_logo.png',
                                                        height: 12,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 250,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: AppColor.WHITE,
                                                width: 1),
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              AnimatedPositioned(
                                                duration:
                                                    Duration(milliseconds: 500),
                                                curve: Curves.easeInOut,
                                                left: isRiel ? 1 : 125,
                                                right: isRiel ? 125 : 1,
                                                child: Container(
                                                  width: 125,
                                                  height: 36,
                                                  decoration: BoxDecoration(
                                                    color: AppColor
                                                        .BLUE_OPACITY_70,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
                                                  ),
                                                ),
                                              ),

                                              // ✅ Text Labels
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .opaque,
                                                      onTap: () {
                                                        setState(() {
                                                          isRiel = true;
                                                          dollarController
                                                              .clear();
                                                        });
                                                      },
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          'រៀល',
                                                          style: TextStyle(
                                                            color: isRiel
                                                                ? AppColor.WHITE
                                                                : AppColor
                                                                    .WHITE_60,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                KhmerFonts
                                                                    .preahvihear,
                                                            package:
                                                                'khmer_fonts',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .opaque,
                                                      onTap: () {
                                                        setState(() {
                                                          isRiel = false;
                                                          rielController
                                                              .clear();
                                                        });
                                                      },
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          'ដុល្លារ',
                                                          style: TextStyle(
                                                            color: !isRiel
                                                                ? AppColor.WHITE
                                                                : AppColor
                                                                    .WHITE_60,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                KhmerFonts
                                                                    .preahvihear,
                                                            package:
                                                                'khmer_fonts',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        AnimatedSwitcher(
                                          duration: Duration(milliseconds: 500),
                                          transitionBuilder:
                                              (child, animation) {
                                            // A combined slide & fade transition:
                                            final inAnimation = Tween<Offset>(
                                              begin: Offset(0.0, 0.2),
                                              end: Offset(0.0, 0.0),
                                            ).animate(animation);
                                            return SlideTransition(
                                              position: inAnimation,
                                              child: FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              ),
                                            );
                                          },
                                          child: SizedBox(
                                            key: ValueKey(
                                                isRiel ? 'riel' : 'dollar'),
                                            height: 60,
                                            child: textField(
                                              label: isRiel ? 'រៀល' : 'ដុល្លារ',
                                              controller: isRiel
                                                  ? rielController
                                                  : dollarController,
                                              focusNode:
                                                  isRiel ? rielFN : dollarFN,
                                              keyboardType:
                                                  TextInputType.number,
                                              onEditingComplete: () {
                                                isRiel
                                                    ? rielFN.unfocus()
                                                    : dollarFN.unfocus();
                                              },
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: isLoadingInsert
                                              ? null
                                              : insertData,
                                          child: Obx(() {
                                            return SizedBox(
                                              width: 120,
                                              child: isLoadingInsert
                                                  ? Container(
                                                      height: 32,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 42,
                                                          vertical: 4),
                                                      child: loading(),
                                                    )
                                                  : Center(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          if (_sheetsService
                                                                  .buttonText
                                                                  .value ==
                                                              'ជោគជ័យ')
                                                            Icon(
                                                              CupertinoIcons
                                                                  .checkmark_alt,
                                                              size: 18,
                                                              color:
                                                                  AppColor.BLUE,
                                                            ),
                                                          if (_sheetsService
                                                                  .buttonText
                                                                  .value ==
                                                              'ជោគជ័យ')
                                                            SizedBox(width: 6),
                                                          Text(
                                                            _sheetsService
                                                                .buttonText
                                                                .value,
                                                            style: TextStyle(
                                                              color:
                                                                  AppColor.BLUE,
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  KhmerFonts
                                                                      .preahvihear,
                                                              package:
                                                                  'khmer_fonts',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 32),
                                  Center(
                                    child: Text(
                                      'កម្មវិធីជំនាន់ទី ${_sheetsService.toKhmerNumber(appVersion)}',
                                      style: TextStyle(
                                        color: AppColor.WHITE,
                                        fontSize: 16,
                                        fontFamily: KhmerFonts.preahvihear,
                                        package: 'khmer_fonts',
                                      ),
                                    ),
                                  )
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  swtichButton({
    required String title,
    bool isSelected = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppColor.BLUE_OPACITY_70 : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: AppColor.WHITE,
          fontSize: 14,
          fontFamily: KhmerFonts.preahvihear,
          package: 'khmer_fonts',
        ),
      ),
    );
  }

  loading() {
    return LoadingIndicator(
      indicatorType: Indicator.lineScalePulseOutRapid,
      colors: [
        AppColor.BLUE_OPACITY_70,
        AppColor.RED_OPACITY,
        Colors.amber,
      ],
      strokeWidth: 2,
    );
  }

  textField({
    Key? key,
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    Function(String)? onChanged,
    Function(String)? onFieldSubmitted,
    Function()? onEditingComplete,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return TextFormField(
          key: key,
          controller: controller,
          focusNode: focusNode,
          textInputAction: textInputAction ?? TextInputAction.done,
          keyboardType: keyboardType ?? TextInputType.text,
          decoration: InputDecoration(
            labelStyle: TextStyle(
              color: AppColor.WHITE,
              fontSize: 14,
              fontFamily: KhmerFonts.preahvihear,
              package: 'khmer_fonts',
            ),
            hintText: label,
            hintStyle: TextStyle(
              color: AppColor.WHITE,
              fontSize: 14,
              fontFamily: KhmerFonts.preahvihear,
              package: 'khmer_fonts',
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: controller.text.isNotEmpty
                    ? AppColor.BLUE_OPACITY_70
                    : AppColor.WHITE,
                width: 1,
              ),
              borderRadius: controller.text.isNotEmpty
                  ? BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                      topRight: Radius.circular(6),
                      bottomLeft: Radius.circular(6),
                    )
                  : BorderRadius.circular(6),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.BLUE_OPACITY_70,
                width: 1.5,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
                topRight: Radius.circular(6),
                bottomLeft: Radius.circular(6),
              ),
            ),
          ),
          style: TextStyle(
            color: controller.text.isNotEmpty ? AppColor.BLUE : AppColor.WHITE,
            fontSize: 14,
            fontFamily: KhmerFonts.preahvihear,
            package: 'khmer_fonts',
          ),
          onChanged: (val) {
            if (onChanged != null) {
              onChanged(val);
            }
          },
          onFieldSubmitted: (val) {
            if (onFieldSubmitted != null) {
              onFieldSubmitted(val);
            }
          },
          onEditingComplete: () {
            if (onEditingComplete != null) {
              onEditingComplete();
            }
          },
        );
      },
    );
  }
}
