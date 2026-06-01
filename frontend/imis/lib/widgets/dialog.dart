import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:imis/auditor_team/models/auditor_team.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/user/models/user.dart';
import 'package:intl/intl.dart';

import '../common_services/common_service.dart';
import 'time_picker_widget.dart';

class ProcessItem {
  String processName = "";
  bool isTeam = true;
  String? selectedPerson;
  List<bool> selectedClauses = [false, false, false];
  AuditorTeam? selectedTeam;
}

void showAuditDialog(BuildContext context) {
  DateTime? startDate;
  DateTime? endDate;

  List<DateTime> generatedDays = [];
  List<List<ProcessItem>> dayProcesses = [];
  final commonService = CommonService(Dio());

  Map<String, List<String>> teams = {
    "Team 1": ["Alice", "Bob", "Charlie"],
    "Team 2": ["David", "Eva"],
    "Team 3": ["Frank", "Grace"],
  };
  List<User> userList = [];
  bool isLoadingUsers = false;
  String? selectedUserId;
  List<User> selectedUsers = [];
  bool hasFetchedUsers = false; //
  List<String> clauseTitles = [
    "5.1 Leadership and commitment",
    "5.2 Policy",
    "6.1 Risk and opportunities",
  ];
  List<AuditorTeam> auditorTeamList = [];
  List<Team> teamList = [];

  bool hasFetchedData = false;
  bool isLoading = false;
  List<AuditorTeam> selectedTeams = [];
  AuditorTeam? selectedTeam;
  String getTeamName(int teamId, List<Team> teamList) {
    final team = teamList.firstWhere(
      (t) => t.id == teamId,
      orElse: () => Team(0, 'name', true, false),
    );

    return team.name;
  }

  String getFullName(String userId, List<User> userList) {
    final user = userList.firstWhere(
      (u) => u.id == userId,
      orElse: () => User(id: '', fullName: '', position: 'position'),
    );
    return user.fullName;
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          void generateDays() {
            if (startDate != null && endDate != null) {
              generatedDays.clear();
              dayProcesses.clear();

              for (
                int i = 0;
                i <= endDate!.difference(startDate!).inDays;
                i++
              ) {
                generatedDays.add(startDate!.add(Duration(days: i)));
                dayProcesses.add([ProcessItem()]);
              }
            }
          }

          if (!hasFetchedData) {
            isLoading = true;

            Future.wait([
              commonService.fetchUsers(),
              commonService.fetchAuditorTeam(),
              commonService.fetchTeam(),
            ]).then((values) {
              setState(() {
                userList = values[0] as List<User>;
                auditorTeamList = values[1] as List<AuditorTeam>;
                teamList = values[2] as List<Team>;

                hasFetchedData = true;
                isLoading = false;
              });
            });
          }
          return Dialog(
            backgroundColor: mainBgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * .8,
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Audit Programme",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Audit Objectives: ',
                    //     style: TextStyle(fontWeight: FontWeight.w600),
                    //     children: [
                    //       TextSpan(
                    //         text:
                    //             'To properly manage the implementation of the Internral Quality Audit activities as per scheduled Audit Plan.',
                    //         style: TextStyle(fontWeight: FontWeight.normal),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: 6),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Scope of Audit: ',
                    //     style: TextStyle(fontWeight: FontWeight.w600),
                    //     children: [
                    //       TextSpan(
                    //         text:
                    //             'Management Processes, all Core Processes, an d Support Processes of all Department/Sections/Units of the Organization.',
                    //         style: TextStyle(fontWeight: FontWeight.normal),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 18),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Select Date Range",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              /// START DATE
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Start Date"),
                                    const SizedBox(height: 8),
                                    InkWell(
                                      onTap: () async {
                                        DateTime? picked = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2024),
                                          lastDate: DateTime(2100),
                                        );

                                        if (picked != null) {
                                          setState(() {
                                            startDate = picked;
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              startDate == null
                                                  ? "Select Start Date"
                                                  : DateFormat(
                                                      'MM/dd/yyyy',
                                                    ).format(startDate!),
                                            ),
                                            const Icon(
                                              Icons.calendar_today,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 20),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("End Date"),
                                    const SizedBox(height: 8),
                                    InkWell(
                                      onTap: () async {
                                        DateTime? picked = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2024),
                                          lastDate: DateTime(2100),
                                        );

                                        if (picked != null) {
                                          setState(() {
                                            endDate = picked;
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              endDate == null
                                                  ? "Select End Date"
                                                  : DateFormat(
                                                      'MM/dd/yyyy',
                                                    ).format(endDate!),
                                            ),
                                            const Icon(
                                              Icons.calendar_today,
                                              size: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 20),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(" "), // empty label for alignment
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      backgroundColor: primaryColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        generateDays();
                                      });
                                    },
                                    child: const Text(
                                      "Generate Days",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: generatedDays.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: mainBgColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: ExpansionTile(
                            title: Row(
                              children: [
                                Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "${index + 1}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "DAY ${index + 1}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${DateFormat('MMMM d, yyyy').format(generatedDays[index])} • ${dayProcesses[index].length} process",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            children: [
                              Column(
                                children: [
                                  ...dayProcesses[index].asMap().entries.map((
                                    entry,
                                  ) {
                                    int processIndex = entry.key;
                                    ProcessItem process = entry.value;

                                    return Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Process ${processIndex + 1}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    dayProcesses[index]
                                                        .removeAt(processIndex);
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),

                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("Time"),
                                                    const SizedBox(height: 6),
                                                    TimePickerField(
                                                      label: "Start Time",
                                                      onTimeSelected: (time) {},
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(width: 16),

                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Organizational Unit and Process",
                                                    ),
                                                    const SizedBox(height: 6),
                                                    TextField(
                                                      decoration: const InputDecoration(
                                                        hintText:
                                                            "Enter organizational unit and process",
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                      onChanged: (value) {
                                                        process.processName =
                                                            value;
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          const Text("Responsibility"),
                                          Row(
                                            children: [
                                              RadioGroup<bool>(
                                                groupValue: process.isTeam,
                                                onChanged: (value) {
                                                  setState(() {
                                                    process.isTeam = value!;
                                                    // Reset selections when switching
                                                    process.selectedTeam = null;
                                                    process.selectedPerson =
                                                        null;
                                                  });
                                                },
                                                child: Row(
                                                  children: const [
                                                    Radio<bool>(value: true),
                                                    Text("Audit Team"),
                                                    Radio<bool>(value: false),
                                                    Text("Responsible Person"),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          if (process.isTeam)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                DropdownSearch<AuditorTeam>(
                                                  items: auditorTeamList,
                                                  selectedItem:
                                                      process.selectedTeam,

                                                  itemAsString: (team) =>
                                                      getTeamName(
                                                        team.teamId,
                                                        teamList,
                                                      ),

                                                  onChanged: (value) {
                                                    setState(() {
                                                      process.selectedTeam =
                                                          value;
                                                    });
                                                  },

                                                  popupProps: PopupProps.menu(
                                                    showSearchBox: true,
                                                    searchFieldProps: TextFieldProps(
                                                      decoration: InputDecoration(
                                                        floatingLabelBehavior:
                                                            FloatingLabelBehavior
                                                                .never,
                                                        hintText:
                                                            "Search Team...",
                                                        prefixIcon: Icon(
                                                          Icons.search,
                                                        ),
                                                        border:
                                                            OutlineInputBorder(),
                                                      ),
                                                    ),

                                                    itemBuilder:
                                                        (
                                                          context,
                                                          team,
                                                          isSelected,
                                                        ) {
                                                          return ListTile(
                                                            title: Text(
                                                              getTeamName(
                                                                team.teamId,
                                                                teamList,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                  ),

                                                  dropdownDecoratorProps:
                                                      DropDownDecoratorProps(
                                                        dropdownSearchDecoration:
                                                            InputDecoration(
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .never,
                                                              labelText:
                                                                  "Select Team",
                                                              border:
                                                                  OutlineInputBorder(),
                                                            ),
                                                      ),
                                                ),

                                                const SizedBox(height: 10),

                                                if (process.selectedTeam !=
                                                    null)
                                                  Wrap(
                                                    spacing: 8,
                                                    runSpacing: 6,
                                                    children: process
                                                        .selectedTeam!
                                                        .auditors
                                                        .map((auditor) {
                                                          return Chip(
                                                            backgroundColor:
                                                                Colors.white,
                                                            avatar: const Icon(
                                                              Icons.person,
                                                              size: 16,
                                                              color:
                                                                  primaryTextColor,
                                                            ),
                                                            label: Text(
                                                              getFullName(
                                                                auditor.userId ??
                                                                    '',
                                                                userList,
                                                              ),
                                                            ),
                                                            deleteIcon: const Icon(
                                                              Icons.cancel,
                                                              color:
                                                                  primaryTextColor,
                                                              size: 18,
                                                            ),
                                                            onDeleted: () {
                                                              setState(() {
                                                                process
                                                                    .selectedTeam!
                                                                    .auditors
                                                                    .remove(
                                                                      auditor,
                                                                    );
                                                              });
                                                            },
                                                          );
                                                        })
                                                        .toList(),
                                                  ),
                                              ],
                                            ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (!process.isTeam)
                                                DropdownSearch<User?>(
                                                  items: userList,
                                                  selectedItem: null,
                                                  itemAsString: (u) =>
                                                      u?.fullName ?? '',
                                                  onChanged: (value) {
                                                    if (value != null &&
                                                        !selectedUsers.contains(
                                                          value,
                                                        )) {
                                                      setState(() {
                                                        selectedUsers.add(
                                                          value,
                                                        ); // add to chip list
                                                      });
                                                    }
                                                  },
                                                  popupProps: PopupProps.menu(
                                                    showSearchBox: true,
                                                    searchFieldProps: TextFieldProps(
                                                      decoration: InputDecoration(
                                                        hintText:
                                                            'Search User Name...',
                                                        filled: true,
                                                        fillColor: mainBgColor,
                                                        prefixIcon: const Icon(
                                                          Icons.search,
                                                        ),
                                                        border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                    color:
                                                                        primaryColor,
                                                                  ),
                                                            ),
                                                      ),
                                                    ),
                                                    itemBuilder:
                                                        (
                                                          context,
                                                          user,
                                                          isSelected,
                                                        ) => ListTile(
                                                          tileColor:
                                                              mainBgColor,
                                                          title: Text(
                                                            user?.fullName ??
                                                                '',
                                                          ),
                                                        ),
                                                  ),
                                                  dropdownDecoratorProps: DropDownDecoratorProps(
                                                    dropdownSearchDecoration: InputDecoration(
                                                      labelText: 'Select User',
                                                      filled: true,
                                                      fillColor: mainBgColor,
                                                      floatingLabelBehavior:
                                                          FloatingLabelBehavior
                                                              .never,
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color:
                                                                  primaryColor,
                                                            ),
                                                          ),
                                                    ),
                                                  ),
                                                ),

                                              const SizedBox(height: 8),
                                              Wrap(
                                                spacing: 8,
                                                children: selectedUsers
                                                    .map(
                                                      (user) => Chip(
                                                        label: Text(
                                                          user.fullName,
                                                        ),
                                                        backgroundColor:
                                                            mainBgColor
                                                                .withValues(
                                                                  alpha: 0.2,
                                                                ),
                                                        side: BorderSide(
                                                          color: grey,
                                                          width: 0.3,
                                                        ),
                                                        onDeleted: () {
                                                          setState(() {
                                                            selectedUsers
                                                                .remove(user);
                                                          });
                                                        },
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          const Text("ISO Standard Clauses"),
                                          const SizedBox(height: 10),

                                          SizedBox(
                                            height:
                                                200, // set your desired height
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: clauseTitles
                                                    .asMap()
                                                    .entries
                                                    .map((entry) {
                                                      int idx = entry.key;
                                                      String title =
                                                          entry.value;

                                                      return CheckboxListTile(
                                                        value: process
                                                            .selectedClauses[idx],
                                                        onChanged: (val) {
                                                          setState(() {
                                                            process.selectedClauses[idx] =
                                                                val!;
                                                          });
                                                        },
                                                        title: Text(title),
                                                      );
                                                    })
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text('Selected ISO Standard'),
                                          gap4px,
                                          if (process.selectedClauses.any(
                                            (selected) => selected,
                                          ))
                                            Wrap(
                                              spacing: 8,
                                              children: process.selectedClauses
                                                  .asMap()
                                                  .entries
                                                  .where((entry) => entry.value)
                                                  .map(
                                                    (entry) => Chip(
                                                      backgroundColor:
                                                          mainBgColor
                                                              .withValues(
                                                                alpha: 0.2,
                                                              ),
                                                      side: BorderSide(
                                                        color: grey,
                                                        width: 0.3,
                                                      ),
                                                      label: Text(
                                                        clauseTitles[entry.key],
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          const Divider(),
                                        ],
                                      ),
                                    );
                                  }),

                                  TextButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        dayProcesses[index].add(ProcessItem());
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      color: primaryColor,
                                    ),
                                    label: const Text(
                                      "Add Row",
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
