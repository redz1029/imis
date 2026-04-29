import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/pgs_signatory_template/pgs_signatory_template_service.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../../common_services/common_service.dart';
import '../models/pgs_signatory_template.dart';

class PgsSignatoryTemplatePage extends StatefulWidget {
  const PgsSignatoryTemplatePage({super.key});
  @override
  PgsSignatoryTemplatePageState createState() =>
      PgsSignatoryTemplatePageState();
}

class PgsSignatoryTemplatePageState extends State<PgsSignatoryTemplatePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _signatoryService = PgsSignatoryTemplateService(Dio());
  final _commonService = CommonService(Dio());
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  final _dio = Dio();

  late AnimationController _fadeCtrl;

  List<PgsSignatoryTemplate> _templateList = [];
  List<PgsSignatoryTemplate> _filteredTemplateList = [];
  List<Map<String, dynamic>> _selectedSignatories = [];
  List<Office> _officeList = [];
  List<User> _userList = [];

  int? _selectOffice;
  int _currentPage = 1;
  final int _pageSize = 48;
  int _totalCount = 0;
  bool _isLoading = false;

  // ── Lifecycle ──────────────────────────────────────────────────────────────
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

  // ── Data ───────────────────────────────────────────────────────────────────
  Future<void> _fetchTemplates({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final result = await _signatoryService.getSignatoryTemplate(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );
      if (mounted) {
        setState(() {
          _currentPage = result.page;
          _totalCount = result.totalCount;
          _templateList = result.items;
          _filteredTemplateList = List.from(_templateList);
        });
        _fadeCtrl.forward(from: 0);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _resetForm() {
    _selectOffice = null;
    _selectedSignatories = [];
  }

  Map<String, List<Map<String, dynamic>>> _groupByOffice(
    List<PgsSignatoryTemplate> list,
    List<Office> offices,
    List<User> users,
  ) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final item in list) {
      if (item.officeId == null) continue;
      final office = offices.firstWhere(
        (o) => o.id == item.officeId,
        orElse:
            () => Office(
              id: -1,
              name: 'Unknown Office',
              officeTypeId: -1,
              isActive: false,
            ),
      );
      final user = users.firstWhere(
        (u) => u.id == item.defaultSignatoryId.toString(),
        orElse: () => User(id: '', fullName: 'Unknown User', position: ''),
      );
      final entry = item.toJson()..['signatoryName'] = user.fullName;
      grouped.putIfAbsent(office.name, () => []).add(entry);
    }
    return grouped;
  }

  // ── Styling helpers ────────────────────────────────────────────────────────
  InputDecoration _field(String label, {Widget? prefix}) => InputDecoration(
    labelText: label,
    prefixIcon: prefix,
    filled: true,
    fillColor: kBackground,
    labelStyle: GoogleFonts.plusJakartaSans(
      color: kMuted,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    floatingLabelStyle: GoogleFonts.plusJakartaSans(
      color: primaryColor,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: kBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: kBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: primaryColor, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: kDanger),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  );

  DropDownDecoratorProps _ddProps(String label) =>
      DropDownDecoratorProps(dropdownSearchDecoration: _field(label));

  PopupProps<T> _popupProps<T>(
    String hint,
    Widget Function(BuildContext, T, bool) builder,
  ) => PopupProps.menu(
    showSearchBox: true,
    searchFieldProps: TextFieldProps(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.plusJakartaSans(color: kMuted, fontSize: 13),
        fillColor: kSurface,
        filled: true,
        prefixIcon: const Icon(Icons.search_rounded, size: 18, color: kMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: kBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    ),
    itemBuilder: builder,
    menuProps: MenuProps(
      borderRadius: BorderRadius.circular(12),
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.12),
    ),
  );

  Widget _sectionLabel(String label, IconData icon) => Row(
    children: [
      Icon(icon, size: 14, color: primaryColor),
      const SizedBox(width: 6),
      Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: kMuted,
          letterSpacing: 0.5,
        ),
      ),
    ],
  );

  // ── Toast helpers ──────────────────────────────────────────────────────────
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

  // ── Confirm dialog ─────────────────────────────────────────────────────────
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

  // ── Add/update API call ───────────────────────────────────────────────────
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

  // ── Signatory sub-dialog ──────────────────────────────────────────────────
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
                                popupProps: _popupProps<User?>(
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
                                dropdownDecoratorProps: _ddProps(
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
                                decoration: _field('Signatory Label'),
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
                                      decoration: _field('Signatory Status'),
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
                                            _StepBtn(
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
                                            _StepBtn(
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
                      _DialogFooter(
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
  }

  // ── Main form dialog ───────────────────────────────────────────────────────
  void showFormDialog({
    String? id,
    bool isDeleted = false,
    int? officeId,
    List<Map<String, dynamic>>? signatories,
  }) {
    _selectOffice = officeId;
    if (signatories != null && signatories.isNotEmpty) {
      _selectedSignatories =
          signatories
              .map(
                (s) => {
                  'id': s['id'],
                  'userId': s['defaultSignatoryId']?.toString(),
                  'name': s['signatoryName'],
                  'label': s['signatoryLabel'],
                  'status': s['status'] ?? '',
                  'level': s['orderLevel'] ?? 1,
                },
              )
              .toList();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => StatefulBuilder(
            builder: (ctx, setDialog) {
              return Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Container(
                  width: 480,
                  constraints: const BoxConstraints(maxHeight: 700),
                  decoration: BoxDecoration(
                    color: kSurface,
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
                        padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.assignment_ind_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    id == null
                                        ? 'Create Signatory Template'
                                        : 'Edit Signatory Template',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    id == null
                                        ? 'Add a new template for an office'
                                        : 'Update the existing configuration',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: Colors.white.withValues(
                                        alpha: 0.75,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(ctx),
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                              ),
                              tooltip: 'Close',
                            ),
                          ],
                        ),
                      ),

                      // Body
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionLabel('Office', Icons.business_rounded),
                              const SizedBox(height: 8),
                              DropdownSearch<Office?>(
                                popupProps: _popupProps<Office?>(
                                  'Search offices…',
                                  (ctx, office, _) => ListTile(
                                    dense: true,
                                    leading: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: kPrimaryLight,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.business_rounded,
                                        size: 16,
                                        color: primaryColor,
                                      ),
                                    ),
                                    title: Text(
                                      office?.name ?? '',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
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
                                dropdownDecoratorProps: _ddProps(
                                  'Select Office',
                                ),
                              ),

                              const SizedBox(height: 28),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _sectionLabel(
                                    'Signatories',
                                    Icons.people_alt_rounded,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: kPrimaryLight,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${_selectedSignatories.length} added',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              if (_selectedSignatories.isEmpty)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 28,
                                  ),
                                  decoration: BoxDecoration(
                                    color: kBackground,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: kBorder),
                                  ),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.group_add_rounded,
                                        size: 32,
                                        color: kMuted,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'No signatories added yet',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: kMuted,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _selectedSignatories.length,
                                  separatorBuilder:
                                      (_, __) => const SizedBox(height: 8),
                                  itemBuilder: (ctx, i) {
                                    final sig = _selectedSignatories[i];
                                    return _SignatoryCard(
                                      signatory: sig,
                                      onEdit:
                                          () => _showSignatoryDialog(
                                            context: ctx,
                                            setOuter: setDialog,
                                            index: i,
                                            existing: sig,
                                          ),
                                      onDelete:
                                          () => setDialog(
                                            () => _selectedSignatories.removeAt(
                                              i,
                                            ),
                                          ),
                                    );
                                  },
                                ),

                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed:
                                      () => _showSignatoryDialog(
                                        context: ctx,
                                        setOuter: setDialog,
                                      ),
                                  icon: const Icon(
                                    Icons.add_rounded,
                                    size: 18,
                                    color: primaryColor,
                                  ),
                                  label: Text(
                                    'Add Signatory',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      color: primaryColor,
                                      width: 1.5,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 13,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Footer
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                        decoration: BoxDecoration(
                          color: kBackground,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                          border: const Border(top: BorderSide(color: kBorder)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () => Navigator.pop(ctx),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: kBorder),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.plusJakartaSans(
                                  color: kMuted,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: () async {
                                if (_selectOffice == null) {
                                  _toastError(ctx, 'Please select an office.');
                                  return;
                                }
                                if (id == null &&
                                    _templateList.any(
                                      (t) => t.officeId == _selectOffice,
                                    )) {
                                  _toastWarning(
                                    ctx,
                                    'This office already has a template.',
                                  );
                                  return;
                                }
                                final levels =
                                    _selectedSignatories
                                        .map((e) => e['level'] as int)
                                        .toList();
                                final unique = <int>{};
                                for (final l in levels) {
                                  if (!unique.add(l)) {
                                    _toastError(
                                      ctx,
                                      'Duplicate order levels found.',
                                    );
                                    return;
                                  }
                                }
                                final ok = await _confirm(
                                  ctx,
                                  title:
                                      id == null
                                          ? 'Confirm Save'
                                          : 'Confirm Update',
                                  body:
                                      id == null
                                          ? 'Save this template?'
                                          : 'Update this template?',
                                  confirmLabel: id == null ? 'Save' : 'Update',
                                );
                                if (ok == true) {
                                  final items =
                                      _selectedSignatories
                                          .map(
                                            (s) => PgsSignatoryTemplate(
                                              s['id'] ?? 0,
                                              isDeleted,
                                              s['level'],
                                              s['userId'],
                                              true,
                                              status: s['status'] ?? '',
                                              signatoryLabel: s['label'] ?? '',
                                              officeId: _selectOffice ?? 0,
                                            ),
                                          )
                                          .toList();
                                  await _addOrUpdate(items);
                                  if (ctx.mounted) {
                                    Navigator.pop(ctx);
                                    _resetForm();
                                  }
                                }
                              },
                              icon: Icon(
                                id == null
                                    ? Icons.save_rounded
                                    : Icons.update_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                              label: Text(
                                id == null
                                    ? 'Save Template'
                                    : 'Update Template',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }

  // ── Delete dialog ──────────────────────────────────────────────────────────
  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => _DeleteDialog(
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
                    description: Text(
                      'Failed to delete template',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  ).show(context);
                }
              }
            },
          ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
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
                        ? _skeleton()
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
          'Signatory Template',
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

  Widget _buildToolbar(bool isNarrow, int officeCount) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: kSurface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: kBorder),
    ),
    child: Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 38,
            child: TextField(
              focusNode: _searchFocus,
              controller: _searchController,
              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: kText),
              decoration: InputDecoration(
                hintText: 'Search by office or signatory…',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: kMuted,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 18,
                  color: _searchFocus.hasFocus ? primaryColor : kMuted,
                ),
                filled: true,
                fillColor: kBackground,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: primaryColor, width: 1.5),
                ),
              ),
            ),
          ),
        ),
        if (!isNarrow) ...[
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: kPrimaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.folder_special_rounded,
                  size: 14,
                  color: primaryColor,
                ),
                const SizedBox(width: 6),
                Text(
                  '$officeCount Services',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {
              _resetForm();
              showFormDialog();
            },
            icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
            label: Text(
              'Add Template',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ],
    ),
  );

  Widget _buildPagination() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: kSurface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: kBorder),
    ),
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
          onPageChanged: (p) => _fetchTemplates(page: p),
        ),
        const SizedBox(width: 60),
      ],
    ),
  );

  Widget _list(Map<String, List<Map<String, dynamic>>> grouped) =>
      ListView.separated(
        itemCount: grouped.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (ctx, i) {
          final entry = grouped.entries.elementAt(i);
          final office = entry.key;
          final sigs = entry.value;
          final officeId = sigs.isNotEmpty ? sigs.first['officeId'] : null;
          return _OfficeCard(
            officeName: office,
            signatories: sigs,
            onEdit: () {
              if (officeId != null) {
                showFormDialog(
                  id: sigs.first['id']?.toString(),
                  officeId: officeId,
                  signatories: sigs,
                );
              }
            },
            onDelete: () {
              final tid = sigs.first['id']?.toString();
              if (tid != null) showDeleteDialog(tid);
            },
          );
        },
      );

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

  Widget _skeleton() => ListView.separated(
    itemCount: 5,
    separatorBuilder: (_, __) => const SizedBox(height: 8),
    itemBuilder:
        (_, __) => Container(
          height: 68,
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kBorder),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: kBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 180,
                    height: 13,
                    decoration: BoxDecoration(
                      color: kBackground,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 10,
                    decoration: BoxDecoration(
                      color: kBackground,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
  );
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

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
              _IconBtn(
                icon: Icons.edit_rounded,
                tooltip: 'Edit',
                color: primaryTextColor,

                onTap: onEdit,
              ),
              const SizedBox(width: 6),
              _IconBtn(
                icon: CupertinoIcons.delete_simple,
                tooltip: 'Delete',
                color: kDanger,

                onTap: onDelete,
              ),
              const SizedBox(width: 4),
              const Icon(Icons.expand_more_rounded, color: kMuted, size: 20),
            ],
          ),
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              decoration: BoxDecoration(
                color: kBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kBorder),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: signatories.length,
                separatorBuilder:
                    (_, __) => const Divider(height: 1, color: kBorder),
                itemBuilder: (ctx, i) {
                  final s = signatories[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: kPrimaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${s['orderLevel'] ?? (i + 1)}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s['signatoryLabel'] ?? 'No Label',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                              Text(
                                s['signatoryName'] ?? 'No Name',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: kText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if ((s['status'] as String?)?.isNotEmpty == true)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: kSuccessLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              s['status'],
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: kSuccess,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignatoryCard extends StatelessWidget {
  final Map<String, dynamic> signatory;
  final VoidCallback onEdit, onDelete;
  const _SignatoryCard({
    required this.signatory,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: kBackground,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: kBorder),
    ),
    child: Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: kPrimaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '${signatory['level'] ?? 1}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: primaryColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                signatory['label'] ?? '',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: kMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                signatory['name'] ?? '',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: kText,
                ),
              ),
            ],
          ),
        ),
        _IconBtn(
          icon: Icons.edit_rounded,
          tooltip: 'Edit',
          color: primaryTextColor,

          onTap: onEdit,
          size: 15,
        ),
        const SizedBox(width: 6),
        _IconBtn(
          icon: CupertinoIcons.delete_simple,
          tooltip: 'Remove',
          color: kDanger,

          onTap: onDelete,
          size: 15,
        ),
      ],
    ),
  );
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;
  final double size;
  const _IconBtn({
    required this.icon,
    required this.tooltip,
    required this.color,

    required this.onTap,
    this.size = 15,
  });

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Icon(icon, size: size, color: color),
    ),
  );
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: SizedBox(
      width: 36,
      height: 46,
      child: Icon(icon, size: 18, color: primaryColor),
    ),
  );
}

class _DialogFooter extends StatelessWidget {
  final VoidCallback onCancel, onConfirm;
  final String confirmLabel;
  final IconData confirmIcon;
  const _DialogFooter({
    required this.onCancel,
    required this.onConfirm,
    required this.confirmLabel,
    required this.confirmIcon,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
    decoration: const BoxDecoration(
      color: kBackground,
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      border: Border(top: BorderSide(color: kBorder)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: onCancel,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: kBorder),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Cancel',
            style: GoogleFonts.plusJakartaSans(
              color: kMuted,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: onConfirm,
          icon: Icon(confirmIcon, size: 16, color: Colors.white),
          label: Text(
            confirmLabel,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    ),
  );
}

class _ConfirmDialog extends StatelessWidget {
  final String title, body, confirmLabel;
  final bool danger;
  const _ConfirmDialog({
    required this.title,
    required this.body,
    required this.confirmLabel,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.transparent,
    child: Container(
      width: 380,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: danger ? kDangerLight : kPrimaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              danger
                  ? Icons.delete_outline_rounded
                  : Icons.help_outline_rounded,
              color: danger ? kDanger : primaryColor,
              size: 26,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: kText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: kMuted,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kBorder),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: danger ? kDanger : primaryColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    confirmLabel,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _DeleteDialog extends StatelessWidget {
  final VoidCallback onDelete;
  const _DeleteDialog({required this.onDelete});

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.transparent,
    child: Container(
      width: 380,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: kDangerLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: kDanger,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Delete Template',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: kText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Are you sure you want to delete this signatory template? This action cannot be undone.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: kMuted,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kBorder),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Delete',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kDanger,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
