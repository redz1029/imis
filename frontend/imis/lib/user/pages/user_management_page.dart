// ignore_for_file: use_build_context_synchronously
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/utils/string_extension.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';

import 'package:imis/constant/constant.dart';
import 'package:imis/user/models/pending_approval_user.dart';
import 'package:imis/user/services/user_lockout_service.dart';
import 'package:imis/widgets/common/pagination_controls.dart';

import 'package:imis/user/models/user_registration.dart';
import 'package:imis/user/services/users_profile_service.dart';
import 'package:imis/widgets/common/search_dropdown.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage>
    with SingleTickerProviderStateMixin {
  final _lockoutService = UserLockoutService(Dio());
  final _userProfileService = UsersProfileService(Dio());

  late TabController _tabController;

  List<PendingApprovalUser> _activeList = [];
  List<PendingApprovalUser> _filteredActiveList = [];
  int _activePage = 1;
  int _activeTotal = 0;
  bool _activeLoading = false;
  final TextEditingController _activeSearchCtrl = TextEditingController();

  List<PendingApprovalUser> _pendingList = [];
  List<PendingApprovalUser> _filteredPendingList = [];
  int _pendingPage = 1;
  int _pendingTotal = 0;
  bool _pendingLoading = false;
  final TextEditingController _pendingSearchCtrl = TextEditingController();

  final int _pageSize = 15;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController prefixController = TextEditingController();
  final TextEditingController suffixController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController positionController = TextEditingController();

  final FocusNode focusNewPassword = FocusNode();
  bool _isNewPassVisible = false;
  String? selectedPosition;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchActive();
    _fetchPending();
    focusNewPassword.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _activeSearchCtrl.dispose();
    _pendingSearchCtrl.dispose();
    focusNewPassword.dispose();
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    userNameController.dispose();
    prefixController.dispose();
    suffixController.dispose();
    passwordController.dispose();
    positionController.dispose();
    super.dispose();
  }

  Future<void> _fetchActive({int? page}) async {
    if (_activeLoading) return;
    setState(() => _activeLoading = true);
    final targetPage = page ?? _activePage;
    try {
      final result = await _lockoutService.getActiveUsers(
        page: targetPage,
        pageSize: _pageSize,
      );
      if (!mounted) return;
      setState(() {
        _activePage = result.page;
        _activeTotal = result.totalCount;
        _activeList =
            result.items
                .where((u) => !u.lockoutEnabled && !u.isPendingApproval)
                .toList();
        _filteredActiveList = List.from(_activeList);
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) setState(() => _activeLoading = false);
    }
  }

  Future<void> _fetchPending({int? page}) async {
    if (_pendingLoading) return;
    setState(() => _pendingLoading = true);
    final targetPage = page ?? _pendingPage;
    try {
      final result = await _lockoutService.getPendingApprovalUsers(
        page: targetPage,
        pageSize: _pageSize,
      );
      if (!mounted) return;
      setState(() {
        _pendingPage = result.page;
        _pendingTotal = result.totalCount;
        _pendingList = result.items;
        _filteredPendingList = List.from(_pendingList);
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) setState(() => _pendingLoading = false);
    }
  }

  void _filterActive(String query) {
    if (query.isEmpty) {
      setState(() => _filteredActiveList = List.from(_activeList));
      return;
    }
    final q = query.toLowerCase();
    setState(() {
      _filteredActiveList =
          _activeList
              .where(
                (u) =>
                    u.fullName.toLowerCase().contains(q) ||
                    u.userName.toLowerCase().contains(q) ||
                    u.position.toLowerCase().contains(q),
              )
              .toList();
    });
  }

  void _filterPending(String query) {
    if (query.isEmpty) {
      setState(() => _filteredPendingList = List.from(_pendingList));
      return;
    }
    final q = query.toLowerCase();
    setState(() {
      _filteredPendingList =
          _pendingList
              .where(
                (u) =>
                    u.fullName.toLowerCase().contains(q) ||
                    u.userName.toLowerCase().contains(q) ||
                    u.position.toLowerCase().contains(q),
              )
              .toList();
    });
  }

  Future<void> _refreshLists() async {
    await _fetchActive();
    await _fetchPending();
  }

  // ---------------------------------------------------------------------
  // Lock / Unlock (unchanged logic from the original page)
  // ---------------------------------------------------------------------

  Future<void> _confirmUnlock(PendingApprovalUser user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => _ConfirmDialog(
            icon: Icons.lock_open_outlined,
            iconColor: primaryColor,
            title: 'Unlock Account',
            message:
                'Are you sure you want to unlock ${user.fullName.isNotEmpty ? user.fullName : user.userName}\'s account?',
            confirmLabel: 'Unlock',
            confirmColor: primaryColor,
          ),
    );
    if (confirmed != true) return;

    try {
      await _lockoutService.unlockUser(user.id);
      if (mounted) {
        MotionToast.success(
          toastAlignment: Alignment.topCenter,
          description: const Text('Account unlocked successfully'),
        ).show(context);
      }
      await _refreshLists();
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        MotionToast.error(
          toastAlignment: Alignment.topCenter,
          description: const Text('Failed to unlock account'),
        ).show(context);
      }
    }
  }

  Future<void> _showLockDialog(PendingApprovalUser user) async {
    String selectedOption = '1 day';
    DateTime customDate = DateTime.now().add(const Duration(days: 1));

    final options = <String>[
      '1 day',
      '3 days',
      '7 days',
      '30 days',
      'Permanent',
      'Custom',
    ];

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 380,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kSurface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
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
                            color: kDanger.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.lock_outline,
                            color: kDanger,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Lock Account',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: kText,
                                ),
                              ),
                              Text(
                                user.fullName.isNotEmpty
                                    ? user.fullName
                                    : user.userName,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: kMuted,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'LOCK DURATION',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          options.map((option) {
                            final isSelected = selectedOption == option;
                            return ChoiceChip(
                              label: Text(
                                option,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? Colors.white : kText,
                                ),
                              ),
                              selected: isSelected,
                              onSelected:
                                  (_) => setDialogState(
                                    () => selectedOption = option,
                                  ),
                              selectedColor: primaryColor,
                              backgroundColor: kBackground,
                              side: BorderSide(color: kBorder),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            );
                          }).toList(),
                    ),
                    if (selectedOption == 'Custom') ...[
                      const SizedBox(height: 14),
                      InkWell(
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: dialogContext,
                            initialDate: customDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 3650),
                            ),
                          );
                          if (pickedDate == null) return;
                          final pickedTime = await showTimePicker(
                            context: dialogContext,
                            initialTime: TimeOfDay.fromDateTime(customDate),
                          );
                          if (pickedTime == null) return;
                          setDialogState(() {
                            customDate = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: kBackground,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: kBorder),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color: kMuted,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                DateFormat(
                                  'MMM d, y • h:mm a',
                                ).format(customDate),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: kText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: kBorder),
                              padding: const EdgeInsets.symmetric(vertical: 12),
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
                          child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.lock_outline,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Lock',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kDanger,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () async {
                              Navigator.pop(dialogContext);
                              await _applyLock(
                                user,
                                selectedOption,
                                customDate,
                              );
                            },
                          ),
                        ),
                      ],
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

  Future<void> _applyLock(
    PendingApprovalUser user,
    String option,
    DateTime customDate,
  ) async {
    try {
      if (option == 'Permanent') {
        await _lockoutService.lockUser(user.id, permanent: true);
      } else {
        DateTime end;
        switch (option) {
          case '1 day':
            end = DateTime.now().toUtc().add(const Duration(days: 1));
            break;
          case '3 days':
            end = DateTime.now().toUtc().add(const Duration(days: 3));
            break;
          case '7 days':
            end = DateTime.now().toUtc().add(const Duration(days: 7));
            break;
          case '30 days':
            end = DateTime.now().toUtc().add(const Duration(days: 30));
            break;
          default:
            end = customDate.toUtc();
        }
        await _lockoutService.lockUser(user.id, lockoutEnd: end);
      }
      if (mounted) {
        MotionToast.success(
          toastAlignment: Alignment.topCenter,
          description: const Text('Account locked successfully'),
        ).show(context);
      }
      await _refreshLists();
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        MotionToast.error(
          toastAlignment: Alignment.topCenter,
          description: const Text('Failed to lock account'),
        ).show(context);
      }
    }
  }

  // ---------------------------------------------------------------------
  // Edit / Create / Change Password  (merged in from UserProfilePage)
  // ---------------------------------------------------------------------

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

  /// The lockout list (PendingApprovalUser) doesn't carry every field the
  /// edit/change-password forms need (email, names, prefix, etc.), so we
  /// look the full record up by username before opening those dialogs.
  Future<UserRegistration?> _fetchFullProfileByUsername(String userName) async {
    try {
      final result = await _userProfileService.getUsers(
        page: 1,
        pageSize: 10,
        searchQuery: userName,
      );
      for (final u in result.items) {
        if (u.userName == userName) return u;
      }
      return result.items.isNotEmpty ? result.items.first : null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> _openEdit(PendingApprovalUser user) async {
    final full = await _fetchFullProfileByUsername(user.userName);
    if (full == null) {
      if (mounted) {
        MotionToast.error(
          toastAlignment: Alignment.topCenter,
          description: const Text('Could not load user profile'),
        ).show(context);
      }
      return;
    }
    showFormDialog(
      id: full.id?.toString(),
      userName: full.userName,
      email: full.email,
      password: full.password,
      firstName: full.firstName,
      middleName: full.middleName,
      lastName: full.lastName,
      prefix: full.prefix,
      suffix: full.suffix,
      position: full.position,
    );
  }

  Future<void> _openChangePassword(PendingApprovalUser user) async {
    final full = await _fetchFullProfileByUsername(user.userName);
    if (full == null) {
      if (mounted) {
        MotionToast.error(
          toastAlignment: Alignment.topCenter,
          description: const Text('Could not load user profile'),
        ).show(context);
      }
      return;
    }
    showFormDialogChangePassword(
      id: full.id?.toString(),
      userName: full.userName,
      email: full.email,
      password: full.password,
      firstName: full.firstName,
      middleName: full.middleName,
      lastName: full.lastName,
      prefix: full.prefix,
      suffix: full.suffix,
      position: full.position,
      isEditingpassword: true,
    );
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
    passwordController.text = '';
    firstNameController.text = firstName ?? '';
    middleNameController.text = middleName ?? '';
    lastNameController.text = lastName ?? '';
    prefixController.text = prefix ?? '';
    suffixController.text = suffix ?? '';
    positionController.text = position ?? '';
    selectedPosition =
        JobPositions.positions.contains(position) ? position : null;
    final formKey = GlobalKey<FormState>();

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
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.security_outlined,
                              color: primaryColor,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Change Password',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: kText,
                                ),
                              ),
                              Text(
                                userName ?? '',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: kMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: kBorder, height: 1),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionLabel('Security'),
                              const SizedBox(height: 12),
                              _passwordField(setDialogState),
                              const SizedBox(height: 8),
                              _passwordHints(),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(height: 1, color: Colors.grey.shade200),
                    Padding(
                      padding: const EdgeInsets.symmetric(
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            icon: Icon(
                              id == null ? Icons.save_outlined : Icons.update,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: Text(
                              id == null ? 'Save' : 'Update',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () async {
                              if (!formKey.currentState!.validate()) return;

                              final confirmAction = await showDialog<bool>(
                                context: dialogContext,
                                builder:
                                    (confirmContext) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      title: Row(
                                        children: [
                                          Icon(
                                            Icons.help_outline,
                                            color: primaryColor,
                                          ),
                                          const SizedBox(width: 8),
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
                                          child: const Text(
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
                                          child: const Text(
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
                                null,
                              );

                              try {
                                await _userProfileService.updateUser(
                                  userProfile,
                                );
                                if (mounted) {
                                  MotionToast.success(
                                    toastAlignment: Alignment.topCenter,
                                    description: const Text(
                                      'Password updated successfully',
                                    ),
                                  ).show(dialogContext);
                                }
                                await _refreshLists();
                              } catch (e) {
                                debugPrint(e.toString());
                                if (mounted) {
                                  MotionToast.error(
                                    toastAlignment: Alignment.topCenter,
                                    description: const Text(
                                      'Failed to update password',
                                    ),
                                  ).show(dialogContext);
                                }
                              }
                              Navigator.pop(dialogContext);
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
    bool isLock = false,
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

    final isEdit = id != null;
    final formKey = GlobalKey<FormState>();

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
                  color: kSurface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isEdit
                                  ? Icons.edit_outlined
                                  : Icons.person_add_alt_1_outlined,
                              color: primaryColor,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEdit ? 'Edit User' : 'Create User',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: kText,
                                ),
                              ),
                              Text(
                                isEdit
                                    ? 'Update user account details'
                                    : 'Add a new user account',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: kMuted,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(Icons.close, color: kMuted, size: 20),
                            onPressed: () => Navigator.pop(dialogContext),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            splashRadius: 18,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: kBorder, height: 1),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionLabel('Personal Information'),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: SearchDropdown<String>(
                                      hintText: 'Select prefix',
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
                                      itemAsString: (e) => e,
                                      selectedItem:
                                          prefixController.text.isNotEmpty
                                              ? prefixController.text
                                              : null,
                                      onChanged: (v) {
                                        setDialogState(
                                          () => prefixController.text = v ?? '',
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 2,
                                    child: _styledField(
                                      controller: suffixController,
                                      label: 'Suffix',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _styledField(
                                      controller: firstNameController,
                                      label: 'First Name',
                                      required: true,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _styledField(
                                      controller: middleNameController,
                                      label: 'Middle Initial',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _styledField(
                                controller: lastNameController,
                                label: 'Last Name',
                                required: true,
                              ),
                              const SizedBox(height: 20),
                              _sectionLabel('Account Information'),
                              const SizedBox(height: 12),
                              _styledField(
                                controller: userNameController,
                                label: 'Username',
                                prefixIcon: Icons.person_outline,
                                required: true,
                              ),
                              const SizedBox(height: 12),
                              _styledField(
                                controller: emailController,
                                label: 'Email',
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 12),
                              _sectionLabel('Position'),
                              const SizedBox(height: 8),
                              _positionComboBox(setDialogState),
                              const SizedBox(height: 20),
                              if (!isEdit) ...[
                                _sectionLabel('Security'),
                                const SizedBox(height: 12),
                                _passwordField(setDialogState),
                                const SizedBox(height: 8),
                                _passwordHints(),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(height: 1, color: kBorder),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: kBorder),
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
                            child: ElevatedButton.icon(
                              icon: Icon(
                                isEdit ? Icons.update : Icons.save_outlined,
                                size: 18,
                                color: Colors.white,
                              ),
                              label: Text(
                                isEdit ? 'Update' : 'Save',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () async {
                                if (!formKey.currentState!.validate()) return;

                                final confirmed = await showDialog<bool>(
                                  context: dialogContext,
                                  builder:
                                      (confirmContext) => _ConfirmDialog(
                                        icon: Icons.help_outline_rounded,
                                        iconColor: primaryColor,
                                        title:
                                            isEdit
                                                ? 'Confirm Update'
                                                : 'Confirm Save',
                                        message:
                                            isEdit
                                                ? 'Are you sure you want to update this record?'
                                                : 'Are you sure you want to save this record?',
                                        confirmLabel: 'Yes',
                                        confirmColor: primaryColor,
                                      ),
                                );
                                if (confirmed != true) return;

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
                                  null,
                                );

                                try {
                                  if (id == null) {
                                    await _userProfileService.createUser(
                                      userProfile,
                                    );
                                    MotionToast.success(
                                      toastAlignment: Alignment.topCenter,
                                      description: const Text(
                                        'Saved successfully',
                                      ),
                                    ).show(dialogContext);
                                  } else {
                                    await _userProfileService.updateUser(
                                      userProfile,
                                    );
                                    MotionToast.success(
                                      toastAlignment: Alignment.topCenter,
                                      description: const Text(
                                        'Updated successfully',
                                      ),
                                    ).show(dialogContext);
                                  }
                                  await _refreshLists();
                                } catch (e) {
                                  debugPrint(e.toString());
                                  MotionToast.error(
                                    toastAlignment: Alignment.topCenter,
                                    description: Text(
                                      id == null
                                          ? 'Failed to save user'
                                          : 'Failed to update user',
                                    ),
                                  ).show(dialogContext);
                                }
                                Navigator.pop(dialogContext);
                              },
                            ),
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

  Future<void> _showDeleteDialog(PendingApprovalUser user) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'User',
            itemName: 'user',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _userProfileService.deleteUser(user.id.toString());
                await _refreshLists();
                if (mounted) {
                  MotionToast.success(
                    description: const Text('User deleted successfully'),
                  ).show(context);
                }
              } catch (_) {
                if (mounted) {
                  MotionToast.error(
                    description: const Text('Failed to delete user'),
                  ).show(context);
                }
              }
            },
          ),
    );
  }

  // ---------------------------------------------------------------------
  // Small shared form widgets (from UserProfilePage)
  // ---------------------------------------------------------------------

  Widget _sectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: primaryColor,
        letterSpacing: 0.6,
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
      style: GoogleFonts.plusJakartaSans(fontSize: 13, color: kText),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: kMuted),
        floatingLabelStyle: GoogleFonts.plusJakartaSans(
          color: primaryColor,
          fontSize: 13,
        ),
        prefixIcon:
            prefixIcon != null
                ? Icon(prefixIcon, size: 18, color: kMuted)
                : null,
        filled: true,
        fillColor: kBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kDanger),
        ),
      ),
      validator:
          validator ??
          (required
              ? (v) =>
                  (v == null || v.isEmpty) ? 'This field is required' : null
              : null),
    );
  }

  Widget _positionComboBox(StateSetter setDialogState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Autocomplete<String>(
          initialValue: TextEditingValue(text: positionController.text),
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) return JobPositions.positions;
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
            textController.text = positionController.text;
            textController.addListener(() {
              positionController.text = textController.text;
            });
            return TextFormField(
              controller: textController,
              focusNode: focusNode,
              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: kText),
              decoration: InputDecoration(
                hintText: 'Select or type a position...',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: kMuted,
                ),
                prefixIcon: Icon(Icons.work_outline, size: 18, color: kMuted),
                suffixIcon: Icon(Icons.arrow_drop_down, color: kMuted),
                filled: true,
                fillColor: kBackground,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: kBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: kBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: primaryColor, width: 1.5),
                ),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: kSurface,
                elevation: 6,
                borderRadius: BorderRadius.circular(8),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                    maxWidth: 472,
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
                          child: Row(
                            children: [
                              Icon(Icons.work_outline, size: 15, color: kMuted),
                              const SizedBox(width: 8),
                              Text(
                                option,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: kText,
                                ),
                              ),
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
        const SizedBox(height: 4),
        Text(
          'Choose from the list or type a custom position',
          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: kMuted),
        ),
      ],
    );
  }

  Widget _passwordField(StateSetter setDialogState) {
    return TextFormField(
      focusNode: focusNewPassword,
      controller: passwordController,
      obscureText: !_isNewPassVisible,
      style: GoogleFonts.plusJakartaSans(fontSize: 13, color: kText),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: kMuted),
        floatingLabelStyle: GoogleFonts.plusJakartaSans(
          color: primaryColor,
          fontSize: 13,
        ),
        prefixIcon: Icon(Icons.lock_outline, size: 18, color: kMuted),
        filled: true,
        fillColor: kBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kDanger),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isNewPassVisible ? Icons.visibility_off : Icons.visibility,
            size: 18,
            color: focusNewPassword.hasFocus ? primaryColor : kMuted,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primaryColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password must contain:',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          ...[
            'At least 6 characters',
            'One uppercase letter',
            'One special character (!@#\$%^&*)',
          ].map(
            (hint) => Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 5, color: primaryColor),
                  const SizedBox(width: 6),
                  Text(
                    hint,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: kMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Avatar / status helpers (unchanged)
  // ---------------------------------------------------------------------

  Widget _avatar(PendingApprovalUser user, {double size = 40}) {
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
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: size * 0.32,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _statusIndicator(Color color, IconData icon, String label) {
    return Tooltip(
      message: label,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, size: 10, color: Colors.white),
          ),
          Flexible(
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.info_outline, size: 13, color: color),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.shield_outlined,
                  color: primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'User Management',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1D23),
                      ),
                    ),
                    Text(
                      '${_activeTotal + _pendingTotal} account${(_activeTotal + _pendingTotal) != 1 ? 's' : ''} found',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
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
                icon: const Icon(Icons.add, color: Colors.white, size: 16),
                label: const Text(
                  'Add New',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEFF2)),
          TabBar(
            controller: _tabController,
            indicatorColor: primaryColor,
            indicatorWeight: 3,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey.shade600,
            labelStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.hourglass_top_rounded, size: 16),
                    const SizedBox(width: 6),
                    const Text('Pending'),
                    const SizedBox(width: 6),
                    _countChip(_pendingTotal, Colors.orange.shade600),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people_alt_outlined, size: 16),
                    const SizedBox(width: 6),
                    const Text('Active'),
                    const SizedBox(width: 6),
                    _countChip(_activeTotal, Colors.green.shade600),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _countChip(int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabBody(
                  isMobile: isMobile,
                  searchCtrl: _pendingSearchCtrl,
                  onSearch: _filterPending,
                  loading: _pendingLoading,
                  list: _filteredPendingList,
                  emptyTitle: 'No pending or locked accounts',
                  emptySubtitle: 'Everything looks clear right now',
                  emptyIcon: Icons.verified_user_outlined,
                  accentFor:
                      (u) =>
                          u.isPendingApproval
                              ? Colors.orange.shade600
                              : kDanger,
                  statusIconFor:
                      (u) =>
                          u.isPendingApproval ? Icons.access_time : Icons.lock,
                  statusLabelFor:
                      (u) =>
                          u.isPendingApproval
                              ? 'Pending'
                              : (u.isPermanentlyLocked
                                  ? 'Locked (Permanent)'
                                  : 'Locked until ${DateFormat('MMM d, y h:mm a').format(u.lockoutEnd!.toLocal())}'),
                  actionsBuilder:
                      (user) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ActionIconButton(
                            tooltip: 'Unlock',
                            icon: Icons.lock_open_rounded,
                            color: Colors.green.shade600,
                            onPressed: () => _confirmUnlock(user),
                          ),
                          const SizedBox(width: 14),
                          _ActionIconButton(
                            tooltip: 'Lock',
                            icon: Icons.lock_rounded,
                            color: kDanger,
                            onPressed: () => _showLockDialog(user),
                          ),
                          const SizedBox(width: 14),
                          _ActionIconButton(
                            tooltip: 'Edit',
                            icon: Icons.edit_outlined,
                            color: kMuted,
                            onPressed: () => _openEdit(user),
                          ),
                          const SizedBox(width: 14),
                          _ActionIconButton(
                            tooltip: 'Change Password',
                            icon: Icons.security_outlined,
                            color: Colors.blueAccent,
                            onPressed: () => _openChangePassword(user),
                          ),
                          const SizedBox(width: 14),
                          _ActionIconButton(
                            tooltip: 'Delete',
                            icon: CupertinoIcons.delete_simple,
                            color: Colors.red,
                            onPressed: () => _showDeleteDialog(user),
                          ),
                        ],
                      ),
                  currentPage: _pendingPage,
                  totalCount: _pendingTotal,
                  onPageChanged: (page) => _fetchPending(page: page),
                ),
                _buildTabBody(
                  isMobile: isMobile,
                  searchCtrl: _activeSearchCtrl,
                  onSearch: _filterActive,
                  loading: _activeLoading,
                  list: _filteredActiveList,
                  emptyTitle: 'No active users',
                  emptySubtitle: 'All accounts are locked or pending',
                  emptyIcon: Icons.person_off_outlined,
                  accentFor: (_) => Colors.green.shade600,
                  statusIconFor: (_) => Icons.check,
                  statusLabelFor: (_) => 'Active',
                  actionsBuilder:
                      (user) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ActionIconButton(
                            tooltip: 'Lock',
                            icon: Icons.lock_rounded,
                            color: kDanger,
                            onPressed: () => _showLockDialog(user),
                          ),
                          const SizedBox(width: 14),
                          _ActionIconButton(
                            tooltip: 'Edit',
                            icon: Icons.edit_outlined,
                            color: kMuted,
                            onPressed: () => _openEdit(user),
                          ),
                          const SizedBox(width: 14),
                          _ActionIconButton(
                            tooltip: 'Change Password',
                            icon: Icons.security_outlined,
                            color: Colors.blueAccent,
                            onPressed: () => _openChangePassword(user),
                          ),
                          const SizedBox(width: 14),
                          _ActionIconButton(
                            tooltip: 'Delete',
                            icon: CupertinoIcons.delete_simple,
                            color: Colors.red,
                            onPressed: () => _showDeleteDialog(user),
                          ),
                        ],
                      ),
                  currentPage: _activePage,
                  totalCount: _activeTotal,
                  onPageChanged: (page) => _fetchActive(page: page),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBody({
    required bool isMobile,
    required TextEditingController searchCtrl,
    required ValueChanged<String> onSearch,
    required bool loading,
    required List<PendingApprovalUser> list,
    required String emptyTitle,
    required String emptySubtitle,
    required IconData emptyIcon,
    required Color Function(PendingApprovalUser) accentFor,
    required IconData Function(PendingApprovalUser) statusIconFor,
    required String Function(PendingApprovalUser) statusLabelFor,
    required Widget Function(PendingApprovalUser) actionsBuilder,
    required int currentPage,
    required int totalCount,
    required ValueChanged<int> onPageChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 36,
            width: 280,
            child: TextField(
              controller: searchCtrl,
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: 'Search name, username, position...',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: kMuted,
                ),
                prefixIcon: Icon(Icons.search, size: 18, color: kMuted),
                filled: true,
                fillColor: kSurface,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: kBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: kBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: kSurface,
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
                  if (!isMobile && list.isNotEmpty)
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
                              '#',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Account',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Position',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Status',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          // Wider now to fit the extra action icons (Edit / Change Password / Delete).
                          Expanded(
                            flex: 4,
                            child: Text(
                              'Actions',
                              textAlign: TextAlign.center,
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
                    child:
                        loading
                            ? Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                            : list.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    emptyIcon,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    emptyTitle,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: kText,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    emptySubtitle,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: kMuted,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ListView.separated(
                              itemCount: list.length,
                              separatorBuilder:
                                  (_, __) => Divider(
                                    height: 1,
                                    color: Colors.grey.withValues(alpha: 0.2),
                                  ),
                              itemBuilder: (context, index) {
                                final user = list[index];
                                final accent = accentFor(user);
                                final itemNumber =
                                    ((currentPage - 1) * _pageSize) + index + 1;

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
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "$itemNumber",
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Row(
                                            children: [
                                              _avatar(user, size: 36),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      user.fullName.isNotEmpty
                                                          ? user.fullName
                                                          : user.userName,
                                                      style:
                                                          GoogleFonts.plusJakartaSans(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: kText,
                                                          ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      user.userName,
                                                      style:
                                                          GoogleFonts.plusJakartaSans(
                                                            fontSize: 11,
                                                            color: kMuted,
                                                          ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            user.position.isNotEmpty
                                                ? user.position
                                                : '—',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: _statusIndicator(
                                            accent,
                                            statusIconFor(user),
                                            statusLabelFor(user),
                                          ),
                                        ),
                                        // FIX: Align (instead of a bare Expanded child) so the action
                                        // buttons keep their natural size and don't stretch/hover-highlight
                                        // across the whole column.
                                        Expanded(
                                          flex: 4,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: actionsBuilder(user),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 4,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      _avatar(user, size: 36),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.fullName.isNotEmpty
                                                  ? user.fullName
                                                  : user.userName,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 13,
                                                    color: kText,
                                                  ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              user.position.isNotEmpty
                                                  ? user.position
                                                  : '@${user.userName}',
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    fontSize: 11,
                                                    color: kMuted,
                                                  ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            _statusIndicator(
                                              accent,
                                              statusIconFor(user),
                                              statusLabelFor(user),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // On mobile, use a popup menu instead of 4-5 inline icons to save space.
                                      PopupMenuButton<String>(
                                        color: Theme.of(context).cardColor,
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Colors.grey.shade500,
                                        ),
                                        onSelected: (value) {
                                          switch (value) {
                                            case 'unlock':
                                              _confirmUnlock(user);
                                              break;
                                            case 'lock':
                                              _showLockDialog(user);
                                              break;
                                            case 'edit':
                                              _openEdit(user);
                                              break;
                                            case 'password':
                                              _openChangePassword(user);
                                              break;
                                            case 'delete':
                                              _showDeleteDialog(user);
                                              break;
                                          }
                                        },
                                        itemBuilder:
                                            (_) => [
                                              if (user.lockoutEnabled)
                                                const PopupMenuItem(
                                                  value: 'unlock',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.lock_open_rounded,
                                                        size: 18,
                                                        color: Colors.green,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text('Unlock'),
                                                    ],
                                                  ),
                                                )
                                              else
                                                const PopupMenuItem(
                                                  value: 'lock',
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.lock_rounded,
                                                        size: 18,
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text('Lock'),
                                                    ],
                                                  ),
                                                ),
                                              const PopupMenuItem(
                                                value: 'edit',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.edit_outlined,
                                                      size: 18,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text('Edit'),
                                                  ],
                                                ),
                                              ),
                                              const PopupMenuItem(
                                                value: 'password',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.security_outlined,
                                                      size: 18,
                                                      color: Colors.blueAccent,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text('Change Password'),
                                                  ],
                                                ),
                                              ),
                                              const PopupMenuItem(
                                                value: 'delete',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons
                                                          .delete_simple,
                                                      size: 18,
                                                      color: Colors.redAccent,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text('Delete'),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    color: Theme.of(context).cardColor,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: PaginationInfo(
                            currentPage: currentPage,
                            totalItems: totalCount,
                            itemsPerPage: _pageSize,
                          ),
                        ),
                        PaginationControls(
                          currentPage: currentPage,
                          totalItems: totalCount,
                          itemsPerPage: _pageSize,
                          isLoading: loading,
                          onPageChanged: onPageChanged,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionIconButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // FIX: give the button an explicit, small, fixed-size tap target
    // (BoxConstraints.tightFor) instead of the previous unbounded
    // `BoxConstraints()`, which let the button (and its hover/ink area)
    // stretch to fill whatever width its parent handed it.
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 32,
        height: 32,
        child: IconButton(
          icon: Icon(icon, size: 16, color: color),
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 32, height: 32),
          splashRadius: 18,
        ),
      ),
    );
  }
}

class _ConfirmDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String confirmLabel;
  final Color confirmColor;

  const _ConfirmDialog({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.confirmColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 340,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 32,
              offset: const Offset(0, 12),
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
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: kText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: kMuted,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: kBorder),
                    ),
                    child: Text(
                      'No',
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
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      confirmLabel,
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
    );
  }
}
