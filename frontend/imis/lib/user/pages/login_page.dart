// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/navigation/sidebar.dart';
import 'package:imis/user/models/user_login.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:motion_toast/motion_toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _isLoggingIn = false;
  bool isPageLoaded = false;

  final dio = Dio();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login(BuildContext context, UserLogin user) async {
    var url = ApiEndpoint().login;
    setState(() {
      _isLoggingIn = true;
    });

    try {
      var response = await dio.post(url, data: user.toJson());

      if (context.mounted) {
        if (response.statusCode == 200) {
          await AuthUtil.storeUserAuth(response, dio);
          await AuthUtil.setIsLoggedIn(true);

          if (!context.mounted) return;
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => Sidebar()),
            (route) => false,
          );
        } else {
          var errMsg = response.statusMessage ?? "Unknown error";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An error has occurred: $errMsg")),
          );
        }
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;

        if (context.mounted) {
          if (statusCode == 401) {
            MotionToast.error(
              title: const Text("Invalid credentials!"),
              description: const Text(
                "Please check your username and password.",
              ),
              toastAlignment: Alignment.center,
            ).show(context);
          } else {
            MotionToast.error(
              title: const Text("An error has occurred!"),
              description: const Text(
                "Oops! Something went wrong. Please try again.",
              ),
              toastAlignment: Alignment.center,
            ).show(context);
          }
        }
      } else {
        if (context.mounted) {
          MotionToast.error(
            title: const Text("Server is Unreachable!"),
            description: const Text("Please check your connection."),
            toastAlignment: Alignment.topCenter,
          ).show(context);
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingIn = false;
        });
      }
    }
  }

  void _handleLogin() {
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      MotionToast.error(
        description: const Text('Please enter your credentials.'),
        toastAlignment: Alignment.topCenter,
      ).show(context);
      return;
    }

    login(
      context,
      UserLogin(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 700;

    return Scaffold(
      backgroundColor: kBackground,
      body: isMobile ? _mobileLayout() : _desktopLayout(),
    );
  }

  Widget _desktopLayout() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Pink gradient background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFCE4EC),
                Color(0xFFF8BBD0),
                Color(0xFFEF9A9A),
                Color(0xFFF48FB1),
              ],
              stops: [0.0, 0.35, 0.65, 1.0],
            ),
          ),
        ),

        Positioned.fill(child: CustomPaint(painter: _DiagonalPanelPainter())),

        Row(
          children: [
            Expanded(flex: 52, child: const _WelcomePanel()),
            Expanded(
              flex: 48,
              child: _FormPanel(
                emailController: _usernameController,
                passwordController: _passwordController,
                obscure: _obscure,
                onToggleObscure: () => setState(() => _obscure = !_obscure),
                isLoading: _isLoggingIn,
                onLogin: _handleLogin,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _mobileLayout() {
    return _FormPanel(
      emailController: _usernameController,
      passwordController: _passwordController,
      obscure: _obscure,
      onToggleObscure: () => setState(() => _obscure = !_obscure),
      isLoading: _isLoggingIn,
      onLogin: _handleLogin,
      mobile: true,
    );
  }
}

class _DiagonalPanelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    final double panelStart = size.width * 0.46;
    final double slantOffset = size.width * 0.06;

    final path = Path();
    path.moveTo(panelStart, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(panelStart - 0, size.height);
    path.lineTo(panelStart - slantOffset, size.height * 0.5);
    path.lineTo(panelStart, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WelcomePanel extends StatelessWidget {
  const _WelcomePanel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 60, top: 40, bottom: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const _FallbackIllustration(),
              ),
            ),
          ),

          const Text(
            "We're so glad to\nhave you on board!",
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7B2D42),
              height: 1.25,
              letterSpacing: 0.3,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            'A centralized system for tracking, managing,\nand ensuring compliance with PGS.',
            style: TextStyle(
              fontSize: 13.5,
              color: const Color(0xFF8B3A52).withValues(alpha: 0.75),
              height: 1.65,
              letterSpacing: 0.2,
            ),
          ),

          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

class _FallbackIllustration extends StatelessWidget {
  const _FallbackIllustration();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_alt_outlined,
            size: 80,
            color: const Color(0xFF8B3A52).withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          Text(
            'CPeMS',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF8B3A52).withValues(alpha: 0.5),
              letterSpacing: 3,
            ),
          ),
        ],
      ),
    );
  }
}

class _FormPanel extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final bool mobile;
  final bool isLoading;
  final VoidCallback onLogin;

  const _FormPanel({
    required this.emailController,
    required this.passwordController,
    required this.obscure,
    required this.onToggleObscure,
    required this.onLogin,
    this.isLoading = false,
    this.mobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: mobile ? 28 : 48,
            vertical: mobile ? 40 : 0,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'CP',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Heading
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: kText,
                      height: 1.2,
                    ),
                    children: [
                      TextSpan(text: 'Sign in to '),
                      TextSpan(
                        text: 'CPeMS',
                        style: TextStyle(color: primaryColor),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Welcome to CPeMS (Centralized Performance Electronic Management System), please enter your login details below to use the app.',
                  style: TextStyle(fontSize: 13, color: kMuted, height: 1.5),
                ),

                const SizedBox(height: 28),

                _InputField(
                  controller: emailController,
                  hint: 'username',
                  textInputAction: TextInputAction.next,

                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 14),

                _InputField(
                  controller: passwordController,
                  hint: 'password',
                  obscure: obscure,
                  textInputAction: TextInputAction.done,
                  onSubmitted: onLogin,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: kMuted,
                      size: 20,
                    ),
                    onPressed: onToggleObscure,
                  ),
                ),

                const SizedBox(height: 12),

                // Align(
                //   alignment: Alignment.centerRight,
                //   child: TextButton(
                //     onPressed: () {},
                //     style: TextButton.styleFrom(
                //       foregroundColor: kBlue,
                //       padding: EdgeInsets.zero,
                //       minimumSize: Size.zero,
                //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //     ),
                //     child: const Text(
                //       'Forgot the password?',
                //       style: TextStyle(
                //         fontSize: 13,
                //         fontWeight: FontWeight.w600,
                //         decoration: TextDecoration.underline,
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20),

                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : onLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: primaryColor.withValues(
                        alpha: 0.6,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child:
                        isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 13, color: kMuted),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kText,

                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final VoidCallback? onSubmitted; // ← add
  final TextInputAction? textInputAction; // ← add

  const _InputField({
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.keyboardType,
    this.suffixIcon,
    this.onSubmitted,
    this.textInputAction,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSubmitted: (_) => onSubmitted?.call(),
      style: const TextStyle(fontSize: 14, color: kText),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: kMuted, fontSize: 14),
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kBorder, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryColor, width: 1.8),
        ),
        isDense: true,
      ),
    );
  }
}
