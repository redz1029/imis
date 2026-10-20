import 'package:dio/dio.dart';
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
  final idController = TextEditingController();
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final prefixController = TextEditingController();
  final suffixController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final positionController = TextEditingController();
  final officeController = TextEditingController();
  final dio = Dio();

  bool _isPasswordVisible = false;
  bool _isPassConfirmVisible = false;
  bool _isRegister = false;
  String? selectedPosition;

  @override
  void dispose() {
    idController.dispose();
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    userNameController.dispose();
    prefixController.dispose();
    suffixController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    positionController.dispose();
    officeController.dispose();
    super.dispose();
  }

  Future<void> register(BuildContext context, UserRegistration user) async {
    final String url = ApiEndpoint().register;
    setState(() => _isRegister = true);

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
        final errorMessage = response.data['title'] ?? "Registration failed";
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
      if (mounted) setState(() => _isRegister = false);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // officeController.text -> office na tinype ng user
    // (ilagay sa tamang param ng UserRegistration kung meron)
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
        positionController.text.isNotEmpty
            ? positionController.text
            : selectedPosition ?? '',
        '',
        '',
        null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 700;
    final isWide = w >= 900;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 245, 222, 229),
              Color.fromARGB(255, 233, 153, 181),
              Color.fromARGB(255, 240, 134, 134),
              Color.fromARGB(255, 187, 54, 98),
            ],
            stops: [0.0, 0.35, 0.65, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 12 : 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1040),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 40,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child:
                      isWide
                          ? Stack(
                            children: [
                              Positioned.fill(
                                child: Row(
                                  children: const [
                                    Expanded(flex: 4, child: _BrandPanel()),
                                    Expanded(flex: 7, child: SizedBox.shrink()),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 4,
                                    child: SizedBox.shrink(),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Container(
                                      color: Colors.white,
                                      child: _buildForm(isMobile, isWide),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                          : _buildForm(isMobile, isWide),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(bool isMobile, bool isWide) {
    final twoCols = !isMobile;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 40,
        vertical: isMobile ? 28 : 36,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isWide) ...[
              Container(
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
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
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
            const SizedBox(height: 8),
            const Text(
              'Create your account to get started.',
              style: TextStyle(fontSize: 13, color: kMuted),
            ),
            const SizedBox(height: 28),

            _sectionTitle('Personal Information'),
            _grid(twoCols, [
              _DropdownField(
                label: 'Prefix',
                value:
                    prefixController.text.isNotEmpty
                        ? prefixController.text
                        : null,
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
                onChanged:
                    (v) => setState(() => prefixController.text = v ?? ''),
              ),
              _InputField(
                controller: firstNameController,
                hint: 'First name',
                textInputAction: TextInputAction.next,
                validator: _required,
              ),
              _InputField(
                controller: middleNameController,
                hint: 'Middle name',
                textInputAction: TextInputAction.next,
              ),
              _InputField(
                controller: lastNameController,
                hint: 'Last name',
                textInputAction: TextInputAction.next,
                validator: _required,
              ),
              _InputField(
                controller: suffixController,
                hint: 'Suffix (optional)',
                textInputAction: TextInputAction.next,
              ),
            ]),

            const SizedBox(height: 24),
            _sectionTitle('Account'),
            _grid(twoCols, [
              _InputField(
                controller: userNameController,
                hint: 'Username',
                textInputAction: TextInputAction.next,
                validator: _required,
              ),
              _InputField(
                controller: emailController,
                hint: 'Email',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: FormValidator.validateEmail,
              ),
              _InputField(
                controller: passwordController,
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
                      () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return validatePassword(value);
                  }
                  if (value.length < 6) return validatePassword(value);
                  if (!RegExp(r'[A-Z]').hasMatch(value)) {
                    return validatePassword(value);
                  }
                  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                    return validatePassword(value);
                  }
                  return null;
                },
              ),
              _InputField(
                controller: confirmPasswordController,
                hint: 'Confirm Password',
                obscure: !_isPassConfirmVisible,
                textInputAction: TextInputAction.next,
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
                  if (value == null || value.isEmpty) return "required";
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ]),

            const SizedBox(height: 24),
            _sectionTitle('Work Information'),
            _grid(twoCols, [
              _InputField(
                controller: officeController,
                hint: 'Office',
                textInputAction: TextInputAction.next,
                validator: _required,
              ),
              _buildPositionField(),
            ]),

            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isRegister ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: primaryColor.withValues(alpha: 0.6),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
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
                        : const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 13, color: kMuted),
                  ),
                  TextButton(
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            gap32px,
            Align(
              alignment: Alignment.center,
              child: Text(
                '© ${DateTime.now().year} Cotabato Regional and Medical Center. All rights reserved.',
                style: const TextStyle(fontSize: 10, color: kHint),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _required(String? v) => (v == null || v.isEmpty) ? 'required' : null;

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: kText,
            ),
          ),
        ],
      ),
    );
  }

  /// 2 columns sa desktop/tablet, 1 column sa mobile
  Widget _grid(bool twoCols, List<Widget> children) {
    if (!twoCols) {
      return Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            children[i],
          ],
        ],
      );
    }
    return LayoutBuilder(
      builder: (context, c) {
        const gap = 14.0;
        final itemWidth = (c.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: 14,
          children: [
            for (final child in children)
              SizedBox(width: itemWidth, child: child),
          ],
        );
      },
    );
  }

  Widget _buildPositionField() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Autocomplete<String>(
          initialValue: TextEditingValue(text: positionController.text),
          optionsBuilder: (TextEditingValue v) {
            if (v.text.isEmpty) return JobPositions.positions;
            return JobPositions.positions.where(
              (pos) => pos.toLowerCase().contains(v.text.toLowerCase()),
            );
          },
          onSelected: (String selection) {
            positionController.text = selection;
            selectedPosition = selection;
          },
          fieldViewBuilder: (context, textController, focusNode, _) {
            return TextFormField(
              controller: textController,
              focusNode: focusNode,
              onChanged: (v) {
                positionController.text = v;
                selectedPosition = v;
              },
              style: const TextStyle(fontSize: 14, color: kText),
              decoration: _decoration(
                'Select or type a position',
                suffixIcon: const Icon(Icons.arrow_drop_down, color: kMuted),
              ),
              validator: _required,
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: kSurface,
                elevation: 6,
                borderRadius: BorderRadius.circular(10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 220,
                    maxWidth: constraints.maxWidth,
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return InkWell(
                        onTap: () => onSelected(option),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Text(
                            option,
                            style: const TextStyle(fontSize: 14, color: kText),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ───────────────────────── Shared decoration ─────────────────────────

InputDecoration _decoration(
  String hint, {
  Widget? suffixIcon,
  Widget? prefixIcon,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: kMuted, fontSize: 14),
    suffixIcon: suffixIcon,
    prefixIcon: prefixIcon,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: kDanger, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: kDanger, width: 1.8),
    ),
    isDense: true,
  );
}

// ───────────────────────── Left brand panel ─────────────────────────

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 245, 222, 229),
            Color.fromARGB(255, 233, 153, 181),
            Color.fromARGB(255, 240, 134, 134),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const _FallbackIllustration(),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            "Join us and help keep\nCPeMS on track!",
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7B2D42),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'A centralized system for tracking, managing, and ensuring compliance with PGS.',
            style: TextStyle(
              fontSize: 13.5,
              color: const Color(0xFF8B3A52).withValues(alpha: 0.85),
              height: 1.65,
            ),
          ),
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
        ],
      ),
    );
  }
}

// ───────────────────────── Form fields ─────────────────────────

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.keyboardType,
    this.suffixIcon,
    this.textInputAction,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: kText),
      decoration: _decoration(hint, suffixIcon: suffixIcon),
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
      decoration: _decoration(label),
    );
  }
}
