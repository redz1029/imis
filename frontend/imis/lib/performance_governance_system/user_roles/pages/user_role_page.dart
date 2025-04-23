import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/auth/models/user.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/roles/models/roles.dart';
import 'package:imis/performance_governance_system/user_roles/models/user_role.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart'; // For firstWhereOrNull

class UserRolePage extends StatefulWidget {
  const UserRolePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserRolePageState createState() => _UserRolePageState();
}

class _UserRolePageState extends State<UserRolePage> {
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

  final TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();
  final dio = Dio();

  Future<void> fetchUserRoles() async {
    var url = ApiEndpoint().userRole;

    try {
      var response = await dio.get(url);
      debugPrint("📥 Raw response data: ${response.data}");

      if (response.statusCode == 200 && response.data is List) {
        List<UserRoles> data = [];

        for (var user in response.data) {
          String userId = user['userId'];

          // Check if user has roles
          if (user['roles'] != null && user['roles'] is List) {
            for (var role in user['roles']) {
              data.add(UserRoles(userId: userId, roleId: role['roleId']));
            }
          }
        }

        debugPrint("📋 Total UserRoles: ${data.length}");
        if (mounted) {
          setState(() {
            userRoleList = data;
            filteredList = List.from(userRoleList);
          });
        }
      } else {
        debugPrint("Unexpected response: ${response.data}");
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
    }
  }

  Future<void> fetchRoleList() async {
    var url = ApiEndpoint().roles;

    try {
      var response = await dio.get(url);
      debugPrint("📥 Raw Office response: ${response.data}");

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
      var response = await dio.get(url);
      debugPrint("📥 Raw User response: ${response.data}");

      if (response.statusCode == 200 && response.data is List) {
        List<User> data =
            (response.data as List).map((e) => User.fromJson(e)).toList();

        setState(() {
          userList = data;
        });

        debugPrint("✅ User list loaded: ${data.length}");
        printUserNameWithUserName();
      }
    } catch (e) {
      debugPrint("🔥 FetchUserList Error: $e");
    }
  }

  void printUserNameWithUserName() {
    for (var userRole in userRoleList) {
      final userName = userList.firstWhere(
        (user) => user.id == userRole.userId,
        orElse: () => User(id: 'unknown', fullName: 'Unknown'),
      );

      debugPrint(
        "🧾 userId: ${userRole.userId}, officeId: ${userRole.roleId}, fullName: ${userName.fullName}",
      );
    }
  }

  void printUserOfficeWithOfficeName() {
    for (var userRole in userRoleList) {
      // Debugging to check roleId being used
      debugPrint("Checking userRole: ${userRole.roleId}");

      // Perform the inner join logic to match roleId
      final matchedRole = rolenameList.firstWhere(
        (role) => role.id == userRole.roleId,
        orElse: () => Roles("unknown", "Unknown", "", ""),
      );

      debugPrint("Matched Role: ${matchedRole.name}");

      // Print the result
      debugPrint(
        "🧾 userId: ${userRole.userId}, officeId: ${userRole.roleId}, roleName: ${matchedRole.name}",
      );
    }
  }

  Future<void> addorUpdateUserRoles(UserRoles userRole) async {
    final url = ApiEndpoint().userRole;

    try {
      final response = await dio.post(url, data: userRole.toJson());

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint("Save successful");
        await fetchUserRoles();
      } else {
        debugPrint("Save failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("🔥 Error: $e");
    }
  }

  //   Future<void> updateRole(String userId, String roleId) async {
  //   final url = '${ApiEndpoint().roles}/$roleId';

  //   try {
  //     final response = await dio.put(
  //       url,
  //       data: '"$roleId"', // 👈 wrap with quotes to make it a valid JSON string
  //       options: Options(
  //         contentType: Headers.jsonContentType,
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       debugPrint("✅ Role updated successfully: ${response.data}");
  //       // Optionally re-fetch roles list or update UI
  //       await fetchUserRoles();
  //     } else {
  //       debugPrint("❌ Update failed: ${response.statusCode} ${response.data}");
  //     }
  //   } catch (e) {
  //     debugPrint("🔥 Error updating role: $e");
  //   }
  // }

  // Future<void> updateRole(String userId, String roleId) async {
  //   final url = '${ApiEndpoint().updateUserRole}/$userId/$roleId'; // 👈 RESTful route

  //   try {
  //     final response = await dio.put(
  //       url,
  //       options: Options(
  //         contentType: Headers.jsonContentType,
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       debugPrint("✅ Role updated successfully: ${response.data}");
  //       await fetchUserRoles(); // or any UI refresh logic
  //     } else {
  //       debugPrint("❌ Update failed: ${response.statusCode} ${response.data}");
  //     }
  //   } catch (e) {
  //     debugPrint("🔥 Error updating role: $e");
  //   }
  // }

  Future<void> updateRole(String userId, String roleId) async {
    final url =
        '${ApiEndpoint().updateUserRole}?userId=$userId&newRoleId=$roleId';

    try {
      final response = await dio.put(
        url,
        options: Options(contentType: Headers.jsonContentType),
      );

      if (response.statusCode == 200) {
        debugPrint("Role updated successfully: ${response.data}");
        await fetchUserRoles();
      } else {
        debugPrint(" Update failed: ${response.statusCode} ${response.data}");
      }
    } catch (e) {
      debugPrint(" Error updating role: $e");
    }
  }

  // Display Form-----
  Future<void> fetchRole() async {
    var url = ApiEndpoint().roles;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        debugPrint("Error: Access token is missing!");
        return;
      }

      final response = await dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && response.data is List) {
        List<Roles> data =
            (response.data as List)
                .map((roles) => Roles.fromJson(roles))
                .toList();

        if (mounted) {
          setState(() {
            roleList = data.map((roles) => roles.toJson()).toList();
            filteredListRole = List.from(
              roleList,
            ); // Ensure filtered list is populated

            if (_selectedRoleId == null && filteredListRole.isNotEmpty) {
              _selectedRoleId = filteredListRole[0]['id'].toString();
            }

            debugPrint("Auto-selected office: $_selectedRoleId");
          });
        }
      } else {
        debugPrint("Unexpected response format: ${response.data.runtimeType}");
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data ?? e.message}");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
  }

  // User Name ----------
  Future<void> fetchUser() async {
    var url = ApiEndpoint().users;
    try {
      final response = await dio.get(url);
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
              debugPrint("Auto-selected user: $_selectedUserId");
            }
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
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
            // Get matching user
            final user = userList.firstWhereOrNull(
              (u) => u.id == userRole.userId,
            );

            // Get matching role
            final role = rolenameList.firstWhereOrNull(
              (r) => r.id == userRole.roleId,
            );

            // If either user or role is not found, skip this item
            if (user == null || role == null) return false;

            final userFullName = user.fullName.toLowerCase();
            final roleName = role.name.toLowerCase();

            // Check if query matches either full name or role name
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
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(id == null ? 'Add User Role' : 'Edit User Role'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 350,
                child: DropdownButtonFormField<String>(
                  value:
                      filteredListUser.any((user) => user.id == _selectedUserId)
                          ? _selectedUserId
                          : null,
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      filteredListUser.map((user) {
                        return DropdownMenuItem<String>(
                          value: user.id,
                          child: Text(user.fullName),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedUserId = value;
                    });
                    debugPrint('Selected User ID: $_selectedUserId');
                  },
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 350,
                child: DropdownButtonFormField<String>(
                  value: _selectedRoleId,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      filteredListRole.map((roleData) {
                        return DropdownMenuItem<String>(
                          value: roleData['id'].toString(),
                          child: Text(roleData['name']),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedRoleId = value;
                    });
                  },
                ),
              ),
            ],
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

                // if (confirmAction == true) {
                //   if (selectedUserId == null || selectedOfficeId == null) {
                //     // ignore: use_build_context_synchronously
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(content: Text("User and role must both be selected.")),
                //     );
                //     return;
                //   }

                //   if (id == null) {
                //     // Add new role assignment
                //     final newUserRole = UserRoles(
                //       userId: selectedUserId,
                //       roleId: selectedOfficeId,
                //       // include other required fields if any
                //     );

                //     await addorUpdateUserRoles(newUserRole);
                //   } else {
                //     // Update existing role
                //     await updateRole(selectedUserId, selectedOfficeId);
                //   }

                //   Navigator.pop(context); // Close the dialog
                // }

                if (confirmAction == true) {
                  if (_selectedUserId == null || _selectedRoleId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("User and role must both be selected."),
                      ),
                    );
                    return;
                  }

                  if (id == null) {
                    // Add new role assignment
                    final newUserRole = UserRoles(
                      userId: _selectedUserId!,
                      roleId: _selectedRoleId!,
                    );

                    await addorUpdateUserRoles(newUserRole);
                  } else {
                    // Update existing role
                    await updateRole(_selectedUserId!, _selectedRoleId!);
                  }

                  Navigator.pop(context); // Close the dialog
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
                      labelText: 'Search User Name and Role',
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
                            filteredList.asMap().entries.map((entry) {
                              int index = entry.key;
                              UserRoles userRoles = entry.value;

                              // Get the matching role by roleId
                              final matchedRole = rolenameList.firstWhere(
                                (roles) => roles.id == userRoles.roleId,
                                orElse:
                                    () => Roles('unknown', 'Unknown', '', ''),
                              );
                              final String roleName = matchedRole.name;

                              // Get the matching user by userId
                              final matchUserName = userList.firstWhere(
                                (user) => user.id == userRoles.userId,
                                orElse:
                                    () => User(
                                      id: 'unknown',
                                      fullName: 'Unknown',
                                    ),
                              );
                              final String userName = matchUserName.fullName;

                              return Container(
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
                                      child: Text((index + 1).toString()),
                                    ),
                                    Expanded(flex: 3, child: Text(userName)),
                                    Expanded(flex: 2, child: Text(roleName)),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () {
                                              final selectedUser = userList
                                                  .firstWhere(
                                                    (user) =>
                                                        user.id ==
                                                        userRoles.userId,
                                                    orElse:
                                                        () => User(
                                                          id: 'unknown',
                                                          fullName: 'Unknown',
                                                        ),
                                                  );

                                              final selectedRoleId =
                                                  userRoles.roleId;
                                              final selectedUserId =
                                                  userRoles.userId;

                                              debugPrint(
                                                "Editing User: ${selectedUser.fullName} (ID: ${selectedUser.id})",
                                              );
                                              debugPrint(
                                                "Role ID: $selectedRoleId",
                                              );
                                              debugPrint(
                                                "User ID: $selectedUserId",
                                              );

                                              showFormDialog(
                                                id:
                                                    userRoles
                                                        .userId, // ✅ add this line
                                                selectedUserId:
                                                    userRoles.userId,
                                                selectedOfficeId:
                                                    userRoles.roleId,
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () async {
                                              // Delete logic here
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
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
