import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';

class Roadmap extends StatefulWidget {
  const Roadmap({super.key});

  @override
  State<Roadmap> createState() => _RoadmapDialogPageState();
}

class _RoadmapDialogPageState extends State<Roadmap> {
  List<String> kpList = ["KP1"];
  List<List<String>> tableRows = [
    ["", "", "", "", "", "", ""],
  ];
  final FocusNode isSearchfocus = FocusNode();
  TextEditingController searchController = TextEditingController();
  List<KeyResultArea> filteredList = [];
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;

  void showRoadmapFormDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),

              titlePadding: EdgeInsets.zero,
              title: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(color: maroon),
                child: Text(
                  'ROADMAP',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  labelText: "Column 1",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Key Priorities",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              ...kpList.map(
                                (kp) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: kp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  setStateDialog(() {
                                    kpList.add("KP${kpList.length + 1}");
                                  });
                                },
                                icon: Icon(Icons.add),
                                label: Text("Add KP"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),
                    Text(
                      "Roadmap Table",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Table(
                        border: TableBorder.all(),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FixedColumnWidth(300),
                          1: FixedColumnWidth(300),
                          2: FixedColumnWidth(300),
                          3: FixedColumnWidth(300),
                          4: FixedColumnWidth(300),
                          5: FixedColumnWidth(300),
                          6: FixedColumnWidth(300),
                        },
                        children: [
                          TableRow(
                            children:
                                [
                                      "Enablers",
                                      "KRA",
                                      "2026",
                                      "2027",
                                      "2028",
                                      "2029",
                                      "2030",
                                    ]
                                    .map(
                                      (header) => Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          header,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                          ...tableRows.map(
                            (row) => TableRow(
                              children: List.generate(
                                row.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "",
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 20,
                                        horizontal: 12,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      row[index] = value;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () {
                        setStateDialog(() {
                          tableRows.add(["", "", "", "", "", "", ""]);
                        });
                      },
                      icon: Icon(Icons.add),
                      label: Text("Add Row to Table"),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Close"),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  child: Text("Save"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
    bool isMinimized = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: AppBar(title: Text("Roadmap Page")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 600;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle: TextStyle(color: grey, fontSize: 14),
                              labelText: 'Search...',
                              prefixIcon: Icon(
                                Icons.search,
                                color:
                                    isSearchfocus.hasFocus
                                        ? primaryColor
                                        : grey,
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
                            onPressed: () => showRoadmapFormDialog(),
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
                          horizontalInside: BorderSide(
                            color: Colors.grey.shade100,
                          ),
                        ),
                        columns: const [
                          DataColumn2(label: Text('#'), fixedWidth: 40),
                          DataColumn2(label: Text('Name'), size: ColumnSize.L),
                          DataColumn(label: Text('Description')),
                          DataColumn(label: Text('Strategic Objectives')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows:
                            filteredList.asMap().entries.map((entry) {
                              int index = entry.key;
                              var kra = entry.value;
                              int itemNumber =
                                  ((_currentPage - 1) * _pageSize) + index + 1;

                              return DataRow(
                                cells: [
                                  DataCell(Text(itemNumber.toString())),
                                  DataCell(Text(kra.name)),
                                  DataCell(Text(kra.remarks ?? '')),
                                  DataCell(Text(kra.strategicObjective ?? '')),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            showRoadmapFormDialog(
                                              // id: kra.id.toString(),
                                              // name: kra.name,
                                              // remarks: kra.remarks,
                                              // strategicObjective:
                                              //     kra.strategicObjective,
                                            );
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
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
