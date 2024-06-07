import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../widget/url.dart';
import 'model.dart';

class ApiController {
  Future<ApiResponse> fetchData(
    String search,
    String currency,
    int page,
    int size,
  ) async {
    final response = await http.post(
      Uri.parse(searchUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'search': search,
        'currency': currency,
        'page': page,
        'size': size,
      }),
    );

    if (response.statusCode == 200) {
      final data = ApiResponse.fromJson(jsonDecode(response.body));
      log(response.body);

      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
