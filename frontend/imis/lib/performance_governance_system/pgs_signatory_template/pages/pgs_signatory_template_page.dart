import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/auditor_team/models/auditor_team.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/utils/token_expiration_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pgs_signatory_template.dart';

class PgsSignatoryTemplateNewPage extends StatefulWidget {
  const PgsSignatoryTemplateNewPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PgsSignatoryTemplateNewPageState createState() =>
      _PgsSignatoryTemplateNewPageState();
}

class _PgsSignatoryTemplateNewPageState
    extends State<PgsSignatoryTemplateNewPage> {
  List<Map<String, dynamic>> signatoryTemplateList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();
  List<Map<String, dynamic>> filteredListSignatoryTemplate = [];
  List<Map<String, dynamic>> filteredListSignatories = [];
  List<Map<String, dynamic>> selectedSignatory = [];
  List<Map<String, dynamic>> officeList = [];
  List<Map<String, dynamic>> signatoryList = [];

  List<PgsSignatoryTemplate> addSignatories = [];
  int? selectOffice;

  int? selectAuditor;
  String? selectTeamText;
  List<User> userList = [];
  List<User> filteredListUser = [];
  String? selectedUserId;
  TextEditingController signatoryLabelController = TextEditingController();
  TextEditingController signatoryStatusController = TextEditingController();
  final _paginationUtils = PaginationUtil(Dio());

  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;

  final dio = Dio();

  Future<void> fetchSignatoryTemplate({
    int page = 1,
    String? searchQuery,
  }) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _paginationUtils
          .fetchPaginatedData<PgsSignatoryTemplate>(
            endpoint: ApiEndpoint().signatoryTemplate,
            page: page,
            pageSize: _pageSize,
            searchQuery: searchQuery,
            fromJson: (json) => PgsSignatoryTemplate.fromJson(json),
          );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          signatoryTemplateList =
              pageList.items.map((a) => a.toJson()).toList();
          filteredListSignatoryTemplate = List.from(signatoryTemplateList);
        });
      }
    } catch (e) {
      debugPrint("Error in fetchAuditSchedule: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> fetchUser() async {
    var url = ApiEndpoint().users;
    try {
      final response = await AuthenticatedRequest.get(dio, url);
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
              selectedUserId = filteredListUser[0].id;
            }
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  Future<void> fetchOffice() async {
    final url = ApiEndpoint().office;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        debugPrint("Error: Access token is missing!");
        return;
      }

      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<Office> data =
            (response.data as List)
                .map((team) => Office.fromJson(team))
                .toList();

        if (mounted) {
          setState(() {
            officeList = data.map((team) => team.toJson()).toList();
            filteredList = List.from(officeList);
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

  Future<void> fetchSignatories() async {
    var url = ApiEndpoint().users;

    try {
      var response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<User> data =
            (response.data as List)
                .map((auditor) => User.fromJson(auditor))
                .toList();

        if (mounted) {
          setState(() {
            signatoryList = data.map((auditor) => auditor.toJson()).toList();
            filteredListSignatories = List.from(signatoryList);
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

  Future<void> addOrUpdateSignatoryTemplate(AuditorTeam auditorTeam) async {
    var url = ApiEndpoint().auditorteam;

    try {
      final Map<String, dynamic> requestData = auditorTeam.toJson();
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchSignatoryTemplate();
      } else {
        debugPrint("Failed to add/update office");
      }
    } catch (e) {
      debugPrint("Error adding/updating office: $e");
    }
  }

  Future<void> deleteSignatoryTemplate(String kraId) async {
    var url = ApiEndpoint().keyresult;
    try {
      final response = await AuthenticatedRequest.delete(dio, url);

      if (response.statusCode == 200) {
        await fetchSignatoryTemplate();
      }
    } catch (e) {
      debugPrint("Error deleting KRA: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    isSearchfocus.addListener(() {
      setState(() {});
    });
    fetchUser();
    fetchOffice();
    fetchSignatories();
    fetchSignatoryTemplate();
    if (filteredListUser.isNotEmpty) {
      selectedUserId = filteredListUser[0].id;
    }
    TokenExpirationHandler(context).checkTokenExpiration();
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  void showFormDialog({
    String? id,
    bool isDeleted = false,
    String? defaultSignatoryId,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: mainBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              title: Text(
                id == null
                    ? 'Create Signatory Template'
                    : 'Edit Signatory Template',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: 400,
                height: 500,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Team Dropdown
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Stack(
                          children: [
                            DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<int>(
                                dropdownColor: mainBgColor,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: 'Select Office',
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                value: selectOffice,
                                items:
                                    officeList.map((team) {
                                      return DropdownMenuItem<int>(
                                        value: team['id'],
                                        child: Text(team['name']),
                                      );
                                    }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectOffice = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      gap3,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("List of Signatories"),
                      ),

                      // Display added signatories
                      if (selectedSignatory.isNotEmpty)
                        Column(
                          children: [
                            gap,
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: selectedSignatory.length,
                              itemBuilder: (context, index) {
                                final signatory = selectedSignatory[index];
                                return ListTile(
                                  title: Text(
                                    "${signatory['label']} : ",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    signatory['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: primaryTextColor,
                                        ),

                                        onPressed: () {
                                          showSignatoryDialog(
                                            context: context,
                                            setDialogState: setDialogState,
                                            index: index,
                                            signatory: signatory,
                                          );
                                        },
                                      ),
                                      // Delete Button
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: primaryTextColor,
                                        ),
                                        onPressed: () {
                                          setDialogState(() {
                                            selectedSignatory.removeAt(index);
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton.icon(
                          onPressed: () {
                            showSignatoryDialog(
                              context: context,
                              setDialogState: setDialogState,
                            );
                          },
                          icon: Icon(Icons.add, color: primaryColor),
                          label: Text(
                            "Add new Signatory",
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
                  style: ElevatedButton.styleFrom(
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
                              child: Text(
                                "No",
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(
                                "Yes",
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    if (confirmAction == true) {
                      List<PgsSignatoryTemplate> signatories = [];

                      if (selectedSignatory.isNotEmpty) {
                        for (var signatory in selectedSignatory) {
                          signatories.add(
                            PgsSignatoryTemplate(
                              int.tryParse(id ?? '0') ?? 0,
                              isDeleted,
                              signatory['level'],
                              signatory['userId'],
                              true,
                              status: signatory['status'] ?? '',
                              signatoryLabel: signatory['label'] ?? '',
                              officeId: selectOffice ?? 0,
                            ),
                          );
                        }
                      }

                      await addOrUpdateSignatory(signatories);
                      // ignore: use_build_context_synchronously
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
      },
    );
  }

  Future<void> addOrUpdateSignatory(
    List<PgsSignatoryTemplate> signatories,
  ) async {
    var url = ApiEndpoint().signatoryTemplate;
    try {
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: signatories.map((s) => s.toJson()).toList(),
      );

      if (response.statusCode == 200) {
        setState(() {});
      }
    } catch (e) {
      debugPrint("Error adding/updating pgs: $e");
    }
  }

  void showSignatoryDialog({
    required BuildContext context,
    required Function setDialogState,
    int? index,
    Map<String, dynamic>? signatory,
    String? selectedUserId,
  }) {
    final signatoryLabelController = TextEditingController(
      text: signatory?['label'] ?? '',
    );
    final signatoryStatusController = TextEditingController(
      text: signatory?['status'] ?? '',
    );
    // ignore: no_leading_underscores_for_local_identifiers
    int _value = signatory?['level'] ?? 1;
    // ignore: no_leading_underscores_for_local_identifiers
    String? _selectedUserId = signatory?['id'] ?? selectedUserId;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: mainBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              title: Text(
                index != null ? 'Edit Signatory' : 'Enter Signatory Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                height: 200,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 480,
                      child: DropdownButtonFormField<String>(
                        value:
                            filteredListUser.any(
                                  (user) => user.id == _selectedUserId,
                                )
                                ? _selectedUserId
                                : null,
                        decoration: InputDecoration(
                          labelText: 'Signatory Name',
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
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a user';
                          }
                          return null;
                        },
                      ),
                    ),
                    gap,
                    TextField(
                      controller: signatoryLabelController,
                      decoration: InputDecoration(
                        labelText: 'Signatory Label',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    gap,
                    Row(
                      children: [
                        // Signatory Status
                        Expanded(
                          child: SizedBox(
                            child: TextField(
                              controller: signatoryStatusController,
                              decoration: InputDecoration(
                                labelText: 'Signatory Status',
                                border: OutlineInputBorder(),
                              ),
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        // Level Spinner
                        SizedBox(
                          width: 120,
                          height: 48,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '$_value',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () => setState(() => _value++),
                                      child: Icon(
                                        Icons.arrow_drop_up,
                                        size: 20,
                                      ),
                                    ),
                                    InkWell(
                                      onTap:
                                          () => setState(() {
                                            if (_value > 1) _value--;
                                          }),
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
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
                  onPressed: () {
                    if (_selectedUserId == null || _selectedUserId!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a signatory')),
                      );
                      return;
                    }

                    final selectedUser = filteredListUser.firstWhere(
                      (user) => user.id == _selectedUserId,
                      orElse: () => throw Exception('User not found'),
                    );

                    final result = {
                      'userId': _selectedUserId,
                      'name': selectedUser.fullName,
                      'label': signatoryLabelController.text,
                      'status': signatoryStatusController.text,
                      'level': _value,
                    };

                    if (index != null) {
                      // Editing existing signatory
                      setDialogState(() {
                        selectedSignatory[index] = result;
                      });
                      Navigator.pop(context);
                    } else {
                      // Creating new signatory
                      Navigator.pop(context, result);
                    }
                  },
                  child: Text(
                    index != null ? 'Save Changes' : 'Create',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((value) {
      if (value != null && index == null) {
        // Only for create operation
        setDialogState(() {
          selectedSignatory.add(value);
        });
      }
    });
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredList =
          signatoryTemplateList
              .where(
                (auditorTeam) => auditorTeam['name']!.toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList();
    });
  }

  Map<int, List<Map<String, dynamic>>> groupByOfficeId(
    List<Map<String, dynamic>> list,
  ) {
    Map<int, List<Map<String, dynamic>>> grouped = {};

    for (var item in list) {
      int? officeId = item['officeId'];
      if (officeId == null) continue;

      if (!grouped.containsKey(officeId)) {
        grouped[officeId] = [];
      }
      grouped[officeId]!.add(item);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;
    final groupedData = groupByOfficeId(filteredListSignatoryTemplate);

    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: Text('Signatoy Template Information'),
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
                      labelText: 'Search Signatory',
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
            gap,
            Expanded(
              child: ListView(
                children:
                    groupedData.entries.map((entry) {
                      final officeId = entry.key;
                      final signatories = entry.value;

                      return Card(
                        color: secondaryColor,
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            collapsedBackgroundColor: secondaryColor,
                            backgroundColor: secondaryBgButton,
                            tilePadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            childrenPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            title: Text(
                              'Office ID: $officeId',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.expand_more,
                              color: Colors.black,
                            ),
                            children:
                                signatories.map((signatory) {
                                  return ListTile(
                                    title: Text(
                                      signatory['signatoryLabel'] ?? 'No Label',
                                    ),
                                    subtitle: Text(
                                      'ID: ${signatory['defaultSignatoryId'] ?? 'No ID'}',
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
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
                    onPageChanged: (page) => fetchSignatoryTemplate(page: page),
                  ),
                  Container(width: 60),
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

  void showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete this Auditor Team? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: primaryTextColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await deleteSignatoryTemplate(id);
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
