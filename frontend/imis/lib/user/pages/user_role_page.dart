// ignore_for_file: use_build_context_synchronously
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/roles/models/roles.dart';
import 'package:imis/user/models/user_role.dart';
import 'package:imis/user/services/user_role_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:collection/collection.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/widgets/common/button_filter.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:universal_html/html.dart' as html;

import '../../widgets/common/search_dropdown.dart';

class UserRolePage extends StatefulWidget {
  const UserRolePage({super.key});

  @override
  UserRolePageState createState() => UserRolePageState();
}

class UserRolePageState extends State<UserRolePage> {
  // final _formKey = GlobalKey<FormState>();
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
  String? _selectedRole;
  List<Office> roleListList = [];
  bool isLoadingOffices = false;
  bool isLoadingUsers = false;
  final TextEditingController searchController = TextEditingController();
  final FocusNode isSearchFocus = FocusNode();
  final dio = Dio();
  String? _filterUserId;
  @override
  void initState() {
    super.initState();
    fetchUserRoles();
    _fetchRolesAndUsers();
    isSearchfocus.addListener(() {
      setState(() {});
    });
  }

  Future<void> _fetchRolesAndUsers() async {
    final roles = await _userRoleService.fetchRoles();
    final users = await _commonService.fetchUsers();

    if (!mounted) return;

    setState(() {
      roleList = roles;
      userList = users;
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
    setState(() => _filterUserId = query.trim());
    filterUsersFromApi();
  }

  Future<void> filterUsersFromApi() async {
    setState(() => _isLoading = true);
    try {
      final searchQuery = _filterUserId ?? "";

      if (searchQuery.isEmpty && _selectedRole == null) {
        setState(() {
          filteredList = List.from(_allUserRoles);
        });
        return;
      }

      final response = await AuthenticatedRequest.get(
        dio,
        '${ApiEndpoint().usersFilter}?fullname=$searchQuery&roleId=${_selectedRole ?? ""}&page=1&pageSize=50',
      );

      if (response.statusCode == 200) {
        final List rawData =
            response.data is List
                ? response.data
                : (response.data["data"] ?? []);

        final List<String> returnedUserIds =
            rawData.map((e) => e['userId'].toString()).toList();

        setState(() {
          filteredList =
              _allUserRoles.where((ur) {
                return returnedUserIds.contains(ur.userId.toString());
              }).toList();
        });
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> exportFilteredPdf() async {
    try {
      final searchQuery = _filterUserId ?? "";
      final roleQuery = _selectedRole ?? "";

      final exportSize =
          (searchQuery.isEmpty && roleQuery.isEmpty)
              ? _totalCount
              : filteredList.length;

      final url =
          '${ApiEndpoint.baseUrl}/users-report/pdf?fullname=$searchQuery&roleId=$roleQuery&page=1&pageSize=$exportSize';

      final response = await AuthenticatedRequest.get(
        dio,
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        final bytes = response.data as List<int>;
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final _ =
            html.AnchorElement(href: url)
              ..setAttribute('download', 'user_roles_report.pdf')
              ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        MotionToast.error(
          toastAlignment: Alignment.topCenter,
          description: Text('Failed to export PDF'),
        ).show(context);
      }
    } catch (e) {
      MotionToast.error(
        toastAlignment: Alignment.topCenter,
        description: Text('Error exporting PDF: $e'),
      ).show(context);
    }
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

    final isEdit = id != null;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 480,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kSurface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 32,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.admin_panel_settings_outlined,
                              color: primaryColor,
                              size: 22,
                            ),
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEdit
                                    ? 'Manage User Role'
                                    : 'Create User Role',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: kText,
                                ),
                              ),
                              Text(
                                isEdit
                                    ? 'Update roles assigned to this user'
                                    : 'Assign roles to a user',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: kMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Divider(color: kBorder, height: 1),
                      const SizedBox(height: 20),

                      SearchDropdown<User?>(
                        label: 'User',
                        hintText: 'Search User Name...',
                        items: userList,
                        itemAsString: (u) => u?.fullName ?? '',
                        selectedItem: userList.cast<User?>().firstWhere(
                          (u) => u?.id == _selectedUserId,
                          orElse: () => null,
                        ),
                        onChanged:
                            (value) => setStateDialog(
                              () => _selectedUserId = value?.id,
                            ),
                        validator:
                            (value) =>
                                value == null ? 'Please select a user' : null,
                      ),

                      SizedBox(height: 20),

                      if (isEdit) ...[
                        Text(
                          'Current Roles',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: kMuted,
                          ),
                        ),
                        SizedBox(height: 8),
                      ],

                      ...currentRoles.map(
                        (roleName) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: kBackground,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: kBorder),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(6),
                                      onTap: () async {
                                        final role = roleList.firstWhere(
                                          (r) =>
                                              r.name.toLowerCase() ==
                                              roleName.toLowerCase(),
                                        );

                                        final roleId = role.id;

                                        final permissions =
                                            await _userRoleService
                                                .fetchPermissions(
                                                  _selectedUserId!,
                                                  roleId,
                                                );

                                        if (permissions != null) {
                                          _showPermissionsDialog(
                                            _selectedUserId!,
                                            roleId,
                                            permissions,
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(
                                          Icons.edit_outlined,
                                          size: 18,
                                          color: kMuted,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      roleName,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        color: kText,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(6),
                                  onTap: () {
                                    setStateDialog(
                                      () => currentRoles.remove(roleName),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 18,
                                      color: kMuted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
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
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    width: 380,
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: kSurface,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.12,
                                          ),
                                          blurRadius: 32,
                                          offset: Offset(0, 12),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Select Role',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            color: kText,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Divider(color: kBorder, height: 1),
                                        SizedBox(height: 8),
                                        SizedBox(
                                          height: 300,
                                          child:
                                              availableRoles.isEmpty
                                                  ? Center(
                                                    child: Text(
                                                      'No more roles available',
                                                      style:
                                                          GoogleFonts.plusJakartaSans(
                                                            fontSize: 13,
                                                            color: kMuted,
                                                          ),
                                                    ),
                                                  )
                                                  : ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        availableRoles.length,
                                                    itemBuilder: (
                                                      context,
                                                      index,
                                                    ) {
                                                      final role =
                                                          availableRoles[index];
                                                      return ListTile(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        title: Text(
                                                          role.name,
                                                          style:
                                                              GoogleFonts.plusJakartaSans(
                                                                fontSize: 13,
                                                                color: kText,
                                                              ),
                                                        ),
                                                        trailing: IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .add_circle_outline,
                                                            color: primaryColor,
                                                          ),
                                                          onPressed: () {
                                                            setStateDialog(
                                                              () => currentRoles
                                                                  .add(
                                                                    role.name,
                                                                  ),
                                                            );
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                        ),
                                        SizedBox(height: 8),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: Text(
                                              'Close',
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.add, size: 18, color: primaryColor),
                          label: Text(
                            'Add roles',
                            style: GoogleFonts.plusJakartaSans(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: kBorder),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: kBorder),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.plusJakartaSans(
                                  color: kMuted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                if (!formKey.currentState!.validate()) return;

                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (ctx) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                          width: 340,
                                          padding: EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color: kSurface,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.12,
                                                ),
                                                blurRadius: 32,
                                                offset: Offset(0, 12),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 48,
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  color: primaryColor
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: Icon(
                                                  Icons.help_outline_rounded,
                                                  color: primaryColor,
                                                  size: 26,
                                                ),
                                              ),
                                              SizedBox(height: 14),
                                              Text(
                                                isEdit
                                                    ? 'Confirm Update'
                                                    : 'Confirm Save',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16,
                                                      color: kText,
                                                    ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                isEdit
                                                    ? 'Are you sure you want to update this user role?'
                                                    : 'Are you sure you want to save this user role?',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 13,
                                                      color: kMuted,
                                                      height: 1.5,
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: 16),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            ctx,
                                                            false,
                                                          ),
                                                      style:
                                                          OutlinedButton.styleFrom(
                                                            side: BorderSide(
                                                              color: kBorder,
                                                            ),
                                                          ),
                                                      child: Text(
                                                        'No',
                                                        style:
                                                            GoogleFonts.plusJakartaSans(
                                                              color: kMuted,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            ctx,
                                                            true,
                                                          ),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            primaryColor,
                                                        elevation: 0,
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 11,
                                                            ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Yes',
                                                        style:
                                                            GoogleFonts.plusJakartaSans(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                );

                                if (confirmed != true) return;
                                if (_selectedUserId == null) return;

                                final assignedRoles =
                                    currentRoles.map((roleName) {
                                      final role = roleList.firstWhere(
                                        (r) =>
                                            r.name.toLowerCase() ==
                                            roleName.toLowerCase(),
                                        orElse:
                                            () => Roles(
                                              'unknown',
                                              'Unknown',
                                              '',
                                              '',
                                            ),
                                      );
                                      return RoleAssignment(roleId: role.id);
                                    }).toList();

                                final newUserRole = UserRoles(
                                  _selectedUserId!,
                                  assignedRoles,
                                );

                                if (id == null) {
                                  await _userRoleService.addUserRoles(
                                    newUserRole,
                                  );
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
                                await fetchUserRoles(page: _currentPage);
                                Navigator.pop(context);
                              },
                              child: Text(
                                isEdit ? 'Update' : 'Save',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,

                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
      builder:
          (ctx) => DeleteDialog(
            title: 'User Role',
            itemName: 'user role',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _userRoleService.deleteUserRole(id);
                await fetchUserRoles();
                if (mounted) {
                  MotionToast.success(
                    description: Text(
                      'User Role deleted successfully',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  );
                }
              } catch (_) {
                MotionToast.error(
                  description: Text('Faled to delete user role'),
                ).show(context);
              }
            },
          ),
    );
  }

  void _showPermissionsDialog(
    String userId,
    String roleId,
    List<dynamic> permissions,
  ) {
    String searchQuery = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            bool allChecked = permissions.every((p) => p['isAssigned'] == true);

            final filteredPermissions =
                searchQuery.isEmpty
                    ? permissions
                    : permissions
                        .where(
                          (p) => p['permission']
                              .toString()
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()),
                        )
                        .toList();

            return AlertDialog(
              backgroundColor: mainBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Permissions',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              content: SizedBox(
                width: 700,
                height: 550,
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        setDialogState(() => searchQuery = value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search permissions',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: kMuted,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 20,
                          color: kMuted,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                    gap12px,
                    CheckboxListTile(
                      title: Text(
                        allChecked ? "Uncheck All" : "Check All",
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      value: allChecked,
                      onChanged: (value) async {
                        setDialogState(() {
                          for (var item in permissions) {
                            item['isAssigned'] = value;
                          }
                        });

                        await _userRoleService.updatePermission(
                          userId,
                          '',
                          roleId,
                          permissions,
                        );
                      },
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return primaryColor;
                        }
                        return Colors.transparent;
                      }),
                    ),
                    gap16px,
                    Divider(),
                    Expanded(
                      child:
                          filteredPermissions.isNotEmpty
                              ? ListView.builder(
                                itemCount: filteredPermissions.length,
                                itemBuilder: (context, index) {
                                  final item = filteredPermissions[index];
                                  return CheckboxListTile(
                                    title: Text(
                                      item['permission'],
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                      ),
                                    ),
                                    value: item['isAssigned'],
                                    onChanged: (value) async {
                                      setDialogState(() {
                                        item['isAssigned'] = value;
                                      });

                                      await _userRoleService.updatePermission(
                                        userId,
                                        '',
                                        roleId,
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
            );
          },
        );
      },
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
              "User Role Information",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            gap16px,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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

                    const SizedBox(width: 10),
                    SizedBox(
                      height: 36,
                      width: 200,
                      child: GestureDetector(
                        onTap: () async {
                          await _commonService.loadData<Roles>(
                            list: roleList,
                            fetchFunction: _commonService.fetchRoles,
                            setLoading:
                                (value) =>
                                    setState(() => isLoadingOffices = value),
                            setList: (data) => setState(() => roleList = data),
                          );
                        },
                        child: SearchableDropdown(
                          items:
                              isLoadingOffices
                                  ? ["Loading roles..."]
                                  : [
                                    "All Roles",
                                    ...roleList.map((o) => o.name),
                                  ],
                          selectedItem:
                              _selectedRole == null
                                  ? "All Roles"
                                  : roleList
                                      .firstWhere(
                                        (o) => o.id.toString() == _selectedRole,
                                      )
                                      .name,
                          hintText: "Roles",
                          searchHint: "Search Roles...",
                          onChanged: (value) async {
                            setState(() {
                              _selectedRole =
                                  value == "All Roles"
                                      ? null
                                      : roleList
                                          .firstWhere((o) => o.name == value)
                                          .id
                                          .toString();
                            });
                            await filterUsersFromApi();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                // if (!isMobile)
                //   ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: primaryColor,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(4),
                //       ),
                //     ),
                //     onPressed: () => showFormDialog(),
                //     child: const Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Icon(Icons.add, color: Colors.white),
                //         SizedBox(width: 5),
                //         Text('Add New', style: TextStyle(color: Colors.white)),
                //       ],
                //     ),
                //   ),
                if (!isMobile)
                  Row(
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey.shade400),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: exportFilteredPdf,
                        icon: Icon(
                          Icons.picture_as_pdf,
                          color: Colors.grey.shade600,
                          size: 18,
                        ),
                        label: Text(
                          'Export PDF',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        onPressed: () => showFormDialog(),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              'Add New',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Name",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                "Roles",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Actions",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: ListView.separated(
                        itemCount:
                            userList
                                .where(
                                  (user) => filteredList.any(
                                    (ur) => ur.userId == user.id,
                                  ),
                                )
                                .length,
                        separatorBuilder:
                            (context, index) => Divider(
                              height: 1,
                              color: Colors.grey.withValues(alpha: 0.2),
                            ),
                        itemBuilder: (context, index) {
                          final filteredUsers =
                              userList
                                  .where(
                                    (user) => filteredList.any(
                                      (ur) => ur.userId == user.id,
                                    ),
                                  )
                                  .toList();

                          final user = filteredUsers[index];

                          final userRolesForUser =
                              filteredList
                                  .where((ur) => ur.userId == user.id)
                                  .toList();

                          final roleChips =
                              userRolesForUser
                                  .expand((userRole) => userRole.roles ?? [])
                                  .map((assignedRole) {
                                    final matchedRole = roleList.firstWhere(
                                      (r) => r.id == assignedRole.roleId,
                                      orElse:
                                          () => Roles(
                                            'unknown',
                                            'Unknown',
                                            '',
                                            null,
                                          ),
                                    );
                                    return matchedRole.name;
                                  })
                                  .toList();

                          final initials =
                              user.fullName.trim().isNotEmpty
                                  ? user.fullName
                                      .trim()
                                      .split(' ')
                                      .map((e) => e[0])
                                      .take(2)
                                      .join()
                                      .toUpperCase()
                                  : '?';

                          final itemNumber =
                              ((_currentPage - 1) * _pageSize) + index + 1;

                          Widget buildRoleChips() => Wrap(
                            spacing: 5,
                            runSpacing: 4,
                            children:
                                roleChips.map((roleName) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withValues(
                                        alpha: 0.07,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      roleName,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: primaryColor,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          );

                          if (!isMobile) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 4,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(flex: 1, child: Text("$itemNumber")),

                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
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
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            user.fullName,

                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Expanded(flex: 4, child: buildRoleChips()),

                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit_outlined,
                                            size: 16,
                                          ),
                                          onPressed:
                                              () => showFormDialog(
                                                id: user.id,
                                                selectedUserId: user.id,
                                              ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            CupertinoIcons.delete_simple,
                                            color: Colors.redAccent,
                                            size: 16,
                                          ),
                                          onPressed:
                                              () => showDeleteDialog(user.id),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          // Mobile layout
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 4,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Avatar
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: primaryColor.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      initials,
                                      style: TextStyle(
                                        fontSize: 13,
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
                                        user.fullName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      buildRoleChips(),
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
                                    if (value == 'edit') {
                                      showFormDialog(
                                        id: user.id,
                                        selectedUserId: user.id,
                                      );
                                    }
                                    if (value == 'delete') {
                                      showDeleteDialog(user.id.toString());
                                    }
                                  },
                                  itemBuilder:
                                      (_) => [
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
                                                CupertinoIcons.delete_simple,
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
                            onPageChanged: (page) => fetchUserRoles(page: page),
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
              ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton.small(
                    heroTag: 'export',
                    backgroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                    onPressed: exportFilteredPdf,
                    child: Icon(
                      Icons.picture_as_pdf,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    heroTag: 'add',
                    backgroundColor: primaryColor,
                    onPressed: () => showFormDialog(),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              )
              : null,
    );
  }
}
