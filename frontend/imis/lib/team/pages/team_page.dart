import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:imis/constant/constant.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/utils/api_endpoint.dart';

import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:imis/widgets/permission_widget.dart';

import '../../utils/http_util.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  final _paginationUtils = PaginationUtil(Dio());
  late FilterSearchResultUtil<Team> teamSearchUtil;
  final _formKey = GlobalKey<FormState>();
  List<Team> teamList = [];
  List<Team> filteredList = [];

  final TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();

  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;

  final Dio dio = Dio();

  Future<void> fetchTeam({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _paginationUtils.fetchPaginatedData<Team>(
        endpoint: ApiEndpoint().team,
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
        fromJson: (json) => Team.fromJson(json),
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          teamList = pageList.items;
          filteredList = List.from(teamList);
        });
      }
    } catch (e) {
      debugPrint("Error in fetchTeam: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> addOrUpdateTeam(Team team) async {
    var url = ApiEndpoint().team;
    try {
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: team.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchTeam();
      } else {
        debugPrint(" Save failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint(" Error adding/updating team: $e");
    }
  }

  Future<void> deleteTeam(String teamId) async {
    var url = ApiEndpoint().team;

    try {
      final response = await AuthenticatedRequest.put(
        dio,
        url,
        data: {"isDeleted": true},
      );

      if (response.statusCode == 200) {
        setState(() {
          // ignore: unrelated_type_equality_checks
          filteredList.removeWhere((team) => team.id == teamId);
        });

        await fetchTeam();
      } else {
        debugPrint("Failed to soft delete team: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error soft deleting team: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTeam();
    teamSearchUtil = FilterSearchResultUtil<Team>(
      paginationUtils: _paginationUtils,
      endpoint: ApiEndpoint().team,
      pageSize: _pageSize,
      fromJson: (json) => Team.fromJson(json),
    );
    isSearchfocus.addListener(() {
      setState(() {});
    });
    PermissionService().loadPermissions(['ViewTeam', 'EditTeam', 'DeleteTeam']);
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  Future<void> filterSearchResults(String query) async {
    final results = await teamSearchUtil.filter(
      query,
      (team, search) =>
          (team.name).toLowerCase().contains(search.toLowerCase()),
    );

    setState(() {
      filteredList = results;
    });
  }

  void showFormDialog({
    String? id,
    bool isDeleted = false,
    String? name,
    bool isActive = false,
  }) {
    TextEditingController teamController = TextEditingController(text: name);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(
            id == null ? 'Add Team' : 'Edit Team',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 350,
                  height: 65,
                  child: TextFormField(
                    controller: teamController,
                    decoration: InputDecoration(
                      labelText: 'Team Name',
                      focusColor: primaryColor,
                      floatingLabelStyle: TextStyle(color: primaryColor),
                      border: OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please fill out this field';
                      }
                      return null;
                    },
                  ),
                ),
              ],
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
                if (_formKey.currentState!.validate()) {
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
                    final team = Team(
                      int.tryParse(id ?? '0') ?? 0,
                      teamController.text,
                      isActive,
                      isDeleted,
                      rowVersion: '',
                    );

                    await addOrUpdateTeam(team);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }
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

  String statusFilter = 'Active';

  final List<String> statusOptions = ['Active', 'Inactive'];

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: Text('Team Information'),
        backgroundColor: mainBgColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Search Bar
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
                      labelText: 'Search Team',
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

                gap4,

                // Status Dropdown
                SizedBox(
                  height: 30,
                  width: 140,
                  child: DropdownButtonFormField<String>(
                    dropdownColor: mainBgColor,
                    value: statusFilter,
                    onChanged: (value) {
                      setState(() {
                        statusFilter = value!;
                        filterSearchResults(searchController.text);
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: lightGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      filled: true,
                      fillColor: secondaryColor,
                    ),
                    items:
                        statusOptions.map((String status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                  ),
                ),
                Spacer(),

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
            SizedBox(height: 20),
            PermissionWidget(
              permission: 'ViewTeam',
              child: Expanded(
                child: Column(
                  children: [
                    Container(
                      color: secondaryColor,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('#', style: TextStyle(color: grey)),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text('Team', style: TextStyle(color: grey)),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Actions',
                              style: TextStyle(color: grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children:
                              filteredList
                                  .asMap()
                                  .map((index, team) {
                                    int itemNumber =
                                        ((_currentPage - 1) * _pageSize) +
                                        index +
                                        1;
                                    return MapEntry(
                                      index,
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 1,
                                          horizontal: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  right: 1,
                                                ),
                                                child: Text(
                                                  itemNumber.toString(),
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  right: 1,
                                                ),
                                                child: Text(
                                                  team.name, // Access role name directly
                                                  style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  right: 1,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    PermissionWidget(
                                                      permission: 'EditTeam',
                                                      child: IconButton(
                                                        icon: Icon(Icons.edit),
                                                        onPressed: () {
                                                          // Debug print
                                                          showFormDialog(
                                                            id:
                                                                team.id
                                                                    .toString(),
                                                            name: team.name,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(width: 1),
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color: primaryColor,
                                                      ),
                                                      onPressed:
                                                          () =>
                                                              showDeleteDialog(
                                                                team.id
                                                                    .toString(),
                                                              ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                                  .values
                                  .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
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
                    onPageChanged: (page) => fetchTeam(page: page),
                  ),
                  Container(width: 60), // For alignment
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
            "Are you sure you want to delete this Team? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: primaryTextColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await deleteTeam(id);
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
