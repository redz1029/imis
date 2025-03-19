import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imis/constant/constant.dart';
import 'package:imis/home_page.dart';
import 'package:imis/login/pages/login_main.dart';
import 'package:imis/register/pages/registration_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showModal = true;
  String _modalMessage = '';

  Future<void> _registerUser() async {
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final firstname = "Sample";
    final middlename = "Sample";
    final lastname = "Sample";
    final suffix = "Sample";
    final prefix = "Sample";
    final posiiton = "Sample";
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _setModal("Please fill in all fields.");
      return;
    }

    if (password != confirmPassword) {
      _setModal("Passwords do not match.");
      return;
    }

    final apiUrl = 'https://localhost:7273/register';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
          'firstname': firstname,
          'lastname': lastname,
          'prefix': prefix,
          'suffix': suffix,
          'position': posiiton,
        }),
      );

      if (response.statusCode == 200) {
        _setModal("Registration successful!");

        // Navigate to LoginPage after registration success
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => LoginMain()),
          );
        });
      } else {
        _setModal("Registration failed. Please try again.");
      }
    } catch (e) {
      _setModal(
          "An error occurred. Please check your internet connection and try again.");
    }
  }

  void _setModal(String message) {
    setState(() {
      _modalMessage = message;
      _showModal = true;
    });
  }
  // final _usernameController = TextEditingController();
  // final _emailController = TextEditingController();
  // final _passwordController = TextEditingController();
  // final _confirmPasswordController = TextEditingController();

  // final FocusNode focusUser = FocusNode();
  // final FocusNode focusPass = FocusNode();
  // final FocusNode focusEmail = FocusNode();
  // final FocusNode focusConfirmPass = FocusNode();

  // bool _isPageLoaded = false;
  // bool _isPasswordVisible = false;
  // bool _isPassConfirmVisible = false;
  // bool _isRegistrationDisabled = false;
  // bool _isLoading = false;

  // Future<void> _registerUser() async {
  //   final username = _usernameController.text;
  //   final email = _emailController.text;
  //   final password = _passwordController.text;
  //   final confirmPassword = _confirmPasswordController.text;

  //   final firstname = "Sample";
  //   final middlename = "Sample";
  //   final lastname = "Sample";
  //   final suffix = "Sample";
  //   final prefix = "Sample";
  //   final posiiton = "Sample";

  //   // setState(() {
  //   //   _isLoading = true;
  //   //   _isRegistrationDisabled = true;
  //   // });
  //   final apiUrl = 'https://localhost:7273/register';

  //   try {
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'username': username,
  //         'email': email,
  //         'password': password,
  //         'firstname': firstname,
  //         'lastname': lastname,
  //         'suffix': suffix,
  //         'prefix': prefix,
  //         'position': posiiton,
  //       }),
  //     );
  //     if (response.statusCode == 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Registration successful')),
  //       );

  //       // _usernameController.clear();
  //       // _passwordController.clear();
  //       // _emailController.clear();
  //       // _confirmPasswordController.clear();

  //       // SharedPreferences prefs = await SharedPreferences.getInstance();
  //       // await prefs.setBool('isRegister', true);

  //       setState(() {
  //         _isRegistrationDisabled = true;
  //         _isPageLoaded = true;
  //       });
  //       Future.delayed(Duration(seconds: 1), () {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => LoginMain()),
  //         );
  //       });
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Registration failed')),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('An error occurred. Please try again.')),
  //     );
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   focusUser.addListener(() {
  //     setState(() {}); // Triggers UI update
  //   });
  //   focusEmail.addListener(() {
  //     setState(() {}); // Triggers UI update
  //   });
  //   focusPass.addListener(() {
  //     setState(() {}); // Triggers UI update
  //   });
  //   focusConfirmPass.addListener(() {
  //     setState(() {}); // Triggers UI update
  //   });
  // }

  // @override
  // void dispose() {
  //   focusPass.dispose();
  //   focusEmail.dispose();
  //   focusUser.dispose();
  //   focusConfirmPass.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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

  @override
  Widget _buildForm() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        // key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft, // Aligns the text to the left
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Ensures left alignment
                children: [
                  Text(
                    'Register',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
                  ),
                  gap2, // Adjust spacing
                  Text(
                    'Create your account to get started.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            gap3,
            TextFormField(
              style: TextStyle(fontSize: 14),
              controller: _usernameController,
              // focusNode: focusUser,
              // onTap: () {
              //   FocusScope.of(context).requestFocus(focusUser);
              // },
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
                  // color: focusUser.hasFocus ? primaryColor : grey,
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
              controller: _emailController,
              // focusNode: focusEmail,
              // onTap: () {
              //   FocusScope.of(context).requestFocus(focusEmail);
              // },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter some text";
                }
                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value);
                return emailValid ? null : "Please enter a valid email";
              },
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: grey, fontSize: 14),
                prefixIcon: Icon(
                  Icons.email_outlined,
                  // color: focusEmail.hasFocus ? primaryColor : grey,
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
              controller: _passwordController,
              // focusNode: focusPass,
              // onTap: () {
              //   FocusScope.of(context).requestFocus(focusPass);
              // },
              // obscureText: !_isPasswordVisible,
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
                  // color: focusPass.hasFocus ? primaryColor : Colors.grey,
                ),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                floatingLabelStyle: const TextStyle(color: primaryColor),
                // suffixIcon: IconButton(
                //   icon: Icon(
                //       // // _isPasswordVisible
                //       //     ? Icons.visibility_off
                //       //     : Icons.visibility,
                //       // color: focusPass.hasFocus ? primaryColor : grey,
                //       ),
                //   onPressed: () {
                //     setState(() {
                //       _isPasswordVisible = !_isPasswordVisible;
                //     });
                //   },
                // ),
              ),
            ),
            gap,
            TextFormField(
              style: TextStyle(fontSize: 14),
              controller: _confirmPasswordController,
              // focusNode: focusConfirmPass,
              // onTap: () {
              //   FocusScope.of(context).requestFocus(focusConfirmPass);
              // },
              // obscureText: !_isPassConfirmVisible,
              validator: (value) {
                if (_passwordController != _confirmPasswordController) {
                  return 'Passwords do not match';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: TextStyle(color: grey, fontSize: 14),
                prefixIcon: Icon(
                  Icons.lock_outline_rounded,
                  // color: focusConfirmPass.hasFocus ? primaryColor : Colors.grey,
                ),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                floatingLabelStyle: const TextStyle(color: primaryColor),
                // suffixIcon: IconButton(
                //   icon: Icon(
                //     _isPassConfirmVisible
                //         ? Icons.visibility_off
                //         : Icons.visibility,
                //     color: focusConfirmPass.hasFocus ? primaryColor : grey,
                //   ),
                //   onPressed: () {
                //     setState(() {
                //       _isPassConfirmVisible = !_isPassConfirmVisible;
                //     });
                //   },
                // ),
              ),
            ),
            gap3,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                onPressed: _registerUser, //wtf?
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Register',
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
                  "Already have an account?",
                  style: TextStyle(fontSize: 14),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginMain()),
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: primaryColor, fontSize: 14),
                    )),
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
