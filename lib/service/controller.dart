import 'dart:developer';
import 'package:dio/dio.dart';
import '../ip_address.dart';
import '../widget/url.dart';
import 'create_model.dart';
import 'search_model.dart';

class ApiController {
  final Dio _dio = Dio();

  Future<void> _initializeUrls() async {
    // Ensure URLs are correctly set before making API calls
    apiUrl = 'http://172.16.10.239:5000/api';
    searchUrl = '$apiUrl/search';
    createUrl = '$apiUrl/currency';
  }

  Future<SearchResponse> fetchSearchData({
    String search = '',
    String currency = 'all',
    int page = 1,
    int size = 15,
  }) async {
    await _initializeUrls(); // Initialize URLs
    final response = await _dio.post(
      searchUrl,
      data: {
        'search': search,
        'currency': currency,
        'page': page,
        'size': size,
      },
    );

    if (response.statusCode == 200) {
      log('${response.data}');
      return SearchResponse.fromJson(response.data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<CreateResponse> postInsertAmount(Transaction transaction) async {
    await _initializeUrls(); // Initialize URLs
    try {
      final response = await _dio.post(
        createUrl,
        data: transaction.toJson(),
      );

      if (response.statusCode == 201) {
        log('${response.data}');
        return CreateResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to post data');
      }
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }
}
