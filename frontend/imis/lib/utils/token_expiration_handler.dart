import 'package:flutter/material.dart';
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
    if (accessToken == null || accessToken.isEmpty) return;

    if (JwtDecoder.isExpired(accessToken)) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(_buildExpiredTokenSnackBar());

        Future.delayed(const Duration(seconds: 3), () {
          if (context.mounted) {
            _navigateToLogin();
          }
        });
      }
    }
  }

  SnackBar _buildExpiredTokenSnackBar() {
    return const SnackBar(
      content: Text('Your session has expired. Redirecting to login...'),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
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
