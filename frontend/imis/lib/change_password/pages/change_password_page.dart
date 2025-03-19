import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imis/constant/constant.dart';
import 'package:imis/login/pages/login_main.dart';
import 'dart:convert';

import 'package:imis/login/pages/login_page.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: secondaryColor,
        body: Center(
          child: _FormContent(),
        ),
      ),
    );
  }
}

class _FormContent extends StatefulWidget {
  @override
  State<_FormContent> createState() => _FormContentState();
}

class _FormContentState extends State<_FormContent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String username = '';
  String oldPassword = '';
  String newPassword = '';
  // String confirmPassword = '';

  final FocusNode focusUser = FocusNode();
  final FocusNode focusnewPass = FocusNode();
  final FocusNode focusConfirmPass = FocusNode();

  bool _isPasswordVisible = false;
  bool _isPassConfirmVisible = false;

  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> changePassword(
      String username, String oldPassword, String newPassword) async {
    final String url = 'https://localhost:7273/changePassword';

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'currentPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Success"),
            content: Text('Password changed successfully!'),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Colors.blue[50],
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text("Continue"),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to change password. Please try again.')),
          );
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    focusUser.addListener(() {
      setState(() {}); // Triggers UI update
    });

    focusnewPass.addListener(() {
      setState(() {}); // Triggers UI update
    });
    focusConfirmPass.addListener(() {
      setState(() {}); // Triggers UI update
    });
  }

  @override
  void dispose() {
    focusnewPass.dispose();
    focusUser.dispose();
    focusConfirmPass.dispose();
    super.dispose();
  }
  // void _checkLoginStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  //   if (isLoggedIn) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => HomePage()),
  //     );
  //   } else {
  //     setState(() {
  //       _isPageLoaded = true;
  //     });
  //   }
  // }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      changePassword(_usernameController.text, _newpasswordController.text,
          _confirmPasswordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/assets/lock.png', width: 100),
            Text('Change Password',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300)),
            gap3,
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
                  Icons.person,
                  color: focusUser.hasFocus ? primaryColor : grey,
                ),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                floatingLabelStyle: const TextStyle(color: primaryColor),
              ),
            ),
            gap,
            TextFormField(
              style: TextStyle(fontSize: 14),
              controller: _newpasswordController,
              focusNode: focusnewPass,
              onTap: () {
                FocusScope.of(context).requestFocus(focusnewPass);
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
                  color: focusnewPass.hasFocus ? primaryColor : Colors.grey,
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
                    color: focusnewPass.hasFocus ? primaryColor : grey,
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
            TextFormField(
              style: TextStyle(fontSize: 14),
              controller: _confirmPasswordController,
              focusNode: focusConfirmPass,
              onTap: () {
                FocusScope.of(context).requestFocus(focusConfirmPass);
              },
              obscureText: !_isPassConfirmVisible,
              validator: (value) {
                if (_newpasswordController != _confirmPasswordController) {
                  return 'Passwords do not match';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: TextStyle(color: grey, fontSize: 14),
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
                  color: focusConfirmPass.hasFocus ? primaryColor : Colors.grey,
                ),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                floatingLabelStyle: const TextStyle(color: primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPassConfirmVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: focusConfirmPass.hasFocus ? primaryColor : grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPassConfirmVisible = !_isPassConfirmVisible;
                    });
                  },
                ),
              ),
            ),
            gap3,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cancel Button (Left)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    backgroundColor: secondaryBgButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginMain()));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                // Apply Changes Button (Right)
                _isLoading
                    ? const CircularProgressIndicator() // Show spinner when loading
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: _submitForm,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Apply Changes',
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 14,
                            ),
                          ),
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
