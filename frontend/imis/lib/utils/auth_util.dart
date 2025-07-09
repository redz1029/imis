import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/user/pages/login_page.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/globals.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUtil {
  static const String userkey = "user";
  static const String rolesKey = "roles";
  static const String officeNamesKey = "officeNames";
  static const String officeIdsKey = "officeIds";
  static const String selectedOfficeIdKey = "selectedOfficeId";
  static const String isLoggedInKey = "isLoggedIn";
  static const String accessTokenKey = "accessToken";
  static const String refreshTokenKey = "refreshToken";
  static const String pgsKey = "pgs";

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
    if (refreshToken.isNotEmpty) {
      await sharedPref.setString(refreshTokenKey, refreshToken);
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

    await sharedPref.setString(userkey, jsonEncode(user.toJson()));
    await sharedPref.setBool(isLoggedInKey, true);
    return user;
  }

  static Future<UserRegistration?> fetchLoggedUser([
    SharedPreferences? sharedPref,
  ]) async {
    sharedPref ??= await SharedPreferences.getInstance();
    String? userJson = sharedPref.getString(userkey);

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
    await sharedPref.remove(userkey);
    await sharedPref.remove(rolesKey);
    await sharedPref.remove(officeNamesKey);
    await sharedPref.remove(officeIdsKey);
    await sharedPref.remove(selectedOfficeIdKey);
    await sharedPref.remove(isLoggedInKey);
    await sharedPref.remove(accessTokenKey);
    await sharedPref.remove(refreshTokenKey);
  }

  static Future<UserRegistration?> processTokenValidity(
    Dio dio, [
    BuildContext? context,
  ]) async {
    var loggedUser = await fetchLoggedUser();

    if (loggedUser != null) {
      final accessToken = await fetchAccessToken();
      final refreshToken = await fetchRefreshToken();

      final isAccessTokenExpired =
          accessToken == null || JwtDecoder.isExpired(accessToken);
      final isRefreshTokenExpired =
          refreshToken == null || JwtDecoder.isExpired(refreshToken);

      if (!isAccessTokenExpired) return loggedUser;

      if (isRefreshTokenExpired) {
        await logout();

        snackbarKey.currentState?.showSnackBar(
          const SnackBar(content: Text('Token expired :( Please login again.')),
        );

        if (context != null && context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }

        return null;
      }

      try {
        final refreshUrl = ApiEndpoint().refresh;
        final response = await dio.post(
          refreshUrl,
          data: jsonEncode({'refreshToken': refreshToken}),
        );

        return await storeUserAuth(response, dio);
      } catch (e) {
        await logout();

        snackbarKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text('Unable to refresh session. Please login again.'),
          ),
        );
        if (context != null && context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }

        return null;
      }
    }

    return null;
  }
}
