import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/pagination_util.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfilePage> {
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
  final TextEditingController fullNameController = TextEditingController();

  final FocusNode focusFirstName = FocusNode();
  final FocusNode focusLastName = FocusNode();
  final FocusNode focusMiddleName = FocusNode();
  final FocusNode focusUsername = FocusNode();
  final FocusNode focusEmail = FocusNode();
  final FocusNode focusPrefix = FocusNode();
  final FocusNode focusSuffix = FocusNode();
  final FocusNode focusPassword = FocusNode();
  final FocusNode focusConfirmPassword = FocusNode();
  final FocusNode focusFullname = FocusNode();

  List<UserRegistration> userProfileList = [];
  List<UserRegistration> filteredList = [];

  final TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();
  final dio = Dio();

  final _paginationUtils = PaginationUtil(Dio());

  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;

  //Job Position Dropdown
  String? selectedPosition;
  final List<String> jobPositions = [
    'Admin',
    'Head Admin',
    'Super Admin',
    'Nurse',
    'Secretary',
  ];

  Future<void> fetchUserProfile({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _paginationUtils
          .fetchPaginatedData<UserRegistration>(
            endpoint: ApiEndpoint().getUser,
            page: page,
            pageSize: _pageSize,
            searchQuery: searchQuery,
            fromJson: (json) => UserRegistration.fromJson(json),
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

  Future<void> addOrUpdateUserProfile(UserRegistration userProfile) async {
    var url = ApiEndpoint().register;
    try {
      final response = await dio.post(url, data: userProfile.toJson());
      debugPrint("Sent data: ${userProfile.toJson()}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(
          "Save successful (${response.statusCode}), fetching updated list...",
        );
        await fetchUserProfile();
        userNameController.clear();
        emailController.clear();
        passwordController.clear();
        firstNameController.clear();
        middleNameController.clear();
        lastNameController.clear();
        prefixController.clear();
        suffixController.clear();
      } else {
        debugPrint("Save failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error adding/updating team: $e");
    }
  }

  Future<void> updateUserProfile(UserRegistration userProfile) async {
    var url = ApiEndpoint().updateUser;
    try {
      final response = await dio.put(url, data: userProfile.toJson());
      debugPrint("Sent data: ${userProfile.toJson()}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(
          "Save successful (${response.statusCode}), fetching updated list...",
        );
        await fetchUserProfile();
        userNameController.clear();
        emailController.clear();
        passwordController.clear();
        firstNameController.clear();
        middleNameController.clear();
        lastNameController.clear();
        prefixController.clear();
        suffixController.clear();
      } else {
        debugPrint("Save failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error adding/updating team: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
    isSearchfocus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredList =
          userProfileList
              .where(
                (team) =>
                    team.lastName!.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
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
    selectedPosition = jobPositions.contains(position) ? position : null;
    fullNameController.text = fullName ?? '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(
            id == null ? 'Add User' : 'Change Password',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: false,
                child: SizedBox(
                  width: 350,
                  height: 60,
                  child: TextField(
                    controller: userNameController,
                    decoration: InputDecoration(
                      labelText: 'User Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: false, // change to true to make it visible
                child: SizedBox(
                  width: 350,
                  height: 65,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: 350,
                height: 55,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 4),
                    Text(
                      fullNameController.text,
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 350,
                height: 65,
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              ),

              Visibility(
                visible: false, // change to true to make it visible
                child: SizedBox(
                  width: 350,
                  height: 65,
                  child: TextField(
                    controller: middleNameController,
                    decoration: InputDecoration(
                      labelText: 'Middle Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),

              Visibility(
                visible: false, // change to true to make it visible
                child: SizedBox(
                  width: 350,
                  height: 65,
                  child: TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),

              Visibility(
                visible: false,
                child: SizedBox(
                  width: 350,
                  height: 65,
                  child: TextField(
                    controller: prefixController,
                    decoration: InputDecoration(
                      labelText: 'Prefix',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),

              Visibility(
                visible: false,
                child: SizedBox(
                  width: 350,
                  height: 65,
                  child: TextField(
                    controller: suffixController,
                    decoration: InputDecoration(
                      labelText: 'Suffix',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: false, // set to true to show it
                child: DropdownButtonFormField<String>(
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
                      jobPositions.map<DropdownMenuItem<String>>((
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
              ),
            ],
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
                          child: Text("No"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text("Yes"),
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
                  );

                  if (id == null) {
                    await addOrUpdateUserProfile(userProfile);
                  } else {
                    await updateUserProfile(userProfile);
                  }
                  // ignore: use_build_context_synchronously
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
    selectedPosition = jobPositions.contains(position) ? position : null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(
            id == null ? 'Add User' : 'Edit User',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 350,
                  height: 65,
                  child: TextFormField(
                    controller: userNameController,
                    decoration: InputDecoration(
                      labelText: 'User Name',
                      border: OutlineInputBorder(),
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
                  width: 350,
                  height: 65,
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill out this field';
                      }
                      return null;
                    },
                  ),
                ),
                if (id == null) // Only show when adding a new user
                  SizedBox(
                    width: 350,
                    height: 65,
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill out this field';
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                  ),
                SizedBox(
                  width: 350,
                  height: 65,
                  child: TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      labelText: 'FirstName',
                      border: OutlineInputBorder(),
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
                  width: 350,
                  height: 65,
                  child: TextFormField(
                    controller: middleNameController,
                    decoration: InputDecoration(
                      labelText: 'Middle Name',
                      border: OutlineInputBorder(),
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
                  width: 350,
                  height: 65,
                  child: TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
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
                  width: 350,
                  height: 65,
                  child: TextFormField(
                    controller: prefixController,
                    decoration: InputDecoration(
                      labelText: 'Prefix',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  width: 350,
                  height: 65,
                  child: TextFormField(
                    controller: suffixController,
                    decoration: InputDecoration(
                      labelText: 'Suffix',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

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
                      jobPositions.map<DropdownMenuItem<String>>((
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
                    );

                    if (id == null) {
                      await addOrUpdateUserProfile(userProfile);
                    } else {
                      await updateUserProfile(userProfile);
                    }
                    // ignore: use_build_context_synchronously
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
  }

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: Text('User Profile Information'),
        backgroundColor: mainBgColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
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
                      labelText: 'Search Name',
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () => showFormDialog(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        SizedBox(width: 5),
                        Text('Add New', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  Container(
                    color: secondaryColor,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text('#', style: TextStyle(color: grey)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'User Name',
                            style: TextStyle(color: grey),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Middle Name',
                            style: TextStyle(color: grey),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Last Name',
                            style: TextStyle(color: grey),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Position',
                            style: TextStyle(color: grey),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text('Actions', style: TextStyle(color: grey)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children:
                            filteredList
                                .asMap()
                                .map((index, userProfile) {
                                  int itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;

                                  return MapEntry(
                                    index,
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 1,
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                itemNumber.toString(),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                userProfile.firstName ?? '',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                userProfile.middleName ?? '',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                userProfile.lastName ?? '',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                userProfile.position ?? '',
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.key,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              showFormDialogChangePassword(
                                                id: userProfile.id.toString(),
                                                userName: userProfile.userName,
                                                email: userProfile.email,
                                                password: userProfile.password,
                                                firstName:
                                                    userProfile.firstName,
                                                middleName:
                                                    userProfile.middleName,
                                                lastName: userProfile.lastName,
                                                prefix: userProfile.prefix,
                                                suffix: userProfile.suffix,
                                                position: userProfile.position,
                                                fullName:
                                                    '${userProfile.firstName} ${userProfile.middleName} ${userProfile.lastName}'
                                                        .trim()
                                                        .replaceAll(
                                                          RegExp(' +'),
                                                          ' ',
                                                        ),
                                              );
                                            },
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: () {
                                                    showFormDialog(
                                                      id:
                                                          userProfile.id
                                                              .toString(),
                                                      userName:
                                                          userProfile.userName,
                                                      email: userProfile.email,
                                                      password:
                                                          userProfile.password,
                                                      firstName:
                                                          userProfile.firstName,
                                                      middleName:
                                                          userProfile
                                                              .middleName,
                                                      lastName:
                                                          userProfile.lastName,
                                                      prefix:
                                                          userProfile.prefix,
                                                      suffix:
                                                          userProfile.suffix,
                                                      position:
                                                          userProfile.position,
                                                    );
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () async {},
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                                .values
                                .toList(),
                      ),
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
                        Container(width: 60), // For alignment
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
}
