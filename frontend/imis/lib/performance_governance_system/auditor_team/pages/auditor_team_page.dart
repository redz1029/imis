import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/auditor/models/auditor.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/auditor_team/models/auditor_team.dart';
import 'package:imis/performance_governance_system/team/models/team.dart';
import 'package:imis/utils/api_endpoint.dart';
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

  final dio = Dio();

  Future<void> fetchAuditorTeam() async {
    var url = ApiEndpoint().auditorteam;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        debugPrint("Error: Access token is missing!");
        return;
      }

      var response = await dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && response.data is List) {
        List<AuditorTeam> data =
            (response.data as List)
                .map((auditorTeam) => AuditorTeam.fromJson(auditorTeam))
                .toList();

        if (mounted) {
          setState(() {
            auditorTeamList =
                data.map((auditorTeam) => auditorTeam.toJson()).toList();
            filteredListTeamAuditor = List.from(auditorTeamList);
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

  Future<void> fetchTeam() async {
    var url = ApiEndpoint().team;

    try {
      var response = await dio.get(url);

      if (response.statusCode == 200 && response.data is List) {
        List<Team> data =
            (response.data as List).map((team) => Team.fromJson(team)).toList();

        if (mounted) {
          setState(() {
            teamList = data.map((team) => team.toJson()).toList();
            filteredList = List.from(
              teamList,
            ); // Ensure filtered list is populated
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

  Future<void> fetchAuditors() async {
    var url = ApiEndpoint().auditor;

    try {
      var response = await dio.get(url);

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
        debugPrint("Unexpected response format: ${response.data.runtimeType}");
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data ?? e.message}");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
  }

  Future<void> addOrUpdateAuditorTeam(AuditorTeam auditorTeam) async {
    var url = ApiEndpoint().auditorteam;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        debugPrint("Error: Access token is missing!");
        return;
      }

      final Map<String, dynamic> requestData = auditorTeam.toJson();
      final response = await dio.post(
        url,
        data: requestData,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchAuditorTeam();
      } else {
        debugPrint(
          "Failed to add/update office. Status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("Error adding/updating office: $e");
    }
  }

  Future<void> deleteAuditorTeam(String kraId) async {
    var url = ApiEndpoint().keyresult;
    try {
      final response = await dio.delete(url);

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
                ), // Filter based on the query
              )
              .toList();
    });
  }

  String getAuditorsNameById(int id, List<Map<String, dynamic>> auditorList) {
    final auditors = auditorList.firstWhere(
      (auditors) => auditors['id'] == id,
      orElse: () => {'name': 'Unknown Auditors'},
    );
    return auditors['name'] ?? 'Unknown Auditors';
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
                          child: Text('Team', style: TextStyle(color: grey)),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Auditors',
                            style: TextStyle(color: grey),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text('Actions', style: TextStyle(color: grey)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children:
                            uniqueTeams
                                .asMap()
                                .map((index, audiorTeam) {
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
                                                (index + 1).toString(),
                                                overflow: TextOverflow.ellipsis,
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
                                                getTeamNameById(
                                                  audiorTeam['teamId'],
                                                  teamList,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              // child: Text(
                                              //   // audiorTeam['auditors'],
                                              // ),
                                            ),
                                          ),

                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: () {
                                                    showFormDialog(
                                                      id: audiorTeam['id'],
                                                      teamId:
                                                          (audiorTeam['teamId'] ??
                                                                  '')
                                                              .toString(),
                                                      auditors:
                                                          audiorTeam['auditors'],

                                                      // auditors:
                                                      //     audiorTeam['auditors'],
                                                    );
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: primaryColor,
                                                  ),
                                                  onPressed:
                                                      () => showDeleteDialog(
                                                        audiorTeam['id']
                                                            .toString(),
                                                      ),
                                                ),
                                              ],
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
