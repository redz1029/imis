// ignore_for_file: use_build_context_synchronously

import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/roadmap/models/kpi_roadmap.dart';
import 'package:imis/roadmap/models/kra_roadmap_role.dart';
import 'package:imis/roadmap/models/roadmap.dart';
import 'package:imis/roadmap/models/roadmap_deliverables.dart';
import 'package:imis/roadmap/pages/print_roadmap_page.dart';
import 'package:imis/roadmap/services/roadmap_service.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:imis/utils/permission_string.dart';
import 'package:imis/widgets/no_permission_widget.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common_services/common_service.dart';
import '../../utils/auth_util.dart';
import '../kra_period_roadmap/models/kra_roadmap_period.dart';

class RoadmapPage extends StatefulWidget {
  const RoadmapPage({super.key});

  @override
  State<RoadmapPage> createState() => RoadmapDialogPageState();
}

class RoadmapDialogPageState extends State<RoadmapPage> {
  final FocusNode isSearchfocus = FocusNode();
  final _commonService = CommonService(Dio());
  final _roadmapService = RoadmapService(Dio());
  TextEditingController searchController = TextEditingController();
  List<Roadmap> filteredList = [];
  List<Roadmap> roadmapList = [];
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;
  final dio = Dio();
  String roleId = "";
  final List<DeliverableGroup> deliverables = [];
  List<KeyResultArea> kraList = [];
  List<KraRoadmapRole> kraListRoadmap = [];
  List<KraRoadmapPeriod> kraPeriodList = [];
  final List<KpiRoadmap> kpiList = [];
  final List<TextEditingController> kpiControllers = [];
  final List<TextEditingController> targetControllers = [];
  final List<TextEditingController> baselineControllers = [];
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  final permissionService = PermissionService();

  @override
  void initState() {
    super.initState();
    _loadCurrentRoleId();
    isSearchfocus.addListener(() {
      setState(() {});
    });
    () async {
      final kra = await _commonService.fetchKra();
      final kraPeriod = await _commonService.fetchKraPeriod();
      final kraRoadmap = await _roadmapService.getKraRoadmapByRoleId();
      if (!mounted) return;

      setState(() {
        kraList = kra;
        kraPeriodList = kraPeriod;
        kraListRoadmap = kraRoadmap;
      });
    }();
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentRoleId() async {
    await AuthUtil.processTokenValidity(dio, context);
    final roles = await AuthUtil.fetchRoles();
    final prefs = await SharedPreferences.getInstance();
    final String? selectedRoleName = prefs.getString('selectedRole');

    String tempRoleId = "";

    if (roles != null && roles.isNotEmpty) {
      var currentRole = roles.first;
      if (selectedRoleName != null) {
        try {
          currentRole = roles.firstWhere((r) => r.name == selectedRoleName);
        } catch (e) {
          // keep first
        }
      }
      tempRoleId = currentRole.id;
    }

    if (mounted) {
      setState(() {
        roleId = tempRoleId;
      });

      if (roleId.isNotEmpty) {
        fetchRoadmap();
      }
    }
  }

  Future<void> fetchRoadmap({int page = 1, String? searchQuery}) async {
    if (_isLoading || roleId.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _roadmapService.getRoadmap(
        roleId: roleId,
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          roadmapList = pageList.items;
          filteredList = List.from(roadmapList);
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

  Future<void> filterSearchResults(String query) async {
    final q = query.trim().toLowerCase();

    if (q.isEmpty) {
      setState(() {
        filteredList = List.from(roadmapList);
      });
      return;
    }

    final results =
        roadmapList.where((r) {
          final matchedKra = kraList.firstWhere(
            (kra) => kra.id == r.kraId,
            orElse:
                () => KeyResultArea(
                  0,
                  'name',
                  'remarks',
                  'strategicObjective',
                  false,
                ),
          );

          final kraName = (matchedKra.name).toLowerCase();

          final matchedKraPeriod = kraPeriodList.firstWhere(
            (p) => p.id == r.kraRoadMapPeriodId,
            orElse:
                () => KraRoadmapPeriod(
                  0,
                  DateTime.now(),
                  DateTime.now(),
                  isDeleted: false,
                  rowVersion: '',
                ),
          );
          final periodString =
              '${matchedKraPeriod.startYear.year} - ${matchedKraPeriod.endYear.year}';

          final kpiMatch = (r.kpis ?? []).any(
            (k) => (k.kpiDescription ?? '').toLowerCase().contains(q),
          );

          return kraName.contains(q) || periodString.contains(q) || kpiMatch;
        }).toList();

    setState(() {
      filteredList = results;
    });
  }

  void showRoadmapFormDialog(
    KraRoadmapPeriod period, {
    KraRoadmapRole? selectedKra,
    Roadmap? roadmapToEdit,
  }) {
    final int startYear = period.startYear.year;
    final int endYear = period.endYear.year;

    final List<int> yearColumns = [
      for (int y = startYear; y <= endYear; y++) y,
    ];

    final List<String> headers = [
      'Action',
      'Enablers',
      'KRA',
      ...yearColumns.map((y) => y.toString()),
    ];

    final bool isEdit = roadmapToEdit != null;
    final String title = '${selectedKra?.kraName ?? ''} ROADMAP';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        List<TextEditingController> kpiControllers = [];
        List<TextEditingController> targetControllers = [];
        List<TextEditingController> baselineControllers = [];
        List<List<TextEditingController>> tableControllers = [];
        List<List<bool>> enablerStates = [];
        List<DeliverableGroup?> existingGroups = [];
        if (isEdit) {
          final deliverables = roadmapToEdit.deliverables ?? [];

          for (final group in deliverables) {
            existingGroups.add(group);

            final row = List.generate(headers.length, (_) => '');
            row[2] = group.kraDescription ?? '';

            for (int i = 3; i < headers.length; i++) {
              final year = yearColumns[i - 3];
              final match = group.items?.firstWhere(
                (d) => d.year == year,
                orElse:
                    () => RoadmapDeliverableItem(
                      id: 0,
                      deliverableDescription: '',
                      year: year,
                      kraDescription: row[2],
                      isEnabler: false,
                      isDeleted: false,
                      rowVersion: '',
                    ),
              );
              row[i] = match?.deliverableDescription ?? '';
            }

            tableControllers.add(
              row.map((v) => TextEditingController(text: v)).toList(),
            );
            final bool isEnabler =
                group.items?.any((item) => item.isEnabler) ?? false;

            enablerStates.add(
              List.generate(headers.length, (i) => i == 1 ? isEnabler : false),
            );
          }

          for (final kpi in roadmapToEdit.kpis ?? []) {
            kpiControllers.add(TextEditingController(text: kpi.kpiDescription));
            targetControllers.add(TextEditingController(text: kpi.target));
            baselineControllers.add(TextEditingController(text: kpi.baseLine));
          }
        }

        if (tableControllers.isEmpty) {
          tableControllers.add(
            List.generate(headers.length, (_) => TextEditingController()),
          );
          enablerStates.add(List.generate(headers.length, (_) => false));
          existingGroups.add(null);
        }

        if (kpiControllers.isEmpty &&
            targetControllers.isEmpty &&
            baselineControllers.isEmpty) {
          kpiControllers.add(TextEditingController());
          targetControllers.add(TextEditingController());
          baselineControllers.add(TextEditingController());
        }

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final Map<int, TableColumnWidth> columnWidths = {
              0: const FixedColumnWidth(80),
              1: const FixedColumnWidth(100),
              2: const FixedColumnWidth(300),
              for (int i = 3; i < headers.length; i++)
                i: const FixedColumnWidth(200),
            };

            return AlertDialog(
              backgroundColor: mainBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              titlePadding: EdgeInsets.zero,
              title: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: maroon,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Title text
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Close button
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Table(
                        border: TableBorder.all(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(6),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Tooltip(
                                  message: 'Strategy Objective',
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              selectedKra
                                                  ?.strategicObjectives ??
                                              '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    for (
                                      int i = 0;
                                      i < kpiControllers.length &&
                                          i < targetControllers.length &&
                                          i < baselineControllers.length;
                                      i++
                                    )
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              'KPI ${i + 1}: ',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: TextFormField(
                                                maxLines: null,
                                                controller: kpiControllers[i],
                                                decoration:
                                                    const InputDecoration(
                                                      isDense: true,
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              'Target ${i + 1}: ',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            Expanded(
                                              flex: 2,
                                              child: TextFormField(
                                                maxLines: null,
                                                controller:
                                                    targetControllers[i],
                                                decoration:
                                                    const InputDecoration(
                                                      isDense: true,
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              'Baseline ${i + 1}: ',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: TextFormField(
                                                maxLines: null,
                                                controller:
                                                    baselineControllers[i],
                                                decoration:
                                                    const InputDecoration(
                                                      isDense: true,
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                setStateDialog(() {
                                                  kpiControllers.removeAt(i);
                                                  baselineControllers.removeAt(
                                                    i,
                                                  );
                                                  targetControllers.removeAt(i);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    Visibility(
                                      visible:
                                          kpiControllers.length < 2 ||
                                          targetControllers.length < 2 ||
                                          baselineControllers.length < 2,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: TextButton.icon(
                                          onPressed: () {
                                            setStateDialog(() {
                                              kpiControllers.add(
                                                TextEditingController(),
                                              );
                                              targetControllers.add(
                                                TextEditingController(),
                                              );
                                              baselineControllers.add(
                                                TextEditingController(),
                                              );
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.add,
                                            color: primaryColor,
                                          ),
                                          label: const Text(
                                            'Add KPI',
                                            style: TextStyle(
                                              color: primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 400,
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            controller: _verticalScrollController,
                            child: Scrollbar(
                              thumbVisibility: true,
                              controller: _horizontalScrollController,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: _horizontalScrollController,
                                child: Table(
                                  border: TableBorder.all(),
                                  columnWidths: columnWidths,
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: [
                                    // Header
                                    TableRow(
                                      children:
                                          headers
                                              .map(
                                                (h) => Padding(
                                                  padding: const EdgeInsets.all(
                                                    12,
                                                  ),
                                                  child: Text(
                                                    h,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                    ),

                                    ...tableControllers.asMap().entries.map((
                                      entry,
                                    ) {
                                      int rowIndex = entry.key;
                                      final controllers = entry.value;

                                      return TableRow(
                                        children: List.generate(headers.length, (
                                          col,
                                        ) {
                                          if (col == 0) {
                                            return PermissionWidget(
                                              allowedRoles: [
                                                PermissionString.roleAdmin,
                                                PermissionString
                                                    .trainingOfficer,
                                                PermissionString.serviceOfficer,
                                                PermissionString.financeOfficer,
                                                PermissionString
                                                    .researchOfficer,
                                                PermissionString
                                                    .facilityOfficer,
                                                PermissionString
                                                    .linkagesOfficer,
                                                PermissionString
                                                    .informationOfficer,
                                                PermissionString.safetyOfficer,
                                                PermissionString.hrOfficer,
                                              ],
                                              child: IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  setStateDialog(() {
                                                    tableControllers.removeAt(
                                                      rowIndex,
                                                    );
                                                    enablerStates.removeAt(
                                                      rowIndex,
                                                    );
                                                    existingGroups.removeAt(
                                                      rowIndex,
                                                    );
                                                  });
                                                },
                                              ),
                                            );
                                          }

                                          if (col == 1) {
                                            return Checkbox(
                                              value:
                                                  enablerStates[rowIndex][col],
                                              onChanged: (v) {
                                                setStateDialog(() {
                                                  enablerStates[rowIndex][col] =
                                                      v ?? false;
                                                });
                                              },
                                              activeColor: mainBgColor,
                                              checkColor: Colors.black,
                                            );
                                          }

                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              maxLines: null,
                                              controller: controllers[col],
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                          );
                                        }),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton.icon(
                          onPressed: () {
                            setStateDialog(() {
                              tableControllers.add(
                                List.generate(
                                  headers.length,
                                  (_) => TextEditingController(),
                                ),
                              );
                              enablerStates.add(
                                List.generate(headers.length, (_) => false),
                              );
                              existingGroups.add(null);
                            });
                            // Scroll to bottom to show the new row
                            Future.delayed(
                              const Duration(milliseconds: 100),
                              () {
                                if (_verticalScrollController.hasClients) {
                                  _verticalScrollController.animateTo(
                                    _verticalScrollController
                                        .position
                                        .maxScrollExtent,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  );
                                }
                              },
                            );
                          },
                          icon: const Icon(Icons.add, color: primaryColor),
                          label: const Text(
                            "Add Row",
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              actions: [
                Builder(
                  builder: (context) {
                    final canEdit =
                        (roadmapToEdit == null) ||
                        (roleId == roadmapToEdit.roleId) ||
                        (permissionService.currentRole != null &&
                            permissionService.currentRole ==
                                PermissionString.roleAdmin);
                    if (!canEdit) {
                      return const SizedBox.shrink();
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Text(
                            'Save',
                            style: const TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            bool? confirmAction = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Confirm Save'),
                                  content: Text(
                                    isEdit
                                        ? 'Are you sure you want to update this roadmap?'
                                        : 'Are you sure you want to save this roadmap?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text(
                                        'Confirm',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmAction != true) return;

                            final Set<String> kraSet = {};
                            bool hasDuplicateKra = false;

                            for (final row in tableControllers) {
                              final kraText = row[2].text.trim().toLowerCase();

                              if (kraText.isEmpty) continue;

                              if (kraSet.contains(kraText)) {
                                hasDuplicateKra = true;
                                break;
                              }
                              kraSet.add(kraText);
                            }

                            if (hasDuplicateKra) {
                              MotionToast.warning(
                                toastAlignment: Alignment.topCenter,
                                description: const Text(
                                  'Duplicate KRA found. Please ensure each KRA is unique.',
                                ),
                              ).show(context);
                              return;
                            }

                            int filledKpiCount =
                                kpiControllers
                                    .where((c) => c.text.trim().isNotEmpty)
                                    .length;

                            if (filledKpiCount < 1) {
                              MotionToast.warning(
                                title: const Text("Insufficient KPI"),
                                description: const Text(
                                  "Please provide at least 1 or 2 KPIs only.",
                                ),
                                toastAlignment: Alignment.center,
                              ).show(context);

                              return;
                            }

                            final List<DeliverableGroup> allGroups = [];

                            for (int r = 0; r < tableControllers.length; r++) {
                              final controllers = tableControllers[r];
                              final existingGroup = existingGroups[r];

                              final List<RoadmapDeliverableItem> items = [];

                              for (int c = 3; c < headers.length; c++) {
                                final year = yearColumns[c - 3];
                                final text = controllers[c].text.trim();

                                final existingItem = existingGroup?.items
                                    ?.firstWhere(
                                      (i) => i.year == year,
                                      orElse:
                                          () => RoadmapDeliverableItem(
                                            id: 0,
                                            deliverableDescription: '',
                                            year: year,
                                            kraDescription: controllers[2].text,
                                            isEnabler:
                                                c == 3
                                                    ? enablerStates[r][1]
                                                    : false,
                                            isDeleted: false,
                                            rowVersion: '',
                                          ),
                                    );

                                items.add(
                                  RoadmapDeliverableItem(
                                    id: isEdit ? existingItem?.id ?? 0 : 0,
                                    deliverableDescription: text,
                                    year: year,
                                    kraDescription: controllers[2].text,
                                    isEnabler:
                                        c == 3 ? enablerStates[r][1] : false,
                                    isDeleted: false,
                                    rowVersion: existingItem?.rowVersion ?? '',
                                  ),
                                );
                              }

                              allGroups.add(
                                DeliverableGroup(
                                  id: isEdit ? existingGroup?.id ?? 0 : 0,
                                  kraDescription: controllers[2].text,
                                  items: items,
                                  isDeleted: false,
                                  rowVersion: existingGroup?.rowVersion ?? '',
                                ),
                              );
                            }

                            kpiList.clear();
                            final int kpiCount = [
                              kpiControllers.length,
                              targetControllers.length,
                              baselineControllers.length,
                            ].reduce((a, b) => a < b ? a : b);

                            for (int i = 0; i < kpiCount; i++) {
                              final kpiText = kpiControllers[i].text.trim();
                              final targetText =
                                  targetControllers[i].text.trim();
                              final baselineText =
                                  baselineControllers[i].text.trim();

                              if (kpiText.isEmpty &&
                                  targetText.isEmpty &&
                                  baselineText.isEmpty) {
                                continue;
                              }

                              kpiList.add(
                                KpiRoadmap(
                                  id: 0,
                                  kpiDescription: kpiText,
                                  target: targetText,
                                  baseLine: baselineText,
                                ),
                              );
                            }
                            final roadmap = Roadmap(
                              isEdit ? roadmapToEdit.id : 0,
                              selectedKra!.kraId,
                              period.id,
                              period,
                              allGroups,
                              kpiList,
                              roleId,
                              isDeleted: false,
                              rowVersion: roadmapToEdit?.rowVersion ?? '',
                            );

                            await _roadmapService.createRoadmap(roadmap);

                            setState(() {
                              fetchRoadmap();
                            });

                            MotionToast.success(
                              toastAlignment: Alignment.topCenter,
                              description: Text(
                                isEdit
                                    ? 'Updated successfully'
                                    : 'Saved successfully',
                              ),
                            ).show(context);

                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showProcess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: Text('Select Process (Core & Support)')),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: FutureBuilder<List<KraRoadmapRole>>(
              future: _roadmapService.getKraRoadmapByRoleId(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Failed to load core and support');
                }

                final kras = snapshot.data ?? [];

                if (kras.isEmpty) {
                  return const Text('No process available');
                }

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: kras.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final kra = kras[index];

                    return ListTile(
                      title: Text(kra.kraName),
                      onTap: () {
                        Navigator.pop(context);
                        showPeriodPanel(selectedKra: kra);
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void showPeriodPanel({KraRoadmapRole? selectedKra}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: Text('Select Period')),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          content: SizedBox(
            width: 400,
            child: FutureBuilder<List<KraRoadmapPeriod>>(
              future: _commonService.fetchKraPeriod(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Failed to load periods');
                }

                final periods = snapshot.data ?? [];

                if (periods.isEmpty) {
                  return const Text('No periods available');
                }

                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: periods.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final period = periods[index];

                    return ListTile(
                      title: Text(
                        '${period.startYear.year} - ${period.endYear.year}',
                      ),

                      onTap: () {
                        Navigator.pop(context);
                        showRoadmapFormDialog(period, selectedKra: selectedKra);
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;
    bool hasPermission = permissionService.hasPermission(
      AppPermissions.viewKraRoadMap,
    );

    if (!hasPermission) {
      return noPermissionScreen();
    }
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: const Text('Roadmap Information'),
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
                      PermissionWidget(
                        allowedRoles: [
                          PermissionString.roleAdmin,
                          PermissionString.trainingOfficer,
                          PermissionString.serviceOfficer,
                          PermissionString.financeOfficer,
                          PermissionString.researchOfficer,
                          PermissionString.facilityOfficer,
                          PermissionString.linkagesOfficer,
                          PermissionString.informationOfficer,
                          PermissionString.safetyOfficer,
                          PermissionString.hrOfficer,
                        ],
                        child: ElevatedButton.icon(
                          onPressed: () => showProcess(),
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
                        label: Text('Process (Core & Support)'),
                        size: ColumnSize.L,
                      ),
                      DataColumn(label: Text('Period')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows:
                        filteredList.asMap().entries.map((entry) {
                          int index = entry.key;
                          var roadmap = entry.value;
                          int itemNumber =
                              ((_currentPage - 1) * _pageSize) + index + 1;

                          final matchedKra = kraList.firstWhere(
                            (kra) => kra.id == roadmap.kraId,
                            orElse:
                                () => KeyResultArea(
                                  0,
                                  'name',
                                  'remarks',
                                  'strategicObjective',
                                  false,
                                ),
                          );

                          final kraName = matchedKra.name;

                          final matchedKraRoadmap = kraListRoadmap.firstWhere(
                            (kra) => kra.kraId == roadmap.kraId,
                            orElse:
                                () => KraRoadmapRole(
                                  kraId: 0,
                                  roleId: 'roleId',
                                  kraName: kraName,
                                  strategicObjectives: '',
                                ),
                          );

                          final matchedKraPeriod = kraPeriodList.firstWhere(
                            (kraPeriod) =>
                                kraPeriod.id == roadmap.kraRoadMapPeriodId,
                            orElse:
                                () => KraRoadmapPeriod(
                                  0,
                                  DateTime.now(),
                                  DateTime.now(),
                                  isDeleted: false,
                                  rowVersion: '',
                                ),
                          );
                          final startYear = matchedKraPeriod.startYear.year;
                          final endYear = matchedKraPeriod.endYear.year;
                          final kraPeriod = '$startYear - $endYear ';
                          return DataRow(
                            cells: [
                              DataCell(Text(itemNumber.toString())),
                              DataCell(Text(kraName)),
                              DataCell(Text(kraPeriod)),
                              DataCell(
                                Row(
                                  children: [
                                    if (roleId == roadmap.roleId ||
                                        permissionService.currentRole ==
                                            PermissionString.roleAdmin)
                                      IconButton(
                                        icon: const Icon(Icons.edit),

                                        onPressed: () async {
                                          final Roadmap roadmapDetails =
                                              await _roadmapService
                                                  .getRoadmapId(roadmap.id!);

                                          showRoadmapFormDialog(
                                            matchedKraPeriod,
                                            selectedKra: matchedKraRoadmap,
                                            roadmapToEdit: roadmapDetails,
                                          );
                                        },
                                      ),
                                    Tooltip(
                                      message: 'Print Preview',

                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.description_outlined,
                                        ),

                                        onPressed: () async {
                                          final roadMapId =
                                              roadmap.id.toString();

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => PrintRoadmapPage(
                                                    roadmapId: roadMapId,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    if (roleId == roadmap.roleId ||
                                        permissionService.currentRole ==
                                            PermissionString.roleAdmin)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: primaryColor,
                                        ),
                                        onPressed: () {
                                          showDeleteDialog(
                                            roadmap.id.toString(),
                                          );
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
                        onPageChanged: (page) => fetchRoadmap(page: page),
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
              ? PermissionWidget(
                allowedRoles: [
                  PermissionString.roleAdmin,
                  PermissionString.trainingOfficer,
                  PermissionString.serviceOfficer,
                  PermissionString.financeOfficer,
                  PermissionString.researchOfficer,
                  PermissionString.facilityOfficer,
                  PermissionString.linkagesOfficer,
                  PermissionString.informationOfficer,
                  PermissionString.safetyOfficer,
                  PermissionString.hrOfficer,
                ],
                child: FloatingActionButton(
                  backgroundColor: primaryColor,
                  onPressed: () => showProcess(),
                  child: Icon(Icons.add, color: Colors.white),
                ),
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
            "Are you sure you want to delete this Roadmap? This action cannot be undone.",
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
                  await _roadmapService.deleteRoadmap(id);
                  await fetchRoadmap();
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text('Deleted successfully'),
                  ).show(context);
                } catch (e) {
                  MotionToast.error(description: Text('Failed to Delete'));
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
