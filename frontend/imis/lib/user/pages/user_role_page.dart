// ignore_for_file: use_build_context_synchronously
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/roles/models/roles.dart';
import 'package:imis/user/models/user_role.dart';
import 'package:imis/user/services/user_role_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:collection/collection.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/widgets/dotted_button.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:motion_toast/motion_toast.dart';

class UserRolePage extends StatefulWidget {
  const UserRolePage({super.key});

  @override
  UserRolePageState createState() => UserRolePageState();
}

class UserRolePageState extends State<UserRolePage> {
  final _formKey = GlobalKey<FormState>();
  final _commonService = CommonService(Dio());
  final _userRoleService = UserRoleService(Dio());
  final FocusNode isSearchfocus = FocusNode();
  List<UserRoles> userRoleList = [];
  List<UserRoles> filteredList = [];
  List<Roles> roleList = [];
  List<User> userList = [];
  String? _selectedUserId;
  List<UserRoles> _allUserRoles = [];
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;

  final TextEditingController searchController = TextEditingController();
  final FocusNode isSearchFocus = FocusNode();
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchUserRoles();
    _fetchRolesAndUsers();
    isSearchfocus.addListener(() {
      setState(() {});
    });
  }

  Future<List<dynamic>?> _fetchPermissions(String userId, String roleId) async {
    try {
      final response = await AuthenticatedRequest.get(
        dio,
        'https://localhost:7273/users/$userId/permissions?roleId=$roleId',
      );

      if (response.statusCode == 200) {
        return response.data['permissions'];
      }

      return null;
    } catch (e) {
      MotionToast.error(
        description: Text('Failed to fetch permissions'),
      ).show(context);
      return null;
    }
  }

  Future<void> _updatePermission(
    String userId,
    String userName,
    List<dynamic> permissions,
  ) async {
    try {
      final response = await AuthenticatedRequest.put(
        dio,
        'https://localhost:7273/users/$userId/permissions',
        data: {"id": userId, "name": userName, "permissions": permissions},
      );

      if (response.statusCode == 200) {
        print("Permission updated successfully");
      } else {
        print("Failed: ${response.data}");
      }
    } catch (e) {
      print("Error updating permission: $e");
    }
  }

  Future<void> _fetchRolesAndUsers() async {
    final roles = await _userRoleService.fetchRoles();
    final users = await _commonService.fetchUsers();

    if (!mounted) return;

    setState(() {
      roleList = roles;
      userList = users;
      _selectedUserId = users.isNotEmpty ? users[0].id : null;
    });
  }

  Future<void> fetchUserRoles({int page = 1}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final response = await AuthenticatedRequest.get(
        dio,
        '${ApiEndpoint().userRole}?page=1&pageSize=50',
      );

      if (response.statusCode == 200 && response.data is List) {
        List<UserRoles> allRoles =
            (response.data as List)
                .map((json) => UserRoles.fromJson(json))
                .where((ur) => ur.roles!.isNotEmpty)
                .toList();
        _allUserRoles = allRoles;
        _totalCount = allRoles.length;

        int start = (page - 1) * _pageSize;
        int end = start + _pageSize;
        if (end > _totalCount) end = _totalCount;

        final pageRoles = allRoles.sublist(start, end);

        if (mounted) {
          setState(() {
            userRoleList = pageRoles;
            filteredList = List.from(userRoleList);
            _currentPage = page;
          });
        }
      } else {}
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void filterSearchResults(String query) {
    final lowerQuery = query.toLowerCase().trim();

    setState(() {
      if (lowerQuery.isEmpty) {
        filteredList = List.from(userRoleList);
      } else {
        filteredList =
            _allUserRoles.where((userRole) {
              final user = userList.firstWhereOrNull(
                (u) => u.id == userRole.userId,
              );

              if (user == null) return false;

              return user.fullName.toLowerCase().contains(lowerQuery);
            }).toList();
      }
    });
  }

  void showFormDialog({String? id, String? selectedUserId}) {
    _selectedUserId = selectedUserId;

    final List<String> currentRoles =
        _allUserRoles
            .where((ur) => ur.userId == _selectedUserId)
            .expand(
              (ur) => ur.roles!.map(
                (r) =>
                    roleList
                        .firstWhereOrNull((role) => role.id == r.roleId)
                        ?.name ??
                    '',
              ),
            )
            .toList();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
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
                  id == null ? 'Create User Role' : 'Manage User Role',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 480,
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
                            (value) =>
                                setState(() => _selectedUserId = value?.id),
                        validator:
                            (value) =>
                                value == null ? 'Please select a user' : null,
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
                    SizedBox(height: 16),
                    Text(id == null ? '' : 'Current Roles'),
                    SizedBox(height: 8),
                    ...currentRoles.map(
                      (roleName) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: Text(roleName)),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: primaryTextColor,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),

                                    // Inside the IconButton's onPressed for editing permissions
                                    onPressed: () async {
                                      final role = roleList.firstWhere(
                                        (r) =>
                                            r.name.toLowerCase() ==
                                            roleName.toLowerCase(),
                                      );

                                      final roleId = role.id;

                                      final permissions =
                                          await _fetchPermissions(
                                            _selectedUserId!,
                                            roleId,
                                          );

                                      if (permissions != null) {
                                        _showPermissionsDialog(
                                          _selectedUserId!, // <-- REQUIRED
                                          roleId, // <-- REQUIRED
                                          permissions, // <-- LIST
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(width: 6),
                                  IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: primaryTextColor,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    onPressed: () {
                                      setStateDialog(
                                        () => currentRoles.remove(roleName),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    DottedButton(
                      prefixIcon: Icon(Icons.add),
                      text: "Add roles",
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final availableRoles =
                                roleList
                                    .where(
                                      (role) =>
                                          !currentRoles.contains(role.name),
                                    )
                                    .toList();
                            return AlertDialog(
                              title: Text("Select Role"),
                              content: SizedBox(
                                width: 400,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: availableRoles.length,
                                  itemBuilder: (context, index) {
                                    final role = availableRoles[index];
                                    return ListTile(
                                      title: Text(role.name),
                                      trailing: IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          setStateDialog(
                                            () => currentRoles.add(role.name),
                                          );
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    "Close",
                                    style: TextStyle(color: primaryColor),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
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
                        if (_selectedUserId == null) return;

                        final assignedRoles =
                            currentRoles.map((roleName) {
                              final role = roleList.firstWhere(
                                (r) =>
                                    r.name.toLowerCase() ==
                                    roleName.toLowerCase(),
                                orElse:
                                    () => Roles('unknown', 'Unknown', '', ''),
                              );
                              return RoleAssignment(roleId: role.id);
                            }).toList();

                        final newUserRole = UserRoles(
                          _selectedUserId!,
                          assignedRoles,
                        );

                        if (id == null) {
                          await _userRoleService.addUserRoles(newUserRole);
                          MotionToast.success(
                            toastAlignment: Alignment.topCenter,
                            description: Text('Saved successfully'),
                          ).show(context);
                        } else {
                          await _userRoleService.updateRole(
                            _selectedUserId!,
                            assignedRoles,
                          );
                          MotionToast.success(
                            toastAlignment: Alignment.topCenter,
                            description: Text('Updated successfully'),
                          ).show(context);
                        }
                        await fetchUserRoles();
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

  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this User Role?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: primaryTextColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await _userRoleService.deleteUserRole(id);
                  await fetchUserRoles();
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text('User role deleted successfully'),
                  ).show(context);
                } catch (e) {
                  MotionToast.error(
                    description: Text('Failed to Delete User role'),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionsDialog(
    String userId,
    String userName,
    List<dynamic> permissions,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            bool allChecked = permissions.every((p) => p['isAssigned'] == true);
            return AlertDialog(
              backgroundColor: mainBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              title: Text('Permissions'),
              content: SizedBox(
                width: 700,
                height: 350,
                child: Column(
                  children: [
                    CheckboxListTile(
                      title: Text(
                        allChecked ? "Uncheck All" : "Check All",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      value: allChecked,
                      onChanged: (value) async {
                        setDialogState(() {
                          for (var item in permissions) {
                            item['isAssigned'] = value;
                          }
                        });

                        await _updatePermission(userId, userName, permissions);
                      },
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return primaryColor;
                        }
                        return Colors.transparent;
                      }),
                    ),
                    Divider(),
                    gap8px,
                    Expanded(
                      child:
                          permissions.isNotEmpty
                              ? ListView.builder(
                                itemCount: permissions.length,
                                itemBuilder: (context, index) {
                                  final item = permissions[index];
                                  return CheckboxListTile(
                                    title: Text(item['permission']),
                                    value: item['isAssigned'],
                                    onChanged: (value) async {
                                      setDialogState(() {
                                        item['isAssigned'] = value;
                                      });

                                      await _updatePermission(
                                        userId,
                                        userName,
                                        permissions,
                                      );
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    fillColor: WidgetStateProperty.resolveWith((
                                      states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.selected,
                                      )) {
                                        return primaryColor;
                                      }
                                      return Colors.transparent;
                                    }),
                                  );
                                },
                              )
                              : Text('No permissions found.'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close', style: TextStyle(color: primaryColor)),
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
    final isMinimized = MediaQuery.of(context).size.width < 600;
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
              child: SingleChildScrollView(
                child: Column(
                  children:
                      userList
                          .where(
                            (user) =>
                                filteredList.any((ur) => ur.userId == user.id),
                          )
                          .map((user) {
                            final userRolesForUser =
                                filteredList
                                    .where((ur) => ur.userId == user.id)
                                    .toList();
                            return Card(
                              color: mainBgColor,
                              elevation: 0,
                              margin: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: Theme(
                                data: Theme.of(
                                  context,
                                ).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  collapsedBackgroundColor: secondaryColor,
                                  backgroundColor: secondaryBgButton,
                                  tilePadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  childrenPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  title: Text(user.fullName),
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children:
                                          userRolesForUser.expand((userRole) {
                                            return userRole.roles!.map((
                                              assignedRole,
                                            ) {
                                              final matchedRole = roleList
                                                  .firstWhere(
                                                    (r) =>
                                                        r.id ==
                                                        assignedRole.roleId,
                                                    orElse:
                                                        () => Roles(
                                                          'unknown',
                                                          'Unknown',
                                                          '',
                                                          null,
                                                        ),
                                                  );
                                              return Container(
                                                width: double.infinity,
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 4,
                                                  horizontal: 16,
                                                ),
                                                child: Text(matchedRole.name),
                                              );
                                            });
                                          }).toList(),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit, size: 20),
                                          onPressed:
                                              () => showFormDialog(
                                                id: user.id,
                                                selectedUserId: user.id,
                                              ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: primaryColor,
                                          ),
                                          onPressed:
                                              () => showDeleteDialog(user.id),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
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
      floatingActionButton:
          isMinimized
              ? FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () => showFormDialog(),
                child: Icon(Icons.add),
              )
              : null,
    );
  }
}
