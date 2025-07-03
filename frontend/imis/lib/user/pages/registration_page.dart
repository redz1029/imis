import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/user/pages/login_page.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/api_endpoint.dart';
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
      debugPrint("Registering user: ${user.toJson()}");

      final response = await dio.post(
        url,
        data: user.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!context.mounted) return;

        MotionToast.success(
          description: const Text("Registration successful!"),
          // ignore: deprecated_member_use
          position: MotionToastPosition.top,
        ).show(context);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        final errorMessage = response.data['message'] ?? "Registration failed";
        if (!context.mounted) return;

        MotionToast.error(
          description: Text("Error: $errorMessage"),
          // ignore: deprecated_member_use
          position: MotionToastPosition.top,
        ).show(context);
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.statusCode} - ${e.message}");
      if (!context.mounted) return;

      MotionToast.error(
        description: Text("An error occurred: ${e.message}"),
        // ignore: deprecated_member_use
        position: MotionToastPosition.top,
      ).show(context);
    } catch (e) {
      debugPrint("Unexpected error: $e");
      if (!context.mounted) return;

      MotionToast.error(
        description: const Text("Something went wrong. Please try again."),
        // ignore: deprecated_member_use
        position: MotionToastPosition.top,
      ).show(context);
    }
  }

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
  //

  //Job Position Dropdown
  String? selectedPosition;
  final List<String> jobPositions = [
    'Chief of Medical Professional Staff II',
    'Medical Center Chief II',
    'Head, Department of Anesthesiology',
    'Head, Cancer Institute',
    'Head, COVID-19 Center',
    'Head, Dental Department',
    'Head, NDD',
    'Head, Delivery Room',
    'Head, EFMD',
    'Head, Emergency Room',
    'Head, Finance Service',
    'Head, HIMD',
    'Head, Human Resource Mngt. Department',
    'Head, IHOMP',
    'Head, Department of Internal Medicine',
    'Nurse VI',
    'Head, Department of OB-GYN',
    'Head, OPD',
    'Head, OR (Cath. Lab)',
    'Head, OSM',
    'Head, PACD',
    'Head, Department of Pathology',
    'Head, Department of Pediatrics',
    'Head, PETRU',
    'Head, Pharmacy Deparment',
    'Head, Physical Medicine and Rehabilitation Department',
    'Head, DDTR',
    'Head, Department of Surgery',
    'Head, Trauma Care',
    'Chief Administrative Officer',
  ];
  //end

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
                    ...['Mr.', 'Ms.', 'Mrs.', 'Dr.', 'Prof.', 'Engr.'].map(
                      (prefix) =>
                          DropdownMenuItem(value: prefix, child: Text(prefix)),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Prefix',
                    border: OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                ),
              ),

              TextFormField(
                textInputAction: TextInputAction.next,
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
                textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: 14),
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
              gap,
              TextFormField(
                textInputAction: TextInputAction.next,
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
                textInputAction: TextInputAction.next,
                style: TextStyle(fontSize: 14),
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
                textInputAction: TextInputAction.next,
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
                textInputAction: TextInputAction.next,
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
                textInputAction: TextInputAction.done,
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
                style: const TextStyle(fontSize: 12, color: Colors.black),
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
                  TextButton(
                    onPressed: _prevStep,
                    child: const Text(
                      "Back",
                      style: TextStyle(color: primaryTextColor),
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
