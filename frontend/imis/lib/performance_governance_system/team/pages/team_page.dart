import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/team/models/team.dart';
import 'package:imis/utils/api_endpoint.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  List<Team> teamList = [];
  List<Team> filteredList = [];

  final TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();
  final dio = Dio();

  Future<void> fetchTeam() async {
    var url = ApiEndpoint().team;

    try {
      var response = await dio.get(url);

      if (response.statusCode == 200 && response.data is List) {
        List<Team> data =
            (response.data as List)
                .map((team) => Team.fromJson(team))
                .where((team) => team.isDeleted == false)
                .toList();

        if (mounted) {
          setState(() {
            teamList = data;
            filteredList = List.from(teamList);
          });
        }
      } else {
        debugPrint("Unexpected response: ${response.data}");
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
    }
  }

  Future<void> addOrUpdateTeam(Team team) async {
    var url = ApiEndpoint().team;
    try {
      final response = await dio.post(url, data: team.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchTeam();
      } else {
        debugPrint(" Save failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint(" Error adding/updating team: $e");
    }
  }

  // Future<void> deleteTeam(String teamId) async {
  //   var url = ApiEndpoint().team;

  //   try {
  //     final response = await dio.put(url, data: {"isDeleted": true});

  //     if (response.statusCode == 200) {
  //       setState(() {
  //         // ignore: unrelated_type_equality_checks
  //         filteredList.removeWhere((team) => team.id == teamId);
  //       });

  //       await fetchTeam();
  //     } else {
  //       debugPrint("Failed to soft delete team: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     debugPrint("Error soft deleting team: $e");
  //   }
  // }
  Future<void> deleteTeam(String teamId) async {
    var url = "${ApiEndpoint().team}/$teamId"; // target specific team endpoint

    try {
      final response = await dio.post(
        url, // Using POST if that's the supported method
        data: {"isActive": true},
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
    isSearchfocus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredList =
          teamList
              .where(
                (team) => team.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 350,
                height: 65,
                child: TextField(
                  controller: teamController,
                  decoration: InputDecoration(
                    labelText: 'Team Name',
                    border: OutlineInputBorder(),
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
            Expanded(
              child: Column(
                children: [
                  Container(
                    color: secondaryColor,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                            filteredList.asMap().entries.map((entry) {
                              int index = entry.key;
                              Team team = entry.value;
                              return Container(
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
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text((index + 1).toString()),
                                    ),
                                    Expanded(flex: 3, child: Text(team.name)),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed:
                                                () => showFormDialog(
                                                  id: team.id.toString(),
                                                  name: team.name,
                                                ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: primaryColor,
                                            ),
                                            onPressed:
                                                () => showDeleteDialog(
                                                  team.id.toString(),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
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
