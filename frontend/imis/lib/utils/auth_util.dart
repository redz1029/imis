import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUtil {
  static const String userKey = "user";
  static const String accessTokenKey = "accessToken";
  static const String rolesKey = "roles";
  static const String officeNamesKey = "officeNames";
  static const String officeIdsKey = "officeIds";
  static const String isLoggedInKey = "isLoggedIn";

  static Future<UserRegistration> storeUserAuth(
    Response<dynamic> response,
    Dio dio, [
    Options? options,
  ]) async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();

    var user = UserRegistration.fromJson(response.data);
    String userJson = jsonEncode(user.toJson());
    await sharedPref.setString(userKey, userJson);

    String accessToken = response.data['accessToken'] ?? '';
    if (accessToken.isNotEmpty) {
      await sharedPref.setString(accessTokenKey, accessToken);
    }

    if (response.data['roles'] != null) {
      String rolesJson = jsonEncode(response.data['roles']);
      await sharedPref.setString(rolesKey, rolesJson);
    }
    if (response.data['offices'] != null) {
      List<dynamic> offices = response.data['offices'];
      List<String> officeNames =
          offices.map((o) => o['officeNames'].toString()).toList();
      List<String> officeIds =
          offices.map((o) => o['officeIds'].toString()).toList();

      await sharedPref.setStringList(officeNamesKey, officeNames);
      await sharedPref.setStringList(officeIdsKey, officeIds);
    }

    await sharedPref.setBool(isLoggedInKey, true);

    return user;
  }

  static Future<UserRegistration?> fetchRegisteredUser([
    SharedPreferences? sharedPref,
  ]) async {
    sharedPref ??= await SharedPreferences.getInstance();
    String? userJson = sharedPref.getString(userKey);

    if (userJson != null) {
      Map<String, dynamic> userData = jsonDecode(userJson);
      return UserRegistration.fromJson(userData);
    }
    return null;
  }

  static Future<String?> fetchAccessToken([
    SharedPreferences? sharedPref,
  ]) async {
    sharedPref ??= await SharedPreferences.getInstance();
    return sharedPref.getString(accessTokenKey);
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

  static Future<bool> isLoggedIn([SharedPreferences? sharedPref]) async {
    sharedPref ??= await SharedPreferences.getInstance();
    return sharedPref.getBool(isLoggedInKey) ?? false;
  }

  static Future<void> setIsLoggedIn(bool status) async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setBool(isLoggedInKey, status);
  }

  static Future<void> logout() async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    await sharedPref.remove(userKey);
    await sharedPref.remove(accessTokenKey);
    await sharedPref.remove(rolesKey);
    await sharedPref.setBool(isLoggedInKey, false);
  }
}
