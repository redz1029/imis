// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:imis/auditor/models/auditor.dart';
import 'package:imis/auditor_offices/models/auditor_offices.dart';
import 'package:imis/auditor_offices/services/auditor_offices_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:imis/widgets/pagination_controls.dart';
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

  final dio = Dio();
  TextEditingController searchController = TextEditingController();
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

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    isSearchfocus.addListener(() {
      setState(() {});
    });

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
    fetchAuditorOffice();
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  void displayFullName() {
    for (var auditorOffice in auditorOfficeList) {
      userList.firstWhere(
        (user) => user.id == auditorOffice.auditorId.toString(),
        orElse: () => User(id: '', fullName: 'Unknown', position: 'position'),
      );
    }
  }

  Future<void> fetchAuditorOffice({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _auditorOfficeSevice.getAuditorOffice(
        page: page,
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

  void displayOfficeName() {
    for (var userOffice in auditorOfficeList) {
      officenameList.firstWhere(
        (office) => office.id == userOffice.officeId,
        orElse:
            () => Office(
              id: 0,
              name: 'Unknown',
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

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          titlePadding: EdgeInsets.zero,
          title: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: primaryLightColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              id == null ? 'Create Auditor Office' : 'Edit Auditor Office',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 480,

                  child: DropdownSearch<Auditor?>(
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: 'Search Auditors ...',
                          filled: true,
                          fillColor: mainBgColor,
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                      ),
                      itemBuilder: (context, auditor, isSelected) {
                        final user = userList.firstWhere(
                          (u) => u.id == auditor?.userId,
                          orElse:
                              () => User(
                                id: '',
                                fullName: 'Unknown',
                                position: '',
                              ),
                        );

                        return ListTile(
                          tileColor: mainBgColor,
                          title: Text(user.fullName),
                        );
                      },
                    ),
                    items: auditorList,
                    itemAsString: (auditor) {
                      final user = userList.firstWhere(
                        (u) => u.id == auditor?.userId,
                        orElse:
                            () =>
                                User(id: '', fullName: 'Unknown', position: ''),
                      );
                      return user.fullName;
                    },
                    onChanged:
                        (value) => setState(
                          () => _selectedAuditor = value?.id.toString(),
                        ),
                    selectedItem:
                        _selectedAuditor == null
                            ? null
                            : auditorList.firstWhere(
                              (auditor) =>
                                  auditor.id.toString() == _selectedAuditor,
                              orElse:
                                  () => Auditor(
                                    id: 0,
                                    name: 'Unknown',
                                    userId: '',
                                  ),
                            ),
                    validator: (value) {
                      if (value == null) {
                        return 'required';
                      }
                      return null;
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Select Auditor',
                        filled: true,
                        fillColor: mainBgColor,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                        ),
                      ),
                    ),
                  ),
                ),
                gap14px,
                SizedBox(
                  width: 480,
                  child: DropdownSearch<Office>(
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: 'Search Office Name...',
                          filled: true,
                          fillColor: mainBgColor,
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                      ),
                      itemBuilder:
                          (context, office, isSelected) => ListTile(
                            tileColor: mainBgColor,
                            title: Text(office.name),
                          ),
                    ),
                    items: officenameList,
                    itemAsString: (office) => office.name,
                    selectedItem:
                        _selectedOffice == null
                            ? null
                            : officenameList.firstWhere(
                              (office) =>
                                  office.id.toString() == _selectedOffice,
                              orElse:
                                  () => Office(
                                    id: 0,
                                    name: 'Unknown',
                                    officeTypeId: 0,
                                    parentOfficeId: 0,
                                    isActive: true,
                                    isDeleted: false,
                                  ),
                            ),

                    onChanged: (value) {
                      setState(() {
                        _selectedOffice = value?.id.toString();
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'required';
                      }
                      return null;
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Select Office',
                        filled: true,
                        fillColor: mainBgColor,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                        ),
                      ),
                    ),
                  ),
                ),
                gap14px,
                SizedBox(
                  width: 480,
                  child: DropdownSearch<PgsPeriod>(
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          hintText: 'Search Period...',
                          filled: true,
                          fillColor: mainBgColor,
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                      ),
                      itemBuilder:
                          (context, period, isSelected) => ListTile(
                            tileColor: mainBgColor,
                            title: Text(
                              "${LongDateOnlyConverter().toJson(period.startDate)} - ${LongDateOnlyConverter().toJson(period.endDate)}",
                            ),
                          ),
                    ),

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

                    onChanged: (value) {
                      setState(() {
                        _selectedPeriod = value?.id.toString();
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'required';
                      }
                      return null;
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: 'Select Period',
                        filled: true,
                        fillColor: mainBgColor,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
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
                  final auditorOffice = AuditorOffices(
                    id: int.tryParse(id ?? '0') ?? 0,
                    auditorId: int.tryParse(_selectedAuditor ?? '0') ?? 0,
                    officeId: int.tryParse(_selectedOffice ?? '0') ?? 0,
                    pgsPeriodId: int.tryParse(_selectedPeriod ?? '0') ?? 0,
                    isOfficeHead: false,
                    isDeleted: false,
                  );
                  await _auditorOfficeSevice.addAuditorOffice(auditorOffice);
                  setState(() {
                    fetchAuditorOffice();
                  });
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

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: Text("Auditor Office"),
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
                      labelText: 'Search',
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
            gap16px,
            Expanded(
              child: Column(
                children: [
                  Container(
                    color: secondaryColor,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text('#', style: TextStyle(color: grey)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text('Auditor', style: TextStyle(color: grey)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text('Office', style: TextStyle(color: grey)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text('Period', style: TextStyle(color: grey)),
                        ),

                        SizedBox(
                          width: 150,
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
                            filteredList
                                .asMap()
                                .map((index, auditorOffice) {
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
                                              name: 'Unknown',
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
                                          name: 'name',
                                          userId: '',
                                        ),
                                  );

                                  final matchedUser = userList.firstWhere(
                                    (u) => u.id == matchedAuditor.userId,
                                    orElse:
                                        () => User(
                                          id: '',
                                          fullName: 'Unknown',
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

                                  return MapEntry(
                                    index,
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 1,
                                        horizontal: 10,
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
                                          SizedBox(
                                            width: 80,
                                            child: Text(
                                              itemNumber.toString(),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              userName,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              officeName,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              period,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 160,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.edit),
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
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: primaryColor,
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
                              (page) => fetchAuditorOffice(page: page),
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
    );
  }

  void showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete this Auditor Office? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: primaryTextColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _auditorOfficeSevice.deleteAuditorOffice(id);
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
