import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/audit_schedules/models/audit_schedules.dart';
import 'package:imis/audit_schedules/models/audit_schedules_details.dart';
import 'package:imis/audit_schedules/models/auditable_office.dart';

import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/utils/token_expiration_handler.dart';
import '../../utils/http_util.dart';

class AuditSchedulesPage extends StatefulWidget {
  const AuditSchedulesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuditSchedulesPageState createState() => _AuditSchedulesPageState();
}

class _AuditSchedulesPageState extends State<AuditSchedulesPage> {
  List<Map<String, dynamic>> auditScheduleList = [];
  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();
  List<Map<String, dynamic>> filteredListAuditSchedule = [];
  List<Map<String, dynamic>> filteredListAuditor = [];
  List<Map<String, dynamic>> selectedOffice = [];
  List<Map<String, dynamic>> officeList = [];
  List<Map<String, dynamic>> teamList = [];
  List<Map<String, dynamic>> filteredListTeam = [];
  List<Map<String, dynamic>> auditorList = [];
  List<Map<String, dynamic>> auditscheduleDetails = [];

  int? selectTeam;
  int? selectAuditor;
  String? selectTeamText;

  final _paginationUtils = PaginationUtil(Dio());

  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;

  final dio = Dio();

  Future<void> fetchAuditSchedule({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _paginationUtils
          .fetchPaginatedData<AuditSchedules>(
            endpoint: ApiEndpoint().auditSchedule,
            page: page,
            pageSize: _pageSize,
            searchQuery: searchQuery,
            fromJson: (json) => AuditSchedules.fromJson(json),
          );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          auditScheduleList = pageList.items.map((a) => a.toJson()).toList();
          filteredListAuditSchedule = List.from(auditScheduleList);
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

  Future<void> fetchOffice() async {
    var url = ApiEndpoint().office;

    try {
      var response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<Office> data =
            (response.data as List)
                .map((office) => Office.fromJson(office))
                .toList();

        if (mounted) {
          setState(() {
            officeList = data.map((office) => office.toJson()).toList();
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

  Future<void> fetchTeam() async {
    var url = ApiEndpoint().team;

    try {
      final response = await AuthenticatedRequest.get(dio, url);

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
      var response = await AuthenticatedRequest.get(dio, url);

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

  Future<void> addOrUpdateAuditSchedule(AuditSchedules auditSchedule) async {
    var url = ApiEndpoint().auditSchedule;

    try {
      final Map<String, dynamic> requestData = auditSchedule.toJson();
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchAuditSchedule();
        selectedOffice.clear();
      } else {
        debugPrint(
          "Failed to add/update office. Status code: ${response.statusCode}",
        );
        debugPrint("Response data: ${response.data}");
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint("  Error message: ${e.message}");
      }
      debugPrint("Error adding/updating auditschedule: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    isSearchfocus.addListener(() {
      setState(() {});
    });
    fetchOffice();
    fetchTeam();
    fetchAuditors();
    fetchAuditSchedule();
    TokenExpirationHandler(context).checkTokenExpiration();
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  String getOfficeNameById(int id) {
    return officeList.firstWhere(
      (o) => o['id'] == id,
      orElse: () => {'name': 'Unknown'},
    )['name'];
  }

  void showFormDialog({
    int? id,
    String? auditTitle,
    String? startDate,
    String? endDate,
    bool isActive = false,
    List<AuditableOffice>? auditableOffices,
    List<AuditScheduleDetails>? auditSchduleDetails,
  }) {
    // Title and audit date fields
    TextEditingController auditTitleController = TextEditingController(
      text: auditTitle,
    );
    TextEditingController startDateController = TextEditingController(
      text: startDate,
    );
    TextEditingController endDateController = TextEditingController(
      text: endDate,
    );

    // Schedule list
    List<Map<String, dynamic>> scheduleDetails = [];

    // Controllers for multiple schedule dates
    List<TextEditingController> startDateControllers = [];
    List<TextEditingController> endDateControllers = [];

    // Populate selected offices
    if (auditableOffices != null && auditableOffices.isNotEmpty) {
      selectedOffice.clear();
      for (final office in auditableOffices) {
        selectedOffice.add({
          'id': office.officeId,
          'name': getOfficeNameById(office.officeId!),
        });
      }
    }

    if (auditSchduleDetails != null && auditSchduleDetails.isNotEmpty) {
      for (final detail in auditSchduleDetails) {
        final startDateText =
            detail.startDateTime?.toLocal().toString().split(' ')[0] ?? '';
        final endDateText =
            detail.endDateTime?.toLocal().toString().split(' ')[0] ?? '';

        scheduleDetails.add({
          'team': detail.teamId,
          'office': detail.officeId,
          'startDateTime': startDateText,
          'endDateTime': endDateText,
        });

        startDateControllers.add(TextEditingController(text: startDateText));
        endDateControllers.add(TextEditingController(text: endDateText));
      }
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
                        children: [
                          Column(
                            children:
                                scheduleDetails.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  var schedule = entry.value;

                                  // Ensure controllers exist
                                  if (startDateControllers.length <= index) {
                                    startDateControllers.add(
                                      TextEditingController(),
                                    );
                                  }
                                  if (endDateControllers.length <= index) {
                                    endDateControllers.add(
                                      TextEditingController(),
                                    );
                                  }

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                startDateControllers.removeAt(
                                                  index,
                                                );
                                                endDateControllers.removeAt(
                                                  index,
                                                );
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

                                      // Team Dropdown
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          value: schedule['team'],
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

                                      // Office Dropdown
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
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

                                      // Start Date Input
                                      SizedBox(
                                        width: double.infinity,
                                        height: 60,
                                        child: TextField(
                                          controller:
                                              startDateControllers[index],
                                          readOnly: true,
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
                                          onTap: () async {
                                            DateTime? picked =
                                                await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime(2101),
                                                );
                                            if (picked != null) {
                                              setDialogState(() {
                                                String formattedDate =
                                                    picked
                                                        .toLocal()
                                                        .toString()
                                                        .split(' ')[0];
                                                startDateControllers[index]
                                                    .text = formattedDate;
                                                scheduleDetails[index]['startDateTime'] =
                                                    formattedDate;
                                              });
                                            }
                                          },
                                        ),
                                      ),

                                      gap,

                                      // End Date Input
                                      SizedBox(
                                        width: double.infinity,
                                        height: 60,
                                        child: TextField(
                                          controller: endDateControllers[index],
                                          readOnly: true,
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
                                          onTap: () async {
                                            DateTime? picked =
                                                await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime(2101),
                                                );
                                            if (picked != null) {
                                              setDialogState(() {
                                                String formattedDate =
                                                    picked
                                                        .toLocal()
                                                        .toString()
                                                        .split(' ')[0];
                                                endDateControllers[index].text =
                                                    formattedDate;
                                                scheduleDetails[index]['endDateTime'] =
                                                    formattedDate;
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
                                    'startDateTime': null,
                                    'endDateTime': null,
                                  });
                                  startDateControllers.add(
                                    TextEditingController(),
                                  );
                                  endDateControllers.add(
                                    TextEditingController(),
                                  );
                                });
                              },
                              icon: Icon(Icons.add, color: primaryColor),
                              label: Text(
                                "Add schedule",
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Add Button
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    selectedOffice.clear();
                    Navigator.pop(context);
                  },
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
                      List<AuditScheduleDetails> scheduleDetailsList = [];
                      List<AuditableOffice> auditableOfficeList = [];

                      for (var schedule in scheduleDetails) {
                        String? start = schedule['startDateTime'];
                        String? end = schedule['endDateTime'];

                        DateTime? parsedStart;
                        DateTime? parsedEnd;

                        try {
                          parsedStart =
                              start != null && start.isNotEmpty
                                  ? DateTime.parse(start)
                                  : null;
                        } catch (_) {
                          parsedStart = null;
                        }

                        try {
                          parsedEnd =
                              end != null && end.isNotEmpty
                                  ? DateTime.parse(end)
                                  : null;
                        } catch (_) {
                          parsedEnd = null;
                        }

                        if (parsedStart == null || parsedEnd == null) {
                          continue;
                        }

                        scheduleDetailsList.add(
                          AuditScheduleDetails(
                            id: 0,
                            isDeleted: false,
                            rowVersion: '',
                            auditScheduleId: 0,
                            startDateTime: parsedStart,
                            endDateTime: parsedEnd,
                            teamId: schedule['team'],
                            teamName: schedule['team']?.toString() ?? '',
                            officeId: schedule['office'],
                            officeName: schedule['office']?.toString() ?? '',
                          ),
                        );
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
                              .map(
                                (a) => Office(
                                  id: a['id'],
                                  name: a['name'],
                                  officeTypeId: a['officeTypeId'],
                                  parentOfficeId: a['parentOfficeId'],
                                ),
                              )
                              .toList();

                      final auditschedule = AuditSchedules(
                        id: 0,
                        isDeleted: false,
                        rowVersion: '',
                        auditTitle: auditTitleController.text,
                        startDate: DateTime.parse(startDateController.text),
                        endDate: DateTime.parse(endDateController.text),
                        isActive: true,
                        offices: officeList,
                        auditableOffices: auditableOfficeList,
                        auditSchduleDetails: scheduleDetailsList,
                      );

                      await addOrUpdateAuditSchedule(auditschedule);
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
          auditScheduleList
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
                // Search Field
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
                      labelText: 'Search Audit Schedule',
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
                // Add New Button
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
            // List of Audit Schedules
            Expanded(
              child: Column(
                children: [
                  // Table Header
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
                            'Audit Schedule',
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
                  // Audit Schedule List
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children:
                            filteredListAuditSchedule
                                .asMap()
                                .map((index, auditSchedule) {
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
                                                (auditSchedule['auditTitle'] ??
                                                        '')
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
                                                        id: auditSchedule['id'],
                                                        auditTitle:
                                                            auditSchedule['auditTitle'],
                                                        startDate:
                                                            auditSchedule['startDate'],
                                                        endDate:
                                                            auditSchedule['endDate'],
                                                        auditableOffices:
                                                            auditSchedule['auditableOffices'],
                                                        auditSchduleDetails:
                                                            auditSchedule['auditSchduleDetails'],
                                                      );
                                                    },
                                                  ),

                                                  SizedBox(width: 1),
                                                  // Delete Button
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
                                                    onPressed: () async {
                                                      final confirmed = await showDialog<
                                                        bool
                                                      >(
                                                        context: context,
                                                        builder:
                                                            (
                                                              ctx,
                                                            ) => AlertDialog(
                                                              title: Text(
                                                                'Confirm Deletion',
                                                              ),
                                                              content: Text(
                                                                'Are you sure you want to delete this audit schedule?',
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () => Navigator.pop(
                                                                        ctx,
                                                                        false,
                                                                      ),
                                                                  child: Text(
                                                                    'Cancel',
                                                                  ),
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () =>
                                                                          Navigator.pop(
                                                                            ctx,
                                                                            true,
                                                                          ),
                                                                  child: Text(
                                                                    'Delete',
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                      );

                                                      if (confirmed == true) {
                                                        // await deleteAuditSchedule(auditSchedule['id']); // Implement the delete logic
                                                        // fetchAuditSchedules(); // Refresh the list after deletion
                                                      }
                                                    },
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
                          onPageChanged:
                              (page) => fetchAuditSchedule(page: page),
                        ),
                        Container(width: 60),
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
}
