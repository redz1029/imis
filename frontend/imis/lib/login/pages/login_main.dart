import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imis/register/pages/registration_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:imis/dashboard_page.dart';
import 'package:imis/register/pages/registration.dart';
import 'package:imis/constant/constant.dart';

class LoginMain extends StatefulWidget {
  const LoginMain({super.key});

  @override
  _LoginMainState createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode focusUser = FocusNode();
  final FocusNode focusPass = FocusNode();

  bool _isPageLoaded = false;
  bool _isPasswordVisible = false;
  bool _isLoginButtonDisabled = false;
  bool _isLoading = false;

  static const String loginUrl = 'https://localhost:7273/login';

  Future<void> _login(String username, String password) async {
    setState(() {
      _isLoading = true; // Show loading indicator inside button
      _isLoginButtonDisabled = true; // Disable the button during login
    });
    await Future.delayed(const Duration(seconds: 3));

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        jsonDecode(response.body);

        _usernameController.clear();
        _passwordController.clear();
        String firstName = data['firstName'] ?? 'Guest';
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('firstName', firstName);
        setState(() {
          _isLoginButtonDisabled = true;
          _isPageLoaded = true;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      } else {
        _passwordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid username or password.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
        _isLoginButtonDisabled = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } else {
      setState(() {
        _isPageLoaded = true;
      });
    }
  }

  void _triggerLogin() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    _login(username, password);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    focusUser.dispose();
    focusPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('lib/assets/CRMC.png', height: 40, width: 40),
          ),
        ),
        backgroundColor: secondaryColor,
        body: Center(
          child: isSmallScreen
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [_Logo(), _buildForm()])
              : Container(
                  padding: const EdgeInsets.all(32.0),
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Row(
                    children: [
                      Expanded(child: _Logo()),
                      Expanded(child: Center(child: _buildForm())),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildForm() {
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
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              style: TextStyle(fontSize: 14),
              controller: _usernameController,
              focusNode: focusUser,
              onTap: () {
                FocusScope.of(context).requestFocus(focusUser);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter some text";
                }
                return null;
                // bool emailValid = RegExp(
                //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                //     .hasMatch(value);
                // return emailValid ? null : "Please enter a valid email";
              },
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: const TextStyle(color: grey, fontSize: 14),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: focusUser.hasFocus ? primaryColor : grey,
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
              focusNode: focusPass,
              onTap: () {
                FocusScope.of(context).requestFocus(focusPass);
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
                  color: focusPass.hasFocus ? primaryColor : Colors.grey,
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
                    color: focusPass.hasFocus ? primaryColor : grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            // gap,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     GestureDetector(
            //       onTap: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => ChangePasswordPage()),
            //         );
            //       },
            //       child: Text(
            //         "Forgot Password?",
            //         style: TextStyle(color: primaryColor, fz`ontSize: 14),
            //       ),
            //     ),
            //   ],
            // ),
            gap3,
            SizedBox(
              width: double.infinity,
              child: _isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator(), // Show spinner when loadingz`
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      onPressed: _isLoginButtonDisabled ? null : _triggerLogin,
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
                      MaterialPageRoute(builder: (context) => Registration()),
                    );
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(color: primaryColor, fontSize: 14),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('lib/assets/pic1.png', width: 300),
      ],
    );
  }
}
