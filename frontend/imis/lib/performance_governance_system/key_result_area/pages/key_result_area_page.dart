import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/utils/api_endpoint.dart';

class KeyResultAreaPage extends StatefulWidget {
  const KeyResultAreaPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _KeyResultAreaPageState createState() => _KeyResultAreaPageState();
}

class _KeyResultAreaPageState extends State<KeyResultAreaPage> {
  List<Map<String, dynamic>> kraList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  int maxVisiblePages = 4;

  @override
  void initState() {
    super.initState();
    fetchKRAs();
  }

  final dio = Dio();

  //fetch kra list
  Future<void> fetchKRAs() async {
    var url = ApiEndpoint().keyresult;

    try {
      var response = await dio.get(url);

      if (response.statusCode == 200 && response.data is List) {
        List<KeyResultArea> data =
            (response.data as List)
                .map((kra) => KeyResultArea.fromJson(kra))
                .toList();

        if (mounted) {
          setState(() {
            kraList = data.map((kra) => kra.toJson()).toList();
            filteredList = List.from(kraList);
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

  // Add or Update KRA list
  Future<void> addOrUpdateKRA(KeyResultArea kra) async {
    var url = ApiEndpoint().keyresult;
    try {
      final response = await dio.post(url, data: kra.toJson());

      if (response.statusCode == 201) {
        await fetchKRAs();
        setState(() {
          fetchKRAs();
        });
      }
    } catch (e) {
      print("Error adding/updating KRA: $e");
    }
  }

  //Delete KRA LIST

  Future<void> deleteKRA(String kraId) async {
    var url = ApiEndpoint().keyresult;
    try {
      final response = await dio.delete(url);

      if (response.statusCode == 200) {
        await fetchKRAs();
      }
    } catch (e) {
      print("Error deleting KRA: $e");
    }
  }

  //filtered result
  void filterSearchResults(String query) {
    setState(() {
      filteredList =
          kraList
              .where(
                (kra) =>
                    kra['name']!.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;

    int itemsPerPage = 14;
    int totalPage = (filteredList.length / itemsPerPage).ceil();
    int startPage = (currentPage - 1).clamp(1, totalPage - maxVisiblePages + 1);
    int endPage = (startPage + maxVisiblePages - 1).clamp(1, totalPage);

    var paginatedList =
        filteredList
            .skip((currentPage - 1) * itemsPerPage)
            .take(itemsPerPage)
            .toList();

    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: Text('Key Result Areas'),
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
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: lightGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Search KRA',
                      labelStyle: TextStyle(color: grey, fontSize: 14),
                      prefixIcon: Icon(Icons.search, size: 20),
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
            gap,
            Expanded(
              child: Column(
                children: [
                  Container(
                    color: secondaryColor,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text('#', style: TextStyle(color: grey)),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'KRA Name',
                            style: TextStyle(color: grey),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text('Remarks', style: TextStyle(color: grey)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text('Actions', style: TextStyle(color: grey)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: paginatedList.length,
                      itemBuilder: (context, index) {
                        var kra = paginatedList[index];
                        return Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 1,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  (index + 1 + (currentPage - 1) * itemsPerPage)
                                      .toString(),
                                ),
                              ),
                              Expanded(flex: 3, child: Text(kra['name'])),
                              Expanded(
                                flex: 3,
                                child: Text(kra['remarks'] ?? ''),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed:
                                          () => showFormDialog(
                                            id: kra['id'].toString(),
                                            name: kra['name'],
                                            remarks: kra['remarks'],
                                          ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: primaryColor,
                                      ),
                                      onPressed:
                                          () => showDeleteDialog(
                                            kra['id'].toString(),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            'Page $currentPage out of $totalPage',
                            style: TextStyle(
                              fontSize: 14,
                              color: primaryTextColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.chevron_left),
                                onPressed:
                                    currentPage > 1
                                        ? () {
                                          setState(() {
                                            currentPage--;
                                          });
                                        }
                                        : null,
                              ),

                              if (currentPage > 4)
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Text("..."),
                                ),
                              for (int i = startPage; i <= endPage; i++)
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        currentPage = i;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color:
                                            currentPage == i
                                                ? primaryColor
                                                : null,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        "$i",
                                        style: TextStyle(
                                          color:
                                              currentPage == i
                                                  ? Colors.white
                                                  : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (currentPage < 4)
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Text("..."),
                                ),

                              IconButton(
                                icon: Icon(Icons.chevron_right),
                                onPressed:
                                    currentPage < totalPage
                                        ? () {
                                          setState(() {
                                            currentPage++;
                                          });
                                        }
                                        : null,
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildPageButton(int page) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () {
          setState(() {
            currentPage = page;
          });
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: currentPage == page ? primaryColor : null,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            "$page",
            style: TextStyle(
              color: currentPage == page ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void showFormDialog({String? id, String? name, String? remarks}) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController remarksController = TextEditingController(
      text: remarks,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(
            id == null ? 'Add KRA' : 'Edit KRA',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 350,
                height: 65,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    focusColor: primaryColor,
                    floatingLabelStyle: TextStyle(color: primaryColor),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 350,
                height: 65,
                child: TextField(
                  controller: remarksController,
                  decoration: InputDecoration(
                    focusColor: primaryColor,
                    labelText: 'Remarks',
                    floatingLabelStyle: TextStyle(color: primaryColor),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryBgButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
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
                if (confirmAction == true) {
                  final kra = KeyResultArea(
                    int.tryParse(id ?? '0') ?? 0,
                    nameController.text,
                    remarksController.text,
                    false,
                  );

                  addOrUpdateKRA(kra);
                  Navigator.pop(context);
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

  void showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete this KRA? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: primaryTextColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog first
                await deleteKRA(id); // Call delete function
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
