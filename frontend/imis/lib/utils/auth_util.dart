// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';

// class AuthUtil {
//   static String key = "user";

//   static Future<User> storeUserAuth(
//     Response<dynamic> response,
//     Dio dio,
//     BuildContext context, [
//     Options? options,
//   ]) async {
//     var user = User.fromJson(response.data);

//     SharedPreferences sharedPref = await SharedPreferences.getInstance();
//     var storedUserAuth = await fetchLoggedUser(sharedPref);
//     if (storedUserAuth != null) {
//       sharedPref.remove(key);
//       user.employee = storedUserAuth.employee;
//     } else {
//       var url = ApiEndpoint().employeesById + user.crmcRecordId.toString();
//       //  Retrieve and Set the Employee details
//       var empRequest = await dio.get(
//         url,
//         options:
//             options ??
//             Options(headers: {"Authorization": "Bearer ${user.accessToken}"}),
//       );
//       if (empRequest.statusCode == 200) {
//         var employee = Employee.fromJson(empRequest.data);
//         user.employee = employee;
//       }
//     }

//     // decode the access token from payload.
//     var jwtData = jwtDecode(user.accessToken!);

//     // extract the roles from access token.
//     var payloadRoles =
//         jwtData
//             .payload['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];

//     if (payloadRoles == null) {
//       if (context.mounted) {
//         MotionToast.error(
//           title: const Text("No Role found for the User."),
//           description: const Text("Please contact System Administrator."),
//           position: MotionToastPosition.top,
//         ).show(context);
//       }
//     }

//     List<dynamic> roles = [];
//     if (payloadRoles is String) {
//       roles.add(payloadRoles);
//     } else {
//       roles.addAll(payloadRoles);
//     }
//     user.roles = List<String>.from(roles);

//     // Finally store the user details in Shared Preferences.
//     sharedPref.setString(key, jsonEncode(user));

//     return user;
//   }

//   static Future<User?> fetchLoggedUser([SharedPreferences? sharedPref]) async {
//     sharedPref = sharedPref ?? await SharedPreferences.getInstance();

//     // Retrieve the saved user details from shared preferences
//     String? userJson = sharedPref.getString(key);
//     if (userJson != null) {
//       Map<String, dynamic> userData = jsonDecode(userJson);
//       User user = User.fromJson(userData);
//       return user;
//     }

//     return null;
//   }

//   /// Handles refresh token rotation.
//   static Future<User?> processTokenValidity(
//     Dio dio, [
//     BuildContext? context,
//   ]) async {
//     // Retrieve the current logged user from Shared Preferences
//     var loggedUser = await fetchLoggedUser();

//     if (loggedUser != null) {
//       // Get the Access Token
//       var accessToken = jwtDecode(loggedUser.accessToken!);

//       // Check if the access token is expired
//       bool isAccessTokenExpired = accessToken.isExpired!;

//       // Return the current logged user if Access Token is not Expired.
//       if (!isAccessTokenExpired) return loggedUser;

//       // Retrieve the refresh token for refresh token rotation handling.
//       final refreshToken = jwtDecode(loggedUser.refreshToken!);

//       // Check if the refresh token is already expired.
//       bool isRefreshTokenExpired = refreshToken.isExpired!;

//       // Handle if the refresh token is expired.
//       if (isRefreshTokenExpired) {
//         // Throw an exception if context is null.
//         if (context == null) throw Exception("Refresh token expired!");

//         // Show a snackbar and redirect to login page if context is not null and is mounted.
//         if (context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Token expired :( Please login again.'),
//             ),
//           );

//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const LoginPage()),
//           );
//         }
//       } else {
//         var refresh = ApiEndpoint().refresh;

//         // Refresh the expired access token, invalidate the current refresh token and get a new refresh token
//         var refreshResponse = await dio.post(
//           refresh,
//           data: jsonEncode(loggedUser),
//         );

//         if (context!.mounted) {
//           // Store the new tokens.
//           loggedUser = await storeUserAuth(refreshResponse, dio, context);
//         }
//       }
//     }

//     return loggedUser;
//   }

//   static Future<void> logout() async {
//     SharedPreferences shredPref = await SharedPreferences.getInstance();
//     shredPref.remove(key);
//   }
// }
