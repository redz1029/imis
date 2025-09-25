import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/user/models/user_office.dart';
import 'package:imis/user/services/user_office_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/widgets/custom_toggle.dart';
import 'package:imis/widgets/pagination_controls.dart';

class UserOfficePage extends StatefulWidget {
  const UserOfficePage({super.key});

  @override
  UserOfficePageState createState() => UserOfficePageState();
}

class UserOfficePageState extends State<UserOfficePage> {
  final _commonService = CommonService(Dio());
  final _userOfficeService = UserOfficeService(Dio());
  final _paginationUtils = PaginationUtil(Dio());
  late FilterSearchResultUtil<UserOffice> userOfficeSearchUtil;
  final _formKey = GlobalKey<FormState>();
  List<UserOffice> userOfficeList = [];
  List<UserOffice> filteredList = [];
  List<User> userList = [];
  List<User> filteredListUser = [];
  List<Office> officenameList = [];
  String? _selectedOfficeId;
  String? _selectedUserId;
  String? officeName;
  String? userName;
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;
  final TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();
  final dio = Dio();

  Future<void> fetchUserOffice({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _userOfficeService.getPgsPeriod(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          userOfficeList = pageList.items;
          filteredList = List.from(userOfficeList);
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
    fetchUserOffice();
    isSearchfocus.addListener(() {
      setState(() {});
    });
    userOfficeSearchUtil = FilterSearchResultUtil<UserOffice>(
      paginationUtils: _paginationUtils,
      endpoint: ApiEndpoint().useroffice,
      pageSize: _pageSize,
      fromJson: (json) => UserOffice.fromJson(json),
    );
    isSearchfocus.addListener(() {
      setState(() {});
    });

    () async {
      final offices = await _commonService.fetchOffices();
      final users = await _commonService.fetchUsers();

      if (!mounted) return;

      setState(() {
        officenameList = offices;
        userList = users;
        _selectedOfficeId =
            offices.isNotEmpty ? offices[0].id.toString() : null;
        _selectedUserId = users.isNotEmpty ? users[0].id : null;
      });

      displayFullName();
      displayOfficeName();
    }();
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  void displayFullName() {
    for (var userOffice in userOfficeList) {
      userList.firstWhere(
        (user) => user.id == userOffice.userId,
        orElse: () => User(id: '', fullName: 'Unknown', position: 'position'),
      );
    }
  }

  void displayOfficeName() {
    for (var userOffice in userOfficeList) {
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

  Future<void> filterSearchResults(String query) async {
    final results = await userOfficeSearchUtil.filter(
      query,
      (useroffice, search) =>
          (useroffice.firstName).toLowerCase().contains(search.toLowerCase()),
    );

    setState(() {
      filteredList = results;
    });
  }

  void showFormDialog({
    String? id,
    bool isDeleted = false,
    String? selectedUserId,
    String? selectedOfficeId,
    bool isActive = true,
    bool isOfficeHead = false,
  }) {
    TextEditingController firstNameController = TextEditingController(text: '');
    TextEditingController middleNameController = TextEditingController(
      text: '',
    );
    TextEditingController lastNameController = TextEditingController(text: '');
    TextEditingController prefixController = TextEditingController(text: '');
    TextEditingController suffixController = TextEditingController(text: '');
    TextEditingController positionController = TextEditingController(text: '');

    _selectedUserId = selectedUserId;
    _selectedOfficeId = selectedOfficeId;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                  id == null ? 'Create User Office' : 'Edit User Office',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 480,
                      child: DropdownSearch<User?>(
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              hintText: 'Search User Name...',
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
                              (context, user, isSelected) => ListTile(
                                tileColor: mainBgColor,
                                title: Text(user?.fullName ?? ''),
                              ),
                        ),
                        items: userList,
                        itemAsString: (u) => u?.fullName ?? '',
                        selectedItem: userList.cast<User?>().firstWhere(
                          (u) => u?.id == _selectedUserId,
                          orElse: () => null,
                        ),
                        onChanged:
                            (value) =>
                                setState(() => _selectedUserId = value?.id),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a user';
                          }
                          return null;
                        },
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Select User',
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
                            _selectedOfficeId == null
                                ? null
                                : officenameList.firstWhere(
                                  (office) =>
                                      office.id.toString() == _selectedOfficeId,
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
                            _selectedOfficeId = value?.id.toString();
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an office';
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
                    CustomToggle(
                      label: "Office Head",
                      value: isOfficeHead,
                      activeColor: primaryColor,
                      inactiveColor: Colors.grey,
                      onChanged: (val) {
                        setState(() {
                          isOfficeHead = val;
                        });
                      },
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
                    if (_formKey.currentState!.validate()) {
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
                        final isDuplicate = userOfficeList.any(
                          (u) =>
                              u.userId == _selectedUserId &&
                              u.officeId ==
                                  int.tryParse(_selectedOfficeId ?? '0') &&
                              u.id != int.tryParse(id ?? '0'),
                        );

                        if (isDuplicate) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'User already assigned to this office.',
                              ),
                            ),
                          );
                          return;
                        }

                        final user = UserOffice(
                          int.tryParse(id ?? '0') ?? 0,
                          isDeleted,
                          '',
                          _selectedUserId ?? '',
                          int.tryParse(_selectedOfficeId ?? '0') ?? 0,
                          isActive,
                          firstNameController.text,
                          middleNameController.text,
                          lastNameController.text,
                          prefixController.text,
                          suffixController.text,
                          positionController.text,
                          isOfficeHead,
                        );

                        await _userOfficeService.addOrUpdateUserOffice(user);
                        setState(() {
                          fetchUserOffice();
                        });
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
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

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: Text('User Office Information'),
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
                      labelText: 'Search User Office',
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
                          child: Text('Name', style: TextStyle(color: grey)),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('Office', style: TextStyle(color: grey)),
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
                            filteredList
                                .asMap()
                                .map((index, userOffice) {
                                  int itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;

                                  final matchedOffice = officenameList
                                      .firstWhere(
                                        (office) =>
                                            office.id == userOffice.officeId,
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

                                  final matchUserName = userList.firstWhere(
                                    (user) => user.id == userOffice.userId,
                                    orElse:
                                        () => User(
                                          id: 'unknown',
                                          fullName: 'Unknown',
                                          position: 'position',
                                        ),
                                  );
                                  final userName = matchUserName.fullName;

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
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                itemNumber.toString(),
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
                                                userName,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                right: 1,
                                              ),
                                              child: Text(
                                                officeName,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.edit),
                                                  onPressed: () {
                                                    userList.firstWhere(
                                                      (user) =>
                                                          user.id ==
                                                          userOffice.userId,
                                                      orElse:
                                                          () => User(
                                                            id: 'unknown',
                                                            fullName: 'Unknown',
                                                            position:
                                                                'position',
                                                          ),
                                                    );
                                                    userOffice.officeId
                                                        .toString();

                                                    showFormDialog(
                                                      id:
                                                          userOffice.id
                                                              .toString(),
                                                      selectedUserId:
                                                          userOffice.userId,
                                                      selectedOfficeId:
                                                          userOffice.officeId
                                                              .toString(),
                                                      isOfficeHead:
                                                          userOffice
                                                              .isOfficeHead,
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
                                                        userOffice.userId
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
                          onPageChanged: (page) => fetchUserOffice(page: page),
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

  void showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete this User Office? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: primaryTextColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _userOfficeService.deleteUserOffice(id);
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
