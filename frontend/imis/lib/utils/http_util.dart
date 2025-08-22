// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:imis/utils/auth_util.dart';
import 'package:motion_toast/motion_toast.dart';

class AuthenticatedRequest {
  static Response<dynamic> _onRequestError(
    DioException e, {
    BuildContext? context,
  }) {
    MotionToast.error(
      title: const Text("Invalid credentials!"),
      description: const Text("Please check your username and password."),
      toastAlignment: Alignment.center,
    ).show;
    return e.response!;
  }

  static Future<Response<dynamic>> get(
    Dio dio,
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    BuildContext? context,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final loggedUser = await AuthUtil.processTokenValidity(dio, context);
      var response = await dio.get(
        url,
        options: Options(
          headers: {"Authorization": "Bearer ${loggedUser!.accessToken}"},
        ),
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      return _onRequestError(e, context: context);
    }
  }

  static Future<Response<dynamic>> post(
    Dio dio,
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    BuildContext? context,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final loggedUser = await AuthUtil.processTokenValidity(dio, context);

      var response = await dio.post(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${loggedUser!.accessToken}",
            Headers.contentTypeHeader: 'application/json',
          },
        ),
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return response;
    } on DioException catch (e) {
      return _onRequestError(e, context: context);
    }
  }

  static Future<Response<dynamic>> put(
    Dio dio,
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    BuildContext? context,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final loggedUser = await AuthUtil.processTokenValidity(dio, context);

      var response = await dio.put(
        url,
        options: Options(
          headers: {"Authorization": "Bearer ${loggedUser!.accessToken}"},
        ),
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return response;
    } on DioException catch (e) {
      return _onRequestError(e, context: context);
    }
  }

  static Future<Response<dynamic>> delete(
    Dio dio,
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    BuildContext? context,
    CancelToken? cancelToken,
  }) async {
    try {
      final loggedUser = await AuthUtil.processTokenValidity(dio, context);
      var response = await dio.delete(
        url,
        options: Options(
          headers: {"Authorization": "Bearer ${loggedUser!.accessToken}"},
        ),
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );

      return response;
    } on DioException catch (e) {
      return _onRequestError(e, context: context);
    }
  }

  static Future<Response<dynamic>> patch(
    Dio dio,
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    BuildContext? context,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final loggedUser = await AuthUtil.processTokenValidity(dio, context);
      var response = await dio.patch(
        url,
        options: Options(
          headers: {"Authorization": "Bearer ${loggedUser!.accessToken}"},
        ),
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return response;
    } on DioException catch (e) {
      return _onRequestError(e, context: context);
    }
  }
}
