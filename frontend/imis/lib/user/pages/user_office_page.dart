import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/user/models/user_office.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserOfficePage extends StatefulWidget {
  const UserOfficePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserOfficePageState createState() => _UserOfficePageState();
}

class _UserOfficePageState extends State<UserOfficePage> {
  List<UserOffice> userOfficeList = [];
  List<UserOffice> filteredList = [];
  List<Office> officenameList = [];

  List<Map<String, dynamic>> filteredListOffice = [];
  List<Map<String, dynamic>> officeList = [];
  String? _selectedOfficeId;

  List<User> userList = [];
  List<User> filteredListUser = [];
  String? _selectedUserId;
  String? officeName;
  String? userName;

  final _paginationUtils = PaginationUtil(Dio());
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
      final pageList = await _paginationUtils.fetchPaginatedData<UserOffice>(
        endpoint: ApiEndpoint().useroffice,
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
        fromJson: (json) => UserOffice.fromJson(json),
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          userOfficeList = pageList.items.toList();
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

  Future<void> fetchOfficeList() async {
    var url = ApiEndpoint().office;

    try {
      var response = await dio.get(url);
      debugPrint(" Raw Office response: ${response.data}");

      if (response.statusCode == 200 && response.data is List) {
        List<Office> data =
            (response.data as List).map((e) => Office.fromJson(e)).toList();

        setState(() {
          officenameList = data;
        });

        debugPrint("Office list loaded: ${data.length}");
        printUserOfficeWithOfficeName();
      }
    } catch (e) {
      debugPrint("FetchOfficeList Error: $e");
    }
  }

  Future<void> fetchUserList() async {
    var url = ApiEndpoint().users;

    try {
      var response = await dio.get(url);
      debugPrint("Raw User response: ${response.data}");

      if (response.statusCode == 200 && response.data is List) {
        List<User> data =
            (response.data as List).map((e) => User.fromJson(e)).toList();

        setState(() {
          userList = data;
        });

        debugPrint("User list loaded: ${data.length}");
        printUserNameWithUserName();
      }
    } catch (e) {
      debugPrint("FetchUserList Error: $e");
    }
  }

  void printUserNameWithUserName() {
    for (var userOffice in userOfficeList) {
      final userName = userList.firstWhere(
        (user) => user.id == userOffice.userId,
        orElse: () => User(id: 'unknown', fullName: 'Unknown'),
      );

      debugPrint(
        " userId: ${userOffice.userId}, officeId: ${userOffice.officeId}, fullName: ${userName.fullName}",
      );
    }
  }

  void printUserOfficeWithOfficeName() {
    for (var userOffice in userOfficeList) {
      final officeName = officenameList.firstWhere(
        (office) => office.id == userOffice.officeId,
        orElse:
            () => Office(
              id: 0,
              name: 'Unknown',
              isActive: true,
              isDeleted: false,
            ),
      );

      debugPrint(
        "userId: ${userOffice.userId}, officeId: ${userOffice.officeId}, officeName: ${officeName.name}",
      );
    }
  }

  Future<void> addOrUpdateUserOffice(UserOffice userOffice) async {
    final url = ApiEndpoint().useroffice;
    final isUpdating = userOffice.id != 0;

    try {
      final response =
          isUpdating
              ? await dio.put(
                '$url/${userOffice.id}',
                data: userOffice.toJson(),
              )
              : await dio.post(url, data: userOffice.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("${isUpdating ? 'Update' : 'Save'} successful");
        await fetchUserOffice(); // Refresh data
      } else {
        debugPrint("Failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint(" Error: $e");
    }
  }

  Future<void> fetchOffice() async {
    var url = ApiEndpoint().office;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        debugPrint("Error: Access token is missing!");
        return;
      }

      final response = await dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && response.data is List) {
        List<Office> data =
            (response.data as List)
                .map((office) => Office.fromJson(office))
                .toList();

        if (mounted) {
          setState(() {
            officeList = data.map((office) => office.toJson()).toList();
            filteredListOffice = List.from(
              officeList,
            ); // Ensure filtered list is populated

            if (_selectedOfficeId == null && filteredListOffice.isNotEmpty) {
              _selectedOfficeId = filteredListOffice[0]['id'].toString();
            }

            debugPrint("Auto-selected office: $_selectedOfficeId");
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

            // Auto-select first user
            if (filteredListUser.isNotEmpty) {
              _selectedUserId = filteredListUser[0].id;
              debugPrint("Auto-selected user: $_selectedUserId");
            }
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching user: $e");
    }
  }

  Future<void> deleteUserOffice(String kraId) async {
    var url = ApiEndpoint().keyresult;
    try {
      final response = await dio.delete(url);

      if (response.statusCode == 200) {
        await fetchUserOffice();
      }
    } catch (e) {
      debugPrint("Error deleting KRA: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserOffice();
    fetchOfficeList();
    fetchOffice();
    fetchUser();
    printUserOfficeWithOfficeName();
    fetchUserList();
    printUserNameWithUserName();
    if (filteredListOffice.isNotEmpty) {
      _selectedOfficeId = filteredListOffice[0]['id'].toString();
    }
    if (filteredListUser.isNotEmpty) {
      _selectedUserId = filteredListUser[0].id;
    }
    isSearchfocus.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredList =
          userOfficeList
              .where(
                (useroffice) => useroffice.userId.toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList();
    });
  }

  void showFormDialog({
    String? id,
    bool isDeleted = false,
    String? selectedUserId,
    String? selectedOfficeId,
    bool isActive = true,
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
        return AlertDialog(
          backgroundColor: mainBgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(id == null ? 'Add User Office' : 'Edit User Office'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 350,
                child: DropdownButtonFormField<String>(
                  value:
                      filteredListUser.any((user) => user.id == _selectedUserId)
                          ? _selectedUserId
                          : null,
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      filteredListUser.map((user) {
                        return DropdownMenuItem<String>(
                          value: user.id,
                          child: Text(user.fullName),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedUserId = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 350,
                child: DropdownButtonFormField<String>(
                  value: _selectedOfficeId,
                  decoration: InputDecoration(
                    labelText: 'Office',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      filteredListOffice.map((officeData) {
                        return DropdownMenuItem<String>(
                          value: officeData['id'].toString(),
                          child: Text(officeData['name']),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedOfficeId = value;
                    });
                  },
                ),
              ),
            ],
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
                  final isDuplicate = userOfficeList.any(
                    (u) =>
                        u.userId == _selectedUserId &&
                        u.officeId == int.tryParse(_selectedOfficeId ?? '0') &&
                        u.id != int.tryParse(id ?? '0'),
                  ); // make sure it's not the same record

                  if (isDuplicate) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('User already assigned to this office.'),
                      ),
                    );
                    return;
                  }

                  final user = UserOffice(
                    id: int.tryParse(id ?? '0') ?? 0,
                    isDeleted: isDeleted,
                    rowVersion: '',
                    userId: _selectedUserId ?? '',
                    officeId: int.tryParse(_selectedOfficeId ?? '0') ?? 0,
                    isActive: isActive,
                    firstName: firstNameController.text,
                    middleName: middleNameController.text,
                    lastName: lastNameController.text,
                    prefix: prefixController.text,
                    suffix: suffixController.text,
                    position: positionController.text,
                  );

                  await addOrUpdateUserOffice(user);
                  // ignore: use_build_context_synchronously
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
                          child: Text('User ID', style: TextStyle(color: grey)),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Office ID',
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
                                        ),
                                  );
                                  final userName = matchUserName.fullName;

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
                                                    final selectedUser =
                                                        userList.firstWhere(
                                                          (user) =>
                                                              user.id ==
                                                              userOffice.userId,
                                                          orElse:
                                                              () => User(
                                                                id: 'unknown',
                                                                fullName:
                                                                    'Unknown',
                                                              ),
                                                        );
                                                    final selectedOfficeId =
                                                        userOffice.officeId
                                                            .toString();

                                                    debugPrint(
                                                      "Editing User: ${selectedUser.fullName} (ID: ${selectedUser.id})",
                                                    );
                                                    debugPrint(
                                                      " Office ID: $selectedOfficeId",
                                                    );

                                                    showFormDialog(
                                                      id:
                                                          userOffice.id
                                                              .toString(),
                                                      selectedUserId:
                                                          userOffice.userId,
                                                      selectedOfficeId:
                                                          userOffice.officeId
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

                  // Pagination Section
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
                        Container(width: 60), // For alignment
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
                await deleteUserOffice(id);
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
