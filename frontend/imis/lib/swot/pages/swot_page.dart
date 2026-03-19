// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/swot/models/swot.dart';
import 'package:imis/swot/services/swot_service.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/permission_string.dart';
import 'package:imis/widgets/no_permission_widget.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../common_services/common_service.dart';
import '../../user/models/user_registration.dart';
import '../../utils/pagination_util.dart';
import '../../utils/permission_service.dart';

class SwotPage extends StatefulWidget {
  const SwotPage({super.key});

  @override
  SwotDialogResponsiveState createState() => SwotDialogResponsiveState();
}

class SwotDialogResponsiveState extends State<SwotPage> {
  final strengthController = TextEditingController();
  final weaknessController = TextEditingController();
  final opportunityController = TextEditingController();
  final threatController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();
  final _swotService = SwotService(Dio());
  final longTermDepartmentStrategicPlanController = TextEditingController();
  final immediateNeedsToAchieveVisionController = TextEditingController();
  final questionBestPracticesController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final _commonService = CommonService(Dio());
  final permissionService = PermissionService();
  final dio = Dio();
  List<User> userList = [];
  List<Swot> filteredList = [];
  List<Swot> swotList = [];
  int _currentPage = 1;
  final int _pageSize = 15;
  int totalCount = 0;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String userId = "";
  final _paginationUtils = PaginationUtil(Dio());
  String? _selectedYear = DateTime.now().year.toString();
  bool isMenuOpenYear = false;
  @override
  void initState() {
    super.initState();
    fetchSwot();
    _loadCurrentUserId();

    () async {
      final users = await _commonService.fetchUsers();

      if (!mounted) return;

      setState(() {
        userList = users;
      });
    }();
  }

  Future<void> fetchSwot({
    int page = 1,
    String? searchQuery,
    String? year,
  }) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      swotList = [];
      filteredList = [];
    });

    try {
      final selectedYear = year ?? _selectedYear;
      final endpoint =
          (selectedYear == null || selectedYear.isEmpty)
              ? "${ApiEndpoint().swotAnalysis}/filter/year"
              : "${ApiEndpoint().swotAnalysis}/filter/year?year=$selectedYear";

      final pageList = await _paginationUtils.fetchPaginatedData<Swot>(
        endpoint: endpoint,
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
        fromJson: (json) => Swot.fromJson(json),
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          totalCount = pageList.totalCount;
          swotList = pageList.items;
          filteredList = List.from(swotList);
        });
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadCurrentUserId() async {
    UserRegistration? user = await AuthUtil.processTokenValidity(dio, context);

    setState(() {
      userId = user!.id ?? "UserId";
    });

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    bool hasPermission = permissionService.hasPermission(
      AppPermissions.viewSWOTAnalysis,
    );
    final isMobile = width < 600;

    if (!hasPermission) {
      return noPermissionScreen();
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "SWOT Analysis Information",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                    color: Theme.of(context).cardColor,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: Colors.white,
                      value: _selectedYear,
                      isDense: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items:
                          SwotYear.years.map((year) {
                            return DropdownMenuItem(
                              value: year.toString(),
                              child: Text(year.toString()),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedYear = value!;
                          fetchSwot();
                        });
                      },
                    ),
                  ),
                ),
                const Spacer(),
                if (!isMobile)
                  PermissionWidget(
                    permission: AppPermissions.addKraRoadMap,
                    child: ElevatedButton.icon(
                      onPressed: () => showSwotDialog(),
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
                    /// DESKTOP HEADER
                    if (!isMobile)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          children: const [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "#",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Full Name",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Date",
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
                              : ListView.builder(
                                itemCount: filteredList.length,
                                itemBuilder: (context, index) {
                                  final swot = filteredList[index];
                                  int itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;
                                  final matchUserName = userList.firstWhere(
                                    (user) => user.id == swot.userId,
                                    orElse:
                                        () => User(
                                          id: 'unknown',
                                          fullName: 'Unknown',
                                          position: 'position',
                                        ),
                                  );
                                  final userName = matchUserName.fullName;

                                  if (!isMobile) {
                                    /// DESKTOP ROW
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text("$itemNumber"),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(userName),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              DateFormat(
                                                'yyyy',
                                              ).format(swot.postingDate),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                PermissionWidget(
                                                  permission:
                                                      AppPermissions
                                                          .editSWOTAnalysis,
                                                  child: Tooltip(
                                                    message: 'Edit',
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.edit_outlined,
                                                      ),
                                                      onPressed: () async {
                                                        try {
                                                          final fetchedSwot =
                                                              await _swotService
                                                                  .getSwotById(
                                                                    swot.id
                                                                        .toString(),
                                                                  );
                                                          showSwotDialog(
                                                            id:
                                                                fetchedSwot.id
                                                                    .toString(),
                                                            userIds: userId,
                                                            strengths:
                                                                fetchedSwot
                                                                    .strengths,
                                                            weaknesses:
                                                                fetchedSwot
                                                                    .weaknesses,
                                                            opportunities:
                                                                fetchedSwot
                                                                    .opportunities,
                                                            threats:
                                                                fetchedSwot
                                                                    .threats,
                                                            longTermDepartmentStrategicPlan:
                                                                fetchedSwot
                                                                    .longTermDepartmentStrategicPlan,
                                                            immediateNeedsToAchieveVision:
                                                                fetchedSwot
                                                                    .immediateNeedsToAchieveVision,
                                                            departmentAchievementsAndBestPractices:
                                                                fetchedSwot
                                                                    .departmentAchievementsAndBestPractices,
                                                            swotToEdit:
                                                                fetchedSwot,
                                                          );
                                                        } catch (e) {
                                                          MotionToast.error(
                                                            description: const Text(
                                                              "Failed to fetch SWOT details",
                                                            ),
                                                            toastAlignment:
                                                                Alignment
                                                                    .topCenter,
                                                          ).show(context);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),

                                                PermissionWidget(
                                                  permission:
                                                      AppPermissions
                                                          .editKraRoadMap,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      CupertinoIcons
                                                          .delete_simple,
                                                      color: Colors.redAccent,
                                                    ),
                                                    onPressed:
                                                        () => showDeleteDialog(
                                                          swot.id.toString(),
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  /// MOBILE ROW
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "$itemNumber",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Spacer(),
                                            PopupMenuButton<String>(
                                              color:
                                                  Theme.of(context).cardColor,
                                              icon: const Icon(Icons.more_vert),
                                              onSelected: (value) async {
                                                if (value == 'edit' &&
                                                    permissionService
                                                        .hasPermission(
                                                          AppPermissions
                                                              .editKraRoadMap,
                                                        )) {
                                                  try {
                                                    final fetchedSwot =
                                                        await _swotService
                                                            .getSwotById(
                                                              swot.id
                                                                  .toString(),
                                                            );
                                                    showSwotDialog(
                                                      id:
                                                          fetchedSwot.id
                                                              .toString(),
                                                      userIds: userId,
                                                      strengths:
                                                          fetchedSwot.strengths,
                                                      weaknesses:
                                                          fetchedSwot
                                                              .weaknesses,
                                                      opportunities:
                                                          fetchedSwot
                                                              .opportunities,
                                                      threats:
                                                          fetchedSwot.threats,
                                                      longTermDepartmentStrategicPlan:
                                                          fetchedSwot
                                                              .longTermDepartmentStrategicPlan,
                                                      immediateNeedsToAchieveVision:
                                                          fetchedSwot
                                                              .immediateNeedsToAchieveVision,
                                                      departmentAchievementsAndBestPractices:
                                                          fetchedSwot
                                                              .departmentAchievementsAndBestPractices,
                                                      swotToEdit: fetchedSwot,
                                                    );
                                                  } catch (e) {
                                                    MotionToast.error(
                                                      description: const Text(
                                                        "Failed to fetch SWOT details",
                                                      ),
                                                      toastAlignment:
                                                          Alignment.topCenter,
                                                    ).show(context);
                                                  }
                                                }

                                                if (value == 'delete' &&
                                                    permissionService
                                                        .hasPermission(
                                                          AppPermissions
                                                              .editKraRoadMap,
                                                        )) {
                                                  showDeleteDialog(
                                                    swot.id.toString(),
                                                  );
                                                }
                                              },
                                              itemBuilder:
                                                  (_) => [
                                                    PopupMenuItem(
                                                      value: 'edit',
                                                      child: PermissionWidget(
                                                        permission:
                                                            AppPermissions
                                                                .viewKraRoadMap,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .edit_outlined,
                                                              size: 18,
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text('Edit'),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                    PopupMenuItem(
                                                      value: 'delete',
                                                      child: PermissionWidget(
                                                        permission:
                                                            AppPermissions
                                                                .editSWOTAnalysis,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              CupertinoIcons
                                                                  .delete_simple,
                                                              color: Colors.red,
                                                              size: 18,
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text('Delete'),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text("Full Name: $userName"),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Period: ${DateFormat('yyyy').format(swot.postingDate)}",
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
                            totalItems: totalCount,
                            itemsPerPage: _pageSize,
                          ),
                          PaginationControls(
                            currentPage: _currentPage,
                            totalItems: totalCount,
                            itemsPerPage: _pageSize,
                            isLoading: _isLoading,
                            onPageChanged: (page) => fetchSwot(page: page),
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
                onPressed: () => showSwotDialog(),
                child: Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  void showSwotDialog({
    String? id,
    String? userIds,
    String? strengths,
    String? weaknesses,
    String? opportunities,
    String? threats,
    String? longTermDepartmentStrategicPlan,
    String? immediateNeedsToAchieveVision,
    String? departmentAchievementsAndBestPractices,
    Swot? swotToEdit,
  }) async {
    TextEditingController strengthController = TextEditingController(
      text: strengths,
    );
    TextEditingController weaknessController = TextEditingController(
      text: weaknesses,
    );
    TextEditingController opportunityController = TextEditingController(
      text: opportunities,
    );
    TextEditingController threatController = TextEditingController(
      text: threats,
    );
    TextEditingController longTermDepartmentStrategicPlanController =
        TextEditingController(text: longTermDepartmentStrategicPlan);
    TextEditingController immediateNeedsToAchieveVisionController =
        TextEditingController(text: immediateNeedsToAchieveVision);
    TextEditingController questionBestPracticesController =
        TextEditingController(text: departmentAchievementsAndBestPractices);

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: mainBgColor,
          insetPadding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Form(
                      key: _formKey,
                      child: Stack(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "SWOT Analysis",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              gap48px,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // LEFT
                                  Expanded(
                                    child: Column(
                                      children: [
                                        _buildLabel("Strength"),
                                        gap8px,
                                        _buildColoredBox(
                                          controller: strengthController,
                                          bg: const Color(0xFFF5FFF7),
                                          border: Colors.green,
                                        ),
                                        const SizedBox(height: 20),

                                        _buildLabel("Weakness"),
                                        gap8px,
                                        _buildColoredBox(
                                          controller: weaknessController,

                                          bg: const Color(0xFFFFF5F5),
                                          border: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  Expanded(
                                    child: Column(
                                      children: [
                                        _buildLabel("Opportunities"),
                                        gap8px,
                                        _buildColoredBox(
                                          controller: opportunityController,

                                          bg: const Color(0xFFF5FBFF),
                                          border: Colors.blue,
                                        ),
                                        const SizedBox(height: 20),

                                        _buildLabel("Threats"),
                                        gap8px,
                                        _buildColoredBox(
                                          controller: threatController,
                                          bg: const Color(0xFFFFF3E0),

                                          border: Colors.orange,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              gap48px,

                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildLabel(
                                          "1. In 3 to 5 years, what is your vision or dream for your unit or department?",
                                        ),
                                        gap14px,
                                        _buildSmallBox(
                                          longTermDepartmentStrategicPlanController,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildLabel(
                                          "2. What do you think are your immediate needs to accomplish your dreams or vision?",
                                        ),
                                        gap14px,
                                        _buildSmallBox(
                                          immediateNeedsToAchieveVisionController,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildLabel(
                                          "3. Enumerate the best practices/awards received by your department?",
                                        ),
                                        gap14px,
                                        _buildSmallBox(
                                          questionBestPracticesController,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              gap32px,
                              Builder(
                                builder: (context) {
                                  // final canEdit =
                                  //     (id == null) ||
                                  //     (userId == strengthController.text) ||
                                  //     (permissionService.currentRole != null &&
                                  //         permissionService.currentRole ==
                                  //             PermissionString.roleAdmin);

                                  final bool isEdit = swotToEdit != null;

                                  final bool isOwner =
                                      isEdit && swotToEdit.userId == userId;

                                  final bool isAdmin =
                                      permissionService.currentRole ==
                                      PermissionString.roleAdmin;

                                  final bool canSaveOrUpdate =
                                      !isEdit || isOwner || isAdmin;
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(color: primaryColor),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      const SizedBox(width: 8),
                                      if (canSaveOrUpdate)
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shadowColor: Colors.transparent,
                                            elevation: 0,
                                            backgroundColor: primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                          child: const Text(
                                            "Save",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              bool?
                                              confirmAction = await showDialog<
                                                bool
                                              >(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      id == null
                                                          ? "Confirm Save"
                                                          : "Confirm Update",
                                                    ),
                                                    content: Text(
                                                      id == null
                                                          ? "Are you sure you want to save this record?"
                                                          : "Are you sure you want to update this record?",
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {},
                                                        child: Text(
                                                          "No",
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            Navigator.pop(
                                                              context,
                                                              true,
                                                            );
                                                          }
                                                        },
                                                        child: Text(
                                                          "Yes",
                                                          style: TextStyle(
                                                            color: primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              if (confirmAction == true) {
                                                final swot = Swot(
                                                  int.tryParse(id ?? '0') ?? 0,
                                                  userId,
                                                  strengthController.text,
                                                  weaknessController.text,
                                                  opportunityController.text,
                                                  threatController.text,
                                                  longTermDepartmentStrategicPlanController
                                                      .text,
                                                  immediateNeedsToAchieveVisionController
                                                      .text,
                                                  questionBestPracticesController
                                                      .text,
                                                  false,
                                                  DateTime.now(),
                                                );
                                                await _swotService.createSwot(
                                                  swot,
                                                );
                                                setState(() {
                                                  fetchSwot();
                                                });
                                              }
                                            }
                                            MotionToast.success(
                                              description: const Text(
                                                "Saved successfully!",
                                              ),
                                              toastAlignment:
                                                  Alignment.topCenter,
                                            ).show(context);
                                            Navigator.pop(context);
                                          },
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: primaryTextColor,
                                size: 32,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return SizedBox(
      height: 40,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildColoredBox({
    required TextEditingController controller,
    required Color bg,
    required Color border,
  }) {
    return TextField(
      controller: controller,
      maxLines: 4,
      decoration: InputDecoration(
        filled: true,
        fillColor: bg,

        // normal border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: border.withValues(alpha: 0.4)),
        ),

        // remove focused effect completely
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: border.withValues(alpha: 0.4)),
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: border.withValues(alpha: 0.4)),
        ),
      ),
    );
  }

  Widget _buildSmallBox(TextEditingController controller) {
    return TextField(
      controller: controller,
      maxLines: 2,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Color(0xFFF8F8F8),
      ),
    );
  }

  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
          title: Text('Confirm Delete'),
          content: Text(
            'Are you sure you want to delete this SWOT Analysis? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: primaryTextColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await _swotService.deleteSwot(id);
                  await fetchSwot();
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text('SWOT Analysis deleted successfully'),
                  ).show(context);
                } catch (e) {
                  MotionToast.error(
                    description: Text('Failed to SWOT Analysis'),
                  );
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
