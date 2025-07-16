import 'dart:io';
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/performance_governance_system/models/performance_governance_system.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/performance_governance_system/models/pgs_readiness.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/performance_governance_system/pgs_signatory_template/models/pgs_signatory.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/utils/range_input_formatter.dart';
import 'package:imis/utils/token_expiration_handler.dart';
import 'package:imis/widgets/filter_button_widget.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/http_util.dart';

class PerformanceGovernanceSystemPage extends StatefulWidget {
  const PerformanceGovernanceSystemPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PerformanceGovernanceSystemPageState createState() =>
      _PerformanceGovernanceSystemPageState();
}

class _PerformanceGovernanceSystemPageState
    extends State<PerformanceGovernanceSystemPage> {
  late FilterSearchResultUtil<PerformanceGovernanceSystem> pgsSearchUtil;
  final GlobalKey _menuKey = GlobalKey();

  Map<int, TextEditingController> deliverablesControllers = {};
  Map<int, TextEditingController> signatoryControllers = {};
  Map<int, TextEditingController> selectedByWhenControllers = {};
  Map<int, Map<String, dynamic>> selectedKRAObjects = {};
  late Future<List<Map<String, dynamic>>> deliverables;
  Map<int, TextEditingController> remarksControllers = {};
  Map<int, TextEditingController> percentageControllers = {};

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

  List<Map<String, dynamic>> filteredList = [];

  List<Map<String, dynamic>> deliverableLists = [];
  List<Map<String, dynamic>> readinessList = [];

  List<Map<String, dynamic>> filteredListSignatory = [];
  List<Map<String, dynamic>> options = [];

  List<Map<String, dynamic>> kraOptions = [];
  Map<int, int?> deliverableIds = {};

  List<PgsSignatory> displaySignatoryList = [];
  List<Map<String, dynamic>> signatoryList = [];
  Map<int, int?> signatoryIds = {};

  List<int> rows = [];
  int rowIndex = 1;

  String officeDisplay = "";
  String officeIdList = "";
  String? selectedOffice = "";
  String? _selectedOfficeId;
  String? selectedPeriodText;
  String? selectedEndDateText;
  String? selectedStartDateText;
  TextEditingController percentageDeliverables = TextEditingController();

  List<Map<String, dynamic>> periodList = [];
  List<Map<String, dynamic>> filteredListPeriod = [];
  List<PgsDeliverables> deliverablesList = [];

  int? selectedPeriod;
  String? selectedStartPeriod;
  String? selectedEndDate;
  int? selectedKra;
  // String? selectedActions;
  Map<int, bool> selectedApproved = {};
  Map<int, bool> selectedDisapproved = {};

  final _paginationUtils = PaginationUtil(Dio());
  int _currentPage = 1;
  final int _pageSize = 30;
  int _totalCount = 0;
  bool _isLoading = false;

  List<Map<String, dynamic>> filteredListOffice = [];
  List<Map<String, dynamic>> officeList = [];
  //For search controller
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchFocus = FocusNode();
  TextEditingController reasonController = TextEditingController();
  Map<int, TextEditingController> kraDescriptionController = {};

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
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  double get totalScore =>
      competenceScore.value + resourceScore.value + confidenceScore.value;

  bool isValidInput(String value) {
    return value.isEmpty || value == '0' || value == '0.5' || value == '1';
  }

  final dio = Dio();

  Future<void> _loadCurrentUserId() async {
    UserRegistration? user = await AuthUtil.processTokenValidity(dio);

    setState(() {
      userId = user!.id ?? "UserId";
    });

    if (mounted) {
      setState(() {});
    }
  }

  //Save pgs
  Future<void> savePGS(PerformanceGovernanceSystem audit) async {
    var url = ApiEndpoint().performancegovernancesystem;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final requestData = audit.toJson();
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Pgs data saved successfully!");

        setState(() {
          fetchPgsList();
          clearAllSelections();
        });

        await prefs.remove('selectedOfficeId');
        await prefs.remove('selectedOfficeName');
      } else {
        debugPrint("Failed to save Pgs data");
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
  }

  //Submit gs
  Future<void> submitPGS(PerformanceGovernanceSystem audit) async {
    try {
      UserRegistration? user = await AuthUtil.fetchLoggedUser();

      if (user == null || user.id == null || user.id!.isEmpty) {
        debugPrint("Error: No valid user found.");
        return;
      }

      final prefs = await SharedPreferences.getInstance();

      final baseUrl = ApiEndpoint().pgsSubmit;
      final url = '$baseUrl?userId=${user.id}';

      final requestData = audit.toJson();
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("PGS data submitted successfully!");

        if (mounted) {
          setState(() {
            fetchPgsList();
            clearAllSelections();
          });
        }

        await prefs.remove('selectedOfficeId');
        await prefs.remove('selectedOfficeName');
      } else {
        debugPrint("Failed to submit PGS data");
      }
    } on DioException catch (e) {
      debugPrint("Dio Error: ${e.message}");
      if (e.response != null) {}
    } catch (e) {
      debugPrint("Unexpected Error: $e");
    }
  }

  // Update Save PGS
  Future<void> updateSavePGS({
    String? pgsId,
    required PerformanceGovernanceSystem updatePgs,
    String? userId,
  }) async {
    final url = '${ApiEndpoint().performancegovernancesystem}/$pgsId';

    try {
      UserRegistration? user = await AuthUtil.fetchLoggedUser();
      if (user == null) {
        debugPrint("Error: No user found in shared preferences.");
        return;
      }

      String? token = await AuthUtil.fetchAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint("Error: Access token is missing!");
        return;
      }

      final signatoryResponse = await AuthenticatedRequest.get(
        dio,
        "${ApiEndpoint().pgsSubmitUserId}/${user.id}?pgsId=$pgsId",
      );

      if (signatoryResponse.statusCode != 200) {
        debugPrint("Failed to fetch signatory data");
        return;
      }

      final signatoryData = PerformanceGovernanceSystem.fromJson(
        signatoryResponse.data,
      );
      final updatedPgsJson = updatePgs.toJson();
      updatedPgsJson['pgsSignatories'] =
          signatoryData.pgsSignatories?.map((s) => s.toJson()).toList();

      SharedPreferences prefs = await SharedPreferences.getInstance();

      final response = await AuthenticatedRequest.put(
        dio,
        url,
        data: updatedPgsJson,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          fetchPgsList();
          clearAllSelections();
        });
        await prefs.remove('selectedOfficeId');
        await prefs.remove('selectedOfficeName');
      } else {
        debugPrint("Failed to update PGS");
        if (response.statusCode == 401 || response.statusCode == 403) {
          debugPrint(
            "Token expired or invalid. Consider redirecting to login.",
          );
        }
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.message}");
      if (e.response != null) {
        debugPrint("Response data: ${e.response?.data}");
        debugPrint("Response status: ${e.response?.statusCode}");
      }
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
  }

  //Disapprove pgs
  Future<void> disapprovePGS(PerformanceGovernanceSystem audit) async {
    var url = ApiEndpoint().disapprovePgs;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final requestData = audit.toJson();
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: requestData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Pgs data disapprove successfully!");

        setState(() {
          fetchPgsList();
          clearAllSelections();
        });

        await prefs.remove('selectedOfficeId');
        await prefs.remove('selectedOfficeName');
      } else {
        debugPrint("Failed to disapprove Pgs data");
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
  }

  //-----------------End Signatories---------------------------------------------------------

  Future<void> fetchUser() async {
    var url = ApiEndpoint().users;
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data is List) {
        List<User> data =
            (response.data as List)
                .map((userJson) => User.fromJson(userJson))
                .toList();

        if (mounted) {
          setState(() {
            userList = data;
            filteredListUser = List.from(userList);

            if (filteredListUser.isNotEmpty) {}
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  Future<List<Map<String, dynamic>>> _getFilteredSignatories() async {
    return signatoryList.toList();
  }

  Widget _buildSignatoryColumnSync({
    required String title,
    required String? currentValue,
    required ValueChanged<String?> onChanged,
    required VoidCallback onDeleted,
  }) {
    // Sort signatories by orderLevel
    final sortedSignatoryList = List<Map<String, dynamic>>.from(signatoryList)
      ..sort(
        (a, b) => (a['orderLevel'] as int).compareTo(b['orderLevel'] as int),
      );

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 6),
          Container(width: 200, height: 1.8, color: Colors.grey),
          const SizedBox(height: 8),
          if (currentValue != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (sortedSignatoryList.any(
                  (s) => s['signatoryId'] == currentValue,
                ))
                  const SizedBox(height: 4),
                Text(
                  (sortedSignatoryList.firstWhere(
                            (s) => s['signatoryId'] == currentValue,
                          )['signatoryName'] ??
                          '')
                      .toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<List<PgsDeliverables>> fetchDeliverables({String? pgsId}) async {
    List<PgsDeliverables> deliverablesList = [];
    final url = "${ApiEndpoint().performancegovernancesystem}/$pgsId";

    try {
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200) {
        final data = response.data;
        final pgsDataList = data is List ? data : [data];

        for (var pgsJson in pgsDataList) {
          final deliverables =
              (pgsJson['pgsDeliverables'] as List)
                  .map((d) => PgsDeliverables.fromJson(d))
                  .where((d) => d.id != null)
                  .toList();

          deliverablesList.addAll(deliverables);
        }
      } else {
        debugPrint("Failed to fetch deliverables");
      }
    } on DioException {
      debugPrint("Dio error");
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

  Future<void> fetchOffice() async {
    final url = ApiEndpoint().office;

    try {
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<Office> data =
            (response.data as List)
                .map((office) => Office.fromJson(office))
                .toList();

        if (mounted) {
          setState(() {
            officeList = data.map((office) => office.toJson()).toList();
            filteredListOffice = List.from(officeList);
          });
          debugPrint("Fetched ${officeList.length} offices.");
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

  Future<String?> _selectOffice() async {
    final officeNames = await AuthUtil.fetchOfficeNames();
    final officeIds = await AuthUtil.fetchOfficeIds();

    if (officeNames == null ||
        officeIds == null ||
        officeNames.isEmpty ||
        officeIds.isEmpty) {
      MotionToast.error(
        title: const Text("Office Not Found"),
        description: const Text(
          "The selected office ID does not match any known office.\nPlease contact the administrator.",
        ),
        toastDuration: const Duration(seconds: 10),
        toastAlignment: Alignment.topCenter,
        // ignore: use_build_context_synchronously
      ).show(context);
      return null;
    }

    String? selectedOffice = await showDialog<String>(
      // ignore: use_build_context_synchronously
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: mainBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxHeight: 450, maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey.shade600),

                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('selectedOfficeId');
                      await prefs.remove('selectedOfficeName');
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context, null);
                    },
                  ),
                ),
                // Title
                Text(
                  "Select an Office",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 8),
                // List of offices
                Expanded(
                  child: ListView.separated(
                    itemCount: officeNames.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          leading: Icon(
                            Icons.apartment_rounded,
                            color: primaryColor,
                          ),
                          title: Text(
                            officeNames[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                          onTap: () => Navigator.pop(context, officeIds[index]),
                          // ignore: deprecated_member_use
                          hoverColor: primaryColor.withOpacity(0.1),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selectedOffice == null || selectedOffice == '-1') {
      await AuthUtil.removeSelectedOfficeId();
      return null;
    }

    await AuthUtil.saveSelectedOfficeId(selectedOffice);
    return selectedOffice;
  }

  Map<String, dynamic> _mapPgsToListItem(
    PerformanceGovernanceSystem pgs,
    String userId,
  ) {
    if (pgs.pgsSignatories != null && pgs.pgsSignatories!.isNotEmpty) {
      signatoryList =
          pgs.pgsSignatories!
              .map(
                (sig) => {
                  'id': sig.id.toString(),
                  'signatoryId': sig.signatoryId,
                  'signatoryName': sig.signatoryName,
                  'signatoryLabel': sig.label,
                  'orderLevel': sig.orderLevel,
                  'defaultSignatoryId': sig.signatoryId,
                  'officeId': pgs.office.id.toString(),
                  'isNextStatus': sig.isNextStatus,
                },
              )
              .toList();
    }

    return {
      'pgsReadinessRatingId': pgs.pgsReadinessRating.id.toString(),
      'userId': userId,
      'id': pgs.id.toString(),
      'name': pgs.office.name,
      'pgsStatus': pgs.pgsStatus.toString(),
      'startDate': DateTimeConverter().toJson(pgs.pgsPeriod.startDate),
      'officeid': pgs.office.id,
      'endDate': DateTimeConverter().toJson(pgs.pgsPeriod.endDate),
      'competencescore': pgs.pgsReadinessRating.competenceToDeliver.toString(),
      'confidencescore': pgs.pgsReadinessRating.confidenceToDeliver.toString(),
      'resourcescore': pgs.pgsReadinessRating.resourceAvailability.toString(),
      'selectPeriod': pgs.pgsPeriod.id.toString(),
      'totalscore': pgs.pgsReadinessRating.totalScore.toString(),
      'percentDeliverables': pgs.percentDeliverables.toString(),
      'remarks': pgs.remarks,
      'forSignature': pgs.forSignature,
      'signatories': pgs.pgsSignatories?.map((s) => s.toJson()).toList(),
      'periodId': pgs.pgsPeriod.id.toString(),
    };
  }

  Future<void> fetchPgsList({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      UserRegistration? user = await AuthUtil.fetchLoggedUser();
      if (user == null) {
        debugPrint("Error: No user found in shared preferences.");
        return;
      }

      setState(() => userId = user.id ?? "UserId");

      String? token = await AuthUtil.fetchAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint("Error: Access token is missing!");
        return;
      }

      final pageList = await _paginationUtils.fetchPaginatedData<
        PerformanceGovernanceSystem
      >(
        endpoint:
            "${ApiEndpoint().performancegovernancesystemUserId}/userId/$userId?userId=$userId",
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
        fromJson: (json) => PerformanceGovernanceSystem.fromJson(json),
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          deliverableLists =
              pageList.items
                  .map((pgs) => _mapPgsToListItem(pgs, userId))
                  .toList();
          filteredList = List.from(deliverableLists);
        });
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.message}");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> fetchSubmitUserId({
    required String pgsId,
    required String userId,
  }) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      UserRegistration? user = await AuthUtil.fetchLoggedUser();
      if (user == null) {
        debugPrint("Error: No user found in shared preferences.");
        return;
      }

      setState(() => userId = user.id ?? "UserId");

      String? token = await AuthUtil.fetchAccessToken();
      if (token == null || token.isEmpty) {
        debugPrint("Error: Access token is missing!");
        return;
      }

      final response = await Dio().get(
        "${ApiEndpoint().pgsSubmitUserId}/${user.id}?pgsId=$pgsId",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && mounted) {
        final data = response.data;
        setState(() {
          deliverableLists = [
            _mapPgsToListItem(
              PerformanceGovernanceSystem.fromJson(data),
              userId,
            ),
          ];
          filteredList = List.from(deliverableLists);
        });
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.message}");
      if (e.response != null) {
        debugPrint("Response data: ${e.response?.data}");
        debugPrint("Response status: ${e.response?.statusCode}");
      }
    } catch (e) {
      debugPrint("Unexpected error: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> fetchPgsFilter({int page = 1, int pageSize = 15}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final user = await AuthUtil.fetchLoggedUser();
      final token = await AuthUtil.fetchAccessToken();

      if (user == null || token == null || token.isEmpty) {
        debugPrint("Missing user or token.");
        return;
      }

      setState(() => userId = user.id ?? "UserId");

      final Map<String, dynamic> queryParams = {
        'userId': userId,
        'Page': page.toString(),
        'PageSize': pageSize.toString(),
        if (selectedStartPeriod != null)
          'FromDate': DateFormat(
            'yyyy-MM-dd',
          ).format(DateTime.parse(selectedStartPeriod!)),
        if (selectedEndDate != null)
          'ToDate': DateFormat(
            'yyyy-MM-dd',
          ).format(DateTime.parse(selectedEndDate!)),
        if (_selectedOfficeId != null && _selectedOfficeId!.isNotEmpty)
          'officeId': _selectedOfficeId,
      };

      debugPrint("Sending query params: $queryParams");

      final response = await AuthenticatedRequest.get(
        dio,
        ApiEndpoint().performancegovernancesystemFilter,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final items =
            (data['items'] as List)
                .map((item) => PerformanceGovernanceSystem.fromJson(item))
                .toList();

        if (mounted) {
          setState(() {
            deliverableLists =
                items.map((pgs) => _mapPgsToListItem(pgs, userId)).toList();
            filteredList = List.from(deliverableLists);
            _currentPage = data['page'] ?? 1;
            _totalCount = data['totalCount'] ?? 0;
          });
        }
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.message}");
      if (e.response != null) {
        debugPrint("Status: ${e.response!.statusCode}");
        debugPrint("Response: ${e.response!.data}");
      }
    } catch (e) {
      debugPrint("Unexpected error: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  //fetch periods
  Future<void> fetchPGSPeriods() async {
    var url = ApiEndpoint().pgsperiod;

    try {
      var response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<PgsPeriod> data =
            (response.data as List)
                .map((period) => PgsPeriod.fromJson(period))
                .toList();

        if (mounted) {
          setState(() {
            periodList = data.map((period) => period.toJson()).toList();
            filteredListPeriod = List.from(periodList);
          });
        }
      } else {
        debugPrint("Unexpected response format: ${response.data.runtimeType}");
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
  }

  Future<void> _loadOfficeName() async {
    List<String>? officeNames = await AuthUtil.fetchOfficeNames();
    List<String>? officeIds = await AuthUtil.fetchOfficeIds();
    selectedOffice = await AuthUtil.fetchSelectedOfficeId();

    String selectedOfficeName = "No Office";

    if (officeNames != null && officeIds != null && selectedOffice != null) {
      int index = officeIds.indexOf(selectedOffice!);
      if (index != -1 && index < officeNames.length) {
        selectedOfficeName = officeNames[index];
      }
    }

    setState(() {
      officeDisplay = selectedOfficeName;
      officeIdList = selectedOffice ?? "No Office ID";
    });
  }

  @override
  void initState() {
    super.initState();
    fetchOffice();
    _loadOfficeName();
    _loadCurrentUserId();
    fetchPgsList();
    fetchUser();
    fetchPGSPeriods();
    TokenExpirationHandler(context).checkTokenExpiration();

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

    pgsSearchUtil = FilterSearchResultUtil<PerformanceGovernanceSystem>(
      paginationUtils: _paginationUtils,
      endpoint: ApiEndpoint().performancegovernancesystem,
      pageSize: _pageSize,
      fromJson: (json) => PerformanceGovernanceSystem.fromJson(json),
    );
  }

  //Save deliverables
  Future<void> saveDeliverables() async {
    var url = ApiEndpoint().deliverables;
    List<PgsDeliverables> deliverablesList = getTableDeliverables();

    try {
      var response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        List<PgsDeliverables> data =
            (response.data as List)
                .map((deliverable) => PgsDeliverables.fromJson(deliverable))
                .toList();

        if (mounted) {
          setState(() {
            deliverablesList = data;
            filteredList = List.from(deliverablesList);
          });
        }
      } else {
        debugPrint("Unexpected response format: ${response.data.runtimeType}");
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
  }

  Future<void> fetchDropdownData() async {
    var url = ApiEndpoint().keyresult;
    try {
      var response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        options =
            data.map<Map<String, dynamic>>((item) {
              return {'id': item['id'] as int, 'name': item['name'].toString()};
            }).toList();
      } else {
        debugPrint("Failed to load data");
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
  }

  PerformanceGovernanceSystem getPgsAuditDetails({
    required int id,
    required String pgsStatus,
    List<PgsSignatory> existingSignatories = const [],
  }) {
    double percentDeliverables = 0.0;

    try {
      percentDeliverables = double.tryParse(percentageDeliverables.text) ?? 0.0;
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
        '',
      ),
      office: Office(
        id: int.tryParse(selectedOffice!) ?? 0,
        name: "Office Name",
        officeTypeId: 0,
        parentOfficeId: 0,
        isActive: false,
        rowVersion: "",
      ),
      pgsDeliverables: getTableDeliverables(),
      pgsReadinessRating: PgsReadiness(
        0,
        false,
        null,
        competenceScore.value,
        resourceScore.value,
        confidenceScore.value,
        totalScore,
      ),

      pgsSignatories: [],
      isDeleted: false,
      remarks: "",
      rowVersion: "",
      percentDeliverables: percentDeliverables,
      forSignature: false,
    );
  }

  List<PgsDeliverables> getTableDeliverables() {
    List<PgsDeliverables> updatedDeliverables = [];

    deliverablesControllers.forEach((index, controller) {
      final kraId = selectedKRA[index];

      final kraData = options.firstWhere(
        (option) => option['id'] == kraId,
        orElse:
            () => {
              'id': 1,
              'name': 'Unknown',
              'remarks': '',
              'isDeleted': false,
              'rowVersion': null,
            },
      );
      selectedKRAObjects[index] = kraData;

      final deliverableText =
          controller.text.isNotEmpty ? controller.text : "No Name";
      final kraDescriptionText = kraDescriptionController[index]?.text ?? '';

      final isDirect = selectedDirect[index] ?? false;
      final byWhen =
          DateTime.tryParse(selectedByWhen[index] ?? '') ?? DateTime.now();

      final percentperDeliverables =
          double.tryParse(percentageControllers[index]!.text) ?? 0.0;

      final statusIndex =
          selectedStatus[index]?.index ?? PgsStatus.notStarted.index;
      final status = PgsStatus.values.firstWhere(
        (e) => e.index == statusIndex,
        orElse: () => PgsStatus.notStarted,
      );

      final remarks = remarksControllers[index]?.text ?? '';
      final existingId = deliverableIds[index] ?? 0;

      updatedDeliverables.add(
        PgsDeliverables(
          existingId,
          KeyResultArea(
            kraData['id'] as int,
            kraData['name'] as String,
            kraData['remarks'] ?? '',
            true,

            rowVersion: kraData['rowVersion'],
          ),
          kraId,
          deliverableText,
          kraDescriptionText,
          isDirect,
          byWhen,
          percentperDeliverables,
          status,

          remarks: remarks,
          rowVersion: '',
        ),
      );
    });

    return updatedDeliverables;
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
    percentageDeliverables.clear();
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

  void showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete this PGS? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: primaryTextColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                // await deleteTeam(id);
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left-aligned filters
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Filter by Office',
                            style: TextStyle(fontSize: 12, color: grey),
                          ),
                          gap2,
                          PopupMenuButton<String>(
                            color: mainBgColor,
                            offset: const Offset(0, 30),
                            onSelected: (String value) {
                              setState(() {
                                _selectedOfficeId =
                                    value.isEmpty ? null : value;
                              });
                              fetchPgsFilter();
                              debugPrint("Start Period: $selectedStartPeriod");
                            },
                            itemBuilder: (BuildContext context) {
                              final updatedOfficeList = [
                                {'id': '', 'name': 'All Offices'},
                                ...filteredListOffice,
                              ];

                              return updatedOfficeList
                                  .map<PopupMenuItem<String>>((office) {
                                    return PopupMenuItem<String>(
                                      value: office['id'].toString(),
                                      child: Text(office['name']),
                                    );
                                  })
                                  .toList();
                            },
                            child: FilterButton(
                              label:
                                  _selectedOfficeId == null
                                      ? 'All Offices'
                                      : filteredListOffice.firstWhere(
                                        (office) =>
                                            office['id'].toString() ==
                                            _selectedOfficeId,
                                        orElse: () => {'name': 'Office'},
                                      )['name'],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Filter by Start Date',
                            style: TextStyle(fontSize: 12, color: grey),
                          ),
                          gap2,
                          PopupMenuButton<String>(
                            color: mainBgColor,
                            offset: const Offset(0, 30),
                            onSelected: (String selectedDate) {
                              setState(() {
                                selectedStartPeriod =
                                    selectedDate.isEmpty ? null : selectedDate;
                                selectedStartDateText =
                                    selectedStartPeriod ?? 'All Start Date';
                              });
                              fetchPgsFilter();
                            },

                            itemBuilder: (BuildContext context) {
                              final periodOptions = [
                                {'date': '', 'displayText': 'All Start Date'},
                                ...filteredListPeriod.map(
                                  (period) => {
                                    'date': period['startDate'],
                                    'displayText': period['startDate'],
                                  },
                                ),
                              ];

                              return periodOptions.map<PopupMenuItem<String>>((
                                option,
                              ) {
                                return PopupMenuItem<String>(
                                  value: option['date'],
                                  child: Text(option['displayText']!),
                                );
                              }).toList();
                            },
                            child: FilterButton(
                              label:
                                  selectedStartDateText ?? 'Select Start Date',
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Filter by End Date',
                            style: TextStyle(fontSize: 12, color: grey),
                          ),
                          gap2,
                          PopupMenuButton<String>(
                            color: mainBgColor,
                            offset: const Offset(0, 30),
                            onSelected: (String selectedDate) {
                              setState(() {
                                selectedEndDate =
                                    selectedDate.isEmpty ? null : selectedDate;
                                selectedEndDateText =
                                    selectedEndDate ?? 'All End Date';
                              });
                              fetchPgsFilter();
                            },
                            itemBuilder: (BuildContext context) {
                              final periodOptions = [
                                {'date': '', 'displayText': 'All End Date'},
                                ...filteredListPeriod.map(
                                  (period) => {
                                    'date': period['endDate'],
                                    'displayText': period['endDate'],
                                  },
                                ),
                              ];

                              return periodOptions.map<PopupMenuItem<String>>((
                                option,
                              ) {
                                return PopupMenuItem<String>(
                                  value: option['date'],
                                  child: Text(option['displayText']!),
                                );
                              }).toList();
                            },
                            child: FilterButton(
                              label: selectedEndDateText ?? 'Select End Date',
                            ),
                          ),
                        ],
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
                    onPressed: () async {
                      selectedOffice = await AuthUtil.fetchSelectedOfficeId();

                      if (selectedOffice == null || selectedOffice!.isEmpty) {
                        await _selectOffice();

                        selectedOffice = await AuthUtil.fetchSelectedOfficeId();

                        if (selectedOffice != null &&
                            selectedOffice!.isNotEmpty) {
                          await _loadOfficeName();
                          showFormDialog();
                        } else {}
                      } else {
                        await _loadOfficeName();
                        showFormDialog();
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
                        SizedBox(
                          width: 60,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('#', style: TextStyle(color: grey)),
                          ),
                        ),

                        SizedBox(
                          width: 500,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
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
                                          SizedBox(
                                            width: 60,
                                            child: Text(
                                              itemNumber.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),

                                          SizedBox(
                                            width: 500,
                                            child: Text(
                                              pgsgovernancesystem['name'],
                                              // Display office
                                              style: TextStyle(
                                                fontWeight: FontWeight.normal,
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
                                                pgsgovernancesystem['startDate'],
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
                                                pgsgovernancesystem['endDate'],
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
                                                      await AuthUtil.saveSelectedOfficeId(
                                                        pgsgovernancesystem['officeid']
                                                            .toString(),
                                                      );

                                                      selectedOffice =
                                                          await AuthUtil.fetchSelectedOfficeId();

                                                      List<PgsDeliverables>
                                                      deliverables =
                                                          await fetchDeliverables(
                                                            pgsId:
                                                                pgsgovernancesystem['id'],
                                                          );

                                                      List<PgsSignatory>
                                                      signatory =
                                                          await fetchSignatoryList(
                                                            pgsId:
                                                                pgsgovernancesystem['id'],
                                                          );
                                                      fetchSubmitUserId(
                                                        userId: userId,
                                                        pgsId:
                                                            pgsgovernancesystem['id'],
                                                      );
                                                      showFormDialog(
                                                        userId:
                                                            pgsgovernancesystem['userId'],
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
                                                            pgsgovernancesystem['startDate'],
                                                        endDate:
                                                            pgsgovernancesystem['endDate'],
                                                        percentDeliverables:
                                                            pgsgovernancesystem['percentDeliverables'],
                                                        deliverables:
                                                            deliverables,
                                                        signatories: signatory,
                                                        pgsstatus:
                                                            pgsgovernancesystem['pgsStatus'],
                                                        remarks:
                                                            pgsgovernancesystem['remarks'],
                                                      );

                                                      fetchPgsList();
                                                      fetchSignatoryList(
                                                        pgsId:
                                                            pgsgovernancesystem['id'],
                                                      );
                                                    },
                                                  ),

                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.preview,
                                                    ),
                                                    onPressed: () async {
                                                      final previewId =
                                                          pgsgovernancesystem['id']
                                                              .toString();
                                                      if (previewId.isEmpty) {
                                                        debugPrint(
                                                          "Preview ID is empty or null.",
                                                        );
                                                        return;
                                                      }

                                                      final pgsId =
                                                          int.tryParse(
                                                            previewId,
                                                          );
                                                      if (pgsId == null) {
                                                        debugPrint(
                                                          "Invalid preview ID: $previewId",
                                                        );
                                                        return;
                                                      }

                                                      final api = ApiEndpoint();
                                                      final pdfUrl =
                                                          '${api.generatePdf}/$pgsId';

                                                      debugPrint(
                                                        "Opening PDF: $pdfUrl",
                                                      );

                                                      try {
                                                        if (kIsWeb) {
                                                          html.window.open(
                                                            pdfUrl,
                                                            "_blank",
                                                          );
                                                        } else {
                                                          final url = Uri.parse(
                                                            pdfUrl,
                                                          );
                                                          final response =
                                                              await http.get(
                                                                url,
                                                              );

                                                          if (response
                                                                  .statusCode ==
                                                              200) {
                                                            final directory =
                                                                await getApplicationDocumentsDirectory();
                                                            final filePath =
                                                                "${directory.path}/PGS_Report_$pgsId.pdf";
                                                            final file = File(
                                                              filePath,
                                                            );

                                                            await file
                                                                .writeAsBytes(
                                                                  response
                                                                      .bodyBytes,
                                                                );
                                                            await OpenFile.open(
                                                              file.path,
                                                            );
                                                          } else {
                                                            debugPrint(
                                                              "Failed to download PDF. Status: ${response.statusCode}",
                                                            );
                                                            if (context
                                                                .mounted) {
                                                              ScaffoldMessenger.of(
                                                                context,
                                                              ).showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                    'Failed to download PDF',
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                          }
                                                        }
                                                      } catch (e) {
                                                        debugPrint(
                                                          "Error opening PDF: $e",
                                                        );
                                                        if (context.mounted) {
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            const SnackBar(
                                                              content: Text(
                                                                'Error opening PDF file',
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      }
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
                                                    onPressed:
                                                        () => showDeleteDialog(
                                                          pgsgovernancesystem['id']
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
                          onPageChanged: (page) => fetchPgsList(page: page),
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
                onPressed: () async {
                  selectedOffice = await AuthUtil.fetchSelectedOfficeId();

                  if (selectedOffice == null || selectedOffice!.isEmpty) {
                    await _selectOffice();

                    selectedOffice = await AuthUtil.fetchSelectedOfficeId();

                    if (selectedOffice != null && selectedOffice!.isNotEmpty) {
                      await _loadOfficeName();

                      showFormDialog();
                    } else {}
                  } else {
                    await _loadOfficeName();
                    showFormDialog();
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

      return signatory['signatoryLabel'].toString();
    } catch (e) {
      return null;
    }
  }

  Future<List<PgsSignatory>> fetchSignatoryList({String? pgsId}) async {
    final url = "${ApiEndpoint().performancegovernancesystem}/$pgsId";

    displaySignatoryList.clear();

    try {
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200) {
        final data = response.data;

        final pgsDataList = data is List ? data : [data];

        for (var pgsJson in pgsDataList) {
          final signatoriesJson = pgsJson['pgsSignatories'];
          if (signatoriesJson is List) {
            final signatories =
                signatoriesJson.map((d) => PgsSignatory.fromJson(d)).toList();

            displaySignatoryList.addAll(signatories);
          } else {
            debugPrint("No valid 'pgsSignatories' list found in response.");
          }
        }
      } else {
        debugPrint("Failed to fetch signatories");
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data ?? e.message}");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }

    return displaySignatoryList;
  }

  int? selectedPgsId;

  void onPgsIdChanged(int? newPgsId) {
    setState(() {
      selectedPgsId = newPgsId;
    });
  }

  Future showFormDialog({
    String? userId,
    String? id,
    String? officename,
    int? officenameid,
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
    String? remarks,
  }) {
    setState(() {
      if (id == null) {
        competenceScore.value = 0.0;
        resourceScore.value = 0.0;
        confidenceScore.value = 0.0;
        selectedPeriod = null;
        selectedPeriodText = null;
        percentageDeliverables.clear();

        deliverablesControllers.clear();
        selectedKRA.clear();
        selectedKRAObjects.clear();
        selectedDirect.clear();
        selectedIndirect.clear();
        selectedByWhen.clear();
        selectedByWhenControllers.clear();
        selectedStatus.clear();
        deliverableIds.clear();
      } else {
        competenceScore.value = double.tryParse(competencescore ?? '') ?? 0.0;
        resourceScore.value = double.tryParse(resourcescore ?? '') ?? 0.0;
        confidenceScore.value = double.tryParse(confidencescore ?? '') ?? 0.0;

        if (percentDeliverables != null) {
          percentageDeliverables.text = percentDeliverables;
        }

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

        deliverablesControllers.clear();
        selectedKRA.clear();
        selectedKRAObjects.clear();
        selectedDirect.clear();
        selectedIndirect.clear();
        selectedByWhen.clear();
        selectedByWhenControllers.clear();
        selectedStatus.clear();
        deliverableIds.clear();

        if (deliverables != null && deliverables.isNotEmpty) {
          rows = List.generate(deliverables.length, (index) => index);

          for (int i = 0; i < deliverables.length; i++) {
            final item = deliverables[i];
            deliverablesControllers[i] = TextEditingController(
              text: item.deliverableName,
            );
            selectedDirect[i] = item.isDirect;
            selectedIndirect[i] = !item.isDirect;
            selectedByWhen[i] = DateFormat('yyyy-MM-dd').format(item.byWhen);
            selectedByWhenControllers[i] = TextEditingController(
              text: DateFormat('MMMM yyyy').format(item.byWhen),
            );
            selectedStatus[i] = item.status;
            deliverableIds[i] = item.id ?? 0;
            selectedKRA[i] = item.kra.id;
            remarksControllers[i] = TextEditingController(text: item.remarks);
            percentageControllers[i] = TextEditingController(
              text: item.percentDeliverables.toString(),
            );

            kraDescriptionController[i] = TextEditingController(
              text: item.kraDescription,
            );
          }
        } else {
          rows = [0];
        }
      }
    });

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final orderLevel =
                signatoryList.firstWhere(
                  (signatory) => signatory['isNextStatus'] == true,
                  orElse: () => {'orderLevel': 1},
                )['orderLevel'] ??
                1;

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
                      onPressed: () async {
                        clearAllSelections();
                        Navigator.pop(context);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.remove('selectedOfficeId');
                        await prefs.remove('selectedOfficeName');
                        fetchPgsList();
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
                                      child: Tooltip(
                                        message: 'Select period',
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
                                              final selected =
                                                  filteredListPeriod.firstWhere(
                                                    (period) =>
                                                        period['id'] ==
                                                        newValue,
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
                                    ),
                                  ],
                                ),
                              ],
                            ),

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
                                            // 5: FlexColumnWidth(1),
                                            5: FlexColumnWidth(0.7),
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
                                                    orderLevel: orderLevel,
                                                    id: id,
                                                  ),
                                            ),
                                          ],
                                        ),

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
                                            0: FlexColumnWidth(1),
                                            1: FlexColumnWidth(0.4),
                                            2: FlexColumnWidth(0.5),
                                            3: FlexColumnWidth(1.90),
                                            4: FlexColumnWidth(0.7),
                                            5: FlexColumnWidth(0.6),
                                            6: FlexColumnWidth(1.30),
                                            7: FlexColumnWidth(0.5),
                                          },
                                          children: [
                                            _PgsDeliverableHeader(
                                              officename:
                                                  officename ?? officeDisplay,
                                            ),
                                            _PgsBuildTableSubheader(),
                                            ...rows.map(
                                              (rowId) =>
                                                  _buildTableRowStrategicPGSDeliverableStatus(
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

                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: FutureBuilder<List<Map<String, dynamic>>>(
                                future: _getFilteredSignatories(),
                                builder: (context, snapshot) {
                                  // Debugging - check what data we're getting
                                  debugPrint(
                                    'Signatories snapshot: ${snapshot.data}',
                                  );

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Error: ${snapshot.error}'),
                                    );
                                  }

                                  final signatories = snapshot.data ?? [];

                                  if (signatories.isEmpty) {
                                    return const Center(
                                      child: Text('No signatories available'),
                                    );
                                  }

                                  return Row(
                                    children:
                                        signatories.map((signatory) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: _buildSignatoryColumnSync(
                                              // Create this synchronous version
                                              title:
                                                  signatory['signatoryLabel'] ??
                                                  'Signatory',
                                              currentValue:
                                                  signatory['defaultSignatoryId'],
                                              onChanged: (newValue) {
                                                setState(() {
                                                  signatory['defaultSignatoryId'] =
                                                      newValue;
                                                });
                                              },
                                              onDeleted: () {
                                                setState(() {
                                                  signatoryList.removeWhere(
                                                    (s) =>
                                                        s['id'] ==
                                                        signatory['id'],
                                                  );
                                                });
                                              },
                                            ),
                                          );
                                        }).toList(),
                                  );
                                },
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
                //DISAPPROVE BUTTON\
                if (id != null &&
                    signatoryList.any(
                      (signatory) => signatory['isNextStatus'] == true,
                    ))
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 235, 172, 172),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () async {
                      bool? confirm = await showDialog(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: const Text("Confirm Disapprove"),
                              content: const Text(
                                "Are you sure you want to disapprove this record? You won't be able to make any changes.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, false),
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
                            ),
                      );

                      if (confirm == true) {
                        try {
                          int? pgsId = int.tryParse(id);
                          if (pgsId == null) {
                            throw Exception("Invalid PGS ID");
                          }

                          PerformanceGovernanceSystem pgs = getPgsAuditDetails(
                            id: pgsId,
                            pgsStatus: "Disapprove",
                          );

                          await disapprovePGS(pgs);

                          MotionToast.success(
                            description: const Text(
                              "Disapproved successfully!",
                            ),
                            // ignore: use_build_context_synchronously
                          ).show(context);

                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        } catch (e) {
                          debugPrint("Error disapproving PGS: $e");
                          MotionToast.error(
                            description: Text(
                              "Failed to disapprove: ${e.toString()}",
                            ),
                            // ignore: use_build_context_synchronously
                          ).show(context);
                        }
                      }
                    },
                    child: const Text(
                      'Disapprove',
                      style: TextStyle(color: primaryColor),
                    ),
                  ),

                // SUBMIT BUTTON
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
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
                          ),
                    );

                    if (confirm == true) {
                      if (selectedPeriod == null ||
                          selectedDirect.isEmpty ||
                          selectedIndirect.isEmpty ||
                          deliverablesControllers.values.any(
                            (controller) => controller.text.trim().isEmpty,
                          ) ||
                          percentageDeliverables.text.trim().isEmpty) {
                        MotionToast.error(
                          title: const Text("Missing Fields"),
                          description: Text(
                            selectedPeriod == null
                                ? "Please complete all required fields before saving."
                                : "Please complete all required fields before saving.",
                          ),
                          // ignore: deprecated_member_use
                          position: MotionToastPosition.top,
                          // ignore: use_build_context_synchronously
                        ).show(context);
                        return;
                      }

                      int? pgsId = int.tryParse(id ?? '');

                      PerformanceGovernanceSystem pgs = getPgsAuditDetails(
                        id: pgsId ?? 0,
                        pgsStatus: "Submit",
                      );

                      int.tryParse(id ?? '');

                      if (pgs.pgsSignatories != null &&
                          pgs.pgsSignatories!.isNotEmpty) {
                        try {} catch (e) {
                          // No match found
                        }
                      }

                      try {
                        final currentUser = await AuthUtil.fetchLoggedUser();
                        final currentUserId = currentUser?.id;
                        if (pgsId == null) {
                          await submitPGS(pgs);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                        // if (signatory == null) {
                        //   submitPGS(pgs);
                        // }
                        else {
                          debugPrint("Updating PGS with ID: $pgsId...");

                          await updateSavePGS(
                            pgsId: pgsId.toString(),
                            updatePgs: pgs,
                            userId: currentUserId,
                          );

                          MotionToast.success(
                            description: Text(
                              (id != null &&
                                      signatoryList.any(
                                        (signatory) =>
                                            signatory['isNextStatus'] == true,
                                      ))
                                  ? "Approved successfully!"
                                  : "Submitted successfully!",
                            ),

                            // ignore: deprecated_member_use
                            position: MotionToastPosition.top,
                            // ignore: use_build_context_synchronously
                          ).show(context);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        debugPrint("Error saving/updating PGS: $e");
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to save PGS: $e')),
                        );
                      }
                    }
                  },
                  child: Text(
                    (id != null && orderLevel >= 2) ? 'Approve' : 'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
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
      String defaultDate = DateFormat('yyyy-MM-dd').format(now);
      selectedByWhen[index] = defaultDate;
      selectedByWhenControllers[index]?.text = DateFormat(
        'MMMM yyyy',
      ).format(now);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Tooltip(
        message:
            'Specify when this deliverable is expected to be finished. Used to monitor deadlines and keep progress on schedule.',
        child: TextFormField(
          controller: selectedByWhenControllers[index],
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
                      style: TextButton.styleFrom(
                        foregroundColor: primaryColor,
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              String formattedDate = DateFormat(
                'yyyy-MM-dd',
              ).format(pickedDate);
              setDialogState(() {
                selectedByWhen[index] = formattedDate;
                selectedByWhenControllers[index]?.text = DateFormat(
                  'MMMM yyyy',
                ).format(pickedDate);
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildDropdownKraCell(int index) {
    if (!selectedKRA.containsKey(index) && options.isNotEmpty) {
      selectedKRA[index] = options.first['id'];
      selectedKRAObjects[index] = options.first;
    }

    if (!kraDescriptionController.containsKey(index)) {
      kraDescriptionController[index] = TextEditingController();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Tooltip(
            message:
                'Key Result Areas define the core outcomes expected from this position. Please select the most applicable one.',
            child: DropdownButtonFormField<int>(
              isExpanded: true,
              value: selectedKRA[index],
              onChanged: (int? newValue) {
                if (newValue == null) return;
                setState(() {
                  selectedKRA[index] = newValue;

                  selectedKRAObjects[index] = options.firstWhere(
                    (option) => option['id'] == newValue,
                    orElse:
                        () => {
                          'id': 1,
                          'name': 'Unknown',
                          'description': '',
                          'rowVersion': '',
                        },
                  );
                  debugPrint("KRA changed for index $index ? KRAID: $newValue");
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 20.0,
                ),
              ),
              items:
                  options.map<DropdownMenuItem<int>>((option) {
                    return DropdownMenuItem<int>(
                      value: option['id'],
                      child: Text(option['name']),
                    );
                  }).toList(),
              selectedItemBuilder: (BuildContext context) {
                return options.map<Widget>((option) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      option['name'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList();
              },
              dropdownColor: Colors.white,
              iconSize: 30.0,
              itemHeight: 50.0,
            ),
          ),

          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              "KRA Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          gap2,
          Tooltip(
            message:
                'Enter a short description of what this KRA focuses on achieving',
            child: TextField(
              controller: kraDescriptionController[index],
              decoration: const InputDecoration(
                hintText: "Enter your description here...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  TableRow _buildMainHeaderStrategic({
    String? officename,
    String? percentDeliverables,
  }) {
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
            child: Tooltip(
              message:
                  'This percentage is used during performance reviews to determine how each output affects your overall results.',
              child: TextField(
                controller: percentageDeliverables,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                ),

                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                  RangeInputFormatter(1, 40),
                ],

                decoration: InputDecoration(
                  labelText: percentDeliverables,
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
        ),

        // BuildHeaderCell(text: ''),
        BuildHeaderCell(text: ''),
      ],
    );
  }

  // Sub Header
  TableRow _buildTableSubHeaderStrategic({bool showApprovalColumn = false}) {
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

        // BuildHeaderCell(text: 'STATUS'),
        // BuildHeaderCell(text: 'ACTION'),
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
    Function setDialogState, {
    int orderLevel = 1,
    String? id,
    // int? id,
  }) {
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

        // _buildDropdownCellStatus(index, () => (index)),
        // _buildRemoveButton(index, setDialogState),
        //  _buildApprovedDisapproved(index, setDialogState),
        (id == null || orderLevel < 2)
            ? _buildRemoveButton(index, setDialogState)
            : _buildApprovedDisapproved(index, setDialogState),
      ],
    );
  }

  // Widget _buildDropdownCellStatus(int index, VoidCallback setDialogState) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: DropdownButtonFormField<PgsStatus>(
  //       value: selectedStatus[index] ?? PgsStatus.notStarted,
  //       onChanged: (PgsStatus? newValue) {
  //         if (newValue != null) {
  //           setDialogState();
  //           setState(() {
  //             selectedStatus[index] = newValue;
  //           });
  //           saveStatusToDb(index, newValue);
  //         }
  //       },
  //       isExpanded: true,
  //       decoration: const InputDecoration(
  //         border: OutlineInputBorder(),
  //         contentPadding: EdgeInsets.all(8.0),
  //       ),
  //       items:
  //           PgsStatus.values.map((PgsStatus value) {
  //             return DropdownMenuItem<PgsStatus>(
  //               value: value,
  //               child: Text(value.name, style: const TextStyle(fontSize: 14)),
  //             );
  //           }).toList(),
  //     ),
  //   );
  // }

  void saveStatusToDb(int index, PgsStatus status) {
    debugPrint('Saving status for index');
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
                ),
                borderRadius: BorderRadius.circular(1),
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
  TableRow _PgsDeliverableHeader({
    String? officename,
    String? percentDeliverables,
  }) {
    return TableRow(
      children: [
        BuildHeaderCell(
          text: 'Office: ${officename ?? officeDisplay}',
          fontSize: 15,
          fontStyle: FontStyle.normal,
        ),
        BuildHeaderCell(text: ''),
        BuildHeaderCell(text: ''),
        BuildHeaderCell(
          text: 'STRATEGIC CONTRIBUTIONS',
          fontSize: 15,
          fontStyle: FontStyle.normal,
        ),

        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(
              message:
                  'This percentage is used during performance reviews to determine how each output affects your overall results.',
              child: TextField(
                controller: percentageDeliverables,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: const Color.fromARGB(255, 10, 7, 1),
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2),
                  RangeInputFormatter(1, 40),
                ],

                decoration: InputDecoration(
                  labelText: percentDeliverables,
                  hintText: '0',
                  suffixText: '%',
                  suffixStyle: TextStyle(
                    color: const Color.fromARGB(255, 15, 11, 1),
                    fontSize: 20,
                  ),
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
        ),
        BuildHeaderCell(text: ''),
        BuildHeaderCell(text: ''),
        BuildHeaderCell(text: ''),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  TableRow _PgsBuildTableSubheader() {
    return TableRow(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 255, 254, 254),
      ),
      children: [
        _buildSizedHeaderCell('KRA', width: 100),
        _buildSizedHeaderCell('DIRECT', width: 70),
        _buildSizedHeaderCell('INDIRECT', width: 80),
        _buildSizedHeaderCell('DELIVERABLES', width: 200),
        _buildSizedHeaderCell('WHEN', width: 90),
        _buildSizedHeaderCell('STATUS', width: 100),
        _buildSizedHeaderCell('REMARKS', width: 120),
        _buildSizedHeaderCell('SCORING', width: 100),
      ],
    );
  }

  Widget _buildSizedHeaderCell(String text, {double width = 10}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: SizedBox(
        width: width,
        child: BuildHeaderCell(
          text: text,
          fontSize: 13,
          fontStyle: FontStyle.normal,
        ),
      ),
    );
  }

  //END PGS DELIVERABLES STATUS

  // start-----------------------PGS Deliverable Status---------------------

  TableRow _buildTableRowStrategicPGSDeliverableStatus(
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
        _buildDropdownKraCellPGSDeliverableStatus(index),
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
        _buildExpandableTextAreaCellPGSDeliverable(index),
        _buildDatePickerCellPgsDeliverableStatus(index, setDialogState),
        _buildDropdownCellStatusPgsDeliverableStatus(index, () => (index)),
        _buildExpandableTextAreaRemarksCell(index),
        _buildExpandableTextAreaPercentageCell(index),
      ],
    );
  }
  // end-----------------------PGS Deliverable Status---------------------

  //Start------------Pgs Deliverables Remark ----------------------------------------------
  Widget _buildExpandableTextAreaRemarksCell(int index) {
    if (!remarksControllers.containsKey(index)) {
      remarksControllers[index] = TextEditingController();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 50.0),
        child: TextField(
          controller: remarksControllers[index],
          maxLines: null,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 13.0),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(8.0),
          ),
          enabled: false,
          onChanged: (value) {
            setState(() {});
          },
        ),
      ),
    );
  }
  //End------------Pgs Deliverables Remarks----------------------------------------------

  //Start------------Pgs Deliverables Remark ----------------------------------------------
  Widget _buildExpandableTextAreaPercentageCell(int index) {
    if (!percentageControllers.containsKey(index)) {
      percentageControllers[index] = TextEditingController();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 50.0),
        child: TextField(
          controller: percentageControllers[index],
          maxLines: null,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(fontSize: 13.0),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],

          decoration: InputDecoration(
            border: OutlineInputBorder(),
            suffixText: '%',
            contentPadding: EdgeInsets.all(8.0),
          ),
          enabled: false,
          onChanged: (value) {
            setState(() {});
          },
        ),
      ),
    );
  }
  //End------------Pgs Deliverables Status----------------------------------------------

  ////------------------Kra for Pgs Delieverable Status--------------------
  Widget _buildDropdownKraCellPGSDeliverableStatus(int index) {
    if (!selectedKRA.containsKey(index) && options.isNotEmpty) {
      selectedKRA[index] = options.first['id'];
      selectedKRAObjects[index] = options.first;
    }

    if (!kraDescriptionController.containsKey(index)) {
      kraDescriptionController[index] = TextEditingController();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Tooltip(
            message:
                'Key Result Areas define the core outcomes expected from this position. Please select the most applicable one.',
            child: DropdownButtonFormField<int>(
              isExpanded: true,
              value: selectedKRA[index],
              onChanged: (int? newValue) {
                if (newValue == null) return;
                setState(() {
                  selectedKRA[index] = newValue;

                  selectedKRAObjects[index] = options.firstWhere(
                    (option) => option['id'] == newValue,
                    orElse:
                        () => {
                          'id': 1,
                          'name': 'Unknown',
                          'description': '',
                          'rowVersion': '',
                        },
                  );
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 20.0,
                ),
              ),
              items:
                  options.map<DropdownMenuItem<int>>((option) {
                    return DropdownMenuItem<int>(
                      value: option['id'],
                      child: Text(option['name']),
                    );
                  }).toList(),
              selectedItemBuilder: (BuildContext context) {
                return options.map<Widget>((option) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      option['name'],
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList();
              },
              dropdownColor: Colors.white,
              iconSize: 30.0,
              itemHeight: 50.0,
            ),
          ),

          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              "KRA Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          gap2,
          Tooltip(
            message:
                'Enter a short description of what this KRA focuses on achieving',
            child: TextField(
              controller: kraDescriptionController[index],
              decoration: const InputDecoration(
                hintText: "Enter your description here...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  //Start---------------------Pgs Deliverable datepicker status---------------------------------------
  Widget _buildDatePickerCellPgsDeliverableStatus(
    int index,
    Function setDialogState,
  ) {
    selectedByWhenControllers.putIfAbsent(index, () => TextEditingController());

    if (selectedByWhen[index] == null ||
        selectedByWhenControllers[index]?.text.isEmpty == true) {
      DateTime now = DateTime.now();
      String defaultDate = DateFormat('yyyy-MM-dd').format(now);
      selectedByWhen[index] = defaultDate;
      selectedByWhenControllers[index]?.text = DateFormat(
        'MMMM yyyy',
      ).format(now);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Tooltip(
        message:
            'Specify when this deliverable is expected to be finished. Used to monitor deadlines and keep progress on schedule.',
        child: TextFormField(
          controller: selectedByWhenControllers[index],
          readOnly: true,
          style: TextStyle(fontSize: 13.50),
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
                      style: TextButton.styleFrom(
                        foregroundColor: primaryColor,
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              String formattedDate = DateFormat(
                'yyyy-MM-dd',
              ).format(pickedDate);
              setDialogState(() {
                selectedByWhen[index] = formattedDate;
                selectedByWhenControllers[index]?.text = DateFormat(
                  'MMMM yyyy',
                ).format(pickedDate);
              });
            }
          },
        ),
      ),
    );
  }
  //End---------------------Pgs Deliverable Status---------------------------------------

  // Start-----------------------PGS Deliverable Status---------------------
  // Dropdown field that allows changing PgsStatus for each row
  Widget _buildDropdownCellStatusPgsDeliverableStatus(
    int index,
    VoidCallback setDialogState,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<PgsStatus>(
        value: selectedStatus[index] ?? PgsStatus.notStarted,
        onChanged: null,
        // onChanged: (PgsStatus? newValue) {
        //   if (newValue != null) {
        //     debugPrint('Selected Status for index $index: ${newValue.name}');
        //     setDialogState();
        //     setState(() {
        //       selectedStatus[index] = newValue;
        //     });
        //     saveStatusToDb(index, newValue);
        //   }
        // },
        isExpanded: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.all(8.0),
        ),

        items:
            PgsStatus.values.map((PgsStatus value) {
              return DropdownMenuItem<PgsStatus>(
                value: value,
                child: Text(value.name, style: const TextStyle(fontSize: 13)),
              );
            }).toList(),
      ),
    );
  }
  // End-----------------------PGS Deliverable Status---------------------

  //Start------------Pgs Deliverables Status----------------------------------------------
  Widget _buildExpandableTextAreaCellPGSDeliverable(int index) {
    if (!deliverablesControllers.containsKey(index)) {
      deliverablesControllers[index] = TextEditingController();
      debugPrint("? Initialized new controller at index: $index");
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 50.0),
        child: Tooltip(
          message:
              'Specify the tangible results or outcomes tied to this responsibility.',
          child: TextField(
            controller: deliverablesControllers[index],
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: TextStyle(fontSize: 14.0),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(8.0),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  //End------------Pgs Deliverables Status----------------------------------------------

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

  //Approved & Disapproved Buttons
  Widget _buildApprovedDisapproved(int index, Function setDialogState) {
    bool isApproved = selectedApproved[index] ?? false;
    bool isDisapproved = selectedDisapproved[index] ?? false;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.thumb_up,
                    color: isApproved ? Colors.green : primaryTextColor,
                  ),
                  onPressed: () {
                    setDialogState(() {
                      selectedApproved[index] = true;
                      selectedDisapproved[index] = false;
                    });
                  },
                ),
                Text("Approve", style: TextStyle(fontSize: 12)),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.thumb_down,
                    color: isDisapproved ? Colors.red : primaryTextColor,
                  ),
                  onPressed: () {
                    setDialogState(() {
                      selectedApproved[index] = false;
                      selectedDisapproved[index] = true;
                    });
                  },
                ),
                Text("Disapprove", style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),

        if (isDisapproved) ...[
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Reason:", style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    hintText: "Enter your reason here...",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                gap,
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildExpandableTextAreaCell(int index) {
    if (!deliverablesControllers.containsKey(index)) {
      deliverablesControllers[index] = TextEditingController();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 50.0),
        child: Tooltip(
          message:
              'Specify the tangible results or outcomes tied to this responsibility.',
          child: TextField(
            controller: deliverablesControllers[index],
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(8.0),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}

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
