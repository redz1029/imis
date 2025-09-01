import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/user/pages/login_page.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/string_extension.dart';
import 'package:imis/validator/validator.dart';
import 'package:motion_toast/motion_toast.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
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

  final FocusNode idFocusNode = FocusNode();
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
  final bool _isRegister = false;

  final dio = Dio();

  Future<void> register(BuildContext context, UserRegistration user) async {
    final String url = ApiEndpoint().register;

    try {
      final response = await dio.post(
        url,
        data: user.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!context.mounted) return;

        MotionToast.success(
          description: const Text("Registration successful!"),
          toastAlignment: Alignment.topCenter,
        ).show(context);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        final errorData = response.data;
        final errorMessage = errorData['title'] ?? "Registration failed";

        if (!context.mounted) return;

        MotionToast.error(
          description: Text("Error: $errorMessage"),
          toastAlignment: Alignment.topCenter,
        ).show(context);
      }
    } on DioException catch (e) {
      if (!context.mounted) return;

      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.unknown ||
          e.type == DioExceptionType.receiveTimeout) {
        // No internet or timeout
        MotionToast.warning(
          title: const Text("Network Error"),
          description: const Text(
            "Please check your internet connection and try again.",
          ),
          toastAlignment: Alignment.topCenter,
        ).show(context);
        return;
      }

      final errorData = e.response?.data;
      if (errorData is Map<String, dynamic>) {
        final errors = errorData['errors'] as Map<String, dynamic>?;

        if (errors != null && errors.containsKey('DuplicateUserName')) {
          MotionToast.warning(
            title: const Text("User Already Exists"),
            description: Text(errors['DuplicateUserName'][0]),
            toastAlignment: Alignment.topCenter,
          ).show(context);
          return;
        }

        final title = errorData['title'] ?? "Registration failed";
        MotionToast.error(
          description: Text("Error: $title"),
          toastAlignment: Alignment.topCenter,
        ).show(context);
      } else {
        MotionToast.error(
          description: const Text("Unexpected error occurred."),
          toastAlignment: Alignment.topCenter,
        ).show(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();

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

  //carousel indicator
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

  //Job Position Dropdown
  String? selectedPosition;

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
                    children: [_Logo(), _buildRegistrationForm()],
                  )
                  : Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Row(
                      children: [
                        Expanded(child: _Logo()),
                        Expanded(
                          child: Center(child: _buildRegistrationForm()),
                        ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Register',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
                  ),
                  gap8px,
                  Text(
                    'Create your account to get started.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            gap24px,
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
            gap16px,
            if (_currentStep == 0) ...[
              SizedBox(
                height: 65,
                child: DropdownButtonFormField<String>(
                  value:
                      prefixController.text.isNotEmpty
                          ? prefixController.text
                          : null,
                  onChanged: (value) {
                    prefixController.text = value ?? '';
                  },
                  items: [
                    DropdownMenuItem(value: '', child: Text('')),
                    ...[
                      'Mr.',
                      'Ms.',
                      'Mrs.',
                      'Dr.',
                      'Prof.',
                      'Engr.',
                      'Atty.',
                      'Gen.',
                    ].map(
                      (prefix) =>
                          DropdownMenuItem(value: prefix, child: Text(prefix)),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Prefix',
                    labelStyle: TextStyle(color: grey, fontSize: 14),
                    border: OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                ),
              ),

              TextFormField(
                textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: 16),
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
              gap16px,
              TextFormField(
                textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: 16),
                controller: middleNameController,
                focusNode: focusMiddleName,
                onTap: () {
                  FocusScope.of(context).requestFocus(focusMiddleName);
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
              gap16px,
              TextFormField(
                textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: 16),
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
              gap16px,
              TextFormField(
                textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: 16),
                controller: suffixController,
                focusNode: focusSuffix,
                onTap: () {
                  FocusScope.of(context).requestFocus(focusSuffix);
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
                textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: 16),
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
              gap16px,
              TextFormField(
                textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: 16),
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
              gap16px,
              TextFormField(
                textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: 16),
                controller: passwordController,
                focusNode: focusPassword,
                onTap: () {
                  FocusScope.of(context).requestFocus(focusPassword);
                },
                obscureText: !_isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return validatePassword(value);
                  }
                  if (value.length < 6) {
                    return validatePassword(value);
                  }
                  if (!RegExp(r'[A-Z]').hasMatch(value)) {
                    return validatePassword(value);
                  }
                  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                    return validatePassword(value);
                  }
                  return null;
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
              gap16px,
              TextFormField(
                textInputAction: TextInputAction.done,
                style: TextStyle(fontSize: 16),
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
              gap16px,
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Position',
                  labelStyle: TextStyle(color: grey, fontSize: 14),
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
                style: const TextStyle(fontSize: 12, color: Colors.black),
                items:
                    JobPositions.positions.map<DropdownMenuItem<String>>((
                      String value,
                    ) {
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
            gap24px,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep == 1)
                  TextButton(
                    onPressed: _prevStep,
                    child: const Text(
                      "Back",
                      style: TextStyle(color: primaryTextColor, fontSize: 14),
                    ),
                  ),
                Spacer(),
                ElevatedButton(
                  onPressed:
                      _isRegister
                          ? null
                          : () {
                            if (_currentStep == 1) {
                              if (_formKey.currentState!.validate()) {
                                register(
                                  context,
                                  UserRegistration(
                                    idController.text,
                                    userNameController.text,
                                    emailController.text,
                                    passwordController.text,
                                    firstNameController.text,
                                    middleNameController.text,
                                    lastNameController.text,
                                    prefixController.text,
                                    suffixController.text,
                                    selectedPosition ?? '',
                                    '',
                                    '',
                                  ),
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
                          ? const Center(child: CircularProgressIndicator())
                          : Text(
                            _currentStep == 1 ? "Register" : "Next",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                ),
              ],
            ),
            gap16px,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/logo.png',
            width: isSmallScreen ? 100 : 300,
            height: isSmallScreen ? 100 : 300,
          ),
          const Text(
            'IMIS',
            style: TextStyle(fontSize: 32, color: primaryColor),
          ),
        ],
      ),
    );
  }
}
