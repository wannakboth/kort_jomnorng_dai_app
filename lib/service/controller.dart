import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:kort_jomnorng_dai_app/widget/url.dart';
import 'create_model.dart';
import 'search_model.dart';

class ApiController {
  final Dio _dio = Dio();

  Future<SearchResponse> fetchSearchData({
    String search = '',
    String currency = 'all',
    int page = 1,
    int size = 15,
  }) async {
    final response = await _dio.post(
      searchUrl, // Replace with your API endpoint
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
