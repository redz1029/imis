// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/user/services/users_profile_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/string_extension.dart';
import 'package:imis/validator/validator.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:motion_toast/motion_toast.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _userProfileService = UsersProfileService(Dio());
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
  final TextEditingController positionController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final FocusNode focusFirstName = FocusNode();
  final FocusNode focusLastName = FocusNode();
  final FocusNode focusMiddleName = FocusNode();
  final FocusNode focusUsername = FocusNode();
  final FocusNode focusEmail = FocusNode();
  final FocusNode focusPrefix = FocusNode();
  final FocusNode focusSuffix = FocusNode();
  final FocusNode focusFullname = FocusNode();
  List<UserRegistration> userProfileList = [];
  List<UserRegistration> filteredList = [];

  final FocusNode focusNewPassword = FocusNode();
  bool _isNewPassVisible = false;

  final TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();
  final dio = Dio();

  final _paginationUtils = PaginationUtil(Dio());
  late FilterSearchResultUtil<UserRegistration> userSearchUtil;

  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;
  String? selectedPosition;

  Future<void> fetchUserProfile({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _userProfileService.getUsers(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          userProfileList = pageList.items;
          filteredList = List.from(userProfileList);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool> isUsernameExists(String username, [String? userId]) async {
    try {
      final userList = await _userProfileService.getUsers(
        page: 1,
        pageSize: 100,
        searchQuery: username,
      );
      return userList.items.any((user) {
        final hasSameUsername = user.userName == username;
        final isNotCurrent = userId == null || user.id != userId;

        return hasSameUsername && isNotCurrent;
      });
    } catch (e) {
      debugPrint('Error checking username exists: $e');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    isSearchfocus.addListener(() {
      setState(() {});
    });
    userSearchUtil = FilterSearchResultUtil<UserRegistration>(
      paginationUtils: _paginationUtils,
      endpoint: ApiEndpoint().getUser,
      pageSize: _pageSize,
      fromJson: (json) => UserRegistration.fromJson(json),
    );

    fetchUserProfile();
    isSearchfocus.addListener(() {
      setState(() {});
    });
    focusNewPassword.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
    focusNewPassword.dispose();
    super.dispose();
  }

  Future<void> filterSearchResults(String query) async {
    final results = await userSearchUtil.filter(
      query,
      (user, search) =>
          (user.firstName ?? '').toLowerCase().contains(search.toLowerCase()) ||
          (user.middleName ?? '').toLowerCase().contains(
            search.toLowerCase(),
          ) ||
          (user.lastName ?? '').toLowerCase().contains(search.toLowerCase()),
    );

    setState(() {
      filteredList = results;
    });
  }

  void showFormDialogChangePassword({
    String? id,
    String? userName,
    String? email,
    String? password,
    String? firstName,
    String? middleName,
    String? lastName,
    String? prefix,
    String? suffix,
    String? position,
    bool isEditingpassword = false,
  }) {
    userNameController.text = userName ?? '';
    emailController.text = email ?? '';
    passwordController.text = password ?? '';
    firstNameController.text = firstName ?? '';
    middleNameController.text = middleName ?? '';
    lastNameController.text = lastName ?? '';
    prefixController.text = prefix ?? '';
    suffixController.text = suffix ?? '';
    positionController.text = position ?? '';
    selectedPosition =
        JobPositions.positions.contains(position) ? position : null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 520,
                  maxHeight: MediaQuery.of(dialogContext).size.height * 0.92,
                ),
                decoration: BoxDecoration(
                  color: mainBgColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 32,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Header ──────────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, primaryLightColor],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            id == null ? Icons.person_add_alt_1 : Icons.edit,
                            color: Colors.white,
                            size: 22,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Change Password',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white70,
                              size: 20,
                            ),
                            onPressed: () => Navigator.pop(dialogContext),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            splashRadius: 18,
                          ),
                        ],
                      ),
                    ),

                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(24, 20, 24, 8),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionLabel('Security'),
                              SizedBox(height: 12),
                              _passwordField(setDialogState),
                              SizedBox(height: 8),
                              _passwordHints(),

                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Divider(height: 1, color: Colors.grey.shade200),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primaryColor,
                              side: BorderSide(color: primaryColor),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Cancel'),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton.icon(
                            icon: Icon(
                              id == null ? Icons.save_outlined : Icons.update,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: Text(
                              id == null ? 'Save' : 'Update',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                bool? confirmAction = await showDialog<bool>(
                                  context: dialogContext,
                                  builder:
                                      (confirmContext) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        title: Row(
                                          children: [
                                            Icon(
                                              Icons.help_outline,
                                              color: primaryColor,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              id == null
                                                  ? "Confirm Save"
                                                  : "Confirm Update",
                                            ),
                                          ],
                                        ),
                                        content: Text(
                                          id == null
                                              ? "Are you sure you want to save this password?"
                                              : "Are you sure you want to update this password?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(
                                                  confirmContext,
                                                  false,
                                                ),
                                            child: Text(
                                              "No",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed:
                                                () => Navigator.pop(
                                                  confirmContext,
                                                  true,
                                                ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                            child: Text(
                                              "Yes",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );

                                if (confirmAction != true) return;

                                final username = userNameController.text;
                                final exists = await isUsernameExists(
                                  username,
                                  id,
                                );
                                if (exists) {
                                  MotionToast.warning(
                                    description: const Text(
                                      'Username already exists',
                                    ),
                                    toastAlignment: Alignment.topCenter,
                                  ).show(dialogContext);
                                  return;
                                }

                                final userProfile = UserRegistration(
                                  id,
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
                                );

                                if (id == null) {
                                  await _userProfileService.createUser(
                                    userProfile,
                                  );
                                  MotionToast.success(
                                    toastAlignment: Alignment.topCenter,
                                    description: Text('Saved successfully'),
                                  ).show(dialogContext);
                                } else {
                                  await _userProfileService.updateUser(
                                    userProfile,
                                  );
                                  MotionToast.success(
                                    toastAlignment: Alignment.topCenter,
                                    description: Text('Updated successfully'),
                                  ).show(dialogContext);
                                  setState(() {
                                    fetchUserProfile();
                                  });
                                }
                                Navigator.pop(dialogContext);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showFormDialog({
    String? id,
    String? userName,
    String? email,
    String? password,
    String? firstName,
    String? middleName,
    String? lastName,
    String? prefix,
    String? suffix,
    String? position,
    bool isEditingpassword = false,
  }) {
    userNameController.text = userName ?? '';
    emailController.text = email ?? '';
    passwordController.text = password ?? '';
    firstNameController.text = firstName ?? '';
    middleNameController.text = middleName ?? '';
    lastNameController.text = lastName ?? '';
    prefixController.text = prefix ?? '';
    suffixController.text = suffix ?? '';
    positionController.text = position ?? '';
    selectedPosition =
        JobPositions.positions.contains(position) ? position : null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 520,
                  maxHeight: MediaQuery.of(dialogContext).size.height * 0.92,
                ),
                decoration: BoxDecoration(
                  color: mainBgColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 32,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Header ──────────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, primaryLightColor],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            id == null ? Icons.person_add_alt_1 : Icons.edit,
                            color: Colors.white,
                            size: 22,
                          ),
                          SizedBox(width: 10),
                          Text(
                            id == null ? 'Create User' : 'Edit User',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white70,
                              size: 20,
                            ),
                            onPressed: () => Navigator.pop(dialogContext),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            splashRadius: 18,
                          ),
                        ],
                      ),
                    ),

                    // ── Body ────────────────────────────────────────────
                    Flexible(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(24, 20, 24, 8),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionLabel('Personal Information'),
                              SizedBox(height: 12),

                              // Prefix + Suffix row
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: _styledDropdown(
                                      label: 'Prefix',
                                      value:
                                          prefixController.text.isNotEmpty
                                              ? prefixController.text
                                              : null,
                                      items: [
                                        '',
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
                                          (v) =>
                                              prefixController.text = v ?? '',
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    flex: 2,
                                    child: _styledField(
                                      controller: suffixController,
                                      label: 'Suffix',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),

                              // First + Middle row
                              Row(
                                children: [
                                  Expanded(
                                    child: _styledField(
                                      controller: firstNameController,
                                      label: 'First Name',
                                      required: true,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: _styledField(
                                      controller: middleNameController,
                                      label: 'Middle Name',
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),

                              _styledField(
                                controller: lastNameController,
                                label: 'Last Name',
                                required: true,
                              ),
                              SizedBox(height: 20),

                              _sectionLabel('Account Information'),
                              SizedBox(height: 12),

                              _styledField(
                                controller: userNameController,
                                label: 'Username',
                                prefixIcon: Icons.person_outline,
                                required: true,
                              ),
                              SizedBox(height: 12),

                              _styledField(
                                controller: emailController,
                                label: 'Email',
                                prefixIcon: Icons.email_outlined,
                                validator: FormValidator.validateEmail,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 12),

                              _sectionLabel('Position'),
                              SizedBox(height: 8),
                              _positionComboBox(setDialogState),
                              SizedBox(height: 20),

                              if (id == null) ...[
                                _sectionLabel('Security'),
                                SizedBox(height: 12),
                                _passwordField(setDialogState),
                                SizedBox(height: 8),
                                _passwordHints(),
                              ],

                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // ── Footer ──────────────────────────────────────────
                    Divider(height: 1, color: Colors.grey.shade200),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primaryColor,
                              side: BorderSide(color: primaryColor),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Cancel'),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton.icon(
                            icon: Icon(
                              id == null ? Icons.save_outlined : Icons.update,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: Text(
                              id == null ? 'Save' : 'Update',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                bool? confirmAction = await showDialog<bool>(
                                  context: dialogContext,
                                  builder:
                                      (confirmContext) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        title: Row(
                                          children: [
                                            Icon(
                                              Icons.help_outline,
                                              color: primaryColor,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              id == null
                                                  ? "Confirm Save"
                                                  : "Confirm Update",
                                            ),
                                          ],
                                        ),
                                        content: Text(
                                          id == null
                                              ? "Are you sure you want to save this record?"
                                              : "Are you sure you want to update this record?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(
                                                  confirmContext,
                                                  false,
                                                ),
                                            child: Text(
                                              "No",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed:
                                                () => Navigator.pop(
                                                  confirmContext,
                                                  true,
                                                ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                            ),
                                            child: Text(
                                              "Yes",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );

                                if (confirmAction != true) return;

                                final username = userNameController.text;
                                final exists = await isUsernameExists(
                                  username,
                                  id,
                                );
                                if (exists) {
                                  MotionToast.warning(
                                    description: const Text(
                                      'Username already exists',
                                    ),
                                    toastAlignment: Alignment.topCenter,
                                  ).show(dialogContext);
                                  return;
                                }

                                final userProfile = UserRegistration(
                                  id,
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
                                );

                                if (id == null) {
                                  await _userProfileService.createUser(
                                    userProfile,
                                  );
                                  MotionToast.success(
                                    toastAlignment: Alignment.topCenter,
                                    description: Text('Saved successfully'),
                                  ).show(dialogContext);
                                } else {
                                  await _userProfileService.updateUser(
                                    userProfile,
                                  );
                                  MotionToast.success(
                                    toastAlignment: Alignment.topCenter,
                                    description: Text('Updated successfully'),
                                  ).show(dialogContext);
                                  setState(() {
                                    fetchUserProfile();
                                  });
                                }
                                Navigator.pop(dialogContext);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _styledField({
    required TextEditingController controller,
    required String label,
    bool required = false,
    IconData? prefixIcon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon:
            prefixIcon != null
                ? Icon(prefixIcon, size: 18, color: Colors.grey)
                : null,
        floatingLabelStyle: TextStyle(color: primaryColor, fontSize: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        isDense: true,
      ),
      validator:
          validator ??
          (required
              ? (v) =>
                  (v == null || v.isEmpty) ? 'This field is required' : null
              : null),
    );
  }

  Widget _styledDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: TextStyle(color: primaryColor, fontSize: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        isDense: true,
      ),
      items:
          items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.isEmpty ? '—' : e),
                ),
              )
              .toList(),
    );
  }

  /// Combo box: pick from list OR type a custom position
  Widget _positionComboBox(StateSetter setDialogState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Autocomplete acts as a combo box
        Autocomplete<String>(
          initialValue: TextEditingValue(text: positionController.text),
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return JobPositions.positions;
            }
            return JobPositions.positions.where(
              (pos) => pos.toLowerCase().contains(
                textEditingValue.text.toLowerCase(),
              ),
            );
          },
          onSelected: (String selection) {
            setDialogState(() {
              positionController.text = selection;
              selectedPosition = selection;
            });
          },
          fieldViewBuilder: (
            context,
            textController,
            focusNode,
            onFieldSubmitted,
          ) {
            // Sync external controller → autocomplete's internal controller
            textController.text = positionController.text;
            textController.addListener(() {
              positionController.text = textController.text;
            });
            return TextFormField(
              controller: textController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: 'Select or type a position...',
                prefixIcon: Icon(
                  Icons.work_outline,
                  size: 18,
                  color: Colors.grey,
                ),
                suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                floatingLabelStyle: TextStyle(
                  color: primaryColor,
                  fontSize: 13,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: primaryColor, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                isDense: true,
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 200, maxWidth: 472),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return InkWell(
                        onTap: () => onSelected(option),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.work_outline,
                                size: 15,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 8),
                              Text(option, style: TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 4),
        Text(
          'Choose from the list or type a custom position',
          style: TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _passwordField(StateSetter setDialogState) {
    return TextFormField(
      focusNode: focusNewPassword,
      controller: passwordController,
      obscureText: !_isNewPassVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock_outline, size: 18, color: Colors.grey),
        floatingLabelStyle: TextStyle(color: primaryColor, fontSize: 13),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        isDense: true,
        suffixIcon: IconButton(
          icon: Icon(
            _isNewPassVisible ? Icons.visibility_off : Icons.visibility,
            size: 18,
            color: focusNewPassword.hasFocus ? primaryColor : Colors.grey,
          ),
          onPressed:
              () =>
                  setDialogState(() => _isNewPassVisible = !_isNewPassVisible),
          splashRadius: 18,
        ),
      ),
      validator: (value) => validatePassword(value),
    );
  }

  Widget _passwordHints() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password must contain:',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
          SizedBox(height: 4),
          ...[
            'At least 6 characters',
            'One uppercase letter',
            'One special character (!@#\$%^&*)',
          ].map(
            (hint) => Padding(
              padding: EdgeInsets.only(top: 2),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 5, color: Colors.blue.shade400),
                  SizedBox(width: 6),
                  Text(
                    hint,
                    style: TextStyle(fontSize: 11, color: Colors.blue.shade700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "User Information",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  height: 36,
                  width: 250,
                  child: TextField(
                    focusNode: isSearchfocus,
                    controller: searchController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: lightGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Search...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: isSearchfocus.hasFocus ? primaryColor : grey,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      filled: true,
                      fillColor: secondaryColor,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 5,
                      ),
                    ),
                    onChanged: filterSearchResults,
                  ),
                ),
                const Spacer(),
                if (!isMobile)
                  ElevatedButton.icon(
                    onPressed: () => showFormDialog(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Add New',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 26),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withValues(alpha: .05),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row (desktop only)
                    if (!isMobile)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "#",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                "Name",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Position",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Actions",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 5),
                    Expanded(
                      child:
                          _isLoading
                              ? Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                              : ListView.separated(
                                itemCount: filteredList.length,
                                separatorBuilder:
                                    (context, index) => Divider(
                                      height: 1,
                                      color: Colors.grey.withValues(alpha: 0.2),
                                    ),
                                itemBuilder: (context, index) {
                                  final user = filteredList[index];

                                  final fullName =
                                      '${user.firstName ?? ''} ${user.middleName ?? ''} ${user.lastName ?? ''}'
                                          .trim()
                                          .replaceAll(RegExp(' +'), ' ');

                                  final initials =
                                      fullName.trim().isNotEmpty
                                          ? fullName
                                              .trim()
                                              .split(' ')
                                              .map((e) => e[0])
                                              .take(2)
                                              .join()
                                              .toUpperCase()
                                          : '?';

                                  final itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;

                                  if (!isMobile) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 4,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // # Number
                                          Expanded(
                                            flex: 1,
                                            child: Text("$itemNumber"),
                                          ),

                                          // Name: Avatar + Full Name
                                          Expanded(
                                            flex: 4,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 38,
                                                  height: 38,
                                                  decoration: BoxDecoration(
                                                    color: primaryColor
                                                        .withValues(alpha: 0.1),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      initials,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    fullName,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Position: plain text
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              user.position ?? '—',
                                              style: const TextStyle(
                                                fontSize: 13,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          // Actions
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.security_outlined,
                                                    size: 18,
                                                    color: Colors.blueAccent,
                                                  ),
                                                  onPressed:
                                                      () =>
                                                          showFormDialogChangePassword(
                                                            id:
                                                                user.id
                                                                    .toString(),
                                                            userName:
                                                                user.userName,
                                                            email: user.email,
                                                            password:
                                                                user.password,
                                                            firstName:
                                                                user.firstName,
                                                            middleName:
                                                                user.middleName,
                                                            lastName:
                                                                user.lastName,
                                                            prefix: user.prefix,
                                                            suffix: user.suffix,
                                                            position:
                                                                user.position,
                                                          ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.edit_outlined,
                                                    size: 18,
                                                  ),
                                                  onPressed:
                                                      () => showFormDialog(
                                                        id: user.id.toString(),
                                                        userName: user.userName,
                                                        email: user.email,
                                                        password: user.password,
                                                        firstName:
                                                            user.firstName,
                                                        middleName:
                                                            user.middleName,
                                                        lastName: user.lastName,
                                                        prefix: user.prefix,
                                                        suffix: user.suffix,
                                                        position: user.position,
                                                      ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    CupertinoIcons
                                                        .delete_simple,
                                                    size: 18,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed:
                                                      () => showDeleteDialog(
                                                        user.id.toString(),
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 4,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Avatar
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: primaryColor.withValues(
                                              alpha: 0.1,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              initials,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                fullName,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              if ((user.position ?? '')
                                                  .isNotEmpty) ...[
                                                const SizedBox(height: 4),
                                                Text(
                                                  user.position ?? '',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),

                                        PopupMenuButton<String>(
                                          color: Theme.of(context).cardColor,
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: Colors.grey.shade500,
                                          ),
                                          onSelected: (value) {
                                            if (value == 'password') {
                                              showFormDialogChangePassword(
                                                id: user.id.toString(),
                                                userName: user.userName,
                                                email: user.email,
                                                password: user.password,
                                                firstName: user.firstName,
                                                middleName: user.middleName,
                                                lastName: user.lastName,
                                                prefix: user.prefix,
                                                suffix: user.suffix,
                                                position: user.position,
                                              );
                                            }
                                            if (value == 'edit') {
                                              showFormDialog(
                                                id: user.id.toString(),
                                                userName: user.userName,
                                                email: user.email,
                                                password: user.password,
                                                firstName: user.firstName,
                                                middleName: user.middleName,
                                                lastName: user.lastName,
                                                prefix: user.prefix,
                                                suffix: user.suffix,
                                                position: user.position,
                                              );
                                            }
                                            if (value == 'delete') {
                                              showDeleteDialog(
                                                user.id.toString(),
                                              );
                                            }
                                          },
                                          itemBuilder:
                                              (_) => [
                                                PopupMenuItem(
                                                  value: 'password',
                                                  child: Row(
                                                    children: const [
                                                      Icon(
                                                        Icons.security_outlined,
                                                        size: 18,
                                                        color:
                                                            Colors.blueAccent,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text('Change Password'),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'edit',
                                                  child: Row(
                                                    children: const [
                                                      Icon(
                                                        Icons.edit_outlined,
                                                        size: 18,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text('Edit'),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        CupertinoIcons
                                                            .delete_simple,
                                                        color: Colors.redAccent,
                                                        size: 18,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      const Text('Delete'),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: Theme.of(context).cardColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PaginationInfo(
                            currentPage: _currentPage,
                            totalItems: _totalCount,
                            itemsPerPage: _pageSize,
                          ),
                          PaginationControls(
                            currentPage: _currentPage,
                            totalItems: _totalCount,
                            itemsPerPage: _pageSize,
                            isLoading: _isLoading,
                            onPageChanged:
                                (page) => fetchUserProfile(page: page),
                          ),
                          const SizedBox(width: 60),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          isMobile
              ? FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () => showFormDialog(),
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete this User? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: primaryTextColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  // await _pgsPeriodService.deletePeriod(id);
                  // await fetchPGSPeriods();
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text('User deleted successfully'),
                  ).show(context);
                } catch (e) {
                  MotionToast.error(description: Text('User to Delete Period'));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
