import 'dart:developer';
import 'dart:convert'; // Import for JSON encoding
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../ip_address.dart';

class GoogleSheetsService extends GetxController {
  final Dio _dio = Dio();
  RxString buttonText = 'បញ្ចូល'.obs;

  Future<void> insertData(
    String no,
    String name,
    String status,
    String riel,
    String dollar,
    bool isKHQR,
  ) async {
    try {
      final requestData = {
        "no": no,
        "name": name,
        "status": status,
        "riel": riel,
        "dollar": dollar,
        "isKHQR": isKHQR.toString(), // Convert boolean to string
      };

      // ✅ Log the request data as formatted JSON
      log("🔵 Sending POST Request to: $appScriptUrl");
      log("📤 Request Data:\n${JsonEncoder.withIndent('  ').convert(requestData)}");

      final response = await _dio.post(
        appScriptUrl,
        data: requestData,
        options: Options(
          followRedirects: false,
          validateStatus: (status) => status == 200,
        ),
      );

      final GoogleSheetsService googleSheetsService =
          Get.find<GoogleSheetsService>();

      if (response.statusCode == 200) {
        var responseData = response.data;

        // ✅ Log the response data as formatted JSON
        log("🟢 Received Response:\n${JsonEncoder.withIndent('  ').convert(responseData)}");

        googleSheetsService.buttonText.value =
            responseData['status'] == "error" ? 'ទិន្នន័យស្ទួន' : 'ជោគជ័យ';
      }
    } catch (e) {
      log("🔴 Error inserting data: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchRecords({String? searchQuery}) async {
    try {
      // ✅ Log the request before sending
      log("🔵 Fetching Data from: $appScriptUrl with Query: ${searchQuery ?? ''}");

      final response = await _dio.get(appScriptUrl, queryParameters: {
        "query": searchQuery ?? "",
      });

      if (response.statusCode == 200) {
        var rawData = response.data;

        // ✅ Log the response as formatted JSON
        log("🟢 Received Response:\n${JsonEncoder.withIndent('  ').convert(rawData)}");

        if (rawData is List) {
          return rawData.map((item) {
            return {
              "no": item["no"]?.toString() ?? "N/A",
              "name": item["name"]?.toString() ?? "Unknown",
              "status": item["status"]?.toString() ?? "មិនទាន់បញ្ចូល",
              "isInserted": item["isInserted"] ?? false,
              "isInNameSheet": item["isInNameSheet"] ?? false,
              "riel": item["riel"] ?? 0,
              "dollar": item["dollar"] ?? 0,
              "khqrRiel": item["khqrRiel"] ?? 0,
              "khqrDollar": item["khqrDollar"] ?? 0,
            };
          }).toList();
        } else {
          log("⚠️ Unexpected data format: $rawData");
        }
      }
    } catch (e) {
      log("🔴 Error fetching data: $e");
    }
    return [];
  }

//   String formatMoney(num amount, {bool isDollar = false}) {
//   final formatter = isDollar
//       ? NumberFormat("#,##0.00", "km_KH") // USD: #,###.00
//       : NumberFormat("#,##0", "km_KH"); // KHR: #,###,###

//   return formatter.format(amount);
// }
  String toKhmerNumber(String number) {
    const khmerDigits = ['០', '១', '២', '៣', '៤', '៥', '៦', '៧', '៨', '៩'];
    return number.split('').map((char) {
      if (RegExp(r'[0-9]').hasMatch(char)) {
        return khmerDigits[int.parse(char)];
      }
      return char;
    }).join('');
  }

  String formatMoney(num amount, {bool isDollar = false}) {
    final formatted =
        NumberFormat(isDollar ? "#,##0.00" : "#,###").format(amount);
    return toKhmerNumber(formatted); // Convert numbers to Khmer numerals
  }
}
