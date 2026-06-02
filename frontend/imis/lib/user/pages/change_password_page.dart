// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:imis/user/models/change_password_request.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/user/pages/login_page.dart';
import 'package:imis/utils/api_endpoint.dart';

void showChangePasswordDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Change Password',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 380),
    transitionBuilder: (ctx, anim1, anim2, child) {
      final curved = CurvedAnimation(parent: anim1, curve: Curves.easeOutBack);
      return ScaleTransition(
        scale: Tween<double>(begin: 0.88, end: 1.0).animate(curved),
        child: FadeTransition(opacity: anim1, child: child),
      );
    },
    pageBuilder: (ctx, _, __) => const _ChangePasswordDialog(),
  );
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();
  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();

  bool _showOld = false;
  bool _showNew = false;
  bool _isLoading = false;
  bool _done = false;

  double _strength = 0;
  String _strengthLabel = '';
  Color _strengthColor = kHint;

  final _dio = Dio();

  @override
  void initState() {
    super.initState();
    _newPassCtrl.addListener(_evaluateStrength);
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    super.dispose();
  }

  void _evaluateStrength() {
    final p = _newPassCtrl.text;
    double s = 0;
    if (p.length >= 6) s += 0.25;
    if (RegExp(r'[A-Z]').hasMatch(p)) s += 0.25;
    if (RegExp(r'[0-9]').hasMatch(p)) s += 0.25;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(p)) s += 0.25;

    String label;
    Color color;
    if (s <= 0) {
      label = '';
      color = kHint;
    } else if (s <= 0.25) {
      label = 'Weak';
      color = kDanger;
    } else if (s <= 0.50) {
      label = 'Fair';
      color = Colors.orange;
    } else if (s <= 0.75) {
      label = 'Good';
      color = Colors.amber[700]!;
    } else {
      label = 'Strong';
      color = kSuccess;
    }

    setState(() {
      _strength = s;
      _strengthLabel = label;
      _strengthColor = color;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final url = ApiEndpoint().changepassword;
    final payload = ChangePasswordRequest(
      username: _usernameCtrl.text,
      currentPassword: _oldPassCtrl.text,
      newPassword: _newPassCtrl.text,
    );

    try {
      final response = await _dio.put(
        url,
        data: json.encode(payload.toJson()),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        setState(() => _done = true);
        await Future.delayed(const Duration(milliseconds: 1800));
        if (!mounted) return;
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginPage()),
        );
      } else {
        MotionToast.error(
          title: const Text("Invalid credentials!"),
          description: const Text(
            "Failed to change password. Please try again.",
          ),
          toastAlignment: Alignment.topCenter,
        ).show(context);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      String errorMessage = "Please try again.";

      if (e is DioException && e.response != null) {
        final data = e.response?.data;

        if (data["errors"] != null) {
          errorMessage = data["errors"]["PasswordRequiresNonAlphanumeric"][0];
        } else if (data["title"] != null) {
          errorMessage = data["title"];
        }
      }

      MotionToast.error(
        title: const Text("Error"),
        description: Text(errorMessage),
        toastAlignment: Alignment.topCenter,
      ).show(context);
    }
  }

  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 440,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: .14),
                  blurRadius: 48,
                  spreadRadius: 4,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: _done ? _buildSuccess() : _buildForm(),
            ),
          ),
        ),
      ),
    );
  }

  // ── success screen ────────────────────────────────────────────
  Widget _buildSuccess() {
    return Padding(
      key: const ValueKey('success'),
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 700),
            curve: Curves.elasticOut,
            builder: (_, v, child) => Transform.scale(scale: v, child: child),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: kSuccess.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: kSuccess, size: 44),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Password Updated!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: kLabel,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your password has been changed successfully.\nRedirecting you to login…',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: kHint, height: 1.6),
          ),
        ],
      ),
    );
  }

  // ── main form ─────────────────────────────────────────────────
  Widget _buildForm() {
    return Padding(
      key: const ValueKey('form'),
      padding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── header ──────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        primaryColor.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: kLabel,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'You will be logged out after saving',
                        style: TextStyle(fontSize: 12, color: kHint),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, color: kHint),
                  splashRadius: 18,
                  tooltip: 'Close',
                ),
              ],
            ),

            const SizedBox(height: 22),
            _GradientDivider(),
            const SizedBox(height: 22),

            // ── username ─────────────────────────────
            _FieldLabel('Username'),
            const SizedBox(height: 6),
            _StyledField(
              controller: _usernameCtrl,
              hint: 'Enter your username',
              prefixIcon: Icons.person_outline_rounded,
              validator:
                  (v) =>
                      (v == null || v.isEmpty) ? 'Username is required' : null,
            ),

            const SizedBox(height: 16),

            _FieldLabel('Current Password'),
            const SizedBox(height: 6),
            _PasswordField(
              controller: _oldPassCtrl,
              hint: 'Enter current password',
              show: _showOld,
              onToggle: () => setState(() => _showOld = !_showOld),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                if (v.length < 6) return 'At least 6 characters';
                return null;
              },
            ),

            const SizedBox(height: 16),

            _FieldLabel('New Password'),
            const SizedBox(height: 6),
            _PasswordField(
              controller: _newPassCtrl,
              hint: 'Enter new password',
              show: _showNew,
              onToggle: () => setState(() => _showNew = !_showNew),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                if (v.length < 6) return 'At least 6 characters';
                if (v == _oldPassCtrl.text) {
                  return 'Must differ from current password';
                }
                return null;
              },
            ),

            if (_newPassCtrl.text.isNotEmpty) ...[
              const SizedBox(height: 10),
              _StrengthBar(
                strength: _strength,
                color: _strengthColor,
                label: _strengthLabel,
              ),
            ],

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: const [
                _HintChip('6+ characters'),
                _HintChip('Uppercase'),
                _HintChip('Number'),
                _HintChip('Symbol'),
              ],
            ),

            const SizedBox(height: 26),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kLabel,
                      side: const BorderSide(color: kBorder),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed:
                        _isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child:
                      _isLoading
                          ? _LoadingButton()
                          : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _submit,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.lock_reset_rounded, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Apply Changes',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
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

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: kLabel,
    ),
  );
}

InputDecoration _inputDeco(String hint) => InputDecoration(
  hintText: hint,
  hintStyle: const TextStyle(color: kHint, fontSize: 14),
  filled: true,
  fillColor: kBackground,
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: kBorder),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: kBorder),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: primaryColor, width: 1.8),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: kDanger),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: kDanger, width: 1.8),
  ),
);

class _StyledField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final String? Function(String?)? validator;

  const _StyledField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: kLabel),
      decoration: _inputDeco(
        hint,
      ).copyWith(prefixIcon: Icon(prefixIcon, size: 20, color: kHint)),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool show;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;

  const _PasswordField({
    required this.controller,
    required this.hint,
    required this.show,
    required this.onToggle,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !show,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: kLabel),
      decoration: _inputDeco(hint).copyWith(
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          size: 20,
          color: kHint,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            show ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            size: 20,
            color: kHint,
          ),
          onPressed: onToggle,
          splashRadius: 18,
        ),
      ),
    );
  }
}

class _StrengthBar extends StatelessWidget {
  final double strength;
  final Color color;
  final String label;

  const _StrengthBar({
    required this.strength,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: strength),
              duration: const Duration(milliseconds: 300),
              builder:
                  (_, v, __) => LinearProgressIndicator(
                    value: v,
                    minHeight: 5,
                    backgroundColor: const Color(0xFFE5E7EB),
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
          child: Text(label),
        ),
      ],
    );
  }
}

class _HintChip extends StatelessWidget {
  final String text;
  const _HintChip(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withValues(alpha: .15)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: primaryColor.withValues(alpha: 0.85),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _LoadingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _GradientDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, kBorder, Colors.transparent],
        ),
      ),
    );
  }
}
