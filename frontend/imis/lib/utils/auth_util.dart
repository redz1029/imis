import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:imis/user/models/user_registration.dart';
import 'package:imis/user/pages/login_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthUtil {
  static const String key = "user";
  static const String rolesKey = "roles";
  static const String officeNamesKey = "officeNames";
  static const String officeIdsKey = "officeIds";
  static const String selectedOfficeIdKey = "selectedOfficeId";
  static const String isLoggedInKey = "isLoggedIn";
  static const String accessTokenKey = "accessToken";
  static const String refreshTokenKey = "refreshToken";

  static Future<UserRegistration> storeUserAuth(
    Response<dynamic> response,
    Dio dio, [
    Options? options,
  ]) async {
    var user = UserRegistration.fromJson(response.data);
    SharedPreferences sharedPref = await SharedPreferences.getInstance();

    String accessToken = response.data['accessToken'] ?? '';
    if (accessToken.isNotEmpty) {
      await sharedPref.setString(accessTokenKey, accessToken);
    }

    String refreshToken = response.data['refreshToken'] ?? '';
    if (accessToken.isNotEmpty) {
      await sharedPref.setString(accessTokenKey, refreshToken);
    }

    if (response.data['roles'] != null) {
      String rolesJson = jsonEncode(response.data['roles']);
      await sharedPref.setString(rolesKey, rolesJson);
    }

    if (response.data['offices'] != null) {
      List<dynamic> offices = response.data['offices'];
      List<String> officeNames =
          offices.map((o) => o['name'].toString()).toList();
      List<String> officeIds = offices.map((o) => o['id'].toString()).toList();

      await sharedPref.setStringList(officeNamesKey, officeNames);
      await sharedPref.setStringList(officeIdsKey, officeIds);
    }

    await sharedPref.setString(key, jsonEncode(user.toJson()));

    await sharedPref.setBool(isLoggedInKey, true);
    return user;
  }

  static Future<UserRegistration?> fetchLoggedUser([
    SharedPreferences? sharedPref,
  ]) async {
    sharedPref ??= await SharedPreferences.getInstance();
    String? userJson = sharedPref.getString(key);

    if (userJson != null) {
      return UserRegistration.fromJson(jsonDecode(userJson));
    }

    return null;
  }

  static Future<String?> fetchAccessToken([
    SharedPreferences? sharedPref,
  ]) async {
    sharedPref ??= await SharedPreferences.getInstance();
    return sharedPref.getString(accessTokenKey);
  }

  static Future<String?> fetchRefreshToken([
    SharedPreferences? sharedPref,
  ]) async {
    sharedPref ??= await SharedPreferences.getInstance();
    return sharedPref.getString(refreshTokenKey);
  }

  static Future<List<String>?> fetchRoles([
    SharedPreferences? sharedPref,
  ]) async {
    sharedPref ??= await SharedPreferences.getInstance();
    String? rolesJson = sharedPref.getString(rolesKey);

    if (rolesJson != null) {
      List<dynamic> rolesListDynamic = jsonDecode(rolesJson);
      return rolesListDynamic.cast<String>();
    }
    return null;
  }

  static Future<List<String>?> fetchOfficeNames([
    SharedPreferences? sharedPref,
  ]) async {
    sharedPref ??= await SharedPreferences.getInstance();
    return sharedPref.getStringList(officeNamesKey);
  }

  static Future<List<String>?> fetchOfficeIds([
    SharedPreferences? sharedPref,
  ]) async {
    sharedPref ??= await SharedPreferences.getInstance();
    return sharedPref.getStringList(officeIdsKey);
  }

  static Future<String?> fetchSelectedOfficeId([
    SharedPreferences? sharedPref,
  ]) async {
    sharedPref ??= await SharedPreferences.getInstance();
    return sharedPref.getString(selectedOfficeIdKey);
  }

  static Future<void> removeSelectedOfficeId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(selectedOfficeIdKey);
  }

  static Future<bool> isLoggedIn([SharedPreferences? sharedPref]) async {
    sharedPref ??= await SharedPreferences.getInstance();
    return sharedPref.getBool(isLoggedInKey) ?? false;
  }

  static Future<void> saveSelectedOfficeId(String officeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(selectedOfficeIdKey, officeId);
  }

  static Future<void> setIsLoggedIn(bool status) async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setBool(isLoggedInKey, status);
  }

  static Future<void> logout() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    await sharedPref.remove(key);
    await sharedPref.remove(rolesKey);
    await sharedPref.remove(officeNamesKey);
    await sharedPref.remove(officeIdsKey);
    await sharedPref.remove(selectedOfficeIdKey);
    await sharedPref.remove(isLoggedInKey);
  }

  static void setupDioInterceptors(
    Dio dio,
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? accessToken = await fetchAccessToken();

          if (accessToken == null || JwtDecoder.isExpired(accessToken)) {
            await logout();

            // Show alert dialog using navigatorKey.currentState?.context
            BuildContext? context = navigatorKey.currentState?.overlay?.context;
            if (context != null) {
              // Show dialog and wait for user to press OK
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Session Expired'),
                      content: const Text(
                        'Your session has expired. Please log in again.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();

                            navigatorKey.currentState?.pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
              );
            } else {
              // Fallback if context is null
              navigatorKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            }

            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'Access token expired or missing',
                type: DioExceptionType.cancel,
              ),
            );
          }

          options.headers['Authorization'] = 'Bearer $accessToken';
          return handler.next(options);
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == 401) {
            await logout();

            BuildContext? context = navigatorKey.currentState?.overlay?.context;
            if (context != null) {
              await showDialog(
                // ignore: use_build_context_synchronously
                context: context,
                barrierDismissible: false,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Session Expired'),
                      content: const Text(
                        'Your session has expired. Please log in again.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            navigatorKey.currentState?.pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
              );
            } else {
              navigatorKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            }
          }
          return handler.next(e);
        },
      ),
    );
  }
}
