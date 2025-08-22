import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/roles/models/roles.dart';
import 'package:imis/user/models/user_role.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:collection/collection.dart';
import '../../utils/http_util.dart';

class UserRolePage extends StatefulWidget {
  const UserRolePage({super.key});

  @override
  UserRolePageState createState() => UserRolePageState();
}

class UserRolePageState extends State<UserRolePage> {
  final _formKey = GlobalKey<FormState>();
  List<UserRoles> userRoleList = [];
  List<UserRoles> filteredList = [];
  List<Map<String, dynamic>> filteredListUsersRole = [];
  List<Roles> rolenameList = [];
  List<Map<String, dynamic>> auditorList = [];

  List<Map<String, dynamic>> filteredListRole = [];
  List<Map<String, dynamic>> roleList = [];
  String? _selectedRoleId;

  List<User> userList = [];
  List<User> filteredListUser = [];
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

  Future<void> fetchUserRoles({int page = 1}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final int usersPerFetch = 50;
      final response = await AuthenticatedRequest.get(
        dio,
        '${ApiEndpoint().userRole}?page=1&pageSize=$usersPerFetch',
      );

      if (response.statusCode == 200 && response.data is List) {
        List<UserRoles> allRoles = [];

        for (var userJson in response.data) {
          String userId = userJson['userId'];
          if (userJson['roles'] != null && userJson['roles'] is List) {
            for (var role in userJson['roles']) {
              allRoles.add(UserRoles(userId: userId, roleId: role['roleId']));
            }
          }
        }

        _totalCount = allRoles.length;

        int start = (page - 1) * _pageSize;
        int end = start + _pageSize;
        if (start >= _totalCount) {
          setState(() {
            userRoleList = [];
            filteredList = [];
            _currentPage = page;
          });
          return;
        }
        if (end > _totalCount) end = _totalCount;

        List<UserRoles> pageRoles = allRoles.sublist(start, end);

        if (mounted) {
          setState(() {
            userRoleList = pageRoles;
            filteredList = List.from(userRoleList);
            _currentPage = page;
          });
        }
      } else {
        debugPrint("Unexpected response: ${response.data}");
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> fetchRoleList() async {
    var url = ApiEndpoint().roles;

    try {
      var response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<Roles> data =
            (response.data as List).map((e) => Roles.fromJson(e)).toList();

        setState(() {
          rolenameList = data;
        });
        printUserOfficeWithOfficeName();
      }
    } catch (e) {
      debugPrint(" FetchOfficeList Error: $e");
    }
  }

  Future<void> fetchUserList() async {
    var url = ApiEndpoint().users;

    try {
      var response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<User> data =
            (response.data as List).map((e) => User.fromJson(e)).toList();

        setState(() {
          userList = data;
        });

        printUserNameWithUserName();
      }
    } catch (e) {
      debugPrint("etchUserList Error: $e");
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
      debugPrint("Checking userRole: ${userRole.roleId}");

      rolenameList.firstWhere(
        (role) => role.id == userRole.roleId,
        orElse: () => Roles("unknown", "Unknown", "", ""),
      );
    }
  }

  Future<void> addUserRoles(UserRoles userRole) async {
    final url = ApiEndpoint().userRole;

    try {
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: userRole.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        await fetchUserRoles();
      } else {
        debugPrint("Save failed");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<void> updateRole(String userId, String roleId) async {
    final url =
        '${ApiEndpoint().updateUserRole}?userId=$userId&newRoleId=$roleId';

    try {
      final response = await AuthenticatedRequest.put(dio, url);

      if (response.statusCode == 200) {
        await fetchUserRoles();
      } else {
        debugPrint(" Update failed");
      }
    } catch (e) {
      debugPrint(" Error updating role: $e");
    }
  }

  // Display Form-----
  Future<void> fetchRole() async {
    var url = ApiEndpoint().roles;

    try {
      String? token = await AuthUtil.getAccessToken();
      if (token == null || token.isEmpty) {
        return;
      }

      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<Roles> data =
            (response.data as List)
                .map((roles) => Roles.fromJson(roles))
                .toList();

        if (mounted) {
          setState(() {
            roleList = data.map((roles) => roles.toJson()).toList();
            filteredListRole = List.from(roleList);

            if (_selectedRoleId == null && filteredListRole.isNotEmpty) {
              _selectedRoleId = filteredListRole[0]['id'].toString();
            }
          });
        }
      } else {
        debugPrint("Unexpected response format");
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
  }

  // User Name ----------
  Future<void> fetchUser() async {
    var url = ApiEndpoint().users;
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data is List) {
        List<User> data =
            (response.data as List)
                .map((userJson) => User.fromJson(userJson))
                .toList();

        if (mounted) {
          setState(() {
            userList = data;
            filteredListUser = List.from(userList);

            if (filteredListUser.isNotEmpty) {
              _selectedUserId = filteredListUser[0].id;
            }
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  Future<void> deleteUserRole(String kraId) async {
    var url = ApiEndpoint().keyresult;
    try {
      final response = await AuthenticatedRequest.delete(dio, url);

      if (response.statusCode == 200) {
        await fetchRole();
      }
    } catch (e) {
      debugPrint("Error deleting KRA: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserRoles();
    fetchRoleList();
    fetchRole();
    fetchUser();
    printUserOfficeWithOfficeName();
    fetchUserList();
    printUserNameWithUserName();

    if (filteredListRole.isNotEmpty) {
      _selectedRoleId = filteredListRole[0]['id'].toString();
    }
    if (filteredListUser.isNotEmpty) {
      _selectedUserId = filteredListUser[0].id;
    }
    isSearchfocus.addListener(() {
      setState(() {});
    });
    // TokenExpirationHandler(context).checkTokenExpiration();
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
            final role = rolenameList.firstWhereOrNull(
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
                  child: DropdownSearch<Map<String, dynamic>?>(
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

                            title: Text(item?['name'] ?? ''),
                          ),
                    ),

                    items: roleList.cast<Map<String, dynamic>?>(),
                    itemAsString: (o) => o?['name'] ?? '',
                    selectedItem: roleList
                        .cast<Map<String, dynamic>?>()
                        .firstWhere(
                          (o) => o?['id'] == _selectedRoleId,
                          orElse: () => null,
                        ),
                    onChanged:
                        (value) =>
                            setState(() => _selectedRoleId = value?['id']),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
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

                      await addUserRoles(newUserRole);
                    } else {
                      await updateRole(_selectedUserId!, _selectedRoleId!);
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

                                  final matchedRole = rolenameList.firstWhere(
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
                await deleteUserRole(id);
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
