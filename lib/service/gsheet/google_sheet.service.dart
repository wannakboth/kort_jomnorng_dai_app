import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../ip_address.dart';

class GoogleSheetsService extends GetxController {
  final Dio _dio = Dio();

  Future<void> insertData(
      String no, String name, String status, String riel, String dollar) async {
    try {
      final response = await _dio.post(appScriptUrl, data: {
        "no": no,
        "name": name,
        "status": status,
        "riel": riel,
        "dollar": dollar,
      });

      if (response.statusCode == 200) {
        print("Data inserted successfully: ${response.data}");
      }
    } catch (e) {
      print("Error inserting data: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchData({String? searchQuery}) async {
    try {
      final response = await _dio.get(appScriptUrl, queryParameters: {
        "query": searchQuery ?? "", // Search across all fields
      });

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
    return [];
  }
}
