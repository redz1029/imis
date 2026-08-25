import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/user/pages/login_page.dart';
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
  bool _isRegister = false;

  final dio = Dio();

  Future<void> register(BuildContext context, UserRegistration user) async {
    final String url = ApiEndpoint().register;

    setState(() {
      _isRegister = true;
    });

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
    } finally {
      if (mounted) {
        setState(() {
          _isRegister = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    focusUsername.addListener(() => setState(() {}));
    focusMiddleName.addListener(() => setState(() {}));
    focusLastName.addListener(() => setState(() {}));
    focusFirstName.addListener(() => setState(() {}));
    focusSuffix.addListener(() => setState(() {}));
    focusPrefix.addListener(() => setState(() {}));
    focusEmail.addListener(() => setState(() {}));
    focusPassword.addListener(() => setState(() {}));
    focusConfirmPassword.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
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

  // carousel indicator
  int _currentStep = 0;
  void _nextStep() {
    setState(() {
      if (_currentStep < 1) _currentStep++;
    });
  }

  void _prevStep() {
    setState(() {
      if (_currentStep > 0) _currentStep--;
    });
  }

  // Job Position Dropdown
  String? selectedPosition;

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
            Expanded(flex: 48, child: _buildRegistrationForm()),
          ],
        ),
      ],
    );
  }

  Widget _mobileLayout() {
    return _buildRegistrationForm(mobile: true);
  }

  Widget _buildRegistrationForm({bool mobile = false}) {
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
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
                        TextSpan(text: 'Register for '),
                        TextSpan(
                          text: 'CPeMS',
                          style: TextStyle(color: primaryColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Create your account to get started.',
                    style: TextStyle(fontSize: 13, color: kMuted, height: 1.5),
                  ),
                  const SizedBox(height: 24),
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
                  const SizedBox(height: 20),

                  if (_currentStep == 0) ..._buildStepOne(),
                  if (_currentStep == 1) ..._buildStepTwo(),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep == 1)
                        TextButton(
                          onPressed: _prevStep,
                          child: const Text(
                            "Back",
                            style: TextStyle(
                              color: primaryTextColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      const Spacer(),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
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
                              _isRegister
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    _currentStep == 1 ? "Register" : "Next",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 13, color: kMuted),
                      ),
                      const SizedBox(width: 4),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
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
                          'Login',
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
      ),
    );
  }

  List<Widget> _buildStepOne() {
    return [
      _DropdownField(
        label: 'Prefix',
        value: prefixController.text.isNotEmpty ? prefixController.text : null,
        items: const [
          'Mr.',
          'Ms.',
          'Mrs.',
          'Dr.',
          'Prof.',
          'Engr.',
          'Atty.',
          'Gen.',
        ],
        onChanged: (value) {
          setState(() {
            prefixController.text = value ?? '';
          });
        },
      ),
      const SizedBox(height: 14),
      _InputField(
        controller: firstNameController,
        focusNode: focusFirstName,
        hint: 'First name',
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value == null || value.isEmpty) return "Please enter some text";
          return null;
        },
      ),
      const SizedBox(height: 14),
      _InputField(
        controller: middleNameController,
        focusNode: focusMiddleName,
        hint: 'Middle name',
        textInputAction: TextInputAction.next,
      ),
      const SizedBox(height: 14),
      _InputField(
        controller: lastNameController,
        focusNode: focusLastName,
        hint: 'Last name',
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value == null || value.isEmpty) return "Please enter some text";
          return null;
        },
      ),
      const SizedBox(height: 14),
      _InputField(
        controller: suffixController,
        focusNode: focusSuffix,
        hint: 'Suffix',
        textInputAction: TextInputAction.next,
      ),
    ];
  }

  List<Widget> _buildStepTwo() {
    return [
      _InputField(
        controller: userNameController,
        focusNode: focusUsername,
        hint: 'Username',
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value == null || value.isEmpty) return "Please enter some text";
          return null;
        },
      ),
      const SizedBox(height: 14),
      _InputField(
        controller: emailController,
        focusNode: focusEmail,
        hint: 'Email',
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        validator: FormValidator.validateEmail,
      ),
      const SizedBox(height: 14),
      _InputField(
        controller: passwordController,
        focusNode: focusPassword,
        hint: 'Password',
        obscure: !_isPasswordVisible,
        textInputAction: TextInputAction.next,
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: kMuted,
            size: 20,
          ),
          onPressed:
              () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return validatePassword(value);
          if (value.length < 6) return validatePassword(value);
          if (!RegExp(r'[A-Z]').hasMatch(value)) return validatePassword(value);
          if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
            return validatePassword(value);
          }
          return null;
        },
      ),
      const SizedBox(height: 14),
      _InputField(
        controller: confirmPasswordController,
        focusNode: focusConfirmPassword,
        hint: 'Confirm Password',
        obscure: !_isPassConfirmVisible,
        textInputAction: TextInputAction.done,
        suffixIcon: IconButton(
          icon: Icon(
            _isPassConfirmVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: kMuted,
            size: 20,
          ),
          onPressed:
              () => setState(
                () => _isPassConfirmVisible = !_isPassConfirmVisible,
              ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please confirm your password";
          }
          if (value != passwordController.text) return 'Passwords do not match';
          return null;
        },
      ),
      const SizedBox(height: 14),
      DropdownSearch<String>(
        popupProps: PopupProps.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: 'Search Position...',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: kBorder, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: primaryColor, width: 1.8),
              ),
            ),
          ),
        ),
        items: JobPositions.positions,
        selectedItem: selectedPosition,
        onChanged: (String? value) {
          setState(() {
            selectedPosition = value;
          });
        },
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            hintText: 'Position',
            hintStyle: const TextStyle(color: kMuted, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: kBorder, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: primaryColor, width: 1.8),
            ),
            isDense: true,
          ),
        ),
      ),
    ];
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
            "Join us and help keep\nCPeMS on track!",
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
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final VoidCallback? onSubmitted;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.hint,
    this.focusNode,
    this.obscure = false,
    this.keyboardType,
    this.suffixIcon,
    this.onSubmitted,
    this.textInputAction,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscure,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: (_) => onSubmitted?.call(),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kDanger, width: 1.5),
        ),
        isDense: true,
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      onChanged: onChanged,
      items: [
        const DropdownMenuItem(value: '', child: Text('')),
        ...items.map((e) => DropdownMenuItem(value: e, child: Text(e))),
      ],
      style: const TextStyle(fontSize: 14, color: kText),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(color: kMuted, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kBorder, width: 1.5),
        ),
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
