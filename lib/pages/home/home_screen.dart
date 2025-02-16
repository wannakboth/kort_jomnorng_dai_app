import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:khmer_fonts/khmer_fonts.dart';

import '../../service/gsheet/google_sheet.service.dart';
import '../../widget/color.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GoogleSheetsService _sheetsService = Get.find();
  final TextEditingController noController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController rielController = TextEditingController();
  final TextEditingController dollarController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> fetchedData = [];
  String searchMessage = "Type a keyword to search or press 'Show All'";

  /// Fetch search results from Google Sheets
  void fetchSearchResults() async {
    String query = searchController.text.trim();

    if (query.isEmpty) {
      // Show all items if search is empty
      fetchAllData();
      return;
    }

    var data = await _sheetsService.fetchData(searchQuery: query);

    setState(() {
      fetchedData = data;
      searchMessage = data.isEmpty ? "No records found" : "";
    });
  }

  /// Fetch all data from Google Sheets
  void fetchAllData() async {
    var data =
        await _sheetsService.fetchData(); // No search query to get all items

    setState(() {
      fetchedData = data;
      searchMessage = data.isEmpty ? "No records found" : "";
    });
  }

  /// Fill text fields with selected search result
  void selectItem(Map<String, dynamic> item) {
    setState(() {
      noController.text = item['no'].toString();
      nameController.text = item['name'].toString();
      statusController.text = item['status'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/background/background.JPG', // Your background image
                fit: BoxFit.cover, // Make it cover the entire screen
              ),
            ),
            Container(
              color: AppColor.SECONDARY.withOpacity(0.75),
            ),
            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    'កត់ចំណងដៃ',
                    style: TextStyle(
                      fontFamily: KhmerFonts.fasthand,
                      fontSize: 24,
                      package: 'khmer_fonts',
                      color: AppColor.WHITE,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColor.WHITE.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Icon(
                                  Icons.alternate_email_rounded,
                                  color: AppColor.WHITE,
                                  size: 24,
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: nameController,
                                  // focusNode: controller.usernameFN,
                                  obscureText: false,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(
                                      color: AppColor.WHITE,
                                      fontSize: 14,
                                    ),
                                    hintText: 'Username',
                                    hintStyle: TextStyle(
                                      color: AppColor.WHITE,
                                      fontSize: 14,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColor.WHITE,
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        // color: AppColors.primaryText,
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColor.RED,
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColor.RED,
                                        width: 1,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: AppColor.WHITE,
                                    fontSize: 14,
                                  ),
                                  onEditingComplete: () {
                                    // FocusScope.of(Get.context!)
                                    //     .requestFocus(controller.passwordFN);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextField(
                          controller: noController,
                          decoration: InputDecoration(labelText: "លេខ"),
                        ),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: "ឈ្មោះ"),
                        ),
                        TextField(
                          controller: statusController,
                          decoration: InputDecoration(labelText: "ចំណាត់"),
                        ),
                        // TextField(
                        //   controller: rielController,
                        //   decoration: InputDecoration(labelText: "Riel"),
                        // ),
                        // TextField(
                        //   controller: dollarController,
                        //   decoration: InputDecoration(labelText: "Dollar"),
                        // ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _sheetsService.insertData(
                                noController.text,
                                nameController.text,
                                statusController.text,
                                rielController.text,
                                dollarController.text);
                          },
                          child: Text("Insert Data"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Search Bar with "Show All" Button
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            labelText: "Search",
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: fetchSearchResults,
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) fetchAllData();
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: fetchAllData,
                        child: Text("Show All"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Search Results or Messages
                  Expanded(
                    child: fetchedData.isEmpty
                        ? Center(
                            child: Text(
                              searchMessage,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: fetchedData.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(fetchedData[index]['name']),
                                subtitle: Text(
                                    "លេខ: ${fetchedData[index]['no']} | ចំណាត់: ${fetchedData[index]['status']}"),
                                onTap: () => selectItem(fetchedData[
                                    index]), // Click to fill text fields
                              );
                            },
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
}
