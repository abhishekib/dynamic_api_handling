import 'dart:developer';
import 'package:allworkdone/model.dart';
import 'package:dio/dio.dart';

class SearchProvider {
  final Dio _dio;

  SearchProvider()
      : _dio = Dio(
          BaseOptions(
            baseUrl: "https://www.mafatihuljinan.org/wp-json/customapi/v1/",
            headers: {
              'Content-Type': 'application/json',
              'Authorization':
                  'Bearer MTAtMDctMjAyNCAwNTo1MjozOGNZUlNldVpVaG5vZDhGNVM=',
            },
          ),
        );

  Future<ApiResponseHandler> fetchSearchResults({
    required String keywords,
    required int page,
  }) async {
    try {
      final response = await _dio.post(
        "search",
        queryParameters: {
          "keywords": keywords,
          "page": page,
        },
      );
      log(response.data.toString());
      if (response.statusCode == 200) {
        return ApiResponseHandler.fromJson(response.data);
      } else {
        log('Failed to fetch search data', error: response.data);
        throw Exception('Failed to fetch search data');
      }
    } catch (e) {
      log('Error fetching search data: $e');
      throw Exception('Error fetching search data: $e');
    }
  }
}
