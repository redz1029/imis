import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/roles/models/roles.dart';
import 'package:imis/user/models/user_role.dart';
import 'package:imis/user/services/user_role_service.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:collection/collection.dart';
import 'package:imis/widgets/pagination_controls.dart';

class UserRolePage extends StatefulWidget {
  const UserRolePage({super.key});

  @override
  UserRolePageState createState() => UserRolePageState();
}

class UserRolePageState extends State<UserRolePage> {
  final _formKey = GlobalKey<FormState>();
  final _commonService = CommonService(Dio());
  final _userRole = UserRoleService(Dio());
  final _userRoleService = UserRoleService(Dio());
  List<UserRoles> userRoleList = [];
  List<UserRoles> filteredList = [];
  List<Roles> roleList = [];
  String? _selectedRoleId;
  List<User> userList = [];
  String? _selectedUserId;
  String? roleName;
  String? userName;
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  late FilterSearchResultUtil<UserRoles> userRoleSearchUtil;
  bool _isLoading = false;
  final TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();
  final dio = Dio();

  Future<void> fetchUserRoles({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _userRoleService.getUserRoles(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          userRoleList = pageList.items;
          filteredList = List.from(userRoleList);
        });
      }
    } catch (e) {
      debugPrint("Error fetching user roles: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void printUserNameWithUserName() {
    for (var userRole in userRoleList) {
      userList.firstWhere(
        (user) => user.id == userRole.userId,
        orElse:
            () =>
                User(id: 'unknown', fullName: 'Unknown', position: 'position'),
      );
    }
  }

  void printUserOfficeWithOfficeName() {
    for (var userRole in userRoleList) {
      roleList.firstWhere(
        (role) => role.id == userRole.roleId,
        orElse: () => Roles("unknown", "Unknown", "", ""),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserRoles();
    () async {
      final roles = await _userRole.fetchRoles();
      final users = await _commonService.fetchUsers();

      if (!mounted) return;

      setState(() {
        roleList = roles;
        userList = users;
        _selectedRoleId = roles.isNotEmpty ? roles[0].id.toString() : null;
        _selectedUserId = users.isNotEmpty ? users[0].id : null;
      });

      printUserOfficeWithOfficeName();
      printUserNameWithUserName();
    }();
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  void filterSearchResults(String query) {
    final lowerQuery = query.toLowerCase();

    setState(() {
      filteredList =
          userRoleList.where((userRole) {
            final user = userList.firstWhereOrNull(
              (u) => u.id == userRole.userId,
            );
            final role = roleList.firstWhereOrNull(
              (r) => r.id == userRole.roleId,
            );

            if (user == null || role == null) return false;

            final userFullName = user.fullName.toLowerCase();
            final roleName = role.name.toLowerCase();

            return userFullName.contains(lowerQuery) ||
                roleName.contains(lowerQuery);
          }).toList();
    });
  }

  void showFormDialog({
    String? id,
    String? selectedUserId,
    String? selectedOfficeId,
    String? userName,
  }) {
    _selectedUserId = selectedUserId;
    _selectedRoleId = selectedOfficeId;

    showDialog(
      context: context,

      barrierDismissible: false,
      builder: (context) {
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
              id == null ? 'Create User Role' : 'Edit User Role',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 450,
                  child: DropdownSearch<User?>(
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: 'Search User Name...',
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
                      itemBuilder:
                          (context, user, isSelected) => ListTile(
                            tileColor: mainBgColor,
                            title: Text(user?.fullName ?? ''),
                          ),
                    ),
                    items: userList,
                    itemAsString: (u) => u?.fullName ?? '',
                    selectedItem: userList.cast<User?>().firstWhere(
                      (u) => u?.id == _selectedUserId,
                      orElse: () => null,
                    ),
                    onChanged:
                        (value) => setState(() => _selectedUserId = value?.id),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a user';
                      }
                      return null;
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Select User',
                        filled: true,
                        fillColor: mainBgColor,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
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
                SizedBox(height: 15),
                SizedBox(
                  width: 450,
                  child: DropdownSearch<Roles?>(
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: 'Search Role...',
                          fillColor: mainBgColor,
                          filled: true,

                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                      ),
                      itemBuilder:
                          (context, item, isSelected) => ListTile(
                            tileColor: mainBgColor,

                            title: Text(item?.name ?? ''),
                          ),
                    ),

                    items: roleList,
                    itemAsString: (o) => o?.name ?? '',
                    selectedItem: roleList.cast<Roles?>().firstWhere(
                      (o) => o?.id == _selectedRoleId,
                      orElse: () => null,
                    ),
                    onChanged:
                        (value) => setState(() => _selectedRoleId = value?.id),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a role';
                      }
                      return null;
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Select Role',
                        fillColor: mainBgColor,
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
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
                    if (_selectedUserId == null || _selectedRoleId == null) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("User and role must both be selected."),
                        ),
                      );
                      return;
                    }

                    if (id == null) {
                      final newUserRole = UserRoles(
                        userId: _selectedUserId!,
                        roleId: _selectedRoleId!,
                      );

                      await _userRoleService.addUserRoles(newUserRole);
                      setState(() {
                        fetchUserRoles();
                      });
                    } else {
                      await _userRoleService.updateRole(
                        _selectedUserId!,
                        _selectedRoleId!,
                      );
                      setState(() {
                        fetchUserRoles();
                      });
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
        title: Text('User Role Information'),
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
                      labelText: 'Search User Role',
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
                          flex: 3,
                          child: Text(
                            'User Name',
                            style: TextStyle(color: grey),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Role Name',
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
                                .map((index, userRoles) {
                                  int itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;

                                  final matchedRole = roleList.firstWhere(
                                    (roles) => roles.id == userRoles.roleId,
                                    orElse:
                                        () =>
                                            Roles('unknown', 'Unknown', '', ''),
                                  );
                                  final String roleName = matchedRole.name;

                                  final matchUserName = userList.firstWhere(
                                    (user) => user.id == userRoles.userId,
                                    orElse:
                                        () => User(
                                          id: 'unknown',
                                          fullName: 'Unknown',
                                          position: 'position',
                                        ),
                                  );
                                  final String userName =
                                      matchUserName.fullName;

                                  return MapEntry(
                                    index,
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 1,
                                        horizontal: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                itemNumber.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                userName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                roleName,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.edit),
                                                    onPressed: () {
                                                      userList.firstWhere(
                                                        (user) =>
                                                            user.id ==
                                                            userRoles.userId,
                                                        orElse:
                                                            () => User(
                                                              id: 'unknown',
                                                              fullName:
                                                                  'Unknown',
                                                              position:
                                                                  'position',
                                                            ),
                                                      );

                                                      final selectedRoleId =
                                                          userRoles.roleId;
                                                      final selectedUserId =
                                                          userRoles.userId;

                                                      showFormDialog(
                                                        id: selectedUserId,
                                                        selectedUserId:
                                                            selectedUserId,
                                                        selectedOfficeId:
                                                            selectedRoleId,
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(width: 1),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: primaryColor,
                                                    ),
                                                    onPressed:
                                                        () => showDeleteDialog(
                                                          userRoles.userId
                                                              .toString(),
                                                        ),
                                                  ),
                                                ],
                                              ),
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
                          onPageChanged: (page) => fetchUserRoles(page: page),
                        ),
                        Container(width: 60),
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

  void showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete this User Role? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: primaryTextColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _userRoleService.deleteUserRole(id);
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
