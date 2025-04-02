import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/navigation/dashboard_navigation_panel.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/auth/models/user_login.dart';
import 'package:imis/auth/pages/registration_page.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

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

  final dio = Dio();

  Future<void> login(BuildContext context, UserLogin user) async {
    var url = ApiEndpoint().login;
    setState(() {
      _isLoggingIn = true;
    });
    try {
      var response = await dio.post(url, data: json.encode(user));

      var responseData = response.data;
      String firstName = responseData['firstName'] ?? '';
      String position = responseData['position'] ?? '';
      List<String> roles = List<String>.from(responseData['roles'] ?? []);

      List<dynamic> offices = responseData['offices'] ?? [];
      List<int> officeIds = offices.map<int>((o) => o['id'] as int).toList();
      List<String> officeNames =
          offices.map((o) => o['name'].toString()).toList();
      List<String> officeIdsAsString =
          officeIds.map((id) => id.toString()).toList();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', firstName);
      await prefs.setString('position', position);
      await prefs.setStringList("officeNames", officeNames);
      await prefs.setStringList("officeIds", officeIdsAsString);
      await prefs.setStringList('roles', roles);

      String accessToken = responseData['accessToken'] ?? '';
      String refreshToken = responseData['refreshToken'] ?? '';
      await prefs.setString('refreshToken', refreshToken);
      await prefs.setString('accessToken', accessToken);

      if (context.mounted) {
        if (response.statusCode == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardNavigationPanel(),
            ),
          );
        }
      } else {
        var errMsg = response.statusMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error has occured: $errMsg")),
        );
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
              position: MotionToastPosition.top,
            ).show(context);
          } else {
            MotionToast.error(
              title: const Text("An error has occured!"),
              description: Text(e.response!.statusMessage!),
              position: MotionToastPosition.top,
            ).show(context);
          }
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

  @override
  void initState() {
    super.initState();
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
                  ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [Logo(), buildLoginForm()],
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
                Text(
                  'Login',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
                ),
                gap2, // Adjust spacing
                Text(
                  'Enter your credentials to access your account.',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              style: TextStyle(fontSize: 14),
              controller: _usernameController,
              focusNode: focusIconUsername,
              onTap: () {
                FocusScope.of(context).requestFocus(focusIconUsername);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter some text";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: const TextStyle(color: grey, fontSize: 14),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: focusIconUsername.hasFocus ? primaryColor : grey,
                ),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                floatingLabelStyle: const TextStyle(color: primaryColor),
              ),
            ),
            gap3,
            TextFormField(
              style: TextStyle(fontSize: 14),
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
            ),
            gap,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ChangePasswordPage()),
                  //   );
                  // },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: primaryColor, fontSize: 14),
                  ),
                ),
              ],
            ),
            gap3,
            SizedBox(
              width: double.infinity,
              child:
                  _isLoggingIn
                      ? const Center(
                        child:
                            CircularProgressIndicator(), // Show spinner when loadingz`
                      )
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
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
            ),
            gap,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account yet?",
                  style: TextStyle(fontSize: 14),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationPage(),
                      ),
                    );
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(color: primaryColor, fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
