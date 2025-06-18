import 'package:dio/dio.dart';

class DioHelper {
  static Dio dio = Dio();

  static const String baseUrl = 'https://glowup.runasp.net';
  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://glowup.runasp.net/api/BlackHat',
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }
  static Future<Response> getData(String endPoint){
    return dio.get(baseUrl+endPoint,
    options: Options(
      validateStatus: (status)=> true
    )
    );

  }
  // static Future<Response> getData({
  //   required String url,
  //   Map<String, dynamic>? query,
  //   String? lang = 'en',
  //   String? token,
  // }) async {
  //   dio.options.headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $token',
  //   };

  //   final uri = Uri.parse(
  //     dio.options.baseUrl + url,
  //   ).replace(queryParameters: query);
  //   print('🔗 Full Request URL: $uri');
  //
  //   return await dio.get(url, queryParameters: query);
  // }

  static Future<Response> postData({
    required dynamic data,
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type':
          data is FormData ? 'multipart/form-data' : 'application/json',
      'Authorization': 'Bearer $token',
    };

    final uri = Uri.parse(
      dio.options.baseUrl + url,
    ).replace(queryParameters: query);
    print('🔗 Full Request URL: $uri');

    return await dio.post(url, data: data, queryParameters: query);
  }

  static Future<Response> putData({
    required String url,
    Map<String, dynamic>? data,
    required Map<String, dynamic> query,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final uri = Uri.parse(
      dio.options.baseUrl + url,
    ).replace(queryParameters: query);
    print('🔗 Full Request URL: $uri');
    return await dio.put(url, data: data, queryParameters: query);
  }

  static Future<Response> deleteData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    return await dio.delete(url, queryParameters: query);
  }
}
