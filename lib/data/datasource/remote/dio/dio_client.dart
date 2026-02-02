import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mahakal/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:mahakal/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  final SharedPreferences sharedPreferences;

  Dio? dio;
  String? token;
  String? countryCode;

  DioClient(
    this.baseUrl,
    Dio? dioC, {
    required this.loggingInterceptor,
    required this.sharedPreferences,
  }) {
    token = sharedPreferences.getString(AppConstants.userLoginToken);
    countryCode = sharedPreferences.getString(AppConstants.countryCode) ??
        AppConstants.languages[0].countryCode;
    if (kDebugMode) {
      print("NNNN $token");
    }
    dio = dioC ?? Dio();
    dio
      ?..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(seconds: 60)
      ..options.receiveTimeout = const Duration(seconds: 60)
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        AppConstants.langKey:
            countryCode == 'US' ? 'en' : countryCode!.toLowerCase(),
      };
    dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("➡️ REQUEST: [${options.method}] ${options.uri}");
          _simpleLog("Headers: ${options.headers}");
          if (options.data != null) {
            _simpleLog("Body: ${options.data}");
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          print(
              "✅ RESPONSE [${response.statusCode}] => ${response.requestOptions.uri}");
          _simpleLog("Response Data: ${response.data}");
          handler.next(response);
        },
        onError: (DioException e, handler) {
          print(
              "❌ ERROR [${e.response?.statusCode}] => ${e.requestOptions.uri}");
          _simpleLog("Error: ${e.message}");
          if (e.response?.data != null) {
            _simpleLog("Error Data: ${e.response?.data}");
          }
          handler.next(e);
        },
      ),
    );
  }

  void _simpleLog(dynamic data) {
    final lines = data.toString().split('\n');
    final limited = lines.take(50).join('\n');
    print(limited);
    if (lines.length > 300) {
      print("... [Log truncated to 100 lines]");
    }
  }

  void updateHeader(String? token, String? countryCode) {
    token = token ?? this.token;
    countryCode = countryCode == null
        ? this.countryCode == 'US'
            ? 'en'
            : this.countryCode!.toLowerCase()
        : countryCode == 'US'
            ? 'en'
            : countryCode.toLowerCase();
    this.token = token;
    this.countryCode = countryCode;
    dio!.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
      AppConstants.langKey:
          countryCode == 'US' ? 'en' : countryCode.toLowerCase(),
    };
  }

  Future<Response> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio!.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio!.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio!.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      var response = await dio!.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
}
