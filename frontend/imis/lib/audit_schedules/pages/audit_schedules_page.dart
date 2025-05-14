import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:imis/constant/constant.dart';
import 'package:imis/audit_schedules/models/audit_schedules.dart';
import 'package:imis/audit_schedules/models/audit_schedules_details.dart';
import 'package:imis/audit_schedules/models/auditable_office.dart';
import 'package:imis/auditor_team/models/auditor_team.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuditSchedulesPage extends StatefulWidget {
  const AuditSchedulesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuditSchedulesPageState createState() => _AuditSchedulesPageState();
}

class _AuditSchedulesPageState extends State<AuditSchedulesPage> {
  List<Map<String, dynamic>> auditorTeamList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();
  List<Map<String, dynamic>> filteredListTeamAuditor = [];
  List<Map<String, dynamic>> filteredListAuditor = [];
  List<Map<String, dynamic>> selectedOffice = [];
  List<Map<String, dynamic>> officeList = [];
  List<Map<String, dynamic>> teamList = [];
  List<Map<String, dynamic>> filteredListTeam = [];
  List<Map<String, dynamic>> auditorList = [];

  int? selectTeam;
  int? selectAuditor;
  String? selectTeamText;

  final dio = Dio();

  Future<void> fetchAuditorTeam() async {
    var url = ApiEndpoint().auditSchedule;

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

  Future<void> fetchOffice() async {
    var url = ApiEndpoint().office;

    try {
      var response = await dio.get(url);

      if (response.statusCode == 200 && response.data is List) {
        List<Office> data =
            (response.data as List)
                .map((office) => Office.fromJson(office))
                .toList();

        if (mounted) {
          setState(() {
            officeList = data.map((office) => office.toJson()).toList();
            filteredList = List.from(
              officeList,
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
            filteredListTeam = List.from(teamList);
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
    var url = ApiEndpoint().office;

    try {
      var response = await dio.get(url);

      if (response.statusCode == 200 && response.data is List) {
        List<Office> data =
            (response.data as List)
                .map((auditor) => Office.fromJson(auditor))
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

  // Future<void> addOrUpdateAuditorTeam(AuditSchedules auditSchedule) async {
  //   var url = ApiEndpoint().auditSchedule;

  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString('accessToken');

  //     if (token == null || token.isEmpty) {
  //       debugPrint("Error: Access token is missing!");
  //       return;
  //     }

  //     final Map<String, dynamic> requestData = auditSchedule.toJson();
  //     final response = await dio.post(
  //       url,
  //       data: requestData,
  //       options: Options(
  //         headers: {
  //           "Content-Type": "application/json",
  //           "Authorization": "Bearer $token",
  //         },
  //       ),
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       // await fetchAuditorTeam();
  //     } else {
  //       debugPrint(
  //         "Failed to add/update office. Status code: ${response.statusCode}",
  //       );
  //     }
  //   } catch (e) {
  //     debugPrint("Error adding/updating auditschedule: $e");
  //   }
  // }
  Future<void> addOrUpdateAuditorTeam(AuditSchedules auditSchedule) async {
    var url = ApiEndpoint().auditSchedule;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        debugPrint("Error: Access token is missing!");
        return;
      }

      final Map<String, dynamic> requestData = auditSchedule.toJson();
      debugPrint("Sending data: ${requestData.toString()}"); // Add this line

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
        // Success handling
      } else {
        debugPrint(
          "Failed to add/update office. Status code: ${response.statusCode}",
        );
        debugPrint("Response data: ${response.data}"); // Add this line
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint("Dio error:");
        debugPrint("  Status code: ${e.response?.statusCode}");
        debugPrint("  Response data: ${e.response?.data}");
        debugPrint("  Error message: ${e.message}");
      }
      debugPrint("Error adding/updating auditschedule: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAuditorTeam();
    isSearchfocus.addListener(() {
      setState(() {});
    });
    fetchOffice();
    fetchTeam();
    fetchAuditors();
    // fetchAuditorTeam();
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  void showFormDialog({
    String? id,
    String? teamId,
    String? startDate,
    String? endDate,
    bool isActive = false,
    String? auditTitle,
  }) {
    TextEditingController auditTitleController = TextEditingController(
      text: auditTitle,
    );
    TextEditingController startDateController = TextEditingController(
      text: startDate,
    );
    TextEditingController endDateController = TextEditingController(
      text: endDate,
    );

    List<Map<String, dynamic>> scheduleDetails = [];
    List<Map<String, dynamic>> auditableOffice = [];

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
              titlePadding: EdgeInsets.zero,
              title: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: primaryLightColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  id == null
                      ? 'Create Audit Schedules'
                      : 'Edit Audit Schedules',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              content: SizedBox(
                width: 400,
                height: 700,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      gap1,
                      // Audit Title
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: TextField(
                          controller: auditTitleController,
                          decoration: InputDecoration(
                            labelText: 'Audit Title',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      gap2,

                      // Start Date
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: TextField(
                          controller: startDateController,
                          decoration: InputDecoration(
                            labelText: 'Start Date',
                            suffixIcon: Icon(
                              Icons.calendar_month,
                              color: Colors.grey,
                            ),
                            floatingLabelStyle: TextStyle(color: primaryColor),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: primaryColor,
                                      onPrimary: secondaryColor,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: primaryColor,
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              startDateController.text =
                                  picked.toLocal().toString().split(' ')[0];
                            }
                          },
                        ),
                      ),

                      gap2,

                      // End Date
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: TextField(
                          controller: endDateController,
                          decoration: InputDecoration(
                            labelText: 'End Date',
                            suffixIcon: Icon(
                              Icons.calendar_month,
                              color: Colors.grey,
                            ),
                            floatingLabelStyle: TextStyle(color: primaryColor),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: primaryColor,
                                      onPrimary: secondaryColor,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: primaryColor,
                                      ),
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              endDateController.text =
                                  picked.toLocal().toString().split(' ')[0];
                            }
                          },
                        ),
                      ),
                      gap2,

                      Text('List of Office'),
                      gap,
                      ...selectedOffice.map((office) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                office['name'],
                                style: TextStyle(color: primaryTextColor),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: primaryTextColor,
                                ),
                                onPressed: () {
                                  setDialogState(() {
                                    selectedOffice.remove(office);
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
                            "Add office",
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                      ),
                      gap5,
                      Column(
                        children:
                            scheduleDetails.map((schedule) {
                              int index = scheduleDetails.indexOf(schedule);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Audit Schedule Details ${index + 1}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: primaryTextColor,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setDialogState(() {
                                            scheduleDetails.removeAt(index);
                                          });
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          size: 24,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  gap,
                                  // Dropdown for Team
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                        setDialogState(() {
                                          schedule['team'] = value;
                                        });
                                      },
                                    ),
                                  ),

                                  gap,
                                  // Dropdown for Team
                                  DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField<int>(
                                      dropdownColor: mainBgColor,
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        labelText: 'Choose Office',
                                        filled: true,
                                        fillColor: secondaryColor,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      value: schedule['office'],
                                      items:
                                          officeList.map((office) {
                                            return DropdownMenuItem<int>(
                                              value: office['id'],
                                              child: Text(office['name']),
                                            );
                                          }).toList(),
                                      onChanged: (value) {
                                        setDialogState(() {
                                          schedule['office'] = value;
                                        });
                                      },
                                    ),
                                  ),
                                  gap,
                                  // End Date for this schedule
                                  SizedBox(
                                    width: double.infinity,
                                    height: 60,
                                    child: TextField(
                                      controller: TextEditingController(
                                        text: schedule['startDate'],
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Start Date',
                                        suffixIcon: Icon(
                                          Icons.calendar_month,
                                          color: Colors.grey,
                                        ),
                                        floatingLabelStyle: TextStyle(
                                          color: primaryColor,
                                        ),
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? picked = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme: ColorScheme.light(
                                                  primary: primaryColor,
                                                  onPrimary: secondaryColor,
                                                ),
                                                textButtonTheme:
                                                    TextButtonThemeData(
                                                      style:
                                                          TextButton.styleFrom(
                                                            foregroundColor:
                                                                primaryColor,
                                                          ),
                                                    ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (picked != null) {
                                          setDialogState(() {
                                            schedule['startDate'] =
                                                picked
                                                    .toLocal()
                                                    .toString()
                                                    .split(' ')[0];
                                          });
                                        }
                                      },
                                    ),
                                  ),

                                  SizedBox(
                                    width: double.infinity,
                                    height: 60,
                                    child: TextField(
                                      controller: TextEditingController(
                                        text: schedule['endDate'],
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'End Date',
                                        suffixIcon: Icon(
                                          Icons.calendar_month,
                                          color: Colors.grey,
                                        ),
                                        floatingLabelStyle: TextStyle(
                                          color: primaryColor,
                                        ),
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                      readOnly: true,
                                      onTap: () async {
                                        DateTime? picked = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2101),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme: ColorScheme.light(
                                                  primary: primaryColor,
                                                  onPrimary: secondaryColor,
                                                ),
                                                textButtonTheme:
                                                    TextButtonThemeData(
                                                      style:
                                                          TextButton.styleFrom(
                                                            foregroundColor:
                                                                primaryColor,
                                                          ),
                                                    ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (picked != null) {
                                          setDialogState(() {
                                            schedule['endDate'] =
                                                picked
                                                    .toLocal()
                                                    .toString()
                                                    .split(' ')[0];
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  gap2,
                                  Divider(
                                    color: lightGrey,
                                    thickness: 1.0,
                                    height: 20,
                                  ),
                                  gap2,
                                ],
                              );
                            }).toList(),
                      ),

                      Align(
                        alignment: Alignment.center,
                        child: TextButton.icon(
                          onPressed: () {
                            setDialogState(() {
                              scheduleDetails.add({
                                'team': null,
                                'office': null,
                                'startDate': null,
                                'endDate': null,
                              });
                            });
                          },
                          icon: Icon(Icons.add, color: primaryColor),
                          label: Text(
                            "Add schedule",
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                      ),

                      // Add Button
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
                      List<AuditScheduleDetails> scheduleDetailsList = [];
                      List<AuditableOffice> auditableOfficeList = [];

                      for (var schedule in scheduleDetails) {
                        scheduleDetailsList.add(
                          AuditScheduleDetails(
                            id: 0,
                            isDeleted: false,
                            rowVersion: '',
                            auditScheduleId: 0,
                            startDate: DateTime.parse(schedule['startDate']),
                            endDate: DateTime.parse(schedule['endDate']),
                            teamId: schedule['team'],
                            teamName: schedule['team']?.toString() ?? '',
                            officeId: schedule['office'],
                            officeName: schedule['office']?.toString() ?? '',
                          ),
                        );

                        // auditableOfficeList.add(
                        //   AuditableOffice(
                        //     auditScheduleId: 0,
                        //     officeId: schedule['office'],
                        //   ),
                        // );
                      }
                      for (var office in selectedOffice) {
                        auditableOfficeList.add(
                          AuditableOffice(
                            auditScheduleId: 0,
                            officeId: office['id'],
                          ),
                        );
                      }
                      List<Office> officeList =
                          selectedOffice
                              .map((a) => Office(id: a['id'], name: a['name']))
                              .toList();

                      final auditschedule = AuditSchedules(
                        0,
                        false,
                        "",
                        auditTitleController.text,
                        DateTime.parse(startDateController.text),
                        DateTime.parse(endDateController.text),
                        true,
                        officeList,
                        auditableOfficeList, // <-- correct type now
                        scheduleDetailsList,
                      );

                      await addOrUpdateAuditorTeam(auditschedule);
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

  // Separate Dialog for Selecting Auditors
  void showAvailableAuditorsDialog(Function setDialogState) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(
            'Select Office',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 400,
            height: 400,
            child: ListView(
              children:
                  auditorList
                      .where(
                        (office) =>
                            !selectedOffice.any(
                              (sel) => sel['id'] == office['id'],
                            ),
                      )
                      .map((office) {
                        return ListTile(
                          title: Text(office['name']),
                          trailing: Icon(Icons.add, color: primaryColor),
                          onTap: () {
                            setDialogState(() {
                              selectedOffice.add({
                                'id': office['id'],
                                'name': office['name'],
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
                (office) =>
                    office['name']!.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: Text('Audit Schedules Information'),
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
                            filteredListTeamAuditor
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
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
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
                                              child: Text(
                                                (audiorTeam['teamId'] ?? '')
                                                    .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                overflow: TextOverflow.ellipsis,
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
                                                  IconButton(
                                                    icon: Icon(Icons.edit),

                                                    onPressed: () {
                                                      showFormDialog(
                                                        id: audiorTeam['id'],
                                                        teamId:
                                                            (audiorTeam['teamId'] ??
                                                                    '')
                                                                .toString(),
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(width: 1),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Color.fromARGB(
                                                        255,
                                                        221,
                                                        79,
                                                        79,
                                                      ),
                                                    ),
                                                    onPressed: () async {},
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
}
