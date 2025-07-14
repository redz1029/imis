import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/auditor/models/auditor.dart';
import 'package:imis/auditor_team/models/auditor_team.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/utils/token_expiration_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuditorTeamPage extends StatefulWidget {
  const AuditorTeamPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuditorTeamPageState createState() => _AuditorTeamPageState();
}

class _AuditorTeamPageState extends State<AuditorTeamPage> {
  List<Map<String, dynamic>> auditorTeamList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();
  List<Map<String, dynamic>> filteredListTeamAuditor = [];
  List<Map<String, dynamic>> filteredListAuditor = [];
  List<Map<String, dynamic>> selectedAuditors = [];
  List<Map<String, dynamic>> teamList = [];
  List<Map<String, dynamic>> auditorList = [];
  int? selectTeam;
  int? selectAuditor;
  String? selectTeamText;

  final _paginationUtils = PaginationUtil(Dio());

  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;

  final dio = Dio();

  Future<void> fetchAuditorTeam({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _paginationUtils.fetchPaginatedData<AuditorTeam>(
        endpoint: ApiEndpoint().auditorteam,
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
        fromJson: (json) => AuditorTeam.fromJson(json),
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          auditorTeamList = pageList.items.map((a) => a.toJson()).toList();
          filteredListTeamAuditor = List.from(auditorTeamList);
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

  Future<void> fetchTeam() async {
    final url = ApiEndpoint().team;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        debugPrint("Error: Access token is missing!");
        return;
      }

      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<Team> data =
            (response.data as List).map((team) => Team.fromJson(team)).toList();

        if (mounted) {
          setState(() {
            teamList = data.map((team) => team.toJson()).toList();
            filteredList = List.from(teamList);
          });
        }
      } else {
        debugPrint("Unexpected response format");
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
  }

  Future<void> fetchAuditors() async {
    var url = ApiEndpoint().auditor;

    try {
      var response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<Auditor> data =
            (response.data as List)
                .map((auditor) => Auditor.fromJson(auditor))
                .toList();

        if (mounted) {
          setState(() {
            auditorList = data.map((auditor) => auditor.toJson()).toList();
            filteredListAuditor = List.from(auditorList);
          });
        }
      } else {
        debugPrint("Unexpected response format");
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
  }

  Future<void> addOrUpdateAuditorTeam(AuditorTeam auditorTeam) async {
    var url = ApiEndpoint().auditorteam;

    try {
      final Map<String, dynamic> requestData = auditorTeam.toJson();
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchAuditorTeam();
      } else {
        debugPrint("Failed to add/update audtor team");
      }
    } catch (e) {
      debugPrint("Error adding/updating audtor team: $e");
    }
  }

  Future<void> deleteAuditorTeam(String kraId) async {
    var url = ApiEndpoint().keyresult;
    try {
      final response = await AuthenticatedRequest.delete(dio, url);

      if (response.statusCode == 200) {
        await fetchAuditorTeam();
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
    fetchTeam();
    fetchAuditors();
    fetchAuditorTeam();
    TokenExpirationHandler(context).checkTokenExpiration();
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  void showFormDialog({String? id, String? teamId, List<dynamic>? auditors}) {
    selectTeam = teamId != null ? int.tryParse(teamId) : null;
    if (teamId != null && auditors != null) {
      selectedAuditors =
          auditors
              .map((auditor) => {'id': auditor.id, 'name': auditor.name})
              .toList();
    } else {
      selectedAuditors = [];
    }

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
                id == null ? 'Create Auditor Team' : 'Edit Auditor Team',
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
                                  labelText: 'Choose Team',
                                  filled: true,
                                  fillColor: secondaryColor,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                value: selectTeam,
                                items:
                                    teamList.map((team) {
                                      return DropdownMenuItem<int>(
                                        value: team['id'],
                                        child: Text(team['name']),
                                      );
                                    }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectTeam = value;
                                  });
                                },
                              ),
                            ),
                            if (selectTeam != null)
                              Positioned.fill(
                                child: AbsorbPointer(
                                  child: Container(color: Colors.transparent),
                                ),
                              ),
                          ],
                        ),
                      ),

                      gap3,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("List of Auditors"),
                      ),
                      gap,

                      // Selected Auditors
                      ...selectedAuditors.map((auditor) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                auditor['name'],
                                style: TextStyle(color: primaryTextColor),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: primaryTextColor,
                                ),
                                onPressed: () {
                                  setDialogState(() {
                                    selectedAuditors.remove(auditor);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }),

                      Align(
                        alignment: Alignment.center,
                        child: TextButton.icon(
                          onPressed: () {
                            showAvailableAuditorsDialog(setDialogState);
                          },
                          icon: Icon(Icons.add, color: primaryColor),
                          label: Text(
                            "Add new auditor",
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
                      List<Auditor> auditors =
                          selectedAuditors
                              .map((a) => Auditor(id: a['id'], name: a['name']))
                              .toList();

                      final auditorTeam = AuditorTeam(
                        selectTeam ?? 0,
                        auditors,
                        true,
                      );

                      await addOrUpdateAuditorTeam(auditorTeam);
                      if (context.mounted) Navigator.pop(context);
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

  void showAvailableAuditorsDialog(Function setDialogState) {
    final assignedAuditorIds =
        auditorTeamList.expand((auditorTeam) {
          final auditors = auditorTeam['auditors'] ?? [];
          return auditors.map((auditor) {
            if (auditor is Map<String, dynamic>) {
              return auditor['id'];
            } else if (auditor is Auditor) {
              return auditor.id;
            } else {
              return null;
            }
          }).whereType<dynamic>();
        }).toSet();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(
            'Select Auditor',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 400,
            height: 400,
            child: ListView(
              children:
                  auditorList
                      .where(
                        (auditor) =>
                            !selectedAuditors.any(
                              (sel) => sel['id'] == auditor['id'],
                            ) &&
                            !assignedAuditorIds.contains(auditor['id']),
                      )
                      .map((auditor) {
                        return ListTile(
                          title: Text(auditor['name']),
                          trailing: Icon(Icons.person_add, color: primaryColor),
                          onTap: () {
                            setDialogState(() {
                              selectedAuditors.add({
                                'id': auditor['id'],
                                'name': auditor['name'],
                              });
                            });
                            Navigator.pop(context);
                          },
                        );
                      })
                      .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close', style: TextStyle(color: primaryColor)),
            ),
          ],
        );
      },
    );
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredList =
          auditorTeamList
              .where(
                (auditorTeam) => auditorTeam['name']!.toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList();
    });
  }

  String getTeamNameById(int id, List<Map<String, dynamic>> teamList) {
    final team = teamList.firstWhere(
      (team) => team['id'] == id,
      orElse: () => {'name': 'Unknown Team'},
    );
    return team['name'] ?? 'Unknown Team';
  }

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;

    final uniqueTeams =
        {
          for (var item in filteredListTeamAuditor) item['teamId']: item,
        }.values.toList();

    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: Text('Auditor Team Information'),
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
                      labelText: 'Search Office',
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
              child: GridView.count(
                crossAxisCount: isMinimized ? 1 : 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.60,
                children:
                    uniqueTeams
                        .asMap()
                        .map((index, audiorTeam) {
                          // int itemNumber =
                          //     ((_currentPage - 1) * _pageSize) + index + 1;
                          return MapEntry(
                            index,
                            Card(
                              color: secondaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    // Team name - centered
                                    Center(
                                      child: Text(
                                        getTeamNameById(
                                          audiorTeam['teamId'],
                                          teamList,
                                        ),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: primaryTextColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // List of auditors - aligned to the left
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'List of Auditors',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount:
                                                  (audiorTeam['auditors']
                                                          as List<Auditor>)
                                                      .length,
                                              itemBuilder: (context, i) {
                                                final auditor =
                                                    (audiorTeam['auditors']
                                                        as List<Auditor>)[i];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 2,
                                                      ),
                                                  child: Text(
                                                    auditor.name ?? '',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // Bottom-right action buttons
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            showFormDialog(
                                              id: audiorTeam['id'],
                                              teamId:
                                                  (audiorTeam['teamId'] ?? '')
                                                      .toString(),
                                              auditors: audiorTeam['auditors'],
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: primaryColor,
                                          ),
                                          onPressed: () {
                                            showDeleteDialog(
                                              audiorTeam['id'].toString(),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                        .values
                        .toList(),
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
                    onPageChanged: (page) => fetchAuditorTeam(page: page),
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
                await deleteAuditorTeam(id);
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
