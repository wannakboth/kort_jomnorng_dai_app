import 'dart:convert';
import 'package:http/http.dart' as http;

import '../widget/url.dart';
import 'model.dart';

class ApiController {
  static Future<ApiResponse> fetchData(String search, String currency) async {
    final response = await http.post(
      Uri.parse(searchUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'search': search,
        'currency': currency, 
      }),
    );

    if (response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}
