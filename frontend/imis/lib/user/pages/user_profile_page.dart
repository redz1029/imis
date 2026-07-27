// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
    String? fullName,
  }) {
    userNameController.text = userName ?? '';
    emailController.text = email ?? '';
    passwordController.text = password ?? '';
    firstNameController.text = firstName ?? '';
    middleNameController.text = middleName ?? '';
    lastNameController.text = lastName ?? '';
    prefixController.text = prefix ?? '';
    suffixController.text = suffix ?? '';
    selectedPosition =
        JobPositions.positions.contains(position) ? position : null;
    fullNameController.text = fullName ?? '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: mainBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              titlePadding: EdgeInsets.zero,
              title: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: primaryLightColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  id == null ? 'Change Password' : 'Change Password',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    gap4px,
                    Theme(
                      data: Theme.of(context).copyWith(
                        inputDecorationTheme: const InputDecorationTheme(
                          errorStyle: TextStyle(fontSize: 10),
                        ),
                      ),

                      child: TextFormField(
                        controller: passwordController,
                        focusNode: focusNewPassword,
                        onTap: () {
                          FocusScope.of(context).requestFocus(focusNewPassword);
                        },
                        obscureText: !_isNewPassVisible,

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
                          if (!RegExp(
                            r'[!@#$%^&*(),.?":{}|<>]',
                          ).hasMatch(value)) {
                            return validatePassword(value);
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: grey, fontSize: 14),
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            color:
                                focusNewPassword.hasFocus
                                    ? primaryColor
                                    : Colors.grey,
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          floatingLabelStyle: const TextStyle(
                            color: primaryColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isNewPassVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color:
                                  focusNewPassword.hasFocus
                                      ? primaryColor
                                      : grey,
                            ),
                            onPressed: () {
                              setDialogState(() {
                                _isNewPassVisible = !_isNewPassVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryBgButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text('Cancel', style: TextStyle(color: primaryColor)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool? confirmAction = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              id == null ? "Confirm Save" : "Confirm Update",
                            ),
                            content: Text(
                              id == null
                                  ? "Are you sure you want to change this password?"
                                  : "Are you sure you want to change this password?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(
                                  "No",
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  "Yes",
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmAction == true) {
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
                          selectedPosition ?? '',
                          '',
                          '',
                        );

                        if (id == null) {
                          await _userProfileService.createUser(userProfile);
                          MotionToast.success(
                            toastAlignment: Alignment.topCenter,
                            description: Text('Saved successfully'),
                          ).show(context);
                        } else {
                          await _userProfileService.updateUser(userProfile);
                          MotionToast.success(
                            toastAlignment: Alignment.topCenter,
                            description: Text('Updated successfully'),
                          ).show(context);
                        }

                        Navigator.pop(context);
                      }
                    }
                  },

                  child: Text(
                    id == null ? 'Save' : 'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
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
    selectedPosition =
        JobPositions.positions.contains(position) ? position : null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: mainBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              titlePadding: EdgeInsets.zero,
              title: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: primaryLightColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  id == null ? 'Create User' : ' Edit User',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 450,
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
                                (prefix) => DropdownMenuItem(
                                  value: prefix,
                                  child: Text(prefix),
                                ),
                              ),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Prefix',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 450,
                          height: 65,
                          child: TextFormField(
                            controller: firstNameController,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              focusColor: primaryColor,
                              floatingLabelStyle: TextStyle(
                                color: primaryColor,
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                            ),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill out this field';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 450,
                          height: 65,
                          child: TextFormField(
                            controller: middleNameController,
                            decoration: InputDecoration(
                              labelText: 'Middle Name',
                              focusColor: primaryColor,
                              floatingLabelStyle: TextStyle(
                                color: primaryColor,
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 450,
                          height: 65,
                          child: TextFormField(
                            controller: lastNameController,
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              focusColor: primaryColor,
                              floatingLabelStyle: TextStyle(
                                color: primaryColor,
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill out this field';
                              }
                              return null;
                            },
                          ),
                        ),

                        SizedBox(
                          width: 450,
                          height: 65,
                          child: TextFormField(
                            controller: suffixController,
                            decoration: InputDecoration(
                              labelText: 'Suffix',
                              focusColor: primaryColor,
                              floatingLabelStyle: TextStyle(
                                color: primaryColor,
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 450,
                          height: 65,
                          child: TextFormField(
                            controller: userNameController,
                            decoration: InputDecoration(
                              labelText: 'User Name',
                              focusColor: primaryColor,
                              floatingLabelStyle: TextStyle(
                                color: primaryColor,
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please fill out this field';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 450,
                          height: 65,
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              focusColor: primaryColor,
                              floatingLabelStyle: TextStyle(
                                color: primaryColor,
                              ),
                              border: OutlineInputBorder(),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                            ),
                            validator: FormValidator.validateEmail,
                          ),
                        ),

                        SizedBox(
                          width: 450,
                          child: DropdownSearch<String>(
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  hintText: 'Search Position...',
                                  filled: true,
                                  fillColor: mainBgColor,
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor),
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
                                labelText: 'Position',
                                filled: true,
                                fillColor: mainBgColor,
                                floatingLabelStyle: TextStyle(
                                  color: primaryColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                        gap14px,
                        if (id == null)
                          SizedBox(
                            width: 450,

                            child: TextFormField(
                              focusNode: focusNewPassword,
                              controller: passwordController,
                              onTap: () {
                                FocusScope.of(
                                  context,
                                ).requestFocus(focusNewPassword);
                              },
                              obscureText: !_isNewPassVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                focusColor: primaryColor,
                                floatingLabelStyle: TextStyle(
                                  color: primaryColor,
                                ),
                                border: OutlineInputBorder(),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isNewPassVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color:
                                        focusNewPassword.hasFocus
                                            ? primaryColor
                                            : grey,
                                  ),
                                  onPressed: () {
                                    setDialogState(() {
                                      _isNewPassVisible = !_isNewPassVisible;
                                    });
                                  },
                                ),
                              ),

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
                                if (!RegExp(
                                  r'[!@#$%^&*(),.?":{}|<>]',
                                ).hasMatch(value)) {
                                  return validatePassword(value);
                                }
                                return null;
                              },
                            ),
                          ),
                        gap48px,
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text('Cancel', style: TextStyle(color: primaryColor)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool? confirmAction = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              id == null ? "Confirm Save" : "Confirm Update",
                            ),
                            content: Text(
                              id == null
                                  ? "Are you sure you want to save this record?"
                                  : "Are you sure you want to update this record?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(
                                  "No",
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  "Yes",
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmAction != true) {
                        return;
                      }
                      final username = userNameController.text;
                      final exists = await isUsernameExists(username, id);
                      if (exists) {
                        MotionToast.warning(
                          description: const Text('Username already exists'),
                          toastAlignment: Alignment.topCenter,
                        ).show(context);
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
                        selectedPosition ?? '',
                        '',
                        '',
                      );
                      if (id == null) {
                        await _userProfileService.createUser(userProfile);
                        MotionToast.success(
                          toastAlignment: Alignment.topCenter,
                          description: Text('Saved successfully'),
                        ).show(context);
                        setState(() {
                          fetchUserProfile();
                        });
                      } else {
                        await _userProfileService.updateUser(userProfile);
                        MotionToast.success(
                          toastAlignment: Alignment.topCenter,
                          description: Text('Updated successfully'),
                        ).show(context);
                        setState(() {
                          fetchUserProfile();
                        });
                      }

                      Navigator.pop(context);
                    }
                  },

                  child: Text(
                    id == null ? 'Save' : 'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: const Text('User Information'),
        backgroundColor: mainBgColor,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 300,
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
                          labelStyle: TextStyle(color: grey, fontSize: 14),
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
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 5,
                          ),
                        ),
                        onChanged: filterSearchResults,
                      ),
                    ),
                    if (!isMinimized)
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
                const SizedBox(height: 20),
                Expanded(
                  child: DataTable2(
                    columnSpacing: isMobile ? 16 : 40,
                    headingRowColor: WidgetStatePropertyAll(secondaryColor),
                    dataRowColor: WidgetStatePropertyAll(mainBgColor),
                    headingTextStyle: const TextStyle(color: grey),
                    horizontalMargin: 12,
                    minWidth: constraints.maxWidth,
                    fixedTopRows: 1,
                    border: TableBorder(
                      horizontalInside: BorderSide(color: Colors.grey.shade100),
                    ),
                    columns: const [
                      DataColumn2(label: Text('#'), fixedWidth: 40),
                      DataColumn2(
                        label: Text('First Name'),
                        size: ColumnSize.L,
                      ),
                      DataColumn(label: Text('Middle Name')),
                      DataColumn(label: Text('Last Name')),
                      DataColumn(label: Text('Position')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows:
                        filteredList.asMap().entries.map((entry) {
                          int index = entry.key;
                          var user = entry.value;
                          int itemNumber =
                              ((_currentPage - 1) * _pageSize) + index + 1;

                          return DataRow(
                            cells: [
                              DataCell(Text(itemNumber.toString())),
                              DataCell(Text(user.firstName ?? '')),
                              DataCell(Text(user.middleName ?? '')),
                              DataCell(Text(user.lastName ?? '')),
                              DataCell(Text(user.position ?? '')),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.key, color: Colors.blue),
                                      onPressed: () {
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
                                          fullName:
                                              '${user.firstName} ${user.middleName} ${user.lastName}'
                                                  .trim()
                                                  .replaceAll(
                                                    RegExp(' +'),
                                                    ' ',
                                                  ),
                                        );
                                      },
                                    ),

                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed:
                                          () => showFormDialog(
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
                                          ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: primaryColor,
                                      ),
                                      onPressed: () {
                                        showDeleteDialog(user.id.toString());
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(10),
                  color: secondaryColor,
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
                        onPageChanged: (page) => fetchUserProfile(page: page),
                      ),
                      Container(width: 60),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),

      floatingActionButton:
          isMinimized
              ? FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () => showFormDialog(),
                child: Icon(Icons.add, color: Colors.white),
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
