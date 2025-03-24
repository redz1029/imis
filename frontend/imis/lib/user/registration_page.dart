import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/user/login_page.dart';
import 'package:imis/user/user_registration.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/validator/validator.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController prefixController = TextEditingController();
  final TextEditingController suffixController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FocusNode focusFirstName = FocusNode();
  final FocusNode focusLastName = FocusNode();
  final FocusNode focusMiddleName = FocusNode();
  final FocusNode focusUsername = FocusNode();
  final FocusNode focusEmail = FocusNode();
  final FocusNode focusPrefix = FocusNode();
  final FocusNode focusSuffix = FocusNode();
  final FocusNode focusPassword = FocusNode();
  final FocusNode focusConfirmPassword = FocusNode();

  bool _isPasswordVisible = false;
  bool _isPassConfirmVisible = false;

  bool _isRegister = false;

  final dio = Dio();

  // Future<void> register(
  //   UserRegistration userRegistration,
  //   BuildContext context,
  // ) async {
  //   String url = ApiEndpoint().register;
  //   setState(() {
  //     _isRegister = true;
  //   });
  //   var response = await dio.post(url, data: json.encode(userRegistration));

  //   if (context.mounted) {
  //     if (response.statusCode == 200) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text("Registered Successfuly")));

  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const LoginPage()),
  //       );
  //     } else {
  //       var errMsg = response.statusMessage;
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("An error has occured: $errMsg")),
  //       );
  //     }
  //   }
  //   if (context.mounted) {
  //     setState(() {
  //       _isRegister = false;
  //     });
  //   }
  // }
  Future<void> register(
    UserRegistration userRegistration,
    BuildContext context,
  ) async {
    String url = ApiEndpoint().register;

    setState(() {
      _isRegister = true; // Show loading state
    });

    try {
      var response = await dio.post(url, data: json.encode(userRegistration));

      if (!context.mounted) {
        return; // Prevent running code if context is unmounted
      }

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registered Successfully")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        String errMsg = response.statusMessage ?? "Unknown error";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error has occurred: $errMsg")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration failed: ${e.toString()}")),
        );
      }
    } finally {
      if (context.mounted) {
        setState(() {
          _isRegister = false; // Hide loading state
        });
      }
    }
  }

  int _currentStep = 0;

  void _nextStep() {
    setState(() {
      if (_currentStep < 1) {
        _currentStep++;
      }
    });
  }

  void _prevStep() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  final List<String> jobPositions = [
    'Admin',
    'Head Admin',
    'Super Admin',
    'Nurse',
    'Secretary',
  ];

  String? selectedPosition;

  @override
  void initState() {
    super.initState();

    // Triggers UI textfield update
    focusUsername.addListener(() {
      setState(() {});
    });
    focusMiddleName.addListener(() {
      setState(() {});
    });
    focusLastName.addListener(() {
      setState(() {});
    });
    focusFirstName.addListener(() {
      setState(() {});
    });
    focusSuffix.addListener(() {
      setState(() {});
    });
    focusPrefix.addListener(() {
      setState(() {});
    });
    focusEmail.addListener(() {
      setState(() {});
    });
    focusPassword.addListener(() {
      setState(() {});
    });
    focusConfirmPassword.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    //dispose UI Textfield
    focusFirstName.dispose();
    focusMiddleName.dispose();
    focusLastName.dispose();
    focusSuffix.dispose();
    focusPrefix.dispose();
    focusPassword.dispose();
    focusEmail.dispose();
    focusConfirmPassword.dispose();
    focusUsername.dispose();
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
                    children: [_Logo(), _buildForm()],
                  )
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
        key: _formKey,
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
            gap1,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.circle,
                  size: 10,
                  color: _currentStep == 0 ? primaryColor : lightGrey,
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.circle,
                  size: 10,
                  color: _currentStep == 1 ? primaryColor : lightGrey,
                ),
              ],
            ),
            gap,
            if (_currentStep == 0) ...[
              TextFormField(
                style: TextStyle(fontSize: 14),
                controller: lastNameController,
                focusNode: focusLastName,
                onTap: () {
                  FocusScope.of(context).requestFocus(focusLastName);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter some text";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Last name',
                  labelStyle: const TextStyle(color: grey, fontSize: 14),

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
                controller: firstNameController,
                focusNode: focusFirstName,
                onTap: () {
                  FocusScope.of(context).requestFocus(focusFirstName);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter some text";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'First name',
                  labelStyle: const TextStyle(color: grey, fontSize: 14),

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
                controller: middleNameController,
                focusNode: focusMiddleName,
                onTap: () {
                  FocusScope.of(context).requestFocus(focusMiddleName);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter some text";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Middle name',
                  labelStyle: const TextStyle(color: grey, fontSize: 14),

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
                controller: prefixController,
                focusNode: focusPrefix,
                onTap: () {
                  FocusScope.of(context).requestFocus(focusPrefix);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter some text";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Prefix',
                  labelStyle: const TextStyle(color: grey, fontSize: 14),

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
                controller: suffixController,
                focusNode: focusSuffix,
                onTap: () {
                  FocusScope.of(context).requestFocus(focusSuffix);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter some text";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Suffix',
                  labelStyle: const TextStyle(color: grey, fontSize: 14),

                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  floatingLabelStyle: const TextStyle(color: primaryColor),
                ),
              ),
            ],
            if (_currentStep == 1) ...[
              TextFormField(
                style: TextStyle(fontSize: 14),
                controller: userNameController,
                focusNode: focusUsername,
                onTap: () {
                  FocusScope.of(context).requestFocus(focusUsername);
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
                controller: emailController,
                focusNode: focusEmail,
                onTap: () {
                  FocusScope.of(context).requestFocus(focusEmail);
                },
                validator: FormValidator.validateEmail,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: grey, fontSize: 14),

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
                controller: passwordController,
                focusNode: focusPassword,
                onTap: () {
                  FocusScope.of(context).requestFocus(focusPassword);
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
                      color: focusPassword.hasFocus ? primaryColor : grey,
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
                controller: confirmPasswordController,
                focusNode: focusConfirmPassword,
                onTap: () {
                  FocusScope.of(context).requestFocus(focusConfirmPassword);
                },
                obscureText: !_isPassConfirmVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm your password";
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null; // This means validation passed
                },

                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: grey, fontSize: 14),

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
                      color:
                          focusConfirmPassword.hasFocus ? primaryColor : grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPassConfirmVisible = !_isPassConfirmVisible;
                      });
                    },
                  ),
                ),
              ),
              gap,
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Position',
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  floatingLabelStyle: const TextStyle(color: primaryColor),
                ),
                value: selectedPosition,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPosition = newValue;
                  });
                },
                items:
                    jobPositions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a position';
                  }
                  return null;
                },
              ),
            ],
            gap3,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep == 1)
                  TextButton(onPressed: _prevStep, child: const Text("Back")),
                Spacer(),

                ElevatedButton(
                  onPressed:
                      _isRegister
                          ? null // Disable button if `_isRegister` is true
                          : () {
                            if (_currentStep == 1) {
                              if (_formKey.currentState!.validate()) {
                                register(
                                  UserRegistration(
                                    firstNameController.text,
                                    middleNameController.text,
                                    lastNameController.text,
                                    prefixController.text,
                                    suffixController.text,
                                    userNameController.text,
                                    emailController.text,
                                    passwordController.text,
                                    confirmPasswordController.text,
                                  ),
                                  context,
                                );
                              }
                            } else {
                              _nextStep();
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  child:
                      _isRegister
                          ? const Center(
                            child: CircularProgressIndicator(),
                          ) // Show loading spinner
                          : Text(
                            _currentStep == 1 ? "Register" : "Next",
                            style: TextStyle(color: Colors.white),
                          ),
                ),
              ],
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
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text(
                    "Login",
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

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Image.asset(
        'assets/logo.png',
        width: isSmallScreen ? 100 : 300,
        height: isSmallScreen ? 100 : 300,
      ),
    );
  }
}
