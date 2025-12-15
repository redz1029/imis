import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/roadmap/models/kpi_roadmap.dart';
import 'package:imis/roadmap/models/roadmap.dart';
import 'package:imis/roadmap/models/roadmap_deliverables.dart';
import 'package:imis/roadmap/services/roadmap_service.dart';
import 'package:imis/widgets/pagination_controls.dart';
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
  final List<RoadmapDeliverables> deliverables = [];
  List<KeyResultArea> kraList = [];
  List<KraRoadmapPeriod> kraPeriodList = [];

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

    final List<int> yearColumns = [];
    for (int y = startYear; y <= endYear; y += 2) {
      yearColumns.add(y);
    }

    final List<String> headers = [
      'Action',
      'Enablers',
      'KRA',
      ...yearColumns.map((y) => y.toString()),
    ];
    final String title =
        selectedKra != null ? '${selectedKra.name} ROADMAP' : 'ROADMAP';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        List<List<String>> tableRows = [
          List.generate(headers.length, (_) => ''),
        ];

        List<List<bool>> enablerStates = [
          List.generate(tableRows[0].length, (_) => false),
        ];

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
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: const BoxDecoration(color: maroon),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // KP section (unchanged)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(selectedKra?.strategicObjective ?? ''),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Key Priorities",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              ...kpList.map(
                                (kp) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      hintText: kp,
                                    ),
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  setStateDialog(() {
                                    kpList.add("KP${kpList.length + 1}");
                                  });
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: primaryColor,
                                ),
                                label: const Text(
                                  "Add KP",
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Table
                    const Text(
                      "Roadmap Table",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Table(
                        border: TableBorder.all(),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: columnWidths,
                        children: [
                          // Header row
                          TableRow(
                            children:
                                headers.map((header) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      header,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                          ...tableRows.asMap().entries.map((entry) {
                            int rowIndex = entry.key;
                            List<String> row = entry.value;

                            return TableRow(
                              children: List.generate(headers.length, (
                                colIndex,
                              ) {
                                if (colIndex == 0) {
                                  return IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: primaryColor,
                                    ),
                                    onPressed: () {
                                      setStateDialog(() {
                                        tableRows.removeAt(rowIndex);
                                        enablerStates.removeAt(rowIndex);
                                      });
                                    },
                                  );
                                }

                                if (colIndex == 1) {
                                  return Checkbox(
                                    value: enablerStates[rowIndex][colIndex],
                                    onChanged: (val) {
                                      setStateDialog(() {
                                        enablerStates[rowIndex][colIndex] =
                                            val ?? false;
                                      });
                                    },

                                    activeColor: mainBgColor,
                                    checkColor: Colors.black,
                                  );
                                }

                                return Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 20,
                                        horizontal: 12,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      row[colIndex] = value;
                                    },
                                  ),
                                );
                              }),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          setStateDialog(() {
                            tableRows.add(
                              List.generate(headers.length, (_) => ''),
                            );
                            enablerStates.add(
                              List.generate(headers.length, (_) => false),
                            );
                          });
                        },
                        icon: const Icon(Icons.add, color: primaryColor),
                        label: const Text(
                          "Add Row to Table",
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: primaryColor),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
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
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),

                  onPressed: () async {
                    try {
                      for (
                        int rowIndex = 0;
                        rowIndex < tableRows.length;
                        rowIndex++
                      ) {
                        final row = tableRows[rowIndex];

                        final String kraDescription = row[2];

                        final bool isEnabler = enablerStates[rowIndex][1];

                        final List<RoadmapDeliverables> deliverables = [];

                        for (
                          int colIndex = 3;
                          colIndex < headers.length;
                          colIndex++
                        ) {
                          final text = row[colIndex];

                          if (text.trim().isNotEmpty) {
                            deliverables.add(
                              RoadmapDeliverables(
                                id: 0,
                                description: text,
                                year: yearColumns[colIndex - 3],
                                isDeleted: false,
                                rowVersion: '',
                              ),
                            );
                          }
                        }

                        final List<KpiRoadmap> kpis =
                            kpList
                                .map(
                                  (kp) => KpiRoadmap(id: 0, kpiDescription: kp),
                                )
                                .toList();

                        final roadmap = Roadmap(
                          0,
                          selectedKra!.id,
                          selectedKra,
                          period.id,
                          period,
                          kraDescription,
                          isEnabler,
                          deliverables,
                          kpis,
                          rowVersion: '',
                          isDeleted: false,
                        );
                        await _roadmapService.createRoadmap(roadmap);
                      }

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    } catch (e, stack) {
                      debugPrint("Error saving roadmap: $e");
                      debugPrint(stack.toString());
                    }
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
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Process (Core & Support)'),
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
                      trailing: const Icon(Icons.chevron_right),
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
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Roadmap Period'),
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
                      trailing: const Icon(Icons.chevron_right),
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
                      DataColumn2(label: Text('Kra'), size: ColumnSize.L),
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
                                  false,
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
                                        showRoadmapFormDialog(); // to be fixd
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: primaryColor,
                                      ),
                                      onPressed: () {
                                        // showDeleteDialog(kra.id.toString());
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
                onPressed: () => showPeriodPanel(),
                child: Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }
}
