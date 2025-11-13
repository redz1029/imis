// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/user/pages/login_page.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/constant.dart';

class AuthUtil {
  static Completer<void>? _refreshLock;
  late final BuildContext context;
  static const String userKey = "user";
  static const String rolesKey = "roles";
  static const String officeNamesKey = "officeNames";
  static const String officeIdsKey = "officeIds";
  static const String selectedOfficeIdKey = "selectedOfficeId";
  static const String isLoggedInKey = "isLoggedIn";
  static const String pgsKey = "pgs";

  static Future<UserRegistration> storeUserAuth(
    Response<dynamic> response,
    Dio dio, [
    Options? options,
  ]) async {
    var user = UserRegistration.fromJson(response.data);
    SharedPreferences sharedPref = await SharedPreferences.getInstance();

    user.accessToken = response.data['accessToken'] ?? '';
    user.refreshToken = response.data['refreshToken'] ?? '';
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
    await sharedPref.setString(userKey, jsonEncode(user.toJson()));
    await sharedPref.setBool(isLoggedInKey, true);
    return user;
  }

  static Future<UserRegistration?> fetchLoggedUser([
    SharedPreferences? sharedPref,
  ]) async {
    sharedPref ??= await SharedPreferences.getInstance();

    String? userJson = sharedPref.getString(userKey);
    if (userJson == null) {
      return null;
    }

    return UserRegistration.fromJson(jsonDecode(userJson));
  }

  static Future<String?> getAccessToken() async {
    final user = await fetchLoggedUser();
    return user?.accessToken;
  }

  static Future<List<String>?> fetchRoles() async {
    final sharedPref = await SharedPreferences.getInstance();
    String? rolesJson = sharedPref.getString(rolesKey);
    return rolesJson != null ? List<String>.from(jsonDecode(rolesJson)) : null;
  }

  static Future<List<String>?> fetchOfficeNames() async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getStringList(officeNamesKey);
  }

  static Future<List<String>?> fetchOfficeIds() async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getStringList(officeIdsKey);
  }

  static Future<String?> fetchSelectedOfficeId() async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString(selectedOfficeIdKey);
  }

  static Future<void> removeSelectedOfficeId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(selectedOfficeIdKey);
  }

  static Future<bool> isLoggedIn() async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getBool(isLoggedInKey) ?? false;
  }

  static Future<void> saveSelectedOfficeId(String officeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(selectedOfficeIdKey, officeId);
  }

  static Future<void> setIsLoggedIn(bool status) async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setBool(isLoggedInKey, status);
  }

  static Future<void> logout(BuildContext context) async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.remove(userKey);
    await sharedPref.remove(rolesKey);
    await sharedPref.remove(officeNamesKey);
    await sharedPref.remove(officeIdsKey);
    await sharedPref.remove(selectedOfficeIdKey);
    await sharedPref.remove(isLoggedInKey);
    await sharedPref.remove(pgsKey);

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  static Future<UserRegistration?> processTokenValidity(
    Dio dio, [
    BuildContext? context,
  ]) async {
    var loggedUser = await fetchLoggedUser();

    if (loggedUser != null) {
      var accessToken = jwtDecode(loggedUser.accessToken!);
      bool isAccessTokenExpired = accessToken.isExpired ?? true;

      if (!isAccessTokenExpired) {
        return loggedUser;
      }

      if (_refreshLock != null && !_refreshLock!.isCompleted) {
        await _refreshLock!.future;
        return await fetchLoggedUser();
      }

      _refreshLock = Completer<void>();

      try {
        final refreshToken = jwtDecode(loggedUser.refreshToken!);
        bool isRefreshTokenExpired = refreshToken.isExpired ?? true;

        if (isRefreshTokenExpired) {
          final sharedPref = await SharedPreferences.getInstance();
          await sharedPref.clear();
          if (context != null && context.mounted) {
            await logout(context);
          }
          return null;
        }

        var refresh = ApiEndpoint().refresh;

        var refreshResponse = await dio.post(
          refresh,
          data: jsonEncode(loggedUser),
        );

        final existingUser = await fetchLoggedUser();
        if (existingUser == null) return null;

        existingUser.accessToken = refreshResponse.data['accessToken'] ?? '';
        existingUser.refreshToken = refreshResponse.data['refreshToken'] ?? '';

        SharedPreferences sharedPref = await SharedPreferences.getInstance();
        await sharedPref.setString(userKey, jsonEncode(existingUser.toJson()));
        loggedUser = existingUser;
      } on DioException {
        if (context != null && context.mounted) {
          await _showSessionExpiredDialog(context);
        }
        return null;
      } catch (e) {
        if (context != null && context.mounted) {
          await _showSessionExpiredDialog(context);
        }
        return null;
      } finally {
        _refreshLock?.complete();
        _refreshLock = null;
      }
    }

    return loggedUser;
  }

  static Future<void> _showSessionExpiredDialog(BuildContext context) async {
    if (!context.mounted) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: const Text("Session Expired"),
              content: const Text("Please log in again to continue."),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await logout(context);
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
