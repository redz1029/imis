import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/performance_governance_system/models/performance_governance_system.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/performance_governance_system/models/pgs_readiness.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/performance_governance_system/pgs_signatory_template/models/pgs_signatory.dart';
import 'package:imis/performance_governance_system/pgs_signatory_template/models/pgs_signatory_template.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerformanceGovernanceSystemPage extends StatefulWidget {
  const PerformanceGovernanceSystemPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PerformanceGovernanceSystemPageState createState() =>
      _PerformanceGovernanceSystemPageState();
}

class _PerformanceGovernanceSystemPageState
    extends State<PerformanceGovernanceSystemPage> {
  final GlobalKey _menuKey = GlobalKey();

  Map<int, TextEditingController> deliverablesControllers = {};
  Map<int, TextEditingController> signatoryControllers = {};
  Map<int, TextEditingController> selectedByWhenControllers = {};
  Map<int, Map<String, dynamic>> selectedKRAObjects = {};
  late Future<List<Map<String, dynamic>>> deliverables;
  Map<int, PgsStatus> selectedStatus = {};
  Map<int, String> selectedValues = {};
  Map<int, String> selectedByWhen = {};
  Map<int, String> selectedStatusOptions = {};
  Map<int, bool> selectedDirect = {};
  Map<int, bool> selectedIndirect = {};
  Map<int, bool> tempSelectedDirect = {};
  Map<int, bool> tempSelectedIndirect = {};
  Map<int, int?> selectedKRA = {};
  String userId = "";
  List<User> userList = [];
  List<User> filteredListUser = [];
  List<PgsSignatory> displaySignatoryList = [];

  List<Map<String, dynamic>> deliverableList = [];
  List<Map<String, dynamic>> deliverableLists = [];
  List<Map<String, dynamic>> readinessList = [];
  List<Map<String, dynamic>> filteredList = [];
  List<Map<String, dynamic>> filteredListSignatory = [];
  List<Map<String, dynamic>> options = [];
  List<String> kraOptions = [];
  Map<int, int?> deliverableIds = {};
  Map<int, int?> signatoryIds = {};

  List<Map<String, dynamic>> signatoryList = [];

  List<int> rows = [];
  int rowIndex = 1;
  // String? _selectedUserId;

  String? _submittedByUserId;
  String? _notedByUserId;
  String? _approvedByUserId;

  String officeDisplay = "";
  String officeIdList = "";
  String? selectedOffice = "";
  String? selectedPeriodText;
  TextEditingController percentage = TextEditingController();

  List<Map<String, dynamic>> periodList = [];
  List<Map<String, dynamic>> filteredListPeriod = [];
  List<PgsDeliverables> deliverablesList = [];

  int? selectedPeriod;

  //For search controller
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchFocus = FocusNode();

  List<String> pgsStatusOptions = PgsStatus.values.map((e) => e.name).toList();
  // ignore: non_constant_identifier_names
  List<String> StatusOptions = ['PATIENT', 'RESEARCH', 'LINKAGES', 'HR'];

  //Start Readiness Rating-Cancer Care------------------------------------------------------------------------------------------------
  TextEditingController competenceScoreController = TextEditingController(
    text: '',
  );
  TextEditingController resourceScoreController = TextEditingController(
    text: '',
  );
  TextEditingController confidenceScoreController = TextEditingController(
    text: '',
  );
  TextEditingController totalScoreController = TextEditingController(text: '');
  ValueNotifier<double> percentageScore = ValueNotifier(0.0);

  // Variables to store dropdown selections
  ValueNotifier<double> competenceScore = ValueNotifier(0.0);
  ValueNotifier<double> resourceScore = ValueNotifier(0.0);
  ValueNotifier<double> confidenceScore = ValueNotifier(0.0);

  double get totalScore =>
      competenceScore.value + resourceScore.value + confidenceScore.value;

  bool isValidInput(String value) {
    return value.isEmpty || value == '0' || value == '0.5' || value == '1';
  }

  final dio = Dio();

  //Save pgs

  Future<void> savePGS(PerformanceGovernanceSystem audit) async {
    var url = ApiEndpoint().performancegovernancesystem;

    if (selectedDirect.isEmpty ||
        selectedIndirect.isEmpty ||
        deliverablesControllers.values.any(
          (controller) => controller.text.trim().isEmpty,
        ) ||
        percentage.text.trim().isEmpty) {
      MotionToast.error(
        title: const Text("Missing Fields"),
        description: const Text(
          "Please complete all required fields before saving.",
        ),
        // ignore: deprecated_member_use
        position: MotionToastPosition.top,
      ).show(context);
      return;
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        debugPrint("Error: Access token is missing!");
        return;
      }

      // Construct deliverables list WITHOUT IDs for new records
      List<PgsDeliverables> deliverablesList = [];

      for (int index in rows) {
        final name = deliverablesControllers[index]?.text.trim() ?? '';
        if (name.isEmpty) continue;

        int kraId = selectedKRA[index] ?? 0;

        KeyResultArea kra = KeyResultArea(kraId, 'KRA Name', 'Remarks', false);
        deliverablesList.add(
          PgsDeliverables(
            null,
            kra,
            name,
            selectedDirect[index] ?? true,
            DateTime.tryParse(selectedByWhen[index] ?? '') ?? DateTime.now(),
            double.tryParse(percentage.text) ?? 0.0,
            selectedStatus[index] ?? PgsStatus.notStarted,
          ),
        );
      }

      deliverablesList;
      double.tryParse(percentage.text) ?? 0.0;

      final requestData = audit.toJson();

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
        debugPrint("Pgs data saved successfully!");
        debugPrint("Pgs ID: ${response.data['id']}"); // Print the new PGS ID

        setState(() {
          fetchPgsList();
          clearAllSelections();
        });

        await prefs.remove('selectedOfficeId');
        await prefs.remove('selectedOfficeName');
      } else {
        debugPrint("Failed to save Pgs data: ${response.statusCode}");
        debugPrint("Response: ${response.data}");
      }
    } on DioException catch (e) {
      debugPrint(
        "Dio error: ${e.response?.statusCode} - ${e.response?.data ?? e.message}",
      );
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
  }

  // Future<void> updatePGS({
  //   String? pgsId,
  //   required PerformanceGovernanceSystem audit,
  // }) async {
  //   // final correctPgsId = audit.id.toString(); // Always use audit.id
  //   final url = '${ApiEndpoint().performancegovernancesystem}/$pgsId';

  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String? token = prefs.getString('accessToken');

  //     if (token == null || token.isEmpty) {
  //       debugPrint("Error: Access token is missing!");
  //       return;
  //     }

  //     // Ensure we have a valid audit id
  //     if (audit.id == 0) {
  //       debugPrint("Error: Invalid audit ID");
  //       return;
  //     }

  //     final pgs = audit.toJson();

  //     final response = await dio.put(
  //       url,
  //       data: pgs,
  //       options: Options(
  //         headers: {
  //           "Content-Type": "application/json",
  //           "Authorization": "Bearer $token",
  //         },
  //       ),
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       debugPrint("PPPPPPPPGS data saved successfully!");
  //       debugPrint("PGS ID: ${response.data['id']}");
  //        print(pgs);

  //       // After successful save
  //       setState(() {
  //         fetchPgsList();
  //         clearAllSelections();
  //       });

  //       // Clean up shared preferences
  //       await prefs.remove('selectedOfficeId');
  //       await prefs.remove('selectedOfficeName');
  //     } else {
  //       debugPrint("Failed to save PGS data: ${response.statusCode}");
  //       debugPrint("Response: ${response.data}");

  //       if (response.statusCode == 401 || response.statusCode == 403) {
  //         debugPrint("Token expired or invalid. Please log in again.");
  //         // Optionally, redirect to login
  //       }
  //     }
  //   } on DioException catch (e) {
  //     debugPrint("Dio error: ${e.response?.statusCode} - ${e.response?.data ?? e.message}");
  //   } catch (e) {
  //     debugPrint("Unexpected error: $e");
  //   }
  // }

  Future<void> updatePGS({
    String? pgsId,
    required PerformanceGovernanceSystem audit,
  }) async {
    final url = '${ApiEndpoint().performancegovernancesystem}/$pgsId';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        debugPrint(" Error: Access token is missing!");
        return;
      }

      // Ensure valid audit ID
      if (audit.id == 0) {
        debugPrint(" Error: Invalid audit ID");
        return;
      }

      final pgs = audit.toJson();

      final response = await dio.put(
        url,
        data: pgs,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh UI
        setState(() {
          fetchPgsList(); // Refresh the list
          clearAllSelections(); // Reset form state
        });

        // Clean up
        await prefs.remove('selectedOfficeId');
        await prefs.remove('selectedOfficeName');
      } else {
        if (response.statusCode == 401 || response.statusCode == 403) {
          debugPrint(
            " Token expired or invalid. Consider redirecting to login.",
          );
        }
      }
    } on DioException catch (e) {
      debugPrint(
        "DioException: ${e.response?.statusCode} - ${e.response?.data ?? e.message}",
      );
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
  }

  Future<void> fetchSignatory() async {
    var url = ApiEndpoint().signatoryTemplate;

    try {
      var response = await dio.get(url);

      if (response.statusCode == 200 && response.data is List) {
        List<PgsSignatoryTemplate> data =
            (response.data as List)
                .map((signatory) => PgsSignatoryTemplate.fromJson(signatory))
                .toList();

        if (mounted) {
          setState(() {
            signatoryList =
                data.map((signatory) => signatory.toJson()).toList();
            filteredListSignatory = List.from(signatoryList);
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

  Future<void> fetchUser() async {
    var url = ApiEndpoint().users;
    try {
      final response = await dio.get(url);
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
              _submittedByUserId = filteredListUser[0].id;
              _approvedByUserId = filteredListUser[0].id;
              _notedByUserId = filteredListUser[0].id;
            }
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  String getFullNameFromSignatoryId(String? signatoryTemplateId) {
    if (signatoryTemplateId == null) return 'Unknown';

    try {
      final signatory = signatoryList.firstWhere(
        (s) => s['id'].toString() == signatoryTemplateId.toString(),
        orElse: () => <String, dynamic>{},
      );
      if (signatory.isEmpty || signatory['defaultSignatoryId'] == null) {
        return 'Unknown';
      }
      final userId = signatory['defaultSignatoryId'].toString();
      final user = userList.firstWhere(
        (u) => u.id.toString() == userId,
        orElse: () => User(id: '', fullName: 'Unknown'),
      );
      return user.fullName;
    } catch (e) {
      return 'Unknown';
    }
  }

  Widget _buildSignatoryColumn({
    required String title,
    required String? currentValue,
    required ValueChanged<String?> onChanged,
    required VoidCallback onDeleted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12)),
        gap6,
        Container(width: 300, height: 1, color: Colors.grey),
        gap,
        currentValue == null
            ? DropdownButton<String>(
              hint: const Text('Select name'),
              value: currentValue,
              items:
                  userList.map((user) {
                    return DropdownMenuItem<String>(
                      value: user.id,
                      child: Text(user.fullName),
                    );
                  }).toList(),
              onChanged: (value) {
                onChanged(value);
              },
            )
            : Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (userList.any((user) => user.id == currentValue)
                          ? userList
                              .firstWhere((user) => user.id == currentValue)
                              .fullName
                          : getFullNameFromSignatoryId(currentValue)),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('[No Position]', style: const TextStyle(fontSize: 12)),
                  ],
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: onDeleted),
              ],
            ),
      ],
    );
  }

  Future<List<PgsDeliverables>> fetchDeliverables({String? pgsId}) async {
    List<PgsDeliverables> deliverablesList = [];
    final url = "${ApiEndpoint().performancegovernancesystem}/$pgsId";

    debugPrint("Fetching deliverables for PGS ID: $pgsId");

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        debugPrint("Error: Access token is missing!");
        return [];
      }

      final response = await dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final pgsDataList = data is List ? data : [data];

        for (var pgsJson in pgsDataList) {
          final deliverables =
              (pgsJson['pgsDeliverables'] as List)
                  .map((d) => PgsDeliverables.fromJson(d))
                  .where((d) => d.id != null)
                  .toList();

          for (var d in deliverables) {
            debugPrint(
              "📦 Deliverable loaded: ID=${d.id}, Name=${d.deliverableName}",
            );
          }

          deliverablesList.addAll(deliverables);
        }
      } else {
        debugPrint("Failed to fetch deliverables: ${response.statusCode}");
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data ?? e.message}");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }

    return deliverablesList;
  }

  Future<bool?> _confirmAction(String title, String message) async {
    return await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("No"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Yes"),
              ),
            ],
          ),
    );
  }

  Future<String?> _selectOffice() async {
    // Change return type to Future<String?>
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> officeNames = prefs.getStringList('officeNames') ?? [];
    List<String> officeIds = prefs.getStringList('officeIds') ?? [];

    if (officeNames.isEmpty || officeIds.isEmpty) {
      return null; // Return null if no offices
    }

    String? selectedOffice = await showDialog<String>(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ), // Rounded corners
          child: Container(
            width:
                MediaQuery.of(context).size.width * 0.30, // 30% of screen width
            constraints: BoxConstraints(maxHeight: 250), // Limit height
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select an Office",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: officeNames.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(
                            officeNames[index],
                            style: TextStyle(fontSize: 16),
                          ),
                          leading: Icon(
                            Icons.apartment,
                            color: Colors.blueAccent,
                          ),
                          onTap:
                              () => Navigator.pop(
                                context,
                                officeIds[index],
                              ), // Return office ID
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed:
                          () => Navigator.pop(
                            context,
                            null,
                          ), // Return null if canceled
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedOffice == null || selectedOffice == "REMOVE_OFFICE") {
      await prefs.remove('selectedOfficeId');
      return null;
    } else {
      await prefs.setString('selectedOfficeId', selectedOffice);

      return selectedOffice;
    }
  }

  Future<void> fetchPgsList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('id') ?? "UserId";
    });

    final url =
        "${ApiEndpoint().performancegovernancesystemUserId}/userId/$userId?userId=$userId";

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
        List<Map<String, Object>> formattedData =
            (response.data as List).map((pgsJson) {
              PerformanceGovernanceSystem pgs =
                  PerformanceGovernanceSystem.fromJson(pgsJson);
              return {
                'pgsReadinessRatingId': pgs.pgsReadinessRating.id.toString(),
                'id': pgs.id.toString(),
                'name': pgs.office.name,
                'pgsStatus': pgs.pgsStatus.toString(),
                'Start Date': DateTimeConverter().toJson(
                  pgs.pgsPeriod.startDate,
                ),
                'officeid': pgs.office.id,
                'End Date': DateTimeConverter().toJson(pgs.pgsPeriod.endDate),
                'competencescore':
                    pgs.pgsReadinessRating.competenceToDeliver.toString(),
                'confidencescore':
                    pgs.pgsReadinessRating.confidenceToDeliver.toString(),
                'resourcescore':
                    pgs.pgsReadinessRating.resourceAvailability.toString(),
                'selectPeriod': pgs.pgsPeriod.id.toString(),
                'totalscore': pgs.pgsReadinessRating.totalScore.toString(),
                'percentDeliverables': pgs.percentDeliverables.toString(),

                'PgsId':
                    pgs.pgsSignatories != null
                        ? pgs.pgsSignatories!
                            .where((s) => s.pgsId != null)
                            .map((s) => s.pgsId!.toString())
                            .toList()
                        : [],

                'PgsSignatoryTemplateIds':
                    pgs.pgsSignatories != null
                        ? pgs.pgsSignatories!
                            .where((s) => s.pgsSignatoryTemplateId != null)
                            .map((s) => s.pgsSignatoryTemplateId!.toString())
                            .toList()
                        : [],

                'SignatoryId':
                    pgs.pgsSignatories != null
                        ? pgs.pgsSignatories!
                            .where((s) => s.signatoryId != null)
                            .map((s) => s.signatoryId!.toString())
                            .toList()
                        : [],
              };
            }).toList();

        if (mounted) {
          setState(() {
            deliverableLists = formattedData;
            filteredList = List.from(deliverableLists);
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

  //fetch periods
  Future<void> fetchPGSPeriods() async {
    var url = ApiEndpoint().pgsperiod;

    try {
      var response = await dio.get(url);

      if (response.statusCode == 200 && response.data is List) {
        List<PgsPeriod> data =
            (response.data as List)
                .map((period) => PgsPeriod.fromJson(period))
                .toList();

        if (mounted) {
          setState(() {
            periodList = data.map((period) => period.toJson()).toList();
            filteredListPeriod = List.from(
              periodList,
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

  Future<void> _loadOfficeName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> officeNames = prefs.getStringList('officeNames') ?? [];
    List<String> officeIds = prefs.getStringList('officeIds') ?? [];
    selectedOffice = prefs.getString('selectedOfficeId');

    String selectedOfficeName = "No Office";
    if (officeIds.contains(selectedOffice)) {
      int index = officeIds.indexOf(selectedOffice!);
      selectedOfficeName = officeNames[index];
    }

    setState(() {
      officeDisplay = selectedOfficeName;
      officeIdList = selectedOffice ?? "No Office ID";
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSignatory();

    _loadOfficeName();
    fetchPgsList();
    fetchUser();
    fetchPGSPeriods();
    isSearchFocus.addListener(() {
      setState(() {});
    });
    fetchDropdownData().then((_) {
      if (filteredListPeriod.isNotEmpty) {
        selectedPeriod = filteredListPeriod[0]['id'];
        selectedPeriodText =
            "${filteredListPeriod[0]['startDate']} - ${filteredListPeriod[0]['endDate']}";
      }
    });
  }

  Future<void> fetchDropdownData() async {
    var url = ApiEndpoint().keyresult;
    try {
      var response = await dio.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        options =
            data.map<Map<String, dynamic>>((item) {
              return {'id': item['id'] as int, 'name': item['name'].toString()};
            }).toList();

        debugPrint("Fetched Data: $options");
      } else {
        debugPrint("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
  }

  List<PgsDeliverables> getTableDeliverables(int pgsid) {
    List<PgsDeliverables> updatedDeliverables = [];
    List<PgsSignatory> updatedSignatory = [];

    deliverablesControllers.forEach((index, controller) {
      debugPrint('Processing deliverable at index $index');

      // Get selected KRA ID or fallback to 1
      int selectedKraId = selectedKRA[index] ?? 1;
      debugPrint("selectedKRA[$index]: $selectedKraId");

      // Match the KRA data from the options list
      final kraData = options.firstWhere(
        (option) => int.tryParse(option['id'].toString()) == selectedKraId,
        orElse: () {
          debugPrint("KRA not found for ID $selectedKraId");
          return {'id': 1, 'name': 'Unspecified KRA', 'description': ''};
        },
      );
      debugPrint("Using KRA data for index $index: $kraData");

      // Build the KeyResultArea object
      KeyResultArea kra = KeyResultArea(
        kraData['id'] ?? 1,
        kraData['name']?.toString() ?? 'Unspecified KRA',
        kraData['description']?.toString() ?? '',
        false,
      );

      // Get and validate the deliverable text
      final name = controller.text.trim();
      if (name.isEmpty) {
        debugPrint("Skipping empty deliverable at index $index");
        return;
      }

      final deliverableText =
          controller.text.isNotEmpty ? controller.text : "No Name";
      final isDirect = selectedDirect[index] ?? false;
      final byWhen =
          DateTime.tryParse(selectedByWhen[index] ?? '') ?? DateTime.now();

      // Parse percentage
      double percentDeliverables = 0.0;
      try {
        percentDeliverables = double.tryParse(percentage.text) ?? 0.0;
      } catch (e) {
        debugPrint("Error parsing percentDeliverables: $e");
      }

      // Determine the status
      final statusIndex =
          selectedStatus[index]?.index ?? PgsStatus.notStarted.index;
      final status = PgsStatus.values.firstWhere(
        (e) => e.index == statusIndex,
        orElse: () => PgsStatus.notStarted,
      );

      final remarks = "";
      final existingId = deliverableIds[index] ?? 0;
      final signatoryExistingId = signatoryIds[index] ?? 0;

      if (existingId > 0) {
        debugPrint(
          "Updating existing deliverable at index $index with ID $existingId - '$deliverableText'",
        );
      }

      // Create and add the deliverable
      updatedDeliverables.add(
        PgsDeliverables(
          existingId,
          kra,
          deliverableText,
          isDirect,
          byWhen,
          percentDeliverables,
          status,
          remarks: remarks,
          rowVersion: '',
        ),
      );

      updatedSignatory.addAll([
        PgsSignatory(
          DateTime.now(),
          false,
          "",
          id: signatoryExistingId,
          pgsId: pgsid,
          pgsSignatoryTemplateId: 1,
          signatoryId: _submittedByUserId!,
        ),
        PgsSignatory(
          DateTime.now(),
          false,
          "",
          id: signatoryExistingId,
          pgsId: pgsid,
          pgsSignatoryTemplateId: 3,
          signatoryId: _approvedByUserId!,
        ),
        PgsSignatory(
          DateTime.now(),
          false,
          "",
          id: signatoryExistingId,
          pgsId: pgsid,
          pgsSignatoryTemplateId: 2,
          signatoryId: _notedByUserId!,
        ),
      ]);
    });

    return updatedDeliverables;
  }

  // List<PgsDeliverables> getTableDeliverables() {
  //   List<PgsDeliverables> updatedDeliverables = [];

  //   deliverablesControllers.forEach((index, controller) {
  //     var kraData =
  //         selectedKRAObjects[index] ??
  //         {'id': 1, 'name': 'Unknown', 'description': ''};

  //     var deliverableText =
  //         controller.text.isNotEmpty ? controller.text : "No Name";
  //     var isDirect = selectedDirect[index] ?? false;
  //     var byWhen =
  //         DateTime.tryParse(selectedByWhen[index] ?? '') ?? DateTime.now();

  //     double percentDeliverables = 0.0;
  //     try {
  //       percentDeliverables = double.tryParse(percentage.text) ?? 0.0;
  //     } catch (e) {
  //       debugPrint("Error parsing percentDeliverables: $e");
  //     }

  //     var statusIndex =
  //         selectedStatus[index]?.index ?? PgsStatus.notStarted.index;
  //     var status = PgsStatus.values.firstWhere(
  //       (e) => e.index == statusIndex,
  //       orElse: () => PgsStatus.notStarted,
  //     );

  //     var remarks = "";

  //     // Check if there's an existing deliverable (for update)
  //     int existingId = deliverableIds[index] ?? 0;

  //     if (existingId > 0) {
  //       debugPrint(
  //         "Updating existing deliverable at index $index with ID $existingId - '$deliverableText'",
  //       );
  //     }

  //     updatedDeliverables.add(
  //       PgsDeliverables(
  //         existingId, // ID (0 for new, >0 for update)
  //         KeyResultArea(
  //           kraData['id'],
  //           kraData['name'],
  //           remarks,
  //           true,
  //           rowVersion: "",
  //         ),
  //         deliverableText,
  //         isDirect,
  //         byWhen,
  //         percentDeliverables,
  //         status,
  //         remarks: remarks,
  //         rowVersion: '',
  //       ),
  //     );
  //   });

  //   return updatedDeliverables;
  // }

  // List<PgsDeliverables> getTableDeliverables() {
  //   List<PgsDeliverables> updatedDeliverables = [];

  //   deliverablesControllers.forEach((index, controller) {
  //     var kraData =
  //         selectedKRAObjects[index] ??
  //         {'id': 1, 'name': 'Unknown', 'description': ''};
  //     // var kraData =
  //     //     selectedKRAObjects[index] ??
  //     //     {'id': 1, 'name': 'Unknown', 'description': ''};

  //     var deliverableText =
  //         controller.text.isNotEmpty ? controller.text : "No Name";
  //     var isDirect = selectedDirect[index] ?? false;
  //     var byWhen =
  //         DateTime.tryParse(selectedByWhen[index] ?? '') ?? DateTime.now();

  //     double percentDeliverables = 0.0;
  //     try {
  //       percentDeliverables = double.tryParse(percentage.text) ?? 0.0;
  //     } catch (e) {
  //       debugPrint("Error parsing percentDeliverables: $e");
  //     }

  //     var statusIndex =
  //         selectedStatus[index]?.index ?? PgsStatus.notStarted.index;
  //     var status = PgsStatus.values.firstWhere(
  //       (e) => e.index == statusIndex,
  //       orElse: () => PgsStatus.notStarted,
  //     );

  //     var remarks = "";

  //     int existingId = deliverableIds[index] ?? 0;

  //     if (existingId > 0) {
  //       int kraId = kraData['id'] ?? 0;
  //       debugPrint(
  //         "Updating existing deliverable at index $index with ID $existingId, KRA ID $kraId - '$deliverableText'",
  //       );
  //     }

  //     updatedDeliverables.add(
  //       PgsDeliverables(
  //         existingId,
  //         KeyResultArea(
  //           kraData['id'],
  //           kraData['name'],
  //           remarks,
  //           true,
  //           rowVersion: "",
  //         ),
  //         deliverableText,
  //         isDirect,
  //         byWhen,
  //         percentDeliverables,
  //         status,
  //         remarks: remarks,
  //         rowVersion: '',
  //       ),
  //     );
  //   });

  //   return updatedDeliverables;
  // }

  PerformanceGovernanceSystem getPgsAuditDetails({
    required int id,
    required String pgsStatus,
    List<PgsSignatory> existingSignatories = const [],
  }) {
    double percentDeliverables = 0.0;

    try {
      percentDeliverables = double.tryParse(percentage.text) ?? 0.0;
    } catch (e) {
      debugPrint("Error parsing percentDeliverables: $e");
    }

    return PerformanceGovernanceSystem(
      id: id,
      pgsStatus: pgsStatus,
      pgsPeriod: PgsPeriod(
        selectedPeriod!,
        false,
        rowVersion: "",
        DateTime.now(),
        DateTime.now(),
      ),
      office: Office(
        id: int.tryParse(selectedOffice!) ?? 0,
        name: "Office Name",
        isActive: false,
        rowVersion: "",
      ),
      pgsDeliverables: getTableDeliverables(id),
      pgsReadinessRating: PgsReadiness(
        0,
        false,
        null,
        competenceScore.value,
        resourceScore.value,
        confidenceScore.value,
        totalScore,
      ),
      pgsSignatories: _getPgsSignatory(id),

      isDeleted: false,
      remarks: "",
      rowVersion: "",
      percentDeliverables: percentDeliverables,
    );
  }

  List<PgsSignatory> _getPgsSignatory(int? pgsid) {
    return [
      PgsSignatory(
        DateTime.now(),
        false,
        "",
        id: 0,
        pgsId: pgsid,
        pgsSignatoryTemplateId: 1,
        signatoryId: _submittedByUserId!,
      ),
      PgsSignatory(
        DateTime.now(),
        false,
        "",
        id: 0,
        pgsId: pgsid,
        pgsSignatoryTemplateId: 3,
        signatoryId: _approvedByUserId!,
      ),
      PgsSignatory(
        DateTime.now(),
        false,
        "",
        id: 0,
        pgsId: pgsid,
        pgsSignatoryTemplateId: 2,
        signatoryId: _notedByUserId!,
      ),
    ];
  }

  //Add rows-------------
  void _addRow() {
    setState(() {
      int newRowId = DateTime.now().millisecondsSinceEpoch;
      rows.add(newRowId);
    });
  }

  void clearAllSelections() {
    rows.clear();
    deliverablesControllers.clear();
    percentage.clear();
    selectedDirect.clear();
    selectedIndirect.clear();
    selectedByWhen.clear();
    selectedStatus.clear();
    selectedKRA.clear();
    deliverableIds.clear();
    deliverablesList.clear();
  }

  void confirmSelection() {
    setState(() {
      selectedDirect.addAll(tempSelectedDirect);
      selectedIndirect.addAll(tempSelectedIndirect);
      tempSelectedDirect.clear();
      tempSelectedIndirect.clear();
    });
  }

  @override
  void dispose() {
    isSearchFocus.dispose();
    super.dispose();
  }

  final Map<String, String> jobTitles = {
    'DR. HALIMA O. MOKAMAD-ROMANCAP': 'Head Department of Surgery',
    'DR. JOHN MALIGA': 'Chief of Medical Professional Staff II',
    'DR. ISHMAEL R. DIMAREN': 'Medical Center Chief II',
  };

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: mainBgColor,
        title: Text('Performance Governance Information'),
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
                    focusNode: isSearchFocus,
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
                      labelText: 'Search Deliverables',
                      prefixIcon: Icon(
                        Icons.search,
                        color: isSearchFocus.hasFocus ? primaryColor : grey,
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
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? selectedOfficeId = prefs.getString(
                        'selectedOfficeId',
                      );
                      if (selectedOfficeId == null ||
                          selectedOfficeId.isEmpty) {
                        await _selectOffice();
                        selectedOfficeId = prefs.getString('selectedOfficeId');
                        if (selectedOfficeId != null &&
                            selectedOfficeId.isNotEmpty) {
                          await _loadOfficeName();
                          showFormDialog();
                        }
                      } else {
                        await _loadOfficeName();
                        showFormDialog();
                        // fetchSignatory();
                      }
                    },
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
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text('#', style: TextStyle(color: grey)),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              'Office Name',
                              style: TextStyle(color: grey),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              'Start Date',
                              style: TextStyle(color: grey),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              'End Date',
                              style: TextStyle(color: grey),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              'Status',
                              style: TextStyle(color: grey),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(right: 1),
                            child: Text(
                              'Actions',
                              style: TextStyle(color: grey),
                            ),
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
                                .map((index, pgsgovernancesystem) {
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
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                pgsgovernancesystem['name'],
                                                // Display office
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                pgsgovernancesystem['Start Date'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                pgsgovernancesystem['End Date'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                pgsgovernancesystem['pgsStatus'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
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
                                                    onPressed: () async {
                                                      List<PgsDeliverables>
                                                      deliverables =
                                                          await fetchDeliverables(
                                                            pgsId:
                                                                pgsgovernancesystem['id'],
                                                          );

                                                      debugPrint(
                                                        'Pgs Status: ${pgsgovernancesystem['pgsStatus']}',
                                                      );

                                                      List<PgsSignatory>
                                                      signatory =
                                                          await fetchSignatoryList(
                                                            pgsId:
                                                                pgsgovernancesystem['id'],
                                                          );

                                                      debugPrint(
                                                        "PGS IDDDDDDDDDDDDDDDDDD. $pgsgovernancesystem,",
                                                      );

                                                      int? dynamicSelectedId =
                                                          int.tryParse(
                                                            pgsgovernancesystem['id']
                                                                .toString(),
                                                          );

                                                      if (dynamicSelectedId !=
                                                          null) {
                                                        setSignatoryLevels(
                                                          dynamicSelectedId,
                                                        );
                                                      } else {
                                                        debugPrint(
                                                          "Error: Invalid ID format for setSignatoryLevels.",
                                                        );
                                                      }
                                                      showFormDialog(
                                                        id:
                                                            pgsgovernancesystem['id'],
                                                        officename:
                                                            pgsgovernancesystem['name'],
                                                        officenameid:
                                                            pgsgovernancesystem['officeid'],
                                                        competencescore:
                                                            pgsgovernancesystem['competencescore'],
                                                        confidencescore:
                                                            pgsgovernancesystem['confidencescore'],
                                                        resourcescore:
                                                            pgsgovernancesystem['resourcescore'],
                                                        startDate:
                                                            pgsgovernancesystem['Start Date'],
                                                        endDate:
                                                            pgsgovernancesystem['End Date'],
                                                        percentDeliverables:
                                                            pgsgovernancesystem['percentDeliverables'],
                                                        deliverables:
                                                            deliverables,
                                                        signatories: signatory,
                                                        pgsstatus:
                                                            pgsgovernancesystem['pgsStatus'],
                                                      );
                                                    },
                                                  ),

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
                                                      setState(() {
                                                        filteredList.removeAt(
                                                          index,
                                                        );
                                                      });
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
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String? selectedOfficeId = prefs.getString(
                    'selectedOfficeId',
                  );

                  if (selectedOfficeId == null || selectedOfficeId.isEmpty) {
                    clearAllSelections(); // Reset form when no office is selected

                    await _selectOffice();
                    selectedOfficeId = prefs.getString('selectedOfficeId');

                    if (selectedOfficeId != null &&
                        selectedOfficeId.isNotEmpty) {
                      await _loadOfficeName();
                      showFormDialog(pgsstatus: null);
                    }
                  } else {
                    // If office is already selected, no need to reset the form unnecessarily
                    await _loadOfficeName();
                    showFormDialog(pgsstatus: null);
                  }
                },
                child: Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  String? getSignatoryByOrderLevelDefault(int level) {
    try {
      final signatory = signatoryList.firstWhere(
        (item) => item['orderLevel'] == level,
        orElse: () => <String, dynamic>{},
      );

      if (signatory.isEmpty || signatory['defaultSignatoryId'] == null) {
        return null;
      }
      return signatory['defaultSignatoryId'].toString();
    } catch (e) {
      return null;
    }
  }

  String? getSignatoryTitleByOrderLevel(int level) {
    try {
      final signatory = signatoryList.firstWhere(
        (item) => item['orderLevel'] == level,
        orElse: () => <String, dynamic>{},
      );

      if (signatory.isEmpty || signatory['signatoryLabel'] == null) {
        return null;
      }

      // debugPrint(signatory);

      return signatory['signatoryLabel'].toString();
    } catch (e) {
      return null;
    }
  }

  Future<List<PgsSignatory>> fetchSignatoryList({String? pgsId}) async {
    final url = "${ApiEndpoint().performancegovernancesystem}/$pgsId";

    debugPrint("Fetching deliverables for PGS ID: $pgsId");

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        debugPrint("Error: Access token is missing!");
        return [];
      }

      final response = await dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final pgsDataList = data is List ? data : [data];

        for (var pgsJson in pgsDataList) {
          final signatories =
              (pgsJson['pgsSignatories'] as List)
                  .map((d) => PgsSignatory.fromJson(d))
                  .where((d) => d.id != null)
                  .toList();

          for (var d in signatories) {
            debugPrint("Deliverable loaded: ID=${d.id}, Name=${d.signatoryId}");
          }

          displaySignatoryList.addAll(signatories);
        }
      } else {
        debugPrint("Failed to fetch deliverables: ${response.statusCode}");
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data ?? e.message}");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }

    return displaySignatoryList;
  }

  String? getSignatoryByOrderLevelEdit({
    required int pgsIdSignatory,
    required int level,
  }) {
    try {
      debugPrint(
        "Getting signatory for PGS ID: $pgsIdSignatory, Level: $level",
      );

      final signatory = displaySignatoryList.firstWhere(
        (item) =>
            item.pgsId == pgsIdSignatory && // Matches by pgsId
            item.pgsSignatoryTemplateId == level, // Matches by level
        orElse:
            () => PgsSignatory(
              DateTime.now(),
              false,
              '',
              id: 0,
              pgsId: pgsIdSignatory,
              pgsSignatoryTemplateId: 0,
              signatoryId: '',
            ),
      );

      // Log the signatory found
      debugPrint("Found signatory: ${signatory.signatoryId}");

      // If the signatoryId is null or empty, return null
      if (signatory.signatoryId == null || signatory.signatoryId!.isEmpty) {
        debugPrint("No valid signatoryId found.");
        return null;
      }

      return signatory.signatoryId;
    } catch (e) {
      debugPrint("Error getting signatory by level: $e");
      return null;
    }
  }

  void setSignatoryLevels(int? dynamicSelectedId) {
    // Ensure selectedId is not null
    final currentPgsId = dynamicSelectedId ?? 0;

    if (currentPgsId != 0) {
      // Fetch signatories and log the results
      _submittedByUserId = getSignatoryByOrderLevelEdit(
        pgsIdSignatory: currentPgsId,
        level: 1,
      );
      _notedByUserId = getSignatoryByOrderLevelEdit(
        pgsIdSignatory: currentPgsId,
        level: 2,
      );
      _approvedByUserId = getSignatoryByOrderLevelEdit(
        pgsIdSignatory: currentPgsId,
        level: 3,
      );

      debugPrint("Submitted By User ID: $_submittedByUserId");
      debugPrint("Noted By User ID: $_notedByUserId");
      debugPrint("Approved By User ID: $_approvedByUserId");
    } else {
      debugPrint("No valid selectedId provided, cannot proceed.");
    }
  }

  void showFormDialog({
    String? id,
    String? officename,
    double? officenameid,
    String? startDate,
    String? endDate,
    String? competencescore,
    String? resourcescore,
    String? confidencescore,
    String? selectPeriod,
    String? percentDeliverables,
    List<dynamic>? deliverabledIds,
    List<PgsDeliverables>? deliverables,
    List<PgsSignatory>? signatories,
    String? pgsstatus,
    String? pgsId,
  }) {
    setState(() {
      // Reset fields when creating a new entry
      if (id == null) {
        competenceScore.value = 0.0;
        resourceScore.value = 0.0;
        confidenceScore.value = 0.0;
        selectedPeriod = null;
        selectedPeriodText = null;
        percentage.clear();
        deliverablesControllers.clear();
        selectedKRA.clear();
        selectedDirect.clear();
        selectedIndirect.clear();
        selectedByWhen.clear();
        selectedStatus.clear();
        deliverableIds.clear();
      } else {
        // EDIT MODE - Populate the form with existing data
        competenceScore.value = double.tryParse(competencescore ?? '') ?? 0.0;
        resourceScore.value = double.tryParse(resourcescore ?? '') ?? 0.0;
        confidenceScore.value = double.tryParse(confidencescore ?? '') ?? 0.0;

        if (percentDeliverables != null) {
          percentage.text = percentDeliverables;
        }

        // Assign the correct period from startDate and endDate
        if (startDate != null && endDate != null) {
          final selected = filteredListPeriod.firstWhere(
            (period) =>
                period['startDate'] == startDate &&
                period['endDate'] == endDate,
            orElse: () => {},
          );

          if (selected.isNotEmpty) {
            selectedPeriod = selected['id'];
            selectedPeriodText =
                "${selected['startDate']} - ${selected['endDate']}";
          } else {
            selectedPeriod = null;
            selectedPeriodText = null;
          }
        }

        // Clear and set new data for the deliverables
        deliverablesControllers.clear();
        selectedKRA.clear();
        selectedDirect.clear();
        selectedIndirect.clear();
        selectedByWhen.clear();
        selectedStatus.clear();
        deliverableIds.clear();

        // if (deliverables != null && deliverables.isNotEmpty) {
        //   rows = List.generate(deliverables.length, (index) => index);

        //   for (int i = 0; i < deliverables.length; i++) {
        //     final item = deliverables[i];
        //     deliverablesControllers[i] = TextEditingController(
        //       text: item.deliverableName,
        //     );
        //     selectedKRA[i] = item.kra.id;
        //     selectedDirect[i] = item.isDirect;
        //     selectedIndirect[i] = !item.isDirect;
        //     selectedByWhen[i] = DateFormat('yyyy-MM-dd').format(item.byWhen);
        //     selectedByWhenControllers[i] = TextEditingController(
        //       text: DateFormat('MMMM yyyy').format(item.byWhen),
        //     );
        //     selectedStatus[i] = item.status;
        //     deliverableIds[i] = item.id ?? 0;
        //   }
        // } else {
        //   rows = [0];
        // }

        if (deliverables != null && deliverables.isNotEmpty) {
          rows = List.generate(deliverables.length, (index) => index);

          for (int i = 0; i < deliverables.length; i++) {
            final item = deliverables[i];

            // 🔍 Debug print for existing deliverable
            debugPrint(
              "Editing Deliverable #$i → ID: ${item.id}, Name: ${item.deliverableName}",
            );

            deliverablesControllers[i] = TextEditingController(
              text: item.deliverableName,
            );
            selectedKRA[i] = item.kra.id;
            selectedDirect[i] = item.isDirect;
            selectedIndirect[i] = !item.isDirect;
            selectedByWhen[i] = DateFormat('yyyy-MM-dd').format(item.byWhen);
            selectedByWhenControllers[i] = TextEditingController(
              text: DateFormat('MMMM yyyy').format(item.byWhen),
            );
            selectedStatus[i] = item.status;
            deliverableIds[i] = item.id ?? 0;
          }
        } else {
          rows = [0];
        }
      }
    });

    bool isDraft = pgsstatus == null || pgsstatus == 'Draft';
    bool isSubmitted = pgsstatus == 'Submitted';
    bool isApproved = pgsstatus == 'Approved';
    bool isCancelled = pgsstatus == 'Cancelled';

    if (id == null) {
      // NEW ENTRY - Set the default signatories for new record
      _submittedByUserId = getSignatoryByOrderLevelDefault(1);
      _notedByUserId = getSignatoryByOrderLevelDefault(2);
      _approvedByUserId = getSignatoryByOrderLevelDefault(3);
    }

    //  else {
    //   // Existing record - Fetch the actual signatories
    //   _submittedByUserId =
    //       signatories
    //           ?.firstWhere((signatory) => signatory.pgsSignatoryTemplateId == 1)
    //           .signatoryId
    //           .toString() ??
    //       '0'; // Ensure it's a String
    //   _notedByUserId =
    //       signatories
    //           ?.firstWhere((signatory) => signatory.pgsSignatoryTemplateId == 2)
    //           .signatoryId
    //           .toString() ??
    //       '0'; // Ensure it's a String
    //   _approvedByUserId =
    //       signatories
    //           ?.firstWhere((signatory) => signatory.pgsSignatoryTemplateId == 3)
    //           .signatoryId
    //           .toString() ??
    //       '0'; // Ensure it's a String
    // }

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
              content: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: primaryTextColor,
                        size: 32,
                      ),
                      onPressed: () {
                        clearAllSelections();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: DefaultTabController(
                        length: 3, // Number of tabs
                        child: Column(
                          children: [
                            // Header Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/CRMC.png', height: 90),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      id == null
                                          ? 'COTABATO REGIONAL AND MEDICAL CENTER'
                                          : 'COTABATO REGIONAL AND MEDICAL CENTER',

                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),

                                    Container(
                                      width: 250,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: DropdownButton<int>(
                                        dropdownColor: mainBgColor,
                                        value: selectedPeriod,
                                        isExpanded: true,
                                        underline: Container(),
                                        icon: Icon(Icons.arrow_drop_down),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        hint: Text(
                                          selectedPeriodText ??
                                              'Select a period',
                                        ),
                                        onChanged: (int? newValue) {
                                          if (newValue != null) {
                                            final selected = filteredListPeriod
                                                .firstWhere(
                                                  (period) =>
                                                      period['id'] == newValue,
                                                  orElse: () => {},
                                                );

                                            setDialogState(() {
                                              selectedPeriod = newValue;
                                              selectedPeriodText =
                                                  "${selected['startDate']} - ${selected['endDate']}";
                                            });

                                            debugPrint(
                                              "Dropdown selected new value: $newValue",
                                            );
                                          }
                                        },
                                        items:
                                            filteredListPeriod.map<
                                              DropdownMenuItem<int>
                                            >((period) {
                                              return DropdownMenuItem<int>(
                                                value: period['id'],
                                                child: Text(
                                                  "${period['startDate']} - ${period['endDate']}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Confirm Dratf Button
                            if (isDraft) ...[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      bool?
                                      confirmCancel = await _confirmAction(
                                        "Confirm Cancel",
                                        "Are you sure you want to cancel the selected office?",
                                      );

                                      if (confirmCancel == true) {
                                        SharedPreferences prefs =
                                            await SharedPreferences.getInstance();
                                        await prefs.remove('selectedOfficeId');
                                        await prefs.remove(
                                          'selectedOfficeName',
                                        );

                                        setDialogState(() {
                                          officeDisplay = ""; // Clear Office UI
                                        });

                                        Navigator.pop(context); // Close dialog

                                        // Select a new office and refresh UI
                                        String? newOfficeId =
                                            await _selectOffice();
                                        if (newOfficeId != null &&
                                            newOfficeId.isNotEmpty) {
                                          await _loadOfficeName(); // Refresh UI immediately
                                          showFormDialog(); // Re-open dialog after refreshing
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        233,
                                        135,
                                        135,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    label: Text(
                                      "Cancel Office",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            // Confirm Submitted Button
                            if (isSubmitted) ...[],
                            if (isApproved) ...[],
                            if (isCancelled) ...[],

                            SizedBox(height: 20),
                            TabBar(
                              labelColor: primaryLightColor,
                              unselectedLabelColor: Colors.black,
                              indicatorColor: primaryColor,
                              labelStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              unselectedLabelStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              tabs: [
                                Tab(
                                  text: "Strategic Contributions",
                                ), // Tab Name 1
                                Tab(
                                  text:
                                      "Readiness Rating - ${officename ?? officeDisplay}",
                                ), // Tab Name 2
                                Tab(
                                  text: "PGS Deliverables Status",
                                ), // Tab Name 3
                              ],
                            ),

                            //First Tab Strategic Contributions
                            Expanded(
                              child: TabBarView(
                                children: [
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20),
                                        Table(
                                          border: TableBorder.all(
                                            color: const Color.fromARGB(
                                              255,
                                              49,
                                              46,
                                              46,
                                            ),
                                            width: 1,
                                          ),
                                          columnWidths: const {
                                            0: FlexColumnWidth(1.5),
                                            1: FlexColumnWidth(0.7),
                                            2: FlexColumnWidth(0.7),
                                            3: FlexColumnWidth(2),
                                            4: FlexColumnWidth(1),
                                            5: FlexColumnWidth(1),
                                            6: FlexColumnWidth(0.7),
                                          },

                                          children: [
                                            _buildMainHeaderStrategic(
                                              officename:
                                                  officename ?? officeDisplay,
                                            ),

                                            _buildTableSubHeaderStrategic(),

                                            ...rows.map(
                                              (rowId) =>
                                                  _buildTableRowStrategic(
                                                    rowId,
                                                    '',
                                                    '',
                                                    setState,
                                                    setDialogState,
                                                  ),
                                            ),
                                          ],
                                        ),

                                        if (isDraft) ...[
                                          TextButton(
                                            onPressed: () {
                                              setDialogState(() {
                                                _addRow();
                                              });
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.add,
                                                  color: primaryColor,
                                                ),
                                                Text(
                                                  'Add Row',
                                                  style: TextStyle(
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                        if (isSubmitted) ...[],

                                        if (isApproved) ...[],

                                        if (isCancelled) ...[],
                                      ],
                                    ),
                                  ),
                                  //End First Tab

                                  //Second Tab  Readiness Rating-Cancer Care
                                  Scaffold(
                                    backgroundColor: mainBgColor,
                                    appBar: AppBar(
                                      automaticallyImplyLeading: false,
                                      title: Row(
                                        children: [
                                          Text(
                                            'READINESS RATING - ${officename ?? officeDisplay}',
                                            style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      toolbarHeight: 60,
                                      backgroundColor: primaryLightColor,
                                    ),
                                    body: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Container(
                                              alignment: Alignment(1.0, 0.0),
                                              padding: EdgeInsets.only(
                                                right: 50.0,
                                              ),
                                              child: Text(
                                                'SCORE',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            // Competence Score Dropdown
                                            buildScoreRow(
                                              'COMPETENCE TO DELIVER',
                                              [
                                                'Teams lack adequate skills and training to deliver performance commitments',
                                                'Teams are skilled but lack training to deliver performance commitments ',
                                                'Teams are highly skilled and trained to deliver performance commitments',
                                              ],

                                              competenceScore,
                                            ),

                                            // Resource Availability Dropdown
                                            buildScoreRow(
                                              'RESOURCE AVAILABILITY',
                                              [
                                                'Insufficient; external resources difficult to source',
                                                'Sufficient resources but not available; OR Insufficient but external resources can be tapped',
                                                'Sufficient and available staff and budget',
                                              ],

                                              resourceScore,
                                            ),

                                            // Confidence to Deliver Dropdown
                                            buildScoreRow(
                                              'CONFIDENCE TO DELIVER',
                                              [
                                                'Low confidence because of high degree of organizational change required',
                                                'Moderate confidence',
                                                'High confidence despite organizational change required',
                                              ],

                                              confidenceScore,
                                            ),

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                ValueListenableBuilder<double>(
                                                  valueListenable:
                                                      competenceScore,
                                                  builder: (context, comp, __) {
                                                    return ValueListenableBuilder<
                                                      double
                                                    >(
                                                      valueListenable:
                                                          resourceScore,
                                                      builder: (
                                                        context,
                                                        res,
                                                        // _,
                                                        __,
                                                      ) {
                                                        return ValueListenableBuilder<
                                                          double
                                                        >(
                                                          valueListenable:
                                                              confidenceScore,
                                                          builder: (
                                                            context,
                                                            // _,
                                                            conf,
                                                            __,
                                                          ) {
                                                            final totalScore =
                                                                comp +
                                                                res +
                                                                conf;
                                                            return Padding(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                    right: 60.0,
                                                                  ),
                                                              child: Text(
                                                                ('TOTAL SCORE:${totalScore.toStringAsFixed(1)}'),

                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      Colors
                                                                          .black,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  //End Second Tab

                                  // Third Tab: PGS Deliverable Status
                                  SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20),
                                        Table(
                                          border: TableBorder.all(
                                            color: const Color.fromARGB(
                                              255,
                                              49,
                                              46,
                                              46,
                                            ),
                                            width: 1,
                                          ),
                                          columnWidths: const {
                                            0: FlexColumnWidth(1.5),
                                            1: FlexColumnWidth(0.7),
                                            2: FlexColumnWidth(0.7),
                                            3: FlexColumnWidth(2),
                                            4: FlexColumnWidth(1),
                                            5: FlexColumnWidth(1),
                                            6: FlexColumnWidth(0.7),
                                          },
                                          children: [
                                            _PgsDeliverableHeader(
                                              officename:
                                                  officename ?? officeDisplay,
                                            ),
                                            _PgsBuildTableSubheader(),
                                            ...rows.map(
                                              (rowId) =>
                                                  _buildTableRowStrategic(
                                                    rowId,
                                                    '',
                                                    '',
                                                    setState,
                                                    setDialogState,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSignatoryColumn(
                                      title:
                                          '${getSignatoryTitleByOrderLevel(1) ?? ''}:',
                                      currentValue: _submittedByUserId,
                                      onChanged: (value) {
                                        setDialogState(() {
                                          _submittedByUserId = value;
                                        });
                                      },
                                      onDeleted: () {
                                        setDialogState(() {
                                          _submittedByUserId = null;
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 40),
                                    _buildSignatoryColumn(
                                      title:
                                          '${getSignatoryTitleByOrderLevel(2) ?? ''}:',
                                      currentValue: _notedByUserId,
                                      onChanged: (value) {
                                        setDialogState(() {
                                          _notedByUserId = value;
                                        });
                                      },
                                      onDeleted: () {
                                        setDialogState(() {
                                          _notedByUserId = null;
                                        });
                                      },
                                    ),
                                    const SizedBox(width: 40),
                                    _buildSignatoryColumn(
                                      title:
                                          '${getSignatoryTitleByOrderLevel(3) ?? ''}:',
                                      currentValue: _approvedByUserId,
                                      onChanged: (value) {
                                        setDialogState(() {
                                          _approvedByUserId = value;
                                        });
                                      },
                                      onDeleted: () {
                                        setDialogState(() {
                                          _approvedByUserId = null;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              //End third tab

              // Action Buttons
              actions: [
                if (isDraft) ...[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 45, 57, 212),
                    ),
                    onPressed: () async {
                      bool? confirm = await showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: Text("Confirm Submit"),
                              content: Text(
                                "Are you sure you want to submit this record? You won’t be able to make any changes.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, false),
                                  child: Text("No"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text("Yes"),
                                ),
                              ],
                            ),
                      );

                      if (confirm == true) {
                        int? pgsId = int.tryParse(id ?? '');
                        PerformanceGovernanceSystem audit = getPgsAuditDetails(
                          id: pgsId ?? 0,
                          pgsStatus: "Submitted",
                        );
                        await savePGS(audit);

                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () async {
                      bool? confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (_) => AlertDialog(
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
                                  onPressed:
                                      () => Navigator.pop(context, false),
                                  child: Text("No"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text("Yes"),
                                ),
                              ],
                            ),
                      );

                      // if (confirm == true) {
                      //   int? pgsId = int.tryParse(id ?? '');

                      //   // Generate PGS details
                      //   PerformanceGovernanceSystem audit = getPgsAuditDetails(
                      //     id: pgsId ?? 0,
                      //     pgsStatus: "Draft",
                      //   );

                      //   if (pgsId == null) {

                      //     debugPrint("Saving new PGS");
                      //     await savePGS(audit);

                      //   } else {

                      //      debugPrint("Updating PGS with ID: $pgsId");
                      //     await updatePGS(
                      //       pgsId: pgsId.toString(),
                      //       audit: audit,
                      //     );
                      //   }

                      //   Navigator.pop(context);
                      // }

                      if (confirm == true) {
                        int? pgsId = int.tryParse(id ?? '');

                        // Generate the full PGS audit object
                        PerformanceGovernanceSystem audit = getPgsAuditDetails(
                          id: pgsId ?? 0,
                          pgsStatus: "Draft",
                        );

                        try {
                          if (pgsId == null) {
                            debugPrint("Saving new PGS...");
                            await savePGS(audit);
                          } else {
                            debugPrint("Updating PGS with ID: $pgsId...");
                            await updatePGS(
                              pgsId: pgsId.toString(),
                              audit: audit,
                            );
                          }

                          Navigator.pop(
                            context,
                          ); // Close dialog or form after save/update
                        } catch (e) {
                          debugPrint("Error saving/updating PGS: $e");
                          // Optionally show error feedback to the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to save PGS: $e')),
                          );
                        }
                      }
                    },
                    child: Text(
                      id == null ? 'Save as draft' : 'Save as draft',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],

                if (isSubmitted) ...[],

                if (isApproved) ...[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text(
                      id == null ? 'Print' : 'Print',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],

                if (isCancelled) ...[],
              ],
            );
          },
        );
      },
    );
  } //end

  Widget _buildDatePickerCell(int index, Function setDialogState) {
    selectedByWhenControllers.putIfAbsent(index, () => TextEditingController());

    if (selectedByWhen[index] == null ||
        selectedByWhenControllers[index]?.text.isEmpty == true) {
      DateTime now = DateTime.now();
      String defaultDate = DateFormat('yyyy-MM-dd').format(now); // ISO format
      selectedByWhen[index] = defaultDate;
      selectedByWhenControllers[index]?.text = DateFormat(
        'MMMM yyyy',
      ).format(now);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller:
            selectedByWhenControllers[index], // Use persistent controller
        readOnly: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          contentPadding: EdgeInsets.all(8.0),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: primaryColor,
                    onPrimary: secondaryColor,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: primaryColor),
                  ),
                ),
                child: child!,
              );
            },
          );
          if (pickedDate != null) {
            String formattedDate = DateFormat(
              'yyyy-MM-dd',
            ).format(pickedDate); // ISO format for saving
            setDialogState(() {
              selectedByWhen[index] = formattedDate;
              selectedByWhenControllers[index]?.text = DateFormat(
                'MMMM yyyy',
              ).format(pickedDate); // User-friendly format
            });
          }
        },
      ),
    );
  }

  // Kra Dropdown
  // Kra Dropdown
  // Widget _buildDropdownKraCell(int index) {
  //   if (selectedKRA[index] == null && options.isNotEmpty) {
  //     selectedKRA[index] = options.first['id'];
  //     selectedKRAObjects[index] = options.first;
  //   }

  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: DropdownButtonFormField<int>(
  //       isExpanded: true,
  //       value: selectedKRA[index],
  //       // onChanged: (int? newValue) {
  //       //   if (newValue == null) return; // Guard against null values

  //       //   setState(() {
  //       //     selectedKRA[index] = newValue;
  //       //     selectedKRAObjects[index] = options.firstWhere(
  //       //       (option) => option['id'] == newValue,
  //       //       orElse: () => {'id': 0, 'name': 'Unknown'},
  //       //     );
  //       //   });
  //       // },
  //       onChanged: (int? newValue) {
  //         if (newValue == null) return; // Guard against null values

  //         setState(() {
  //           selectedKRA[index] = newValue;
  //           selectedKRAObjects[index] = options.firstWhere(
  //             (option) => option['id'] == newValue,
  //             orElse: () => {'id': 0, 'name': 'Unknown', 'description': ''},
  //           );
  //           debugPrint(
  //             '🔄 Updated selectedKRAObjects[$index] to ${selectedKRAObjects[index]}',
  //           );
  //         });
  //       },

  //       decoration: const InputDecoration(
  //         border: OutlineInputBorder(),
  //         contentPadding: EdgeInsets.symmetric(
  //           horizontal: 12.0,
  //           vertical: 20.0,
  //         ),
  //       ),
  //       items:
  //           options.map<DropdownMenuItem<int>>((option) {
  //             return DropdownMenuItem<int>(
  //               value: option['id'],
  //               child: Text(
  //                 option['name'],
  //                 softWrap: true,
  //                 overflow:
  //                     TextOverflow.visible, // Ensure long items are visible
  //               ),
  //             );
  //           }).toList(),
  //       selectedItemBuilder: (BuildContext context) {
  //         return options.map<Widget>((option) {
  //           return Container(
  //             alignment: Alignment.centerLeft,
  //             child: Text(
  //               option['name'],
  //               softWrap: true,
  //               overflow: TextOverflow.visible, // Don't truncate selected item
  //               style: const TextStyle(fontSize: 14),
  //             ),
  //           );
  //         }).toList();
  //       },
  //       dropdownColor:
  //           Colors.white, // Optional: to set the dropdown's background color
  //       iconSize: 30.0, // Optional: to adjust the icon size
  //       itemHeight:
  //           50.0, // Controls the height of each dropdown item (in case you want taller items)
  //     ),
  //   );
  // }
  // Widget _buildDropdownKraCell(int index) {
  //   // Ensure selectedKRA and selectedKRAObjects are initialized for the index
  //   if (selectedKRA[index] == null && options.isNotEmpty) {
  //     selectedKRA[index] = options.first['id'] as int;
  //     selectedKRAObjects[index] = options.first;
  //   }

  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: DropdownButtonFormField<int>(
  //       isExpanded: true,
  //       value: selectedKRA[index],
  //       onChanged: (int? newValue) {
  //         if (newValue == null) return;
  //         setState(() {
  //           selectedKRA[index] = newValue;
  //           selectedKRAObjects[index] = options.firstWhere(
  //             (option) => option['id'] == newValue,
  //             orElse: () => {'id': 0, 'name': 'Unknown', 'description': ''},
  //           );
  //           debugPrint('🔄 selectedKRA[$index] updated to $newValue');
  //           debugPrint(
  //             '🔄 selectedKRAObjects[$index] updated to ${selectedKRAObjects[index]}',
  //           );
  //         });
  //       },
  //       decoration: const InputDecoration(
  //         border: OutlineInputBorder(),
  //         contentPadding: EdgeInsets.symmetric(
  //           horizontal: 12.0,
  //           vertical: 20.0,
  //         ),
  //       ),
  //       items:
  //           options.map<DropdownMenuItem<int>>((option) {
  //             return DropdownMenuItem<int>(
  //               value: option['id'] as int,
  //               child: Text(
  //                 option['name'].toString(),
  //                 softWrap: true,
  //                 overflow: TextOverflow.visible,
  //               ),
  //             );
  //           }).toList(),
  //       selectedItemBuilder: (BuildContext context) {
  //         return options.map<Widget>((option) {
  //           return Container(
  //             alignment: Alignment.centerLeft,
  //             child: Text(
  //               option['name'].toString(),
  //               softWrap: true,
  //               overflow: TextOverflow.visible,
  //               style: const TextStyle(fontSize: 14),
  //             ),
  //           );
  //         }).toList();
  //       },
  //       dropdownColor: Colors.white,
  //       iconSize: 30.0,
  //       itemHeight: 50.0,
  //     ),
  //   );
  // }
  Widget _buildDropdownKraCell(int index) {
    // Fallback KRA option if none selected
    Map<String, dynamic> defaultOption = {
      'id': 0,
      'name': 'Select a KRA',
      'description': '',
    };

    // Initialize selectedKRA and selectedKRAObjects if null
    if (selectedKRA[index] == null) {
      final initialOption = options.isNotEmpty ? options.first : defaultOption;
      selectedKRA[index] = initialOption['id'] as int;
      selectedKRAObjects[index] = initialOption;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<int>(
        isExpanded: true,
        value: selectedKRA[index],
        onChanged: (int? newValue) {
          if (newValue == null) return;

          setState(() {
            selectedKRA[index] = newValue;
            selectedKRAObjects[index] = options.firstWhere(
              (option) => option['id'] == newValue,
              orElse: () => defaultOption,
            );
            debugPrint('🔄 selectedKRA[$index] updated to $newValue');
            debugPrint(
              '🔄 selectedKRAObjects[$index] updated to ${selectedKRAObjects[index]}',
            );
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 16.0,
          ),
        ),
        items:
            options.map<DropdownMenuItem<int>>((option) {
              return DropdownMenuItem<int>(
                value: option['id'] as int,
                child: Text(
                  option['name'].toString(),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
        selectedItemBuilder: (BuildContext context) {
          return options.map<Widget>((option) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                option['name'].toString(),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList();
        },
        dropdownColor: Colors.white,
        iconSize: 30.0,
        itemHeight: 48.0,
      ),
    );
  }

  //Start Strategic Contributions
  // Strategic Contribution Main Header
  TableRow _buildMainHeaderStrategic({String? officename}) {
    return TableRow(
      decoration: BoxDecoration(color: primaryLightColor),

      children: [
        GestureDetector(
          key: _menuKey,
          child: BuildHeaderCell(
            text: officename ?? officeDisplay,
            color: Colors.white,
            fontSize: 20,
            fontStyle: FontStyle.normal,
          ),
        ),

        BuildHeaderCell(text: ''),
        BuildHeaderCell(text: ''),
        BuildHeaderCell(
          text: 'STRATEGIC CONTRIBUTIONS',
          color: Colors.white,
          fontSize: 20,
          fontStyle: FontStyle.normal,
        ),

        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: percentage,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: secondaryColor,
                fontSize: 20,
                fontStyle: FontStyle.normal,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+$'),
                ), // Only allow numbers
              ],
              decoration: InputDecoration(
                hintText: '0',
                suffixText: '%',
                suffixStyle: TextStyle(color: secondaryColor, fontSize: 20),
                hintStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
        ),

        BuildHeaderCell(text: ''),
        BuildHeaderCell(text: ''),
      ],
    );
  }

  // Sub Header
  TableRow _buildTableSubHeaderStrategic() {
    return TableRow(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 254, 254),
      ),
      children: [
        BuildHeaderCell(text: 'KRA'),
        BuildHeaderCell(text: 'DIRECT'),
        BuildHeaderCell(text: 'INDIRECT'),
        BuildHeaderCell(text: 'DELIVERABLES'),
        BuildHeaderCell(text: 'BY WHEN'),
        BuildHeaderCell(text: 'STATUS'),
        BuildHeaderCell(text: 'ACTION'),
      ],
    );
  }

  // PGS Table Row  Strategic
  TableRow _buildTableRowStrategic(
    int index,
    String direct,
    String indirect,
    Function setState,
    Function setDialogState,
  ) {
    deliverablesControllers.putIfAbsent(index, () => TextEditingController());
    selectedDirect.putIfAbsent(index, () => false);
    selectedIndirect.putIfAbsent(index, () => false);
    selectedByWhen.putIfAbsent(index, () => '');

    // Define alternating row colors
    Color rowColor = (index % 2 == 0) ? mainBgColor : Colors.white;

    return TableRow(
      decoration: BoxDecoration(color: rowColor),
      children: [
        _buildDropdownKraCell(index),
        _buildCheckboxCell(
          index,
          selectedDirect,
          selectedIndirect,
          setDialogState,
          isDirect: true,
        ),
        _buildCheckboxCell(
          index,
          selectedIndirect,
          selectedDirect,
          setDialogState,
          isDirect: false,
        ),
        _buildExpandableTextAreaCell(index),
        _buildDatePickerCell(index, setDialogState),
        _buildDropdownCellStatus(index, () => (index)),
        _buildRemoveButton(index, setDialogState),
      ],
    );
  }

  // Dropdown field that allows changing PgsStatus for each row
  Widget _buildDropdownCellStatus(int index, VoidCallback setDialogState) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<PgsStatus>(
        value:
            selectedStatus[index] ??
            PgsStatus.notStarted, // Display current status for this row
        onChanged: (PgsStatus? newValue) {
          if (newValue != null) {
            print(
              'Selected Status for index $index: ${newValue.name}',
            ); // Debug print
            setDialogState(); // Trigger setState to update UI
            setState(() {
              selectedStatus[index] =
                  newValue; // Update status for this row's index
            });
            saveStatusToDb(
              index,
              newValue,
            ); // Save the selected status to the database
          }
        },
        isExpanded: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(8.0),
        ),
        items:
            PgsStatus.values.map((PgsStatus value) {
              return DropdownMenuItem<PgsStatus>(
                value: value,
                child: Text(value.name, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
      ),
    );
  }

  // Function to save status to the database
  void saveStatusToDb(int index, PgsStatus status) {
    int statusIndex = status.index; // Get the integer value of the status

    // Example: Saving the status index to a mock DB (or replace with actual API call)
    print('Saving status for index $index: $statusIndex');

    // Here you can save the statusIndex to your database
    // For example: api.saveStatus(index, statusIndex);
  }

  // // Check Box
  Widget _buildCheckboxCell(
    int index,
    Map<int, bool> selectedValues,
    Map<int, bool> oppositeValues,
    Function setDialogState, {
    required bool isDirect,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color.fromARGB(255, 255, 255, 255),
            width: 0.5,
          ),
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Checkbox(
            value: selectedValues[index] ?? false, // Read from state
            onChanged: (bool? newValue) {
              if (newValue == null) return;

              setDialogState(() {
                selectedValues[index] = newValue;

                if (newValue) {
                  oppositeValues[index] = false;
                }

                debugPrint("Index: $index");
                debugPrint(
                  "${isDirect ? "Direct" : "Indirect"} checked: $newValue",
                );
                debugPrint(
                  "${isDirect ? "Indirect" : "Direct"} unchecked: ${oppositeValues[index]}",
                );
              });
            },
            activeColor: Colors.white,
            checkColor: Colors.black,
          ),
        ),
      ),
    );
  }

  //Readiness Rating-Cancer Care Table
  Widget buildScoreRow(
    String title,
    List<String> descriptions,
    ValueNotifier<double> selectedValue,
  ) {
    List<Color> boxColors = [
      const Color.fromARGB(197, 235, 235, 235),
      secondaryBgButton,
      primaryLightColor,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            for (int i = 0; i < descriptions.length; i++)
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  height: 120,
                  decoration: BoxDecoration(
                    color: boxColors[i],
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${i * 0.5}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        descriptions[i],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            Container(
              width: 150,
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 245, 243, 243),
                ), // Optional: Adds a border
                borderRadius: BorderRadius.circular(
                  1,
                ), // Optional: Rounds the corners
              ),
              child: ValueListenableBuilder<double>(
                valueListenable: selectedValue,
                builder: (context, value, child) {
                  return DropdownButton<double>(
                    value: value,
                    onChanged: (newValue) {
                      selectedValue.value = newValue!;
                    },
                    items: List.generate(descriptions.length, (index) {
                      return DropdownMenuItem(
                        value: index * 0.5,
                        child: Center(
                          child: Text(
                            '${index * 0.5}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }),
                    underline: Container(),
                    isExpanded: true,
                    alignment: Alignment.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }
  // End Readiness Rating-Cancer Care

  //PGS DELIVERABLES STATUS
  // ignore: non_constant_identifier_names
  TableRow _PgsDeliverableHeader({String? officename}) {
    return TableRow(
      children: [
        BuildHeaderCell(
          text: 'Office: ${officename ?? officeDisplay}',
          fontSize: 20,
          fontStyle: FontStyle.normal,
        ),
        BuildHeaderCell(text: ''),
        BuildHeaderCell(text: ''),
        BuildHeaderCell(
          text: 'STRATEGIC CONTRIBUTIONS',
          fontSize: 20,
          fontStyle: FontStyle.normal,
        ),
        TableCell(child: Padding(padding: const EdgeInsets.all(8.0))),
        BuildHeaderCell(text: ''),
        BuildHeaderCell(text: ''),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  TableRow _PgsBuildTableSubheader() {
    return TableRow(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 254, 254),
      ),
      children: [
        BuildHeaderCell(text: 'KRA'),
        BuildHeaderCell(text: 'DIRECT'),
        BuildHeaderCell(text: 'INDIRECT'),
        BuildHeaderCell(text: 'DELIVERABLES'),
        BuildHeaderCell(text: 'WHEN'),
        BuildHeaderCell(text: 'STATUS'),
        BuildHeaderCell(text: 'REMARKS'),
      ],
    );
  } //END PGS DELIVERABLES STATUS

  // Removed Rows
  Widget _buildRemoveButton(int index, Function setDialogState) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red),
      onPressed: () {
        setDialogState(() {
          // Update UI after removal
          rows.remove(index);
          deliverablesControllers.remove(index);
          selectedKRA.remove(index);
          selectedDirect.remove(index);
          selectedIndirect.remove(index);
        });
      },
    );
  }

  Widget _buildExpandableTextAreaCell(int index) {
    if (!deliverablesControllers.containsKey(index)) {
      deliverablesControllers[index] = TextEditingController();
      debugPrint("✅ Initialized new controller at index: $index");
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 50.0),
        child: TextField(
          controller: deliverablesControllers[index],
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(8.0),
          ),
          onChanged: (value) {
            setState(() {
              debugPrint("Updated TextField at index $index: $value");
            });
          },
        ),
      ),
    );
  }

  // Filter search results based on query

  void filterSearchResults(String query) {
    deliverables.then((data) {
      setState(() {
        filteredList =
            data
                .where(
                  (item) => item['deliverableName'].toLowerCase().contains(
                    query.toLowerCase(),
                  ),
                )
                .toList();
      });
    });
  }
}

// Capitalize first letter of each word
extension StringExtension on String {
  String capitalize() {
    return split(' ')
        .map(
          (word) =>
              word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '',
        )
        .join(' ');
  }
}
