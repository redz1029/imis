// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/navigation_utils.dart';
import 'package:imis/user/pages/no_connection_page.dart';
import 'package:motion_toast/motion_toast.dart';

class AuthenticatedRequest {
  static Response<dynamic> _onRequestError(
    DioException e, {
    BuildContext? context,
  }) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.unknown) {
      if (context != null) {
        MotionToast.warning(
          title: const Text("No Connection!"),
          description: const Text("Please check your internet connection."),
          toastAlignment: Alignment.center,
        ).show(context);
      }

      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => const NoConnectionPage()),
      );

      return Response<dynamic>(
        data: {'error': 'no_connection'},
        statusCode: 503,
        statusMessage: 'Service Unavailable',
        requestOptions: e.requestOptions,
      );
    }

    if (context != null) {
      MotionToast.error(
        title: const Text("Invalid Credentials!"),
        description: const Text("Please check your username and password."),
        toastAlignment: Alignment.center,
      ).show(context);
    }

    return e.response!;
  }

  /// Merges the Authorization header into any caller-supplied Options,
  /// preserving responseType, validateStatus, Accept, and other headers.
  static Options _mergeOptions(String accessToken, [Options? options]) {
    final existingHeaders = Map<String, dynamic>.from(
      options?.headers as Map? ?? {},
    );
    existingHeaders['Authorization'] = 'Bearer $accessToken';
    return (options ?? Options()).copyWith(headers: existingHeaders);
  }

  static Future<Response<dynamic>> get(
    Dio dio,
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    BuildContext? context,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final loggedUser = await AuthUtil.processTokenValidity(dio, context);
      return await dio.get(
        url,
        options: _mergeOptions(loggedUser!.accessToken!, options),
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      return _onRequestError(e, context: context);
    }
  }

  static Future<Response<dynamic>> post(
    Dio dio,
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    BuildContext? context,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    String contentType = Headers.jsonContentType,
  }) async {
    try {
      final loggedUser = await AuthUtil.processTokenValidity(dio, context);
      final merged = _mergeOptions(loggedUser!.accessToken!, options);
      final headers = Map<String, dynamic>.from(merged.headers as Map? ?? {});
      headers.putIfAbsent(Headers.contentTypeHeader, () => contentType);

      return await dio.post(
        url,
        options: merged.copyWith(headers: headers),
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      return _onRequestError(e, context: context);
    }
  }

  static Future<Response<dynamic>> put(
    Dio dio,
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    BuildContext? context,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final loggedUser = await AuthUtil.processTokenValidity(dio, context);
      return await dio.put(
        url,
        options: _mergeOptions(loggedUser!.accessToken!, options),
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      return _onRequestError(e, context: context);
    }
  }

  static Future<Response<dynamic>> delete(
    Dio dio,
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    BuildContext? context,
    CancelToken? cancelToken,
  }) async {
    try {
      final loggedUser = await AuthUtil.processTokenValidity(dio, context);
      return await dio.delete(
        url,
        options: _mergeOptions(loggedUser!.accessToken!, options),
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      return _onRequestError(e, context: context);
    }
  }

  static Future<Response<dynamic>> patch(
    Dio dio,
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    BuildContext? context,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final loggedUser = await AuthUtil.processTokenValidity(dio, context);
      return await dio.patch(
        url,
        options: _mergeOptions(loggedUser!.accessToken!, options),
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      return _onRequestError(e, context: context);
    }
  }
}
