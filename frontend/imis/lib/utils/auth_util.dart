// // ignore_for_file: deprecated_member_use

// import 'dart:async';
// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:imis/roles/models/roles.dart';
// import 'package:imis/user/models/user_registration.dart';
// import 'package:imis/user/pages/login_page.dart';
// import 'package:imis/utils/api_endpoint.dart';
// import 'package:imis/utils/permission_role_string.dart';
// import 'package:jwt_decode_full/jwt_decode_full.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../constant/constant.dart';

// class AuthUtil {
//   static Completer<void>? _refreshLock;
//   late final BuildContext context;
//   static const String userKey = "user";
//   static const String rolesKey = "roles";
//   static const String officeNamesKey = "officeNames";
//   static const String officeIdsKey = "officeIds";
//   static const String selectedOfficeIdKey = "selectedOfficeId";
//   static const String isLoggedInKey = "isLoggedIn";
//   static const String pgsKey = "pgs";
//   static const String selectedRoleKey = "selectedRole";

//   static Future<UserRegistration> storeUserAuth(
//     Response<dynamic> response,
//     Dio dio, [
//     Options? options,
//   ]) async {
//     var user = UserRegistration.fromJson(response.data);
//     SharedPreferences sharedPref = await SharedPreferences.getInstance();

//     user.accessToken = response.data['accessToken'] ?? '';
//     user.refreshToken = response.data['refreshToken'] ?? '';
//     if (response.data['roles'] != null) {
//       String rolesJson = jsonEncode(response.data['roles']);
//       await sharedPref.setString(rolesKey, rolesJson);
//     }

//     if (response.data['offices'] != null) {
//       List<dynamic> offices = response.data['offices'];
//       List<String> officeNames =
//           offices.map((o) => o['name'].toString()).toList();
//       List<String> officeIds = offices.map((o) => o['id'].toString()).toList();

//       await sharedPref.setStringList(officeNamesKey, officeNames);
//       await sharedPref.setStringList(officeIdsKey, officeIds);

//       Map<String, bool> officeHeadMap = {
//         for (var o in offices) o['id'].toString(): o['isOfficeHead'] ?? false,
//       };
//       await sharedPref.setString('officeHeadMap', jsonEncode(officeHeadMap));
//     }
//     await sharedPref.setString(userKey, jsonEncode(user.toJson()));

//     await sharedPref.setBool(isLoggedInKey, true);
//     return user;
//   }

//   static Future<UserRegistration?> fetchLoggedUser([
//     SharedPreferences? sharedPref,
//   ]) async {
//     sharedPref ??= await SharedPreferences.getInstance();

//     String? userJson = sharedPref.getString(userKey);
//     if (userJson == null) {
//       return null;
//     }

//     return UserRegistration.fromJson(jsonDecode(userJson));
//   }

//   static Future<List<Roles>?> fetchRoles() async {
//     final sharedPref = await SharedPreferences.getInstance();
//     String? rolesJson = sharedPref.getString(rolesKey);

//     if (rolesJson != null) {
//       final List<dynamic> decoded = jsonDecode(rolesJson);
//       return decoded.map((r) => Roles.fromJson(r)).toList();
//     }

//     return null;
//   }

//   static Future<String?> getAccessToken() async {
//     final user = await fetchLoggedUser();
//     return user?.accessToken;
//   }

//   static Future<List<String>?> fetchOfficeNames() async {
//     final sharedPref = await SharedPreferences.getInstance();
//     return sharedPref.getStringList(officeNamesKey);
//   }

//   static Future<List<String>?> fetchOfficeIds() async {
//     final sharedPref = await SharedPreferences.getInstance();
//     return sharedPref.getStringList(officeIdsKey);
//   }

//   static Future<bool?> getIsOfficeHead(String officeId) async {
//     final prefs = await SharedPreferences.getInstance();
//     final officeHeadMapJson = prefs.getString('officeHeadMap');
//     if (officeHeadMapJson == null) return null;

//     final Map<String, dynamic> officeHeadMap = jsonDecode(officeHeadMapJson);
//     return officeHeadMap[officeId] as bool?;
//   }

//   static Future<String?> fetchSelectedOfficeId() async {
//     final sharedPref = await SharedPreferences.getInstance();
//     return sharedPref.getString(selectedOfficeIdKey);
//   }

//   static Future<void> removeSelectedOfficeId() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(selectedOfficeIdKey);
//   }

//   static Future<bool> isLoggedIn() async {
//     final sharedPref = await SharedPreferences.getInstance();
//     return sharedPref.getBool(isLoggedInKey) ?? false;
//   }

//   static Future<bool> isCurrentUserAdmin() async {
//     final sharedPref = await SharedPreferences.getInstance();

//     final selectedRole = sharedPref.getString(selectedRoleKey);
//     if (selectedRole != null) {
//       return selectedRole == PermissionRoleString.roleAdmin;
//     }

//     final roles = await fetchRoles();
//     if (roles == null || roles.isEmpty) return false;
//     return roles.any((role) => role.name == PermissionRoleString.roleAdmin);
//   }

//   /// True when the signed-in role is Lead Auditor. Same rule as
//   /// [isCurrentUserAdmin]: the role picked at login wins, else any role held.
//   static Future<bool> isCurrentUserLeadAuditor() async {
//     final sharedPref = await SharedPreferences.getInstance();

//     final selectedRole = sharedPref.getString(selectedRoleKey);
//     if (selectedRole != null) {
//       return selectedRole == PermissionRoleString.leadAuditor;
//     }

//     final roles = await fetchRoles();
//     if (roles == null || roles.isEmpty) return false;
//     return roles.any((role) => role.name == PermissionRoleString.leadAuditor);
//   }

//   static Future<void> saveSelectedOfficeId(String officeId) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString(selectedOfficeIdKey, officeId);
//   }

//   static Future<void> setIsLoggedIn(bool status) async {
//     final sharedPref = await SharedPreferences.getInstance();
//     await sharedPref.setBool(isLoggedInKey, status);
//   }

//   static Future<void> logout(BuildContext context) async {
//     final sharedPref = await SharedPreferences.getInstance();
//     await sharedPref.remove(userKey);
//     await sharedPref.remove(rolesKey);
//     await sharedPref.remove(officeNamesKey);
//     await sharedPref.remove(officeIdsKey);
//     await sharedPref.remove(selectedOfficeIdKey);
//     await sharedPref.remove(isLoggedInKey);
//     await sharedPref.remove(pgsKey);

//     if (context.mounted) {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginPage()),
//         (route) => false,
//       );
//     }
//   }

//   static Future<UserRegistration?> processTokenValidity(
//     Dio dio, [
//     BuildContext? context,
//   ]) async {
//     var loggedUser = await fetchLoggedUser();

//     if (loggedUser != null) {
//       var accessToken = jwtDecode(loggedUser.accessToken!);
//       // accessToken.expiration is already a DateTime!
//       final expirationDate =
//           accessToken.expiration ??
//           DateTime.now().subtract(const Duration(seconds: 1));

//       // Check if it expires within the next 30 seconds
//       bool isAccessTokenExpired = DateTime.now()
//           .add(const Duration(seconds: 30))
//           .isAfter(expirationDate);

//       if (!isAccessTokenExpired) {
//         return loggedUser;
//       }

//       if (_refreshLock != null && !_refreshLock!.isCompleted) {
//         await _refreshLock!.future;
//         return await fetchLoggedUser();
//       }

//       _refreshLock = Completer<void>();

//       try {
//         final refreshToken = jwtDecode(loggedUser.refreshToken!);

//         // refreshToken.expiration is already a DateTime!
//         final expirationDate =
//             refreshToken.expiration ??
//             DateTime.now().subtract(const Duration(seconds: 1));
//         bool isRefreshTokenExpired = DateTime.now()
//             .add(const Duration(seconds: 30))
//             .isAfter(expirationDate);

//         if (isRefreshTokenExpired) {
//           if (context != null && context.mounted) {
//             await _showSessionExpiredDialog(context);
//           } else {
//             final sharedPref = await SharedPreferences.getInstance();
//             await sharedPref.clear();
//           }
//           return null;
//         }

//         var refresh = ApiEndpoint().refresh;

//         var refreshResponse = await dio.post(
//           refresh,
//           data: loggedUser.toJson(),
//           options: Options(
//             validateStatus:
//                 (status) =>
//                     status != null &&
//                     status < 500, // ✅ Prevents Dio from throwing on 401
//           ),
//         );

//         if (refreshResponse.statusCode == 401) {
//           if (context != null && context.mounted) {
//             await _showSessionExpiredDialog(context);
//           } else {
//             final prefs = await SharedPreferences.getInstance();
//             await prefs.clear();
//           }
//           return null;
//         }

//         final existingUser = await fetchLoggedUser();
//         if (existingUser == null) return null;

//         existingUser.accessToken = refreshResponse.data['accessToken'] ?? '';
//         existingUser.refreshToken = refreshResponse.data['refreshToken'] ?? '';

//         SharedPreferences sharedPref = await SharedPreferences.getInstance();
//         await sharedPref.setString(userKey, jsonEncode(existingUser.toJson()));
//         loggedUser = existingUser;
//       } on DioException {
//         if (context != null && context.mounted) {
//           await _showSessionExpiredDialog(context);
//         }
//         return null;
//       } catch (e) {
//         if (context != null && context.mounted) {
//           await _showSessionExpiredDialog(context);
//         }
//         return null;
//       } finally {
//         _refreshLock?.complete();
//         _refreshLock = null;
//       }
//     }

//     return loggedUser;
//   }

//   static Future<void> _showSessionExpiredDialog(BuildContext context) async {
//     if (!context.mounted) return;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();

//     if (context.mounted) {
//       await showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder:
//             (context) => PopScope(
//               canPop: false,
//               child: AlertDialog(
//                 title: const Text("Session Expired"),
//                 content: const Text("Please log in again to continue."),
//                 actions: [
//                   TextButton(
//                     onPressed: () async {
//                       Navigator.pop(context);
//                       await logout(context);
//                     },
//                     child: const Text(
//                       "OK",
//                       style: TextStyle(color: primaryColor),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//       );
//     }
//   }
// }
// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/main.dart' show navigatorKey;
import 'package:imis/roles/models/roles.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/user/pages/login_page.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/permission_role_string.dart';
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
  static const String selectedRoleKey = "selectedRole";

  static bool _hadSession = false;
  static bool _dialogShowing = false;
  static Timer? _sessionWatcher;

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

      Map<String, bool> officeHeadMap = {
        for (var o in offices) o['id'].toString(): o['isOfficeHead'] ?? false,
      };
      await sharedPref.setString('officeHeadMap', jsonEncode(officeHeadMap));
    }
    await sharedPref.setString(userKey, jsonEncode(user.toJson()));

    await sharedPref.setBool(isLoggedInKey, true);

    _hadSession = true;
    startSessionWatcher();
    return user;
  }

  static Future<UserRegistration?> fetchLoggedUser([
    SharedPreferences? sharedPref,
  ]) async {
    sharedPref ??= await SharedPreferences.getInstance();
    await sharedPref.reload(); // kunin ang latest galing sa ibang tab

    String? userJson = sharedPref.getString(userKey);
    if (userJson == null) {
      return null;
    }

    _hadSession = true;
    return UserRegistration.fromJson(jsonDecode(userJson));
  }

  static Future<List<Roles>?> fetchRoles() async {
    final sharedPref = await SharedPreferences.getInstance();
    String? rolesJson = sharedPref.getString(rolesKey);

    if (rolesJson != null) {
      final List<dynamic> decoded = jsonDecode(rolesJson);
      return decoded.map((r) => Roles.fromJson(r)).toList();
    }

    return null;
  }

  static Future<String?> getAccessToken() async {
    final user = await fetchLoggedUser();
    return user?.accessToken;
  }

  static Future<List<String>?> fetchOfficeNames() async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getStringList(officeNamesKey);
  }

  static Future<List<String>?> fetchOfficeIds() async {
    final sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getStringList(officeIdsKey);
  }

  static Future<bool?> getIsOfficeHead(String officeId) async {
    final prefs = await SharedPreferences.getInstance();
    final officeHeadMapJson = prefs.getString('officeHeadMap');
    if (officeHeadMapJson == null) return null;

    final Map<String, dynamic> officeHeadMap = jsonDecode(officeHeadMapJson);
    return officeHeadMap[officeId] as bool?;
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

  static Future<bool> isCurrentUserAdmin() async {
    final sharedPref = await SharedPreferences.getInstance();

    final selectedRole = sharedPref.getString(selectedRoleKey);
    if (selectedRole != null) {
      return selectedRole == PermissionRoleString.roleAdmin;
    }

    final roles = await fetchRoles();
    if (roles == null || roles.isEmpty) return false;
    return roles.any((role) => role.name == PermissionRoleString.roleAdmin);
  }

  static Future<bool> isCurrentUserLeadAuditor() async {
    final sharedPref = await SharedPreferences.getInstance();

    final selectedRole = sharedPref.getString(selectedRoleKey);
    if (selectedRole != null) {
      return selectedRole == PermissionRoleString.leadAuditor;
    }

    final roles = await fetchRoles();
    if (roles == null || roles.isEmpty) return false;
    return roles.any((role) => role.name == PermissionRoleString.leadAuditor);
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
    _hadSession = false;
    _dialogShowing = false;
    _sessionWatcher?.cancel();
    _sessionWatcher = null;

    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.remove(userKey);
    await sharedPref.remove(rolesKey);
    await sharedPref.remove(officeNamesKey);
    await sharedPref.remove(officeIdsKey);
    await sharedPref.remove(selectedOfficeIdKey);
    await sharedPref.remove(isLoggedInKey);
    await sharedPref.remove(pgsKey);

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  static bool _isExpired(String? token) {
    if (token == null || token.isEmpty) return true;
    try {
      final exp =
          jwtDecode(token).expiration ??
          DateTime.now().subtract(const Duration(seconds: 1));
      return DateTime.now().add(const Duration(seconds: 30)).isAfter(exp);
    } catch (_) {
      return true;
    }
  }

  static void startSessionWatcher() {
    _sessionWatcher?.cancel();
    _sessionWatcher = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (!_hadSession || _dialogShowing) return;

      final user = await fetchLoggedUser();
      if (user == null || _isExpired(user.refreshToken)) {
        await _handleSessionExpired(null);
      }
    });
  }

  static Future<UserRegistration?> processTokenValidity(
    Dio dio, [
    BuildContext? context,
  ]) async {
    var loggedUser = await fetchLoggedUser();

    if (loggedUser == null) {
      // May session dati sa tab na ito pero nawala = expired / na-clear ng ibang tab
      if (_hadSession) await _handleSessionExpired(context);
      return null;
    }

    if (!_isExpired(loggedUser.accessToken)) return loggedUser;

    // May ibang request na nagre-refresh na, hintayin lang
    if (_refreshLock != null && !_refreshLock!.isCompleted) {
      await _refreshLock!.future;
      return await fetchLoggedUser();
    }

    _refreshLock = Completer<void>();

    try {
      // Re-check: baka na-refresh na ng ibang tab
      loggedUser = await fetchLoggedUser();
      if (loggedUser == null) {
        await _handleSessionExpired(context);
        return null;
      }
      if (!_isExpired(loggedUser.accessToken)) return loggedUser;

      if (_isExpired(loggedUser.refreshToken)) {
        await _handleSessionExpired(context);
        return null;
      }

      final refreshResponse = await dio.post(
        ApiEndpoint().refresh,
        data: loggedUser.toJson(),
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (refreshResponse.statusCode != 200) {
        final latest = await fetchLoggedUser();
        if (latest != null &&
            latest.refreshToken != loggedUser.refreshToken &&
            !_isExpired(latest.accessToken)) {
          return latest;
        }
        await _handleSessionExpired(context);
        return null;
      }

      final existingUser = await fetchLoggedUser();
      if (existingUser == null) {
        await _handleSessionExpired(context);
        return null;
      }

      existingUser.accessToken = refreshResponse.data['accessToken'] ?? '';
      existingUser.refreshToken = refreshResponse.data['refreshToken'] ?? '';

      final sharedPref = await SharedPreferences.getInstance();
      await sharedPref.setString(userKey, jsonEncode(existingUser.toJson()));
      return existingUser;
    } on DioException {
      await _handleSessionExpired(context);
      return null;
    } catch (_) {
      await _handleSessionExpired(context);
      return null;
    } finally {
      _refreshLock?.complete();
      _refreshLock = null;
    }
  }

  static Future<void> _handleSessionExpired(BuildContext? context) async {
    if (_dialogShowing) return;

    // overlay.context ang gamit (may Navigator ancestor), hindi currentContext
    final ctx =
        (context != null && context.mounted)
            ? context
            : navigatorKey.currentState?.overlay?.context;

    if (ctx != null && ctx.mounted) {
      await _showSessionExpiredDialog(ctx);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    }
  }

  static Future<void> _showSessionExpiredDialog(BuildContext context) async {
    if (_dialogShowing || !context.mounted) return;
    _dialogShowing = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!context.mounted) {
      _dialogShowing = false;
      return;
    }

    await showDialog(
      barrierDismissible: false,
      context: context,
      useRootNavigator: true,
      builder:
          (dialogContext) => PopScope(
            canPop: false,
            child: AlertDialog(
              title: const Text("Session Expired"),
              content: const Text("Please log in again to continue."),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(dialogContext, rootNavigator: true).pop();
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

  static Future<void> debugForceExpire() async {
    final prefs = await SharedPreferences.getInstance();
    final user = await fetchLoggedUser(prefs);
    if (user == null) return;
    user.accessToken = '';
    user.refreshToken = '';
    await prefs.setString(userKey, jsonEncode(user.toJson()));
  }
}
