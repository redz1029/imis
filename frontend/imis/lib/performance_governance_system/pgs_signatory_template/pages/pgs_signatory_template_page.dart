// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/pgs_signatory_template/pgs_signatory_template_service.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../../common_services/common_service.dart';
import '../../../widgets/dotted_button.dart';
import '../models/pgs_signatory_template.dart';

class PgsSignatoryTemplatePage extends StatefulWidget {
  const PgsSignatoryTemplatePage({super.key});

  @override
  PgsSignatoryTemplatePageState createState() =>
      PgsSignatoryTemplatePageState();
}

class PgsSignatoryTemplatePageState extends State<PgsSignatoryTemplatePage> {
  final _formKey = GlobalKey<FormState>();
  final _signatroyTemplateService = PgsSignatoryTemplateService(Dio());
  late FilterSearchResultUtil<PgsSignatoryTemplate> signatoryTemplateUtil;
  final _commonService = CommonService(Dio());
  List<PgsSignatoryTemplate> signatoryTemplateList = [];
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();
  List<PgsSignatoryTemplate> filteredListSignatoryTemplate = [];
  List<Map<String, dynamic>> selectedSignatory = [];
  List<Office> officeList = [];
  List<Map<String, dynamic>> signatoryList = [];
  int? selectOffice;
  String? selectTeamText;
  List<User> userList = [];
  String? selectedUserId;
  TextEditingController signatoryLabelController = TextEditingController();
  TextEditingController signatoryStatusController = TextEditingController();
  final _paginationUtils = PaginationUtil(Dio());
  int _currentPage = 1;
  final int _pageSize = 48;
  int _totalCount = 0;
  bool _isLoading = false;

  final dio = Dio();

  Future<void> fetchSignatoryTemplate({
    int page = 1,
    String? searchQuery,
  }) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _signatroyTemplateService.getSignatoryTemplate(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          signatoryTemplateList = pageList.items;
          filteredListSignatoryTemplate = List.from(signatoryTemplateList);
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
    isSearchfocus.addListener(() {
      setState(() {});
    });

    fetchSignatoryTemplate();
    signatoryTemplateUtil = FilterSearchResultUtil<PgsSignatoryTemplate>(
      paginationUtils: _paginationUtils,
      endpoint: ApiEndpoint().signatoryTemplate,
      pageSize: _pageSize,
      fromJson: (json) => PgsSignatoryTemplate.fromJson(json),
    );
    if (userList.isNotEmpty) {
      selectedUserId = userList[0].id;
    }

    () async {
      final users = await _commonService.fetchUsers();
      final offices = await _commonService.fetchOffices();
      if (!mounted) return;

      setState(() {
        userList = users;
        officeList = offices;
      });
    }();
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    super.dispose();
  }

  void resetFormFields() {
    selectOffice = null;
    selectedUserId = null;
    selectedSignatory = [];
  }

  void showFormDialog({
    String? id,
    bool isDeleted = false,
    String? defaultSignatoryId,
    int? officeId,
    List<Map<String, dynamic>>? signatories,
  }) {
    selectOffice = officeId;
    selectedUserId = defaultSignatoryId;

    if (signatories != null && signatories.isNotEmpty) {
      selectedSignatory =
          signatories.map((s) {
            return {
              'id': s['id'],
              'userId': s['defaultSignatoryId']?.toString(),
              'name': s['signatoryName'],
              'label': s['signatoryLabel'],
              'status': s['status'] ?? '',
              'level': s['orderLevel'] ?? 1,
            };
          }).toList();
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
                      ? 'Create Signatory Template'
                      : 'Edit Signatory Template',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              content: SizedBox(
                child: SizedBox(
                  width: 400,
                  height: 500,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Stack(
                            children: [
                              DropdownSearch<Office?>(
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      hintText: 'Search offices...',
                                      fillColor: mainBgColor,
                                      filled: true,
                                      prefixIcon: Icon(Icons.search),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  itemBuilder:
                                      (context, office, isSelected) => ListTile(
                                        tileColor: mainBgColor,
                                        title: Text(office?.name ?? ''),
                                      ),
                                ),
                                items: officeList,
                                itemAsString: (office) => office?.name ?? '',
                                selectedItem: officeList.firstWhere(
                                  (office) => office.id == selectOffice,
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
                                onChanged:
                                    (value) => setState(
                                      () => selectOffice = value?.id,
                                    ),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select an office';
                                  }
                                  return null;
                                },
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: 'Select Office',
                                    fillColor: mainBgColor,
                                    filled: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        gap32px,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("List of Signatories"),
                        ),

                        if (selectedSignatory.isNotEmpty)
                          Column(
                            children: [
                              gap16px,
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: selectedSignatory.length,
                                separatorBuilder:
                                    (context, index) => SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final signatory = selectedSignatory[index];
                                  return ListTile(
                                    title: Text(
                                      "${signatory['label']} : ",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    subtitle: Text(
                                      signatory['name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: const Color.fromARGB(
                                              255,
                                              109,
                                              109,
                                              109,
                                            ),
                                          ),

                                          onPressed: () {
                                            showSignatoryDialog(
                                              context: context,
                                              setDialogState: setDialogState,
                                              index: index,
                                              signatory: signatory,
                                            );
                                          },
                                        ),
                                        // Delete Button
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: const Color.fromARGB(
                                              255,
                                              109,
                                              109,
                                              109,
                                            ),
                                          ),
                                          onPressed: () {
                                            setDialogState(() {
                                              selectedSignatory.removeAt(index);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        gap16px,
                        Align(
                          alignment: Alignment.center,
                          child: DottedButton(
                            prefixIcon: Icon(Icons.add),
                            text: "Add signatory",
                            onPressed: () {
                              showSignatoryDialog(
                                context: context,
                                setDialogState: setDialogState,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
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
                    if (selectOffice == null) {
                      MotionToast.error(
                        title: Text("Error Saving"),
                        description: Text(
                          "Please fill out all required fields",
                        ),
                        toastAlignment: Alignment.center,
                      ).show(context);
                      return;
                    }
                    if (selectOffice != null && id == null) {
                      final officeExists = signatoryTemplateList.any(
                        (item) => item.officeId == selectOffice,
                      );

                      if (officeExists) {
                        MotionToast.warning(
                          title: Text("Warning"),
                          description: Text(
                            "The selected office already has a record.",
                          ),
                          toastAlignment: Alignment.center,
                        ).show(context);
                        return;
                      }
                    }
                    List<int> levels =
                        selectedSignatory
                            .map((e) => e['level'] as int)
                            .toList();
                    Set<int> uniqueLevels = <int>{};

                    for (var level in levels) {
                      if (!uniqueLevels.add(level)) {
                        MotionToast.error(
                          title: Text("Error Saving"),
                          description: Text(
                            "Check Order Level. There are duplicates.",
                          ),
                          toastAlignment: Alignment.center,
                        ).show(context);
                        return;
                      }
                    }

                    // Confirmation dialog
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
                      List<PgsSignatoryTemplate> signatories = [];

                      if (selectedSignatory.isNotEmpty) {
                        for (var signatory in selectedSignatory) {
                          signatories.add(
                            PgsSignatoryTemplate(
                              signatory['id'] ?? 0,
                              isDeleted,
                              signatory['level'],
                              signatory['userId'],
                              true,
                              status: signatory['status'] ?? '',
                              signatoryLabel: signatory['label'] ?? '',
                              officeId: selectOffice ?? 0,
                            ),
                          );
                        }
                      }

                      await addOrUpdateSignatory(signatories);
                      if (context.mounted) {
                        Navigator.pop(context);
                        resetFormFields();
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

  Future<void> addOrUpdateSignatory(
    List<PgsSignatoryTemplate> signatories,
  ) async {
    var url = ApiEndpoint().signatoryTemplate;
    try {
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: signatories.map((s) => s.toJson()).toList(),
      );

      if (response.statusCode == 200) {
        await fetchSignatoryTemplate();
        setState(() {
          fetchSignatoryTemplate();
        });
      }
    } catch (e) {
      debugPrint("Error adding/updating pgs: $e");
    }
  }

  void showSignatoryDialog({
    required BuildContext context,
    required Function setDialogState,
    int? index,
    Map<String, dynamic>? signatory,
    String? defaultSignatoryId,
  }) {
    final signatoryLabelController = TextEditingController(
      text: signatory?['label'] ?? '',
    );
    final signatoryStatusController = TextEditingController(
      text: signatory?['status'] ?? '',
    );

    int? currentId = signatory?['id'];
    int currentLevel = signatory?['level'] ?? 1;
    String? selectedUserId = signatory?['userId'] ?? defaultSignatoryId;

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
              title: Text(
                index != null ? 'Edit Signatory' : 'Enter Signatory Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 500,
                      child: DropdownSearch<User?>(
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              labelText: 'Signatory Name',
                              hintText: 'Search user name…',
                              filled: true,
                              fillColor: mainBgColor,
                              floatingLabelStyle: TextStyle(
                                color: primaryColor, // focused color
                                fontWeight: FontWeight.w600,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                              prefixIcon: const Icon(Icons.search),
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
                          (u) => u?.id == selectedUserId,
                          orElse: () => null,
                        ),
                        onChanged:
                            (value) =>
                                setState(() => selectedUserId = value?.id),
                        validator:
                            (value) =>
                                value == null ? 'Please select a user' : null,

                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: 'Select User',
                            filled: true,
                            fillColor: mainBgColor,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            floatingLabelStyle: TextStyle(color: primaryColor),
                            labelStyle: TextStyle(color: Colors.grey.shade600),
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

                    SizedBox(height: 16),
                    // Signatory Label
                    TextFormField(
                      controller: signatoryLabelController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter some text";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Signatory Label',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                        ),

                        floatingLabelStyle: const TextStyle(
                          color: primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        // Signatory Status
                        Expanded(
                          child: TextFormField(
                            controller: signatoryStatusController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter some text";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Signatory Status',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                              floatingLabelStyle: const TextStyle(
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),

                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 120,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (currentLevel > 1) currentLevel--;
                                      });
                                    },
                                  ),
                                  Text(
                                    '$currentLevel',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        currentLevel++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),

                            Positioned(
                              left: 8,
                              top: -10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                color: mainBgColor,

                                child: const Text(
                                  'Order level',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
                      final selectedUser = userList.firstWhere(
                        (user) => user.id == selectedUserId,
                        orElse: () => throw Exception('User not found'),
                      );

                      final result = {
                        'id': currentId,
                        'userId': selectedUserId,
                        'name': selectedUser.fullName,
                        'label': signatoryLabelController.text,
                        'status': signatoryStatusController.text,
                        'level': currentLevel,
                      };

                      if (index != null) {
                        setDialogState(() {
                          selectedSignatory[index] = result;
                        });
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context, result);
                      }
                    }
                  },
                  child: Text(
                    index != null ? 'Save Changes' : 'Create',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((value) {
      if (value != null && index == null) {
        setDialogState(() {
          selectedSignatory.add(value);
        });
      }
    });
  }

  Map<String, List<Map<String, dynamic>>> groupByOfficeName(
    List<PgsSignatoryTemplate> list,
    List<Office> offices,
    List<User> users,
  ) {
    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var item in list) {
      int? officeId = item.officeId;
      if (officeId == null) continue;

      var office = offices.firstWhere(
        (o) => o.id == officeId,
        orElse:
            () => Office(
              id: -1,
              name: 'Unknown Office',
              officeTypeId: -1,
              isActive: false,
            ),
      );

      String? signatoryId = item.defaultSignatoryId.toString();
      var user = users.firstWhere(
        (u) => u.id == signatoryId,
        orElse: () => User(id: '', fullName: 'Unknown User', position: ''),
      );

      var itemWithName = item.toJson();
      itemWithName['signatoryName'] = user.fullName;

      if (!grouped.containsKey(office.name)) {
        grouped[office.name] = [];
      }

      grouped[office.name]!.add(itemWithName);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;

    final groupedData = groupByOfficeName(
      filteredListSignatoryTemplate,
      officeList,
      userList,
    );

    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: Text('Signatory Template Information'),
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
                      labelText: 'Search Signatory',
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

                if (!isMinimized)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      resetFormFields();
                      showFormDialog();
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
            gap16px,
            Expanded(
              child: ListView(
                children:
                    groupedData.entries.map((entry) {
                      final officeName = entry.key;
                      final signatories = entry.value;
                      final officeId =
                          signatories.isNotEmpty
                              ? signatories.first['officeId']
                              : null;

                      return Card(
                        color: secondaryColor,
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            collapsedBackgroundColor: secondaryColor,
                            backgroundColor: secondaryBgButton,
                            tilePadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            childrenPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            title: Text(officeName),
                            trailing: const Icon(
                              Icons.expand_more,
                              color: Colors.black,
                            ),
                            children: [
                              ...signatories.map((signatory) {
                                return ListTile(
                                  title: Text(
                                    "${signatory['signatoryLabel'] ?? 'No Label'}:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        signatory['signatoryName'] ?? 'No Name',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: 8,
                                ),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          if (officeId != null) {
                                            final officeSignatories =
                                                signatories;
                                            final templateId =
                                                signatories.first['id']
                                                    ?.toString();
                                            showFormDialog(
                                              id: templateId,
                                              officeId: officeId,
                                              signatories: officeSignatories,
                                            );
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: primaryColor,
                                        ),
                                        onPressed: () {
                                          final templateId =
                                              signatories.first['id']
                                                  ?.toString();
                                          if (templateId != null) {
                                            showDeleteDialog(templateId);
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
                    }).toList(),
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
                    onPageChanged: (page) => fetchSignatoryTemplate(page: page),
                  ),
                  Container(width: 60),
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
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete this Signatory Template? This action cannot be undone.",
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
                  await _signatroyTemplateService.deleteSignatory(id);
                  await fetchSignatoryTemplate();
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text(
                      'Signatory template deleted successfully',
                    ),
                  ).show(context);
                } catch (e) {
                  MotionToast.error(description: Text('Failed to Delete Team'));
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
