// ignore_for_file: use_build_context_synchronously

import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/swot/models/swot.dart';
import 'package:imis/swot/services/swot_service.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/permission_string.dart';
import 'package:imis/widgets/no_permission_widget.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../common_services/common_service.dart';
import '../../user/models/user_registration.dart';
import '../../utils/pagination_util.dart';
import '../../utils/permission_service.dart';
import '../../widgets/filter_button_widget.dart';

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
  int _totalCount = 0;
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
          _totalCount = pageList.totalCount;
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
    bool isMinimized = MediaQuery.of(context).size.width < 600;
    bool hasPermission = permissionService.hasPermission(
      PermissionString.viewPerformanceGovernanceSystem,
    );

    if (!hasPermission) {
      return noPermissionScreen();
    }
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: const Text('SWOT Information'),
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
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PopupMenuButton<String>(
                            color: mainBgColor,
                            offset: const Offset(0, 30),
                            onCanceled: () {
                              setState(() {
                                isMenuOpenYear = false;
                              });
                            },
                            onOpened: () {
                              setState(() {
                                isMenuOpenYear = true;
                              });
                            },
                            onSelected: (String value) {
                              setState(() {
                                _selectedYear = value;

                                isMenuOpenYear = false;
                                fetchSwot();
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              final updatedYearList = [
                                ...SwotYear.years.map(
                                  (y) => {'id': y, 'name': y},
                                ),
                              ];

                              final searchController = TextEditingController();
                              ValueNotifier<String> searchQuery = ValueNotifier(
                                '',
                              );

                              return [
                                PopupMenuItem<String>(
                                  enabled: false,
                                  height: kMinInteractiveDimension,
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: searchController,
                                        decoration: const InputDecoration(
                                          hintText: 'Search year...',
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.search,
                                            size: 18,
                                          ),
                                          isDense: true,
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          searchQuery.value =
                                              value.toLowerCase();
                                        },
                                      ),
                                      const Divider(height: 16, thickness: 1),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  enabled: false,
                                  child: ValueListenableBuilder<String>(
                                    valueListenable: searchQuery,
                                    builder: (context, query, _) {
                                      final filteredYears =
                                          updatedYearList
                                              .where(
                                                (y) => y['name']
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(query),
                                              )
                                              .toList();

                                      return ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.4,
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children:
                                                filteredYears.map<Widget>((y) {
                                                  return ListTile(
                                                    dense: true,
                                                    title: Text(
                                                      y['name'].toString(),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      Navigator.pop(context);

                                                      setState(() {
                                                        _selectedYear =
                                                            y['id'].toString();

                                                        fetchSwot();
                                                      });
                                                    },
                                                  );
                                                }).toList(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ];
                            },

                            child: FilterButton(
                              label: _selectedYear ?? '',
                              isActive: isMenuOpenYear,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isMinimized)
                      ElevatedButton.icon(
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
                      DataColumn2(label: Text('Name'), size: ColumnSize.L),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows:
                        filteredList.asMap().entries.map((entry) {
                          int index = entry.key;
                          var swot = entry.value;
                          int itemNumber =
                              ((_currentPage - 1) * _pageSize) + index + 1;
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

                          return DataRow(
                            cells: [
                              DataCell(Text(itemNumber.toString())),
                              DataCell(Text(userName)),
                              DataCell(
                                Text(
                                  DateFormat('yyyy').format(swot.postingDate),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        showSwotDialog(
                                          id: swot.id.toString(),
                                          strengths: swot.strengths,
                                          weaknesses: swot.weaknesses,
                                          opportunities: swot.opportunities,
                                          threats: swot.threats,
                                          longTermDepartmentStrategicPlan:
                                              swot.longTermDepartmentStrategicPlan,
                                          immediateNeedsToAchieveVision:
                                              swot.immediateNeedsToAchieveVision,
                                          departmentAchievementsAndBestPractices:
                                              swot.departmentAchievementsAndBestPractices,
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: primaryColor,
                                      ),
                                      onPressed: () {
                                        showDeleteDialog(swot.id.toString());
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
              ],
            ),
          );
        },
      ),
    );
  }

  void showSwotDialog({
    String? id,
    String? strengths,
    String? weaknesses,
    String? opportunities,
    String? threats,
    String? longTermDepartmentStrategicPlan,
    String? immediateNeedsToAchieveVision,
    String? departmentAchievementsAndBestPractices,
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
                      child: Column(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel(
                                      "3. Enumerate the best practices/awards recieved by your department?",
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
                          Row(
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
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  elevation: 0,
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: const Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    bool?
                                    confirmAction = await showDialog<bool>(
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
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  Navigator.pop(context, true);
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
                                        questionBestPracticesController.text,
                                        false,
                                        DateTime.now(),
                                      );
                                      await _swotService.createSwot(swot);
                                      setState(() {
                                        fetchSwot();
                                      });
                                    }
                                  }
                                  MotionToast.success(
                                    description: const Text(
                                      "Saved successfully!",
                                    ),
                                    toastAlignment: Alignment.topCenter,
                                  ).show(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
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
