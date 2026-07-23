// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/auditor/models/auditor.dart';
import 'package:imis/auditor_offices/models/auditor_offices.dart';
import 'package:imis/auditor_offices/services/auditor_offices_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/common/search_dropdown.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../common_services/common_service.dart';
import '../../user/models/user.dart';

class AuditorOfficesPage extends StatefulWidget {
  const AuditorOfficesPage({super.key});

  @override
  State<AuditorOfficesPage> createState() => _AuditorOfficesPageState();
}

class _AuditorOfficesPageState extends State<AuditorOfficesPage> {
  final FocusNode isSearchfocus = FocusNode();
  final _commonService = CommonService(Dio());
  final _auditorOfficeSevice = AuditorOfficesService(Dio());
  final _paginationUtils = PaginationUtil(Dio());
  final dio = Dio();
  TextEditingController searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedAuditor;
  String? _selectedOffice;
  String? _selectedPeriod;
  List<Auditor> auditorList = [];
  List<User> userList = [];
  List<Office> officenameList = [];
  List<PgsPeriod> periodList = [];
  List<AuditorOffices> auditorOfficeList = [];
  List<AuditorOffices> filteredList = [];
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  late FilterSearchResultUtil<AuditorOffices> auditorOfficeSearchUtil;
  bool _isLoading = false;
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    isSearchfocus.addListener(() {
      setState(() {});
    });
    fetchAuditorOffice();
    auditorOfficeSearchUtil = FilterSearchResultUtil<AuditorOffices>(
      paginationUtils: _paginationUtils,
      endpoint: ApiEndpoint().auditorOffice,
      pageSize: _pageSize,
      fromJson: (json) => AuditorOffices.fromJson(json),
    );
    () async {
      final auditor = await _commonService.fetchAuditors();
      final users = await _commonService.fetchUsers();
      final offices = await _commonService.fetchOffices();
      final period = await _commonService.fetchPgsPeriod();

      if (!mounted) return;

      setState(() {
        officenameList = offices;
        _selectedOffice = offices.isNotEmpty ? offices[0].id.toString() : null;

        periodList = period;
        _selectedPeriod = period.isNotEmpty ? period[0].id.toString() : null;

        auditorList = auditor;
        userList = users;
        _selectedAuditor = auditor.isNotEmpty ? auditor[0].id.toString() : null;
      });
      displayFullName();
      displayOfficeName();
    }();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    isSearchfocus.dispose();
    super.dispose();
  }

  void displayFullName() {
    for (var auditorOffice in auditorOfficeList) {
      userList.firstWhere(
        (user) => user.id == auditorOffice.auditorId.toString(),
        orElse: () => User(id: '', fullName: '', position: ''),
      );
    }
  }

  Future<void> fetchAuditorOffice({int? page, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    final targetPage = page ?? _currentPage;

    try {
      final pageList = await _auditorOfficeSevice.getAuditorOffice(
        page: targetPage,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          auditorOfficeList = pageList.items;
          filteredList = List.from(auditorOfficeList);
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

  Future<void> filterSearchResults(String query) async {
    final results = await auditorOfficeSearchUtil.filter(query, (
      auditorOffice,
      search,
    ) {
      final auditor = auditorList.firstWhere(
        (a) => a.id.toString() == auditorOffice.auditorId.toString(),
        orElse: () => Auditor(id: 0, name: '', userId: ''),
      );

      final user = userList.firstWhere(
        (u) => u.id.toString() == auditor.userId.toString(),
        orElse: () => User(id: '', fullName: '', position: ''),
      );

      final office = officenameList.firstWhere(
        (o) => o.id == auditorOffice.officeId,
        orElse:
            () => Office(
              id: 0,
              name: '',
              officeTypeId: 0,
              parentOfficeId: 0,
              isActive: true,
              isDeleted: false,
            ),
      );

      final lowerSearch = search.toLowerCase().trim();
      return user.fullName.toLowerCase().contains(lowerSearch) ||
          office.name.toLowerCase().contains(lowerSearch);
    });

    setState(() {
      filteredList = results;
    });
  }

  void displayOfficeName() {
    for (var userOffice in auditorOfficeList) {
      officenameList.firstWhere(
        (office) => office.id == userOffice.officeId,
        orElse:
            () => Office(
              id: 0,
              name: '',
              officeTypeId: 0,
              parentOfficeId: 0,
              isActive: true,
              isDeleted: false,
            ),
      );
    }
  }

  void showFormDialog({
    String? id,
    String? selectedAuditor,
    String? selectedOffice,
    String? selectedPeriod,
  }) {
    _selectedAuditor = selectedAuditor;
    _selectedOffice = selectedOffice;
    _selectedPeriod = selectedPeriod;
    final isEdit = id != null;
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 480,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kSurface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 32,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.business,
                              color: primaryColor,
                              size: 22,
                            ),
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEdit
                                    ? 'Manage Auditor Office'
                                    : 'Create Auditor Office',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: kText,
                                ),
                              ),
                              Text(
                                isEdit
                                    ? 'Update auditor to this office'
                                    : 'Assign auditor to an office',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: kMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Divider(color: kBorder, height: 1),
                      SizedBox(height: 20),
                      SearchDropdown<Auditor?>(
                        label: 'Auditor',
                        hintText: 'Search auditor...',
                        items: auditorList,
                        itemAsString: (auditor) {
                          final user = userList.firstWhere(
                            (u) => u.id == auditor?.userId,
                            orElse:
                                () => User(id: '', fullName: '', position: ''),
                          );
                          return user.fullName;
                        },
                        selectedItem:
                            _selectedAuditor == null
                                ? null
                                : auditorList.firstWhere(
                                  (auditor) =>
                                      auditor.id.toString() == _selectedAuditor,
                                  orElse:
                                      () =>
                                          Auditor(id: 0, name: '', userId: ''),
                                ),
                        onChanged:
                            (value) => setState(
                              () => _selectedAuditor = value?.id.toString(),
                            ),
                        validator: (value) {
                          if (value == null) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                      gap14px,
                      SearchDropdown<Office?>(
                        label: 'Office',
                        hintText: 'Search office...',
                        items: officenameList,
                        itemAsString: (u) => u?.name ?? '',
                        selectedItem:
                            _selectedOffice == null
                                ? null
                                : officenameList.firstWhereOrNull(
                                  (item) =>
                                      item.id.toString() == _selectedOffice,
                                ),
                        onChanged:
                            (value) => setStateDialog(
                              () => _selectedOffice = value?.id.toString(),
                            ),
                        validator:
                            (value) =>
                                value == null ? 'Please select office' : null,
                      ),
                      gap14px,
                      SearchDropdown<PgsPeriod>(
                        label: 'Period',
                        hintText: 'Search period...',
                        items: periodList,
                        itemAsString:
                            (period) =>
                                "${LongDateOnlyConverter().toJson(period.startDate)} - ${LongDateOnlyConverter().toJson(period.endDate)}",
                        selectedItem:
                            _selectedPeriod == null
                                ? null
                                : periodList.firstWhere(
                                  (office) =>
                                      office.id.toString() == _selectedPeriod,
                                  orElse:
                                      () => PgsPeriod(
                                        0,
                                        false,
                                        DateTime.now(),
                                        DateTime.now(),
                                        'remarks',
                                      ),
                                ),
                        onChanged:
                            (value) => setStateDialog(
                              () => _selectedPeriod = value?.id.toString(),
                            ),
                        validator:
                            (value) =>
                                value == null ? 'Please select office' : null,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: kBorder),
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    8,
                                  ),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.plusJakartaSans(
                                  color: kMuted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              label: Text(
                                isEdit ? 'Update' : 'Save',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) return;
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (ctx) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                          width: 340,
                                          padding: EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            color: kSurface,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.12,
                                                ),
                                                blurRadius: 32,
                                                offset: const Offset(0, 12),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 48,
                                                height: 48,
                                                decoration: BoxDecoration(
                                                  color: primaryColor
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                                child: Icon(
                                                  Icons.help_outline_rounded,
                                                  color: primaryColor,
                                                  size: 26,
                                                ),
                                              ),
                                              SizedBox(height: 14),
                                              Text(
                                                isEdit
                                                    ? 'Confirm Update'
                                                    : 'Confirm Save',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16,
                                                      color: kText,
                                                    ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                isEdit
                                                    ? 'Are you sure you want to update this auditor office?'
                                                    : 'Are you sure you want to save this auditor office',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 13,
                                                      color: kMuted,
                                                      height: 1.5,
                                                    ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            ctx,
                                                            false,
                                                          ),
                                                      child: Text(
                                                        'No',
                                                        style:
                                                            GoogleFonts.plusJakartaSans(
                                                              color: kMuted,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            ctx,
                                                            true,
                                                          ),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            primaryColor,
                                                        elevation: 0,
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 11,
                                                            ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        'Yes',
                                                        style:
                                                            GoogleFonts.plusJakartaSans(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                );
                                if (confirmed == true) {
                                  final auditorOffice = AuditorOffices(
                                    id: int.tryParse(id ?? '0') ?? 0,
                                    auditorId:
                                        int.tryParse(_selectedAuditor ?? '0') ??
                                        0,
                                    officeId:
                                        int.tryParse(_selectedOffice ?? '0') ??
                                        0,
                                    pgsPeriodId:
                                        int.tryParse(_selectedPeriod ?? '0') ??
                                        0,
                                    isOfficeHead: false,
                                    isDeleted: false,
                                  );
                                  await _auditorOfficeSevice.addAuditorOffice(
                                    auditorOffice,
                                  );
                                  setState(() {
                                    fetchAuditorOffice();
                                  });
                                  MotionToast.success(
                                    toastAlignment: Alignment.topCenter,
                                    description: Text('Saved successfully'),
                                  ).show(context);
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        ],
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
              "Auditor Office Information",
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
                      labelText: 'Search...',
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Auditor",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Office",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Period",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 3,
                              child: Text(
                                "Actions",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
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
                                  final auditorOffice = filteredList[index];
                                  int itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;

                                  final matchedOffice = officenameList
                                      .firstWhere(
                                        (office) =>
                                            office.id == auditorOffice.officeId,
                                        orElse:
                                            () => Office(
                                              id: 0,
                                              name: '',
                                              officeTypeId: 0,
                                              parentOfficeId: 0,
                                              isActive: true,
                                              isDeleted: false,
                                            ),
                                      );
                                  final officeName = matchedOffice.name;

                                  final matchedAuditor = auditorList.firstWhere(
                                    (a) => a.id == auditorOffice.auditorId,
                                    orElse:
                                        () => Auditor(
                                          id: 0,
                                          name: '',
                                          userId: '',
                                        ),
                                  );

                                  final matchedUser = userList.firstWhere(
                                    (u) => u.id == matchedAuditor.userId,
                                    orElse:
                                        () => User(
                                          id: '',
                                          fullName: '',
                                          position: '',
                                        ),
                                  );

                                  final userName = matchedUser.fullName;

                                  final matchedPeriod = periodList.firstWhere(
                                    (office) =>
                                        office.id == auditorOffice.pgsPeriodId,
                                    orElse:
                                        () => PgsPeriod(
                                          0,
                                          false,
                                          DateTime.now(),
                                          DateTime.now(),
                                          'remarks',
                                        ),
                                  );
                                  final period =
                                      "${LongDateOnlyConverter().toJson(matchedPeriod.startDate)} - ${LongDateOnlyConverter().toJson(matchedPeriod.endDate)}";

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
                                            child: Text(
                                              "$itemNumber",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              userName,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              officeName,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              period,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),

                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    size: 16,
                                                    Icons.edit_outlined,
                                                  ),
                                                  onPressed: () {
                                                    showFormDialog(
                                                      id:
                                                          auditorOffice.id
                                                              .toString(),
                                                      selectedAuditor:
                                                          auditorOffice
                                                              .auditorId
                                                              .toString(),

                                                      selectedOffice:
                                                          auditorOffice.officeId
                                                              .toString(),
                                                      selectedPeriod:
                                                          auditorOffice
                                                              .pgsPeriodId
                                                              .toString(),
                                                    );
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    size: 16,
                                                    CupertinoIcons
                                                        .delete_simple,
                                                    color: Colors.redAccent,
                                                  ),
                                                  onPressed:
                                                      () => showDeleteDialog(
                                                        auditorOffice.id
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
                                                fontSize: 12,
                                              ),
                                            ),
                                            const Spacer(),
                                            PopupMenuButton<String>(
                                              color:
                                                  Theme.of(context).cardColor,
                                              icon: const Icon(Icons.more_vert),
                                              onSelected: (value) {
                                                if (value == 'edit') {
                                                  showFormDialog(
                                                    id:
                                                        auditorOffice.id
                                                            .toString(),
                                                    selectedAuditor:
                                                        auditorOffice.auditorId
                                                            .toString(),

                                                    selectedOffice:
                                                        auditorOffice.officeId
                                                            .toString(),
                                                    selectedPeriod:
                                                        auditorOffice
                                                            .pgsPeriodId
                                                            .toString(),
                                                  );
                                                }

                                                if (value == 'delete') {
                                                  showDeleteDialog(
                                                    auditorOffice.id.toString(),
                                                  );
                                                }
                                              },
                                              itemBuilder:
                                                  (_) => [
                                                    const PopupMenuItem(
                                                      value: 'edit',
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.edit_outlined,
                                                            size: 16,
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text('Edit'),
                                                        ],
                                                      ),
                                                    ),
                                                    const PopupMenuItem(
                                                      value: 'delete',
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            CupertinoIcons
                                                                .delete_simple,
                                                            color: Colors.red,
                                                            size: 16,
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

                                        Text(
                                          "Auditor: $userName",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 4),

                                        Text(
                                          "Office $officeName",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 4),

                                        Text(
                                          "Period: $period",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(10),
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
                                (page) => fetchAuditorOffice(page: page),
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
      builder:
          (ctx) => DeleteDialog(
            title: 'Auditor Office ',
            itemName: 'auditor office',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _auditorOfficeSevice.deleteAuditorOffice(id);
                await fetchAuditorOffice();
                if (mounted) {
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text(
                      'auditor office deleted successfully',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  ).show(context);
                }
              } catch (_) {
                MotionToast.error(
                  toastAlignment: Alignment.topCenter,
                  description: Text(
                    'Failed to delete auditor office',
                    style: GoogleFonts.plusJakartaSans(),
                  ),
                );
              }
            },
          ),
    );
  }
}
