// ignore_for_file: use_build_context_synchronously

import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/roadmap/models/kpi_roadmap.dart';
import 'package:imis/roadmap/models/roadmap.dart';
import 'package:imis/roadmap/models/roadmap_deliverables.dart';
import 'package:imis/roadmap/pages/print_roadmap_page.dart';
import 'package:imis/roadmap/services/roadmap_service.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../common_services/common_service.dart';
import '../kra_period_roadmap/models/kra_roadmap_period.dart';

class RoadmapPage extends StatefulWidget {
  const RoadmapPage({super.key});

  @override
  State<RoadmapPage> createState() => RoadmapDialogPageState();
}

class RoadmapDialogPageState extends State<RoadmapPage> {
  List<String> kpList = ["KP1"];
  final FocusNode isSearchfocus = FocusNode();
  TextEditingController searchController = TextEditingController();
  List<Roadmap> filteredList = [];
  List<Roadmap> roadmapList = [];
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;
  final _commonService = CommonService(Dio());
  final _roadmapService = RoadmapService(Dio());
  final dio = Dio();
  final List<DeliverableGroup> deliverables = [];
  List<KeyResultArea> kraList = [];
  List<KraRoadmapPeriod> kraPeriodList = [];
  final List<TextEditingController> kpiControllers = [];

  final ScrollController _horizontalScrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    fetchRoadmap();
    isSearchfocus.addListener(() {
      setState(() {});
    });
    () async {
      final kra = await _commonService.fetchKra();
      final kraPeriod = await _commonService.fetchKraPeriod();
      if (!mounted) return;

      setState(() {
        kraList = kra;
        kraPeriodList = kraPeriod;
      });
    }();
  }

  Future<void> fetchRoadmap({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _roadmapService.getRoadmap(
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

  void showRoadmapFormDialog(
    KraRoadmapPeriod period, {
    KeyResultArea? selectedKra,
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
    final String title = '${selectedKra?.name ?? ''} ROADMAP';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        List<TextEditingController> kpiControllers = [];
        List<List<TextEditingController>> tableControllers = [];
        List<List<bool>> enablerStates = [];
        if (isEdit) {
          final deliverables = roadmapToEdit.deliverables ?? [];
          for (var group in deliverables) {
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
            enablerStates.add(
              List.generate(
                headers.length,
                (i) => i == 1 ? group.items?.first.isEnabler ?? false : false,
              ),
            );
          }
          for (final kpi in roadmapToEdit.kpis ?? []) {
            kpiControllers.add(TextEditingController(text: kpi.kpiDescription));
          }
        }

        if (tableControllers.isEmpty) {
          tableControllers.add(
            List.generate(headers.length, (_) => TextEditingController()),
          );
          enablerStates.add(List.generate(headers.length, (_) => false));
        }
        if (kpiControllers.isEmpty) {
          kpiControllers.add(TextEditingController());
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
                padding: const EdgeInsets.all(16),
                color: maroon,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
                          0: FlexColumnWidth(3),
                          1: FlexColumnWidth(1),
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
                                              selectedKra?.strategicObjective ??
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
                              // KP Fields Column
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    for (
                                      int i = 0;
                                      i < kpiControllers.length;
                                      i++
                                    )
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              'KP ${i + 1}: ',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Expanded(
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
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                setStateDialog(() {
                                                  kpiControllers.removeAt(i);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton.icon(
                                        onPressed: () {
                                          setStateDialog(() {
                                            kpiControllers.add(
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
                                          style: TextStyle(color: primaryColor),
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

                                    // Table Rows
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
                                            return IconButton(
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
                                                });
                                              },
                                            );
                                          }

                                          if (col == 1) {
                                            return Checkbox(
                                              value:
                                                  enablerStates[rowIndex][col],
                                              onChanged: (v) {
                                                setStateDialog(
                                                  () =>
                                                      enablerStates[rowIndex][col] =
                                                          v ?? false,
                                                );
                                              },
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
                      const SizedBox(height: 12),
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
                            });
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
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: primaryColor),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () async {
                    final List<DeliverableGroup> allDeliverableGroups = [];

                    for (int r = 0; r < tableControllers.length; r++) {
                      final controllers = tableControllers[r];
                      final List<RoadmapDeliverableItem> items = [];

                      for (int c = 3; c < headers.length; c++) {
                        if (controllers[c].text.trim().isNotEmpty) {
                          items.add(
                            RoadmapDeliverableItem(
                              id: 0,
                              deliverableDescription: controllers[c].text,
                              year: yearColumns[c - 3],
                              kraDescription: controllers[2].text,
                              isEnabler: enablerStates[r][1],
                              isDeleted: false,
                              rowVersion: '',
                            ),
                          );
                        }
                      }

                      if (items.isNotEmpty) {
                        allDeliverableGroups.add(
                          DeliverableGroup(
                            id: 0,
                            kraDescription: controllers[2].text,
                            items: items,
                            isDeleted: false,
                            rowVersion: '',
                          ),
                        );
                      }
                    }
                    final roadmap = Roadmap(
                      isEdit ? roadmapToEdit.id : 0,
                      selectedKra!.id,
                      selectedKra,
                      period.id,
                      period,
                      allDeliverableGroups,
                      kpList
                          .map((k) => KpiRoadmap(id: 0, kpiDescription: k))
                          .toList(),
                      isDeleted: false,
                      rowVersion: '',
                    );

                    if (isEdit) {
                      await _roadmapService.updateRoadmap(roadmap);

                      MotionToast.success(
                        toastAlignment: Alignment.topCenter,
                        description: const Text('Updated successfully'),
                      ).show(context);
                    } else {
                      await _roadmapService.createRoadmap(roadmap);

                      MotionToast.success(
                        toastAlignment: Alignment.topCenter,
                        description: const Text('Saved successfully'),
                      ).show(context);
                    }
                    setState(() {
                      fetchRoadmap();
                    });
                    if (context.mounted) {
                      Navigator.pop(context, true);
                    }
                  },

                  child: Text(
                    isEdit ? "Update" : "Save",
                    style: const TextStyle(color: Colors.white),
                  ),
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
            child: FutureBuilder<List<KeyResultArea>>(
              future: _commonService.fetchKra(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Failed to load periods');
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
                      title: Text(kra.name),
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

  void showPeriodPanel({KeyResultArea? selectedKra}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
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
                        // onChanged: filterSearchResults,
                      ),
                    ),
                    if (!isMinimized)
                      ElevatedButton.icon(
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
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        showRoadmapFormDialog(
                                          matchedKraPeriod,
                                          selectedKra: matchedKra,
                                          roadmapToEdit: roadmap,
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
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: primaryColor,
                                      ),
                                      onPressed: () {
                                        showDeleteDialog(roadmap.id.toString());
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
              ? FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () => showProcess(),
                child: Icon(Icons.add, color: Colors.white),
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
