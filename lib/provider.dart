import 'dart:developer';
import 'package:allworkdone/model.dart';
import 'package:dio/dio.dart';

class CategoryProvider {
  final Dio _dio;

  CategoryProvider()
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

  Future<ApiResponseHandler> fetchCategoryData() async {
    try {
      final response = await _dio.post("/munajat?lang=english");
      // log(response.data.toString());
      if (response.statusCode == 200) {
        return ApiResponseHandler.fromJson(response.data);
      } else {
        log('Failed to fetch travelziyarat data', error: response.data);
        throw Exception('Failed to fetch travelziyarat data');
      }
    } catch (e) {
      log('Error fetching travelziyarat data: $e');
      throw Exception('Error fetching travelziyarat data: $e');
    }
  }
}
