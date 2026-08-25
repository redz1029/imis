import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/navigation/navigation_panel.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/user/models/user_login.dart';
import 'package:imis/user/pages/registration_page.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/widgets/logo.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:imis/user/pages/registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode focusIconUsername = FocusNode();
  final FocusNode focusIconPassword = FocusNode();

  bool _isPasswordVisible = false;

  bool _isLoggingIn = false;
  bool isPageLoaded = false;

  final dio = Dio();

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
            MaterialPageRoute(builder: (context) => const NavigationPanel()),
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
              toastAlignment: Alignment.topCenter,
            ).show(context);
          } else {
            MotionToast.error(
              title: const Text("An error has occurred!"),
              description: Text(
                "Oops! Something went wrong. Please try again.",
              ),
              toastAlignment: Alignment.topCenter,
            ).show(context);
          }
        }
      } else {
        if (context.mounted) {
          MotionToast.error(
            title: const Text("Server is Unreachable!"),
            description: Text("Please check your connection."),
            toastAlignment: Alignment.topCenter,
          ).show(context);
        }
      }
    } finally {
      if (context.mounted) {
        setState(() {
          _isLoggingIn = false;
        });
      }
    }
  }

  void _checkLoginStatus() async {
    final dio = Dio();
    final loggedUser = await AuthUtil.processTokenValidity(dio, context);

    if (!mounted) return;

    if (loggedUser != null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const NavigationPanel()),
        (route) => false,
      );
    } else {
      setState(() {
        isPageLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    focusIconUsername.addListener(() {
      setState(() {});
    });
    focusIconPassword.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    focusIconUsername.dispose();
    focusIconPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: secondaryColor,
        body: Center(
          child:
              isSmallScreen
                  ? SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [Logo(), buildLoginForm()],
                    ),
                  )
                  : Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Row(
                      children: [
                        Expanded(child: Logo()),
                        Expanded(child: Center(child: buildLoginForm())),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }

  Widget buildLoginForm() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                floatingLabelStyle: const TextStyle(color: primaryColor),
              ),
            ),
            gap16px,
            TextFormField(
              style: TextStyle(fontSize: 16),
              controller: _passwordController,
              focusNode: focusIconPassword,
              onTap: () {
                FocusScope.of(context).requestFocus(focusIconPassword);
              },
              obscureText: !_isPasswordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                return value.length < 6
                    ? 'Password must be at least 6 characters'
                    : null;
              },
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: grey, fontSize: 14),
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
                  color:
                      focusIconPassword.hasFocus ? primaryColor : Colors.grey,
                ),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                floatingLabelStyle: const TextStyle(color: primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: focusIconPassword.hasFocus ? primaryColor : grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) {
                if (_formKey.currentState!.validate()) {
                  login(
                    context,
                    UserLogin(
                      username: _usernameController.text,
                      password: _passwordController.text,
                    ),
                  );
                }
              },
            ),

            // for next feauture (Forgot password)
            // gap2,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     TextButton(
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => ForgotPasswordPage(),
            //           ),
            //         );
            //       },
            //       child: Text(
            //         'Forgot Password?',
            //         style: TextStyle(color: primaryColor),
            //       ),
            //     ),
            //   ],
            // ),
            gap24px,
            SizedBox(
              width: double.infinity,
              child:
                  _isLoggingIn
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed:
                            _isLoggingIn
                                ? null
                                : () {
                                  if (_formKey.currentState!.validate()) {
                                    login(
                                      context,
                                      UserLogin(
                                        username: _usernameController.text,
                                        password: _passwordController.text,
                                      ),
                                    );
                                  }
                                },
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 16,
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationPage(),
                          ),
                        );
                      },
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
