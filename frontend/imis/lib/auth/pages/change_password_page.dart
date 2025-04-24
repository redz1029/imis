import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/auth/models/change_password_request.dart';
import 'package:imis/auth/pages/login_page.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/utils/api_endpoint.dart';

import 'dart:convert';

import 'package:motion_toast/motion_toast.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: secondaryColor,
        body: Center(child: _FormContent()),
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
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  final FocusNode focusUser = FocusNode();
  final FocusNode focusoldPassword = FocusNode();
  final FocusNode focusNewPassword = FocusNode();

  bool _isOldPasswordVisible = false;
  bool _isNewPassVisible = false;

  bool _isLoading = false;

  final dio = Dio();

  Future<void> changePassword(
    BuildContext context,
    ChangePasswordRequest changePassword,
  ) async {
    var url = ApiEndpoint().changepassword;
    setState(() {
      _isLoading = true;
    });

    try {
      var response = await dio.put(
        url,
        data: json.encode(changePassword.toJson()),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
        });

        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text("Success"),
                content: const Text('Password changed successfully!'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
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
                    child: const Text(
                      "Continue",
                      style: TextStyle(color: primaryColor),
                    ),
                  ),
                ],
              ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });

        MotionToast.error(
          title: const Text("Invalid credentials!"),
          description: const Text(
            "Failed to change password. Please try again.",
          ),
          // ignore: deprecated_member_use
          position: MotionToastPosition.top,
          // ignore: use_build_context_synchronously
        ).show(context);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      MotionToast.error(
        title: const Text("An error occurred:"),
        description: const Text(" Please try again."),
        // ignore: deprecated_member_use
        position: MotionToastPosition.top,
        // ignore: use_build_context_synchronously
      ).show(context);
    }
  }

  @override
  void initState() {
    super.initState();
    focusUser.addListener(() {
      setState(() {});
    });

    focusoldPassword.addListener(() {
      setState(() {});
    });
    focusNewPassword.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    focusNewPassword.dispose();
    focusUser.dispose();
    focusoldPassword.dispose();
    super.dispose();
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
            Image.asset('assets/lock.png', width: 100),
            Text(
              'Change Password',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
            ),
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
              controller: _oldpasswordController,
              focusNode: focusoldPassword,
              onTap: () {
                FocusScope.of(context).requestFocus(focusoldPassword);
              },
              obscureText: !_isOldPasswordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                return value.length < 6
                    ? 'Password must be at least 6 characters'
                    : null;
              },
              decoration: InputDecoration(
                labelText: 'Old Password',
                labelStyle: TextStyle(color: grey, fontSize: 14),
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
                  color: focusoldPassword.hasFocus ? primaryColor : Colors.grey,
                ),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                floatingLabelStyle: const TextStyle(color: primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isOldPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: focusoldPassword.hasFocus ? primaryColor : grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isOldPasswordVisible = !_isOldPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            gap,
            TextFormField(
              style: TextStyle(fontSize: 14),
              controller: _newPasswordController,
              focusNode: focusNewPassword,
              onTap: () {
                FocusScope.of(context).requestFocus(focusNewPassword);
              },
              obscureText: !_isNewPassVisible,

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                return value.length < 6
                    ? 'Password must be at least 6 characters'
                    : null;
              },
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: TextStyle(color: grey, fontSize: 14),
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
                  color: focusNewPassword.hasFocus ? primaryColor : Colors.grey,
                ),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                floatingLabelStyle: const TextStyle(color: primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isNewPassVisible ? Icons.visibility_off : Icons.visibility,
                    color: focusNewPassword.hasFocus ? primaryColor : grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isNewPassVisible = !_isNewPassVisible;
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: primaryColor, fontSize: 14),
                    ),
                  ),
                ),

                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed:
                          _isLoading
                              ? null
                              : () {
                                if (_formKey.currentState!.validate()) {
                                  changePassword(
                                    context,
                                    ChangePasswordRequest(
                                      username: _usernameController.text,
                                      currentPassword:
                                          _oldpasswordController.text,
                                      newPassword: _newPasswordController.text,
                                    ),
                                  );
                                }
                              },
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Apply Changes',
                          style: TextStyle(color: secondaryColor, fontSize: 14),
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
