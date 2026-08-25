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
<<<<<<< HEAD
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/widgets/pagination_controls.dart';
=======
import 'package:imis/widgets/common/icon_button_widget.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/common/section_label_widget.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
>>>>>>> master
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

<<<<<<< HEAD
  final dio = Dio();

  Future<void> fetchSignatoryTemplate({
    int page = 1,
    String? searchQuery,
  }) async {
=======
  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();

    _searchFocus.addListener(() => setState(() {}));
    _fetchTemplates();

    () async {
      final users = await _commonService.fetchUsers();
      final offices = await _commonService.fetchAlloffices();
      if (!mounted) return;
      setState(() {
        _userList = users;
        _officeList = offices;
      });
    }();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _searchFocus.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchTemplates({int page = 1, String? searchQuery}) async {
>>>>>>> master
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
<<<<<<< HEAD

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
=======
    return grouped;
  }

  void _toastError(BuildContext ctx, String msg) => MotionToast.error(
    title: Text(
      'Error',
      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
    ),
    description: Text(msg, style: GoogleFonts.plusJakartaSans(fontSize: 12)),
    toastAlignment: Alignment.center,
  ).show(ctx);

  void _toastWarning(BuildContext ctx, String msg) => MotionToast.warning(
    title: Text(
      'Warning',
      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
    ),
    description: Text(msg, style: GoogleFonts.plusJakartaSans(fontSize: 12)),
    toastAlignment: Alignment.center,
  ).show(ctx);

  Future<bool?> _confirm(
    BuildContext ctx, {
    required String title,
    required String body,
    required String confirmLabel,
    bool danger = false,
  }) => showDialog<bool>(
    context: ctx,
    builder:
        (_) => _ConfirmDialog(
          title: title,
          body: body,
          confirmLabel: confirmLabel,
          danger: danger,
        ),
  );

  Future<void> _addOrUpdate(List<PgsSignatoryTemplate> items) async {
    try {
      final res = await AuthenticatedRequest.post(
        _dio,
        ApiEndpoint().signatoryTemplate,
        data: items.map((s) => s.toJson()).toList(),
      );
      if (res.statusCode == 200) await _fetchTemplates();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _showSignatoryDialog({
    required BuildContext context,
    required Function setOuter,
    int? index,
    Map<String, dynamic>? existing,
  }) {
    final labelCtrl = TextEditingController(text: existing?['label'] ?? '');
    final statusCtrl = TextEditingController(text: existing?['status'] ?? '');
    int? currentId = existing?['id'];
    int level = existing?['level'] ?? 1;
    String? uid = existing?['userId'];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => StatefulBuilder(
            builder: (ctx, setInner) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: Container(
                  width: 520,
                  decoration: BoxDecoration(
                    color: kBackground,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 40,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 18, 20, 18),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor, primaryColor],
                          ),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.person_add_alt_1_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              index != null
                                  ? 'Edit Signatory'
                                  : 'Add Signatory',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => Navigator.pop(ctx),
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Body
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              DropdownSearch<User?>(
                                popupProps: popupProps<User?>(
                                  'Search user…',
                                  (ctx, user, _) => ListTile(
                                    dense: true,
                                    leading: CircleAvatar(
                                      radius: 14,
                                      backgroundColor: kPrimaryLight,
                                      child: Text(
                                        (user?.fullName ?? 'U')
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        style: GoogleFonts.plusJakartaSans(
                                          color: primaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      user?.fullName ?? '',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                      ),
                                    ),
                                    subtitle:
                                        user?.position != null
                                            ? Text(
                                              user!.position!,
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                    fontSize: 11,
                                                    color: kLabel,
                                                  ),
                                            )
                                            : null,
                                  ),
                                ),
                                items: _userList,
                                itemAsString: (u) => u?.fullName ?? '',
                                selectedItem: _userList
                                    .cast<User?>()
                                    .firstWhere(
                                      (u) => u?.id == uid,
                                      orElse: () => null,
                                    ),
                                onChanged:
                                    (val) => setInner(() => uid = val?.id),
                                validator:
                                    (val) =>
                                        val == null
                                            ? 'Please select a user'
                                            : null,
                                dropdownDecoratorProps: ddProps(
                                  'Select Signatory User',
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: labelCtrl,
                                validator:
                                    (v) =>
                                        (v == null || v.isEmpty)
                                            ? 'Please enter a label'
                                            : null,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                ),
                                decoration: field('Signatory Label'),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: statusCtrl,
                                      validator:
                                          (v) =>
                                              (v == null || v.isEmpty)
                                                  ? 'Please enter a status'
                                                  : null,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                      ),
                                      decoration: field('Signatory Status'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 6,
                                          left: 2,
                                        ),
                                        child: Text(
                                          'Order Level',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: kLabel,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: kBackground,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(color: kBorder),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            StepBtn(
                                              icon: Icons.remove_rounded,
                                              onTap:
                                                  () => setInner(() {
                                                    if (level > 1) level--;
                                                  }),
                                            ),
                                            SizedBox(
                                              width: 40,
                                              child: Center(
                                                child: Text(
                                                  '$level',
                                                  style:
                                                      GoogleFonts.plusJakartaSans(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 15,
                                                        color: kText,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            StepBtn(
                                              icon: Icons.add_rounded,
                                              onTap:
                                                  () => setInner(() => level++),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Footer
                      DialogFooter(
                        onCancel: () => Navigator.pop(ctx),
                        onConfirm: () {
                          if (_formKey.currentState!.validate()) {
                            final user = _userList.firstWhere(
                              (u) => u.id == uid,
                              orElse: () => throw Exception('User not found'),
                            );
                            final result = {
                              'id': currentId,
                              'userId': uid,
                              'name': user.fullName,
                              'label': labelCtrl.text,
                              'status': statusCtrl.text,
                              'level': level,
                            };
                            if (index != null) {
                              setOuter(
                                () => _selectedSignatories[index] = result,
                              );
                              Navigator.pop(ctx);
                            } else {
                              Navigator.pop(ctx, result);
                            }
                          }
                        },
                        confirmLabel:
                            index != null ? 'Save Changes' : 'Add Signatory',
                        confirmIcon:
                            index != null
                                ? Icons.save_rounded
                                : Icons.add_rounded,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    ).then((value) {
      if (value != null && index == null) {
        setOuter(() => _selectedSignatories.add(value));
      }
    });
>>>>>>> master
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
<<<<<<< HEAD
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
=======
      builder:
          (context) => StatefulBuilder(
            builder: (ctx, setDialog) {
              return Dialog(
                backgroundColor: Colors.transparent,

                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 520,
                    maxHeight: MediaQuery.of(ctx).size.height * 0.92,
                  ),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),

                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.assignment_ind_rounded,
                                color: primaryColor,
                                size: 22,
                              ),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  id == null
                                      ? 'Create Signatory Template'
                                      : 'Edit Signatory Template',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: kText,
                                  ),
                                ),
                                Text(
                                  id == null
                                      ? 'Add a new template for an office'
                                      : 'Update the existing configuration',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: kMuted,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () => Navigator.pop(ctx),
                              icon: const Icon(
                                Icons.close_rounded,
                                color: kMuted,
                              ),
                              tooltip: 'Close',
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              sectionLabel('Office', Icons.business_rounded),
                              const SizedBox(height: 8),
                              DropdownSearch<Office?>(
                                popupProps: popupProps<Office?>(
                                  'Search offices…',
                                  (ctx, office, _) => ListTile(
                                    dense: true,
                                    leading: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: kPrimaryLight,
>>>>>>> master
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
<<<<<<< HEAD
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
=======
                                items: _officeList,
                                itemAsString: (o) => o?.name ?? '',
                                selectedItem: _officeList
                                    .cast<Office?>()
                                    .firstWhere(
                                      (o) => o?.id == _selectOffice,
                                      orElse: () => null,
                                    ),
                                onChanged:
                                    (val) =>
                                        setState(() => _selectOffice = val?.id),
                                validator:
                                    (val) =>
                                        val == null
                                            ? 'Please select an office'
                                            : null,
                                dropdownDecoratorProps: ddProps(
                                  'Select Office',
                                ),
                              ),

                              const SizedBox(height: 28),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  sectionLabel(
                                    'Signatories',
                                    Icons.people_alt_rounded,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
>>>>>>> master
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
<<<<<<< HEAD
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
=======
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                        decoration: BoxDecoration(
                          color: kBackground,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20),
>>>>>>> master
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

<<<<<<< HEAD
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
=======
  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'Delete Template',
            itemName: 'signatory',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _signatoryService.deleteSignatory(id);
                await _fetchTemplates();
                if (mounted) {
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text(
                      'Template deleted successfully',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  ).show(context);
                }
              } catch (_) {
                if (mounted) {
                  MotionToast.error(
                    toastAlignment: Alignment.topCenter,
                    description: Text(
                      'Failed to delete template',
                      style: GoogleFonts.plusJakartaSans(),
>>>>>>> master
                    ),
                  ),

<<<<<<< HEAD
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
=======
  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 600;
    final grouped = _groupByOffice(
      _filteredTemplateList,
      _officeList,
      _userList,
    );

    return Scaffold(
      backgroundColor: kBackground,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeCtrl,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildToolbar(isNarrow, grouped.length),
              const SizedBox(height: 16),
              Expanded(
                child:
                    _isLoading
                        ? skeleton()
                        : grouped.isEmpty
                        ? _empty()
                        : _list(grouped),
              ),
              const SizedBox(height: 12),
              _buildPagination(),
            ],
          ),
        ),
      ),
      floatingActionButton:
          isNarrow
              ? FloatingActionButton.extended(
                backgroundColor: primaryColor,
                onPressed: () {
                  _resetForm();
                  showFormDialog();
                },
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: Text(
                  'Add',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
              : null,
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
    elevation: 0,
    backgroundColor: kSurface,
    surfaceTintColor: Colors.transparent,
    titleSpacing: 0,
    leading: Padding(padding: const EdgeInsets.all(4)),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'PGS Signatory Template',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: kText,
          ),
        ),
      ],
    ),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(height: 1, color: kBorder),
    ),
  );
>>>>>>> master

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

<<<<<<< HEAD
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
=======
  Widget _empty() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: kPrimaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.assignment_late_rounded,
            size: 40,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'No Templates Found',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: kText,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Create a signatory template to get started.',
          style: GoogleFonts.plusJakartaSans(fontSize: 13, color: kMuted),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            _resetForm();
            showFormDialog();
          },
          icon: const Icon(Icons.add_rounded, size: 16),
          label: Text(
            'Create First Template',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    ),
  );
}

class _OfficeCard extends StatelessWidget {
  final String officeName;
  final List<Map<String, dynamic>> signatories;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _OfficeCard({
    required this.officeName,
    required this.signatories,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
        boxShadow: const [
          BoxShadow(color: kCardShadow, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: kPrimaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.business_rounded,
              size: 20,
              color: primaryColor,
            ),
          ),
          title: Text(
            officeName,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: kText,
            ),
          ),
          subtitle: Text(
            '${signatories.length} signator${signatories.length == 1 ? 'y' : 'ies'}',
            style: GoogleFonts.plusJakartaSans(fontSize: 11, color: kMuted),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconBtn(
                icon: Icons.edit_rounded,
                tooltip: 'Edit',
                color: primaryTextColor,

                onTap: onEdit,
              ),
              const SizedBox(width: 6),
              IconBtn(
                icon: CupertinoIcons.delete_simple,
                tooltip: 'Delete',
                color: kDanger,
>>>>>>> master

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
<<<<<<< HEAD
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
=======
              ),
            ],
          ),
        ),
        IconBtn(
          icon: Icons.edit_rounded,
          tooltip: 'Edit',
          color: primaryTextColor,

          onTap: onEdit,
          size: 15,
        ),
        const SizedBox(width: 6),
        IconBtn(
          icon: CupertinoIcons.delete_simple,
          tooltip: 'Remove',
          color: kDanger,
>>>>>>> master

    for (var item in list) {
      int? officeId = item.officeId;
      if (officeId == null) continue;

<<<<<<< HEAD
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
=======
class _ConfirmDialog extends StatelessWidget {
  final String title, body, confirmLabel;
  final bool danger;
  const _ConfirmDialog({
    required this.title,
    required this.body,
    required this.confirmLabel,
    this.danger = false,
  });
>>>>>>> master

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
<<<<<<< HEAD
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
                  MotionToast.error(
                    description: Text('Failed to Delete Signatory template'),
                  );
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
=======
    ),
  );
>>>>>>> master
}
