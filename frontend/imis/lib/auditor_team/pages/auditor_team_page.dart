// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/auditor/models/auditor.dart';
import 'package:imis/auditor_team/models/auditor_team.dart';
import 'package:imis/auditor_team/services/auditor_team_service.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/team/services/team_service.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/widgets/custom_toggle.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:motion_toast/motion_toast.dart';

class AuditorTeamPage extends StatefulWidget {
  const AuditorTeamPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuditorTeamPageState createState() => _AuditorTeamPageState();
}

class _AuditorTeamPageState extends State<AuditorTeamPage> {
  final _adutiorTeamService = AuditorTeamService(Dio());
  final _commonService = CommonService(Dio());
  List<AuditorTeam> auditorTeamList = [];
  List<AuditorTeam> filteredList = [];
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();
  List<Map<String, dynamic>> selectedAuditors = [];
  List<Team> teamList = [];
  List<Auditor> auditorList = [];
   List<Map<String, dynamic>> filteredimprovementType = [];
     List<Map<String, dynamic>> filteredimprovement = [];
         String? _selectedimprovementTypeId;
         String? _selectedImprovementFilter;
  String? _selectedImprovementTypeFilter; // Filter: null = All, or specific ID

  int? selectTeam;
  int? selectAuditor;
  String? selectTeamText;
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;
final _teamService = TeamService(Dio());
  final dio = Dio();
List<User> userList = [];
  Future<void> fetchAuditorTeam({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _adutiorTeamService.getAuditorTeam(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          auditorTeamList = pageList.items;
          _applyImprovementTypeFilter();
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

  @override
  void initState() {
    super.initState();
    isSearchfocus.addListener(() {
      setState(() {});
    });
    fetchAuditorTeam();

    () async {
      final auditors = await _commonService.fetchAuditors();
      final team = await _commonService.fetchTeam();
      final users = await _commonService.fetchUsers();
      if (!mounted) return;

      setState(() {
        auditorList = auditors;
        teamList = team;
        userList = users;
      });
    }();

     _teamService
        .getImprovementType()
        .then((data) {
          if (mounted) {
            setState(() {
              filteredimprovement =
                  data.map((improvementType) => improvementType.toJson()).toList();
              filteredimprovementType = List.from(filteredimprovement);
              if (filteredimprovementType.isNotEmpty) {
                _selectedimprovementTypeId =
                    filteredimprovementType[0]['id'].toString();
              }
            });
          }
        })
        .catchError((error) {
          debugPrint("Failed to fetch data");
        });

    if (filteredimprovementType.isNotEmpty) {
      _selectedimprovementTypeId = filteredimprovementType[0]['id'].toString();
    }
  }

  String getUserFullName(String? userId) {
    if (userId == null || userList.isEmpty) return 'Unknown';
    final user = userList.firstWhere(
      (user) => user.id == userId,
      orElse: () => User(id: '', fullName: 'Unknown', position: ''),
    );
    return user.fullName;
  }

  // Check if auditor is already in another team with the same improvement type
  bool isAuditorInSameImprovementType(int auditorId, int currentTeamId) {
    // Get the improvement type of the currently selected team
    final currentTeam = teamList.firstWhere(
      (t) => t.id == currentTeamId,
      orElse: () => Team(0, '', false, false, improvementType: 0),
    );
    final currentImprovementType = currentTeam.improvementType;

    // Check all auditor teams
    for (var auditorTeam in auditorTeamList) {
      // Skip if it's the same team we're editing
      if (auditorTeam.teamId == currentTeamId) continue;

      // Get the team's improvement type
      final team = teamList.firstWhere(
        (t) => t.id == auditorTeam.teamId,
        orElse: () => Team(0, '', false, false, improvementType: 0),
      );

      // If same improvement type, check if auditor is in this team
      if (team.improvementType == currentImprovementType) {
        final hasAuditor = auditorTeam.auditors.any((a) => a.id == auditorId);
        if (hasAuditor) {
          return true; // Auditor found in another team with same improvement type
        }
      }
    }
    return false; // Auditor not in any other team with same improvement type
  }

  // Get the team name where auditor is already assigned (same improvement type)
  String? getAuditorExistingTeam(int auditorId, int currentTeamId) {
    final currentTeam = teamList.firstWhere(
      (t) => t.id == currentTeamId,
      orElse: () => Team(0, '', false, false, improvementType: 0),
    );
    final currentImprovementType = currentTeam.improvementType;

    for (var auditorTeam in auditorTeamList) {
      if (auditorTeam.teamId == currentTeamId) continue;

      final team = teamList.firstWhere(
        (t) => t.id == auditorTeam.teamId,
        orElse: () => Team(0, '', false, false, improvementType: 0),
      );

      if (team.improvementType == currentImprovementType) {
        final hasAuditor = auditorTeam.auditors.any((a) => a.id == auditorId);
        if (hasAuditor) {
          return team.name;
        }
      }
    }
    return null;
  }

  void _applyImprovementTypeFilter() {
    if (_selectedImprovementTypeFilter == null) {
      // Show all auditor teams
      filteredList = List.from(auditorTeamList);
    } else {
      // Filter by improvement type
      filteredList = auditorTeamList.where((auditorTeam) {
        // Find the team associated with this auditor team
        final team = teamList.firstWhere(
          (t) => t.id == auditorTeam.teamId,
          orElse: () => Team(0, '', false, false, improvementType: 0),
        );
        // Check if team's improvement type matches the selected filter
        return team.improvementType.toString() == _selectedImprovementTypeFilter;
      }).toList();
    }
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  void showFormDialog({
    String? id,
    String? teamId,
    List<dynamic>? auditors,
    bool isActive = false,
  }) {
    selectTeam = teamId != null ? int.tryParse(teamId) : null;
    if (teamId != null && auditors != null) {
      selectedAuditors =
          auditors
              .map((auditor) => {
                'id': auditor.id, 
                'userId': auditor.userId,
              })
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
                                        value: team.id,
                                        child: Text("${team.name} - ${  _teamService.getImprovementTypeName(
                                    team.improvementType ?? 0,
                                    filteredimprovementType,
                                  )}"),
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
                      gap32px,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("List of Auditors"),
                      ),
                      gap16px,
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
                                getUserFullName(auditor['userId']),
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
                      gap14px,
                      CustomToggle(
                        label: "Active",
                        value: isActive,
                        activeColor: primaryColor,
                        inactiveColor: Colors.grey,
                        onChanged: (val) {
                          setDialogState(() {
                            isActive = val;
                          });
                        },
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
                      // Validate that no auditor is already in another team with same improvement type
                      if (selectTeam != null) {
                        List<String> conflictingAuditors = [];
                        
                        for (var auditor in selectedAuditors) {
                          final auditorId = auditor['id'] as int?;
                          if (auditorId != null && isAuditorInSameImprovementType(auditorId, selectTeam!)) {
                            final existingTeam = getAuditorExistingTeam(auditorId, selectTeam!);
                            final auditorName = getUserFullName(auditor['userId']);
                            if (existingTeam != null) {
                              conflictingAuditors.add('$auditorName is already in $existingTeam');
                            }
                          }
                        }

                        if (conflictingAuditors.isNotEmpty) {
                          MotionToast.error(
                            toastAlignment: Alignment.topCenter,
                            description: Text(
                              'Cannot save: ${conflictingAuditors.join(', ')}. Please remove them from their current team first.',
                            ),
                          ).show(context);
                          return;
                        }
                      }

                      List<Auditor> auditors =
                          selectedAuditors
                              .map(
                                (a) => Auditor(
                                  id: a['id'],
                                  userId: a['userId'],
                                ),
                              )
                              .toList();

                      final auditorTeam = AuditorTeam(
                        0,
                        selectTeam ?? 0,
                        auditors,
                        true,
                        rowVersion: '',
                        isDeleted: isActive,
                      );

                      await _adutiorTeamService.createOrUpdateAuditorTeam(
                        auditorTeam,
                      );
                      setState(() {
                        fetchAuditorTeam();
                      });
                      MotionToast.success(
                        toastAlignment: Alignment.topCenter,
                        description: Text('Saved successfully'),
                      ).show(context);
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
    // Filter auditors: exclude those already selected AND those in other teams with same improvement type
    final availableAuditors = auditorList.where((auditor) {
      // Check if auditor is already selected
      final isSelected = selectedAuditors.any((sel) => sel['id'] == auditor.id);
      if (isSelected) return false;

      // Check if auditor is in another team with same improvement type
      if (selectTeam != null) {
        final isInSameType = isAuditorInSameImprovementType(auditor.id!, selectTeam!);
        if (isInSameType) return false;
      }

      return true;
    }).toList();

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
            child: availableAuditors.isEmpty
                ? Center(
                    child: Text(
                      'No available auditors.\nAll auditors are already assigned to teams of this type.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView(
                    children: availableAuditors.map((auditor) {
                      return ListTile(
                        title: Text(getUserFullName(auditor.userId)),
                        trailing: Icon(Icons.person_add, color: primaryColor),
                        onTap: () {
                          setDialogState(() {
                            selectedAuditors.add({
                              'id': auditor.id,
                              'userId': auditor.userId.toString(),
                            });
                          });
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
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

  // void filterSearchResults(String query) {
  //   setState(() {
  //     filteredList =
  //         auditorTeamList
  //             .where(
  //               (auditorTeam) => auditorTeam['name']!.toLowerCase().contains(
  //                 query.toLowerCase(),
  //               ),
  //             )
  //             .toList();
  //   });
  // }

  String getTeamNameById(int id, List<Team> teamList) {
    final team = teamList.firstWhere(
      (team) => team.id == id,
      orElse: () => Team(id, 'name', true, false),
    );
    return team.name;
  }

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;

    final uniqueTeams =
        {for (var item in filteredList) item.teamId: item}.values.toList();

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
                Row(
                  children: [
                  
                    // Filter Dropdown
                    Container(
                      height: 30,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: lightGrey),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: secondaryColor,
                          value: _selectedImprovementTypeFilter,
                          hint: Text(
                            'Filter by Type',
                            style: TextStyle(color: grey, fontSize: 14),
                          ),
                          items: [
                            DropdownMenuItem<String>(
                              value: null,
                              child: Text('All'),
                            ),
                            ...filteredimprovementType.map((type) {
                              return DropdownMenuItem<String>(
                                value: type['id'].toString(),
                                child: Text(type['name']),
                              );
                            }).toList(),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedImprovementTypeFilter = value;
                              _applyImprovementTypeFilter();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
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
            gap16px,
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
  "${getTeamNameById(
      audiorTeam.teamId,
      teamList,
    )} - ${_teamService.getImprovementTypeName(
      teamList.firstWhere(
        (t) => t.id == audiorTeam.teamId,
        orElse: () => Team(0, '', false, false, improvementType: 0),
      ).improvementType ?? 0,
      filteredimprovementType,
    )}",
       style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: primaryTextColor,
                                        ),
),

                                    ),
                                    const SizedBox(height: 10),
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
                                                  (audiorTeam.auditors).length,
                                              itemBuilder: (context, i) {
                                                final auditor =
                                                    (audiorTeam.auditors)[i];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 2,
                                                      ),
                                                  child: Text(
                                                    getUserFullName(auditor.userId),
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            showFormDialog(
                                              id: audiorTeam.id.toString(),
                                              teamId:
                                                  (audiorTeam.teamId)
                                                      .toString(),
                                              auditors: audiorTeam.auditors,
                                              isActive: audiorTeam.isActive,
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: primaryColor,
                                          ),
                                          onPressed: () {
                                            showDeleteDialog(audiorTeam.teamId);
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

  void showDeleteDialog(int teamId) {
    showDialog(
      barrierDismissible: false,
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
                try {
                  await _adutiorTeamService.deleteAuditorTeam(teamId);
                  await fetchAuditorTeam();
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text('Auditor Team deleted successfully'),
                  ).show(context);
                } catch (e) {
                  MotionToast.error(
                    description: Text('Failed to Delete Auditor Team'),
                  );
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
