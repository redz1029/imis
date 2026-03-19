// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imis/audit_schedules/models/audit_schedules.dart';
import 'package:imis/audit_schedules/models/audit_schedules_details.dart';
import 'package:imis/audit_schedules/models/auditable_office.dart';
import 'package:imis/auditor/models/auditor.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../utils/http_util.dart';
import '../services/audit_schedules_service.dart';

class AuditSchedulesPage extends StatefulWidget {
  const AuditSchedulesPage({super.key});

  @override
  AuditSchedulesPageState createState() => AuditSchedulesPageState();
}

class AuditSchedulesPageState extends State<AuditSchedulesPage> {
  final _auditScheduleService = AuditSchedulesService(Dio());

  List<AuditSchedules> auditScheduleList = [];
  List<AuditSchedules> filteredList = [];
  final _commonService = CommonService(Dio());
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();
  List<Map<String, dynamic>> selectedOffice = [];
  List<Office> officeList = [];
  List<Team> teamList = [];
  List<Auditor> auditorList = [];
  bool isLoading = false;
  int? selectTeam;
  int? selectAuditor;
  String? selectTeamText;

  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;

  final dio = Dio();

  Future<void> fetchAuditSchedules({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _auditScheduleService.getAuditSchedule(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          auditScheduleList = pageList.items;
          filteredList = List.from(auditScheduleList);
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
        fetchAuditSchedules();
        selectedOffice.clear();
      } else {
        debugPrint("Response data");
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

    fetchAuditSchedules();

    () async {
      setState(() {
        isLoading = true;
      });

      final team = await _commonService.fetchTeam();
      final auditors = await _commonService.fetchAuditors();
      final office = await _commonService.fetchOffices();

      if (!mounted) return;

      setState(() {
        teamList = team;
        auditorList = auditors;
        officeList = office;
        isLoading = false;
      });
    }();
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  String getOfficeNameById(int id) {
    return officeList
        .firstWhere(
          (o) => o.id == id,
          orElse: () => Office(id: 0, name: 'Unknown'),
        )
        .name;
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
                      gap14px,
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
                      gap4px,
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
                      gap4px,
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
                      gap4px,
                      Text('List of Office'),
                      gap16px,
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
                      gap48px,
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
                                      gap16px,
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
                                          initialValue: schedule['team'],
                                          items:
                                              teamList.map((team) {
                                                return DropdownMenuItem<int>(
                                                  value: team.id,
                                                  child: Text(team.name),
                                                );
                                              }).toList(),
                                          onChanged: (value) {
                                            setDialogState(() {
                                              schedule['team'] = value;
                                            });
                                          },
                                        ),
                                      ),
                                      gap16px,
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
                                          initialValue: schedule['office'],
                                          items:
                                              officeList.map((office) {
                                                return DropdownMenuItem<int>(
                                                  value: office.id,
                                                  child: Text(office.name),
                                                );
                                              }).toList(),
                                          onChanged: (value) {
                                            setDialogState(() {
                                              schedule['office'] = value;
                                            });
                                          },
                                        ),
                                      ),
                                      gap16px,
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
                                      gap16px,
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

                                      gap4px,
                                      Divider(
                                        color: lightGrey,
                                        thickness: 1.0,
                                        height: 20,
                                      ),
                                      gap4px,
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
                              (sel) => sel['id'] == office.id,
                            ),
                      )
                      .map((office) {
                        return ListTile(
                          title: Text(office.name ?? ''),
                          trailing: Icon(Icons.add, color: primaryColor),
                          onTap: () {
                            setDialogState(() {
                              selectedOffice.add({
                                'id': office.id,
                                'name': office.name,
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

  // void filterSearchResults(String query) {
  //   setState(() {
  //     filteredList =
  //         auditScheduleList
  //             .where(
  //               (office) =>
  //                   office['name']!.toLowerCase().contains(query.toLowerCase()),
  //             )
  //             .toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Audit Schedule Information",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
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
                    // onChanged: filterSearchResults,
                  ),
                ),
                const Spacer(),
                if (!isMobile)
                  ElevatedButton.icon(
                    onPressed: () => showFormDialog(),
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
            const SizedBox(height: 26),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black.withValues(alpha: .05),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// DESKTOP HEADER
                    if (!isMobile)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: Row(
                          children: const [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "#",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Audit Title",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Text(
                                "Actions",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 5),

                    Expanded(
                      child:
                          _isLoading
                              ? Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                              : ListView.builder(
                                itemCount: filteredList.length,
                                itemBuilder: (context, index) {
                                  final auditSchedule = filteredList[index];
                                  int itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;
                                  if (!isMobile) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text("$itemNumber"),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              auditSchedule.auditTitle,
                                            ),
                                          ),

                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                Tooltip(
                                                  message: 'Edit',
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.edit_outlined,
                                                    ),
                                                    onPressed: () {
                                                      showFormDialog(
                                                        id: auditSchedule.id,
                                                        auditTitle:
                                                            auditSchedule
                                                                .auditTitle,
                                                        startDate:
                                                            DateTimeConverter()
                                                                .toJson(
                                                                  auditSchedule
                                                                      .startDate,
                                                                ),
                                                        endDate:
                                                            DateTimeConverter()
                                                                .toJson(
                                                                  auditSchedule
                                                                      .endDate,
                                                                ),
                                                        auditableOffices:
                                                            auditSchedule
                                                                .auditableOffices,
                                                        auditSchduleDetails:
                                                            auditSchedule
                                                                .auditSchduleDetails,
                                                      );
                                                    },
                                                  ),
                                                ),

                                                IconButton(
                                                  icon: const Icon(
                                                    CupertinoIcons
                                                        .delete_simple,
                                                    color: Colors.redAccent,
                                                  ),
                                                  onPressed:
                                                      () => showDeleteDialog(
                                                        auditSchedule.id
                                                            .toString(),
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "$itemNumber",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Spacer(),
                                            PopupMenuButton<String>(
                                              color:
                                                  Theme.of(context).cardColor,
                                              icon: const Icon(Icons.more_vert),
                                              onSelected: (value) async {
                                                if (value == 'edit') {
                                                  showFormDialog(
                                                    id: auditSchedule.id,
                                                    auditTitle:
                                                        auditSchedule
                                                            .auditTitle,
                                                    startDate:
                                                        DateTimeConverter()
                                                            .toJson(
                                                              auditSchedule
                                                                  .startDate,
                                                            ),
                                                    endDate: DateTimeConverter()
                                                        .toJson(
                                                          auditSchedule.endDate,
                                                        ),
                                                    auditableOffices:
                                                        auditSchedule
                                                            .auditableOffices,
                                                    auditSchduleDetails:
                                                        auditSchedule
                                                            .auditSchduleDetails,
                                                  );
                                                }

                                                if (value == 'delete') {
                                                  showDeleteDialog(
                                                    auditSchedule.id.toString(),
                                                  );
                                                }
                                              },
                                              itemBuilder:
                                                  (_) => [
                                                    PopupMenuItem(
                                                      value: 'edit',
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.edit_outlined,
                                                            size: 18,
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text('Edit'),
                                                        ],
                                                      ),
                                                    ),

                                                    PopupMenuItem(
                                                      value: 'delete',

                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            CupertinoIcons
                                                                .delete_simple,
                                                            color: Colors.red,
                                                            size: 18,
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text('Delete'),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        // Text(
                                        //   "Audit Title: ${auditSchedule['auditTitle']}",
                                        // ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: Theme.of(context).cardColor,
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
                                (page) => fetchAuditSchedules(page: page),
                          ),
                          const SizedBox(width: 60),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          isMobile
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
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
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
                try {
                  await _auditScheduleService.deleteAuditSchedule(id);
                  await fetchAuditSchedules();
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text('Deleted successfully'),
                  ).show(context);
                } catch (e) {
                  MotionToast.error(description: Text('Failed to Delete'));
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
