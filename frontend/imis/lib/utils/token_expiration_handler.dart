import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/user/pages/login_page.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenExpirationHandler {
  final BuildContext context;

  TokenExpirationHandler(this.context);

  Future<void> checkTokenExpiration() async {
    final isLoggedIn = await AuthUtil.isLoggedIn();
    if (!isLoggedIn) return;

    final String? accessToken = await AuthUtil.fetchAccessToken();
    final String? refreshToken = await AuthUtil.fetchRefreshToken();

    if (accessToken == null ||
        accessToken.isEmpty ||
        refreshToken == null ||
        refreshToken.isEmpty) {
      _handleTokenInvalid();
      return;
    }

    final bool isAccessTokenExpired = JwtDecoder.isExpired(accessToken);
    final bool isRefreshTokenExpired = JwtDecoder.isExpired(refreshToken);

    if (isRefreshTokenExpired) {
      _showTokenDialog(
        title: "Session Expired",
        message: "Your refresh token has expired. Please login again.",
      );
    } else if (isAccessTokenExpired) {
      _showTokenDialog(
        title: "Session Expired",
        message: "Your session has expired. Redirecting to login...",
      );
    }
  }

  Future<void> _handleTokenInvalid() async {
    _showTokenDialog(
      title: "Invalid Token",
      message: "Your token is invalid. Redirecting to login...",
    );
  }

  void _showTokenDialog({required String title, required String message}) {
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        // ignore: deprecated_member_use
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text(
                  "Okay",
                  style: TextStyle(color: primaryColor),
                ),
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  await _navigateToLogin();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _navigateToLogin() async {
    await AuthUtil.logout();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }
}
