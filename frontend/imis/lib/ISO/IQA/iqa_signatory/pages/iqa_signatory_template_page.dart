import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/audit/iqa_signatory/model/iqa_signatory_template.dart';
import 'package:imis/audit/iqa_signatory/services/iqa_signatory_template_service.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/user/models/user.dart';
import 'package:imis/widgets/common/icon_button_widget.dart';
import 'package:imis/widgets/common/section_label_widget.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:motion_toast/motion_toast.dart';

// =============================================================================
// SHARED HELPERS
// =============================================================================

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

void _toastSuccess(BuildContext ctx, String msg) => MotionToast.success(
      toastAlignment: Alignment.topCenter,
      description: Text(msg, style: GoogleFonts.plusJakartaSans()),
    ).show(ctx);

InputDecoration _fieldDecoration(String label, {String? hint}) {
  OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: c, width: w),
      );
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: kLabel),
    hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: kMuted),
    filled: true,
    fillColor: kBackground,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    border: border(kBorder),
    enabledBorder: border(kBorder),
    disabledBorder: border(kBorder),
    focusedBorder: border(primaryColor, 1.5),
  );
}

String _initial(String s) => s.trim().isEmpty ? 'U' : s.trim()[0].toUpperCase();

// =============================================================================
// VIEW MODELS
// =============================================================================

/// One card in the list: every template for one (office, audit entity type).
class _TemplateGroup {
  final int officeId;
  final String entityType;
  final String officeName;
  final List<IQASignatoryTemplate> items;

  _TemplateGroup({
    required this.officeId,
    required this.entityType,
    required this.officeName,
    required this.items,
  });

  String get key => '$officeId|$entityType';
}

/// Editable signatory row inside the form dialog.
class _SigDraft {
  final int id;
  final String? rowVersion;
  final String? userId;
  final String label;
  final String status;
  final String? position;
  final int level;
  final bool isActive;

  const _SigDraft({
    required this.id,
    required this.rowVersion,
    required this.userId,
    required this.label,
    required this.status,
    required this.position,
    required this.level,
    required this.isActive,
  });

  factory _SigDraft.fromTemplate(IQASignatoryTemplate t) => _SigDraft(
        id: t.id,
        rowVersion: t.rowVersion,
        userId: t.defaultSignatoryId,
        label: t.signatoryLabel,
        status: t.status,
        position: t.position,
        level: t.orderLevel,
        isActive: t.isActive,
      );
}

class _FormResult {
  final int officeId;
  final String entityType;
  final List<_SigDraft> drafts;
  final List<int> removedIds;

  const _FormResult({
    required this.officeId,
    required this.entityType,
    required this.drafts,
    required this.removedIds,
  });
}

// =============================================================================
// PAGE
// =============================================================================

class IQASignatoryTemplatePage extends StatefulWidget {
  const IQASignatoryTemplatePage({super.key});

  @override
  State<IQASignatoryTemplatePage> createState() =>
      _IQASignatoryTemplatePageState();
}

class _IQASignatoryTemplatePageState extends State<IQASignatoryTemplatePage>
    with SingleTickerProviderStateMixin {
  static const List<String> _entityTypes = [
    'AuditProgramme',
    'AuditPlan',
    'AuditSchedule',
  ];

    final IQASignatoryTemplateService _service =
      IQASignatoryTemplateService(Dio());
  final CommonService _commonService = CommonService(Dio());

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  late AnimationController _fadeCtrl;

  List<IQASignatoryTemplate> _templates = [];
  List<Office> _offices = [];
  List<User> _users = [];

  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _searchFocus.addListener(() {
      if (mounted) setState(() {});
    });
    _searchController.addListener(() {
      if (mounted) setState(() {});
    });
    _load();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _searchFocus.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // DATA
  // ---------------------------------------------------------------------------

    Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final results = await Future.wait([
        _service.getAll(),
        _commonService.fetchAlloffices(),
        _commonService.fetchUsers(),
      ]);
      if (!mounted) return;
      setState(() {
        _templates = (results[0] as List<IQASignatoryTemplate>)
            .where((t) => !t.isDeleted)
            .toList();
        _offices = List<Office>.from(results[1] as List);
        _users = List<User>.from(results[2] as List);
      });
      _fadeCtrl.forward(from: 0);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load signatory templates: $e';
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _officeName(int officeId) {
    final match = _offices.where((o) => o.id == officeId);
    return match.isNotEmpty ? match.first.name : 'Office #$officeId';
  }

  String? _userName(String? userId) {
    if (userId == null || userId.isEmpty) return null;
    final match = _users.where((u) => u.id == userId);
    return match.isNotEmpty ? match.first.fullName : null;
  }

  String _signatoryName(IQASignatoryTemplate t) =>
      _userName(t.defaultSignatoryId) ??
      t.defaultSignatoryName ??
      'No default signatory';

  List<_TemplateGroup> _allGroups() {
    final map = <String, _TemplateGroup>{};
    for (final t in _templates) {
      final key = '${t.officeId}|${t.auditEntityType}';
      map
          .putIfAbsent(
            key,
            () => _TemplateGroup(
              officeId: t.officeId,
              entityType: t.auditEntityType,
              officeName: _officeName(t.officeId),
              items: [],
            ),
          )
          .items
          .add(t);
    }
    final groups = map.values.toList();
    for (final g in groups) {
      g.items.sort((a, b) => a.orderLevel.compareTo(b.orderLevel));
    }
    groups.sort((a, b) {
      final c = a.officeName.toLowerCase().compareTo(b.officeName.toLowerCase());
      return c != 0 ? c : a.entityType.compareTo(b.entityType);
    });
    return groups;
  }

  List<_TemplateGroup> _filteredGroups() {
    final groups = _allGroups();
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return groups;
    return groups.where((g) {
      if (g.officeName.toLowerCase().contains(q)) return true;
      if (g.entityType.toLowerCase().contains(q)) return true;
      return g.items.any(
        (t) =>
            t.signatoryLabel.toLowerCase().contains(q) ||
            _signatoryName(t).toLowerCase().contains(q),
      );
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // ACTIONS
  // ---------------------------------------------------------------------------

  Future<void> _openForm({_TemplateGroup? group}) async {
    final existingKeys = _allGroups().map((g) => g.key).toSet();
    final result = await showDialog<_FormResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _TemplateFormDialog(
        group: group,
        offices: _offices,
        users: _users,
        entityTypes: _entityTypes,
        existingKeys: existingKeys,
      ),
    );
    if (result == null || !mounted) return;
    await _persist(result);
  }

  IQASignatoryTemplate _toTemplate(_FormResult r, _SigDraft d) {
    return IQASignatoryTemplate(
      id: d.id,
      rowVersion: d.rowVersion,
      auditEntityType: r.entityType,
      status: d.status,
      signatoryLabel: d.label,
      orderLevel: d.level,
      defaultSignatoryId: d.userId,
      defaultSignatoryName: _userName(d.userId),
      isActive: d.isActive,
      officeId: r.officeId,
      officeName: _officeName(r.officeId),
      position: d.position,
    );
  }

  Future<void> _persist(_FormResult r) async {
    setState(() => _isLoading = true);
    String? error;
    try {
      for (final id in r.removedIds) {
        await _service.softDelete(id);
      }
      for (final d in r.drafts) {
        await _service.saveOrUpdate(_toTemplate(r, d));
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    }

    if (mounted) {
      if (error == null) {
        _toastSuccess(context, 'Signatory template saved successfully');
      } else {
        _toastError(context, 'Failed to save: $error');
      }
    }
    await _load();
  }

  void _confirmDelete(_TemplateGroup g) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => DeleteDialog(
        title: 'Delete Template',
        itemName: 'signatory template',
        onDelete: () async {
          Navigator.pop(ctx);
          String? error;
          try {
            for (final t in g.items) {
              await _service.softDelete(t.id);
            }
          } catch (e) {
            error = e.toString().replaceFirst('Exception: ', '');
          }
          if (mounted) {
            if (error == null) {
              _toastSuccess(context, 'Template deleted successfully');
            } else {
              _toastError(context, 'Failed to delete template: $error');
            }
          }
          await _load();
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 600;
    final groups = _filteredGroups();

    Widget content;
    if (_isLoading) {
      content = _skeleton();
    } else if (_errorMessage != null) {
      content = _errorView();
    } else if (groups.isEmpty) {
      content = _empty();
    } else {
      content = _list(groups);
    }

    return Scaffold(
      backgroundColor: kBackground,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeCtrl,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildToolbar(isNarrow, groups.length),
              const SizedBox(height: 16),
              Expanded(child: content),
            ],
          ),
        ),
      ),
      floatingActionButton: isNarrow
          ? FloatingActionButton.extended(
              backgroundColor: primaryColor,
              onPressed: () => _openForm(),
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
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            'IQA Signatory Template',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: kText,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: kBorder),
        ),
      );

  Widget _buildToolbar(bool isNarrow, int count) => Container(
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
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: kText,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search by office, type or signatory…',
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
                      borderSide:
                          const BorderSide(color: primaryColor, width: 1.5),
                    ),
                  ),
                ),
              ),
            ),
            if (!isNarrow) ...[
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      '$count Templates',
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
                onPressed: () => _openForm(),
                icon: const Icon(
                  Icons.add_rounded,
                  size: 16,
                  color: Colors.white,
                ),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ],
        ),
      );

  Widget _list(List<_TemplateGroup> groups) => ListView.separated(
        itemCount: groups.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (ctx, i) {
          final g = groups[i];
          return _GroupCard(
            group: g,
            nameOf: _signatoryName,
            onEdit: () => _openForm(group: g),
            onDelete: () => _confirmDelete(g),
          );
        },
      );

  Widget _skeleton() => ListView.separated(
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, __) => Container(
          height: 68,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  Widget _errorView() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 40, color: kDanger),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _errorMessage ?? 'Something went wrong.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: kDanger,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _load,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: Text(
                'Retry',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _empty() {
    final searching = _searchController.text.trim().isNotEmpty;
    return Center(
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
            searching ? 'No Matching Templates' : 'No Templates Found',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: kText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searching
                ? 'Try a different search term.'
                : 'Create a signatory template to get started.',
            style: GoogleFonts.plusJakartaSans(fontSize: 13, color: kMuted),
          ),
          if (!searching) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _openForm(),
              icon: const Icon(Icons.add_rounded, size: 16),
              label: Text(
                'Create First Template',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// LIST CARD
// =============================================================================

class _GroupCard extends StatelessWidget {
  final _TemplateGroup group;
  final String Function(IQASignatoryTemplate) nameOf;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _GroupCard({
    required this.group,
    required this.nameOf,
    required this.onEdit,
    required this.onDelete,
  });

  Widget _pill(String text, Color bg, Color fg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: fg,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final count = group.items.length;
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
          collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
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
            group.officeName,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: kText,
            ),
          ),
          subtitle: Text(
            '${group.entityType} • $count signator${count == 1 ? 'y' : 'ies'}',
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
                itemCount: group.items.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: kBorder),
                itemBuilder: (ctx, i) {
                  final t = group.items[i];
                  final pos = t.position;
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
                              '${t.orderLevel}',
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
                                t.signatoryLabel.isEmpty
                                    ? 'No Label'
                                    : t.signatoryLabel,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: kMuted,
                                ),
                              ),
                              Text(
                                nameOf(t),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: kText,
                                ),
                              ),
                              if (pos != null && pos.isNotEmpty)
                                Text(
                                  pos,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: kMuted,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (t.status.isNotEmpty)
                          _pill(t.status, kSuccessLight, kSuccess),
                        if (!t.isActive) ...[
                          const SizedBox(width: 6),
                          _pill('Inactive', kDangerLight, kDanger),
                        ],
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

// =============================================================================
// FORM DIALOG (office + entity type + signatory list)
// =============================================================================

class _TemplateFormDialog extends StatefulWidget {
  final _TemplateGroup? group;
  final List<Office> offices;
  final List<User> users;
  final List<String> entityTypes;
  final Set<String> existingKeys;

  const _TemplateFormDialog({
    required this.group,
    required this.offices,
    required this.users,
    required this.entityTypes,
    required this.existingKeys,
  });

  @override
  State<_TemplateFormDialog> createState() => _TemplateFormDialogState();
}

class _TemplateFormDialogState extends State<_TemplateFormDialog> {
  int? _officeId;
  late String _entityType;
  final List<_SigDraft> _drafts = [];
  final List<int> _removedIds = [];

  bool get _isEdit => widget.group != null;

  List<String> get _typeOptions {
    final list = List<String>.from(widget.entityTypes);
    if (!list.contains(_entityType)) list.add(_entityType);
    return list;
  }

  Office? get _selectedOffice {
    final match = widget.offices.where((o) => o.id == _officeId);
    return match.isNotEmpty ? match.first : null;
  }

  String? _userName(String? id) {
    if (id == null || id.isEmpty) return null;
    final match = widget.users.where((u) => u.id == id);
    return match.isNotEmpty ? match.first.fullName : null;
  }

  @override
  void initState() {
    super.initState();
    final g = widget.group;
    _officeId = g?.officeId;
    _entityType = g?.entityType ?? widget.entityTypes.first;
    if (g != null) {
      _drafts.addAll(g.items.map(_SigDraft.fromTemplate));
      _drafts.sort((a, b) => a.level.compareTo(b.level));
    }
  }

  Future<void> _addSignatory() async {
    final nextLevel =
        _drafts.fold<int>(0, (m, d) => d.level > m ? d.level : m) + 1;
    final result = await showDialog<_SigDraft>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SignatoryDialog(
        users: widget.users,
        initialLevel: nextLevel,
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _drafts.add(result);
      _drafts.sort((a, b) => a.level.compareTo(b.level));
    });
  }

  Future<void> _editSignatory(int index) async {
    final result = await showDialog<_SigDraft>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SignatoryDialog(
        users: widget.users,
        existing: _drafts[index],
        initialLevel: _drafts[index].level,
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _drafts[index] = result;
      _drafts.sort((a, b) => a.level.compareTo(b.level));
    });
  }

  void _removeSignatory(int index) {
    setState(() {
      final d = _drafts.removeAt(index);
      if (d.id > 0) _removedIds.add(d.id);
    });
  }

  Future<void> _submit() async {
    if (_officeId == null) {
      _toastError(context, 'Please select an office.');
      return;
    }
    if (!_isEdit && widget.existingKeys.contains('$_officeId|$_entityType')) {
      _toastWarning(
        context,
        'This office already has a $_entityType template. Edit it instead.',
      );
      return;
    }
    if (_drafts.isEmpty) {
      _toastWarning(context, 'Add at least one signatory.');
      return;
    }
    final seen = <int>{};
    for (final d in _drafts) {
      if (!seen.add(d.level)) {
        _toastError(context, 'Duplicate order levels found.');
        return;
      }
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => _ConfirmDialog(
        title: _isEdit ? 'Confirm Update' : 'Confirm Save',
        body: _isEdit ? 'Update this template?' : 'Save this template?',
        confirmLabel: _isEdit ? 'Update' : 'Save',
      ),
    );
    if (ok != true || !mounted) return;

    Navigator.pop(
      context,
      _FormResult(
        officeId: _officeId!,
        entityType: _entityType,
        drafts: List<_SigDraft>.of(_drafts),
        removedIds: List<int>.of(_removedIds),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 520,
          maxHeight: MediaQuery.of(context).size.height * 0.92,
        ),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(24),
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
            // Header
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEdit
                              ? 'Edit Signatory Template'
                              : 'Create Signatory Template',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: kText,
                          ),
                        ),
                        Text(
                          _isEdit
                              ? 'Update the existing configuration'
                              : 'Add a new template for an office',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: kMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: kMuted),
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
                    sectionLabel('Office', Icons.business_rounded),
                    const SizedBox(height: 8),
                    DropdownSearch<Office>(
                      enabled: !_isEdit,
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: _fieldDecoration('Search offices…'),
                        ),
                        itemBuilder: (ctx, office, isSelected) => ListTile(
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
                            office.name,
                            style: GoogleFonts.plusJakartaSans(fontSize: 13),
                          ),
                        ),
                      ),
                      items: widget.offices,
                      itemAsString: (o) => o.name,
                      compareFn: (a, b) => a.id == b.id,
                      selectedItem: _selectedOffice,
                      onChanged: (val) => setState(() => _officeId = val?.id),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration:
                            _fieldDecoration('Select Office'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    sectionLabel('Audit Entity Type', Icons.rule_rounded),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _entityType,
                      decoration: _fieldDecoration('Audit Entity Type'),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: kText,
                      ),
                      items: _typeOptions
                          .map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          )
                          .toList(),
                      onChanged: _isEdit
                          ? null
                          : (val) => setState(
                                () => _entityType = val ?? _entityType,
                              ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        sectionLabel('Signatories', Icons.people_alt_rounded),
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
                            '${_drafts.length} added',
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
                    if (_drafts.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 28),
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
                        itemCount: _drafts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (ctx, i) {
                          final d = _drafts[i];
                          return _SignatoryCard(
                            draft: d,
                            userName: _userName(d.userId) ?? 'No default user',
                            onEdit: () => _editSignatory(i),
                            onDelete: () => _removeSignatory(i),
                          );
                        },
                      ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _addSignatory,
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
                          padding: const EdgeInsets.symmetric(vertical: 13),
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
              decoration: const BoxDecoration(
                color: kBackground,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
                border: Border(top: BorderSide(color: kBorder)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
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
                    onPressed: _submit,
                    icon: Icon(
                      _isEdit ? Icons.update_rounded : Icons.save_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: Text(
                      _isEdit ? 'Update Template' : 'Save Template',
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
  }
}

// =============================================================================
// SIGNATORY ROW (inside the form dialog)
// =============================================================================

class _SignatoryCard extends StatelessWidget {
  final _SigDraft draft;
  final String userName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SignatoryCard({
    required this.draft,
    required this.userName,
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
                  '${draft.level}',
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
                    '${draft.label} • ${draft.status}'
                    '${draft.isActive ? '' : ' • Inactive'}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: kMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    userName,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: kText,
                    ),
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
              onTap: onDelete,
              size: 15,
            ),
          ],
        ),
      );
}

// =============================================================================
// ADD / EDIT SIGNATORY DIALOG
// =============================================================================

class _SignatoryDialog extends StatefulWidget {
  final List<User> users;
  final _SigDraft? existing;
  final int initialLevel;

  const _SignatoryDialog({
    required this.users,
    required this.initialLevel,
    this.existing,
  });

  @override
  State<_SignatoryDialog> createState() => _SignatoryDialogState();
}

class _SignatoryDialogState extends State<_SignatoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _labelCtrl;
  late TextEditingController _statusCtrl;
  late TextEditingController _positionCtrl;
  late int _level;
  late bool _isActive;
  User? _selectedUser;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _labelCtrl = TextEditingController(text: e?.label ?? '');
    _statusCtrl = TextEditingController(text: e?.status ?? 'Pending');
    _positionCtrl = TextEditingController(text: e?.position ?? '');
    _level = widget.initialLevel < 1 ? 1 : widget.initialLevel;
    _isActive = e?.isActive ?? true;
    final uid = e?.userId;
    if (uid != null && uid.isNotEmpty) {
      final match = widget.users.where((u) => u.id == uid);
      _selectedUser = match.isNotEmpty ? match.first : null;
    }
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _statusCtrl.dispose();
    _positionCtrl.dispose();
    super.dispose();
  }

  void _confirm() {
    if (!_formKey.currentState!.validate()) return;
    final position = _positionCtrl.text.trim();
    final e = widget.existing;
    Navigator.pop(
      context,
      _SigDraft(
        id: e?.id ?? 0,
        rowVersion: e?.rowVersion,
        userId: _selectedUser?.id,
        label: _labelCtrl.text.trim(),
        status: _statusCtrl.text.trim(),
        position: position.isEmpty ? null : position,
        level: _level,
        isActive: _isActive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 520,
          maxHeight: MediaQuery.of(context).size.height * 0.92,
        ),
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
                color: primaryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                    _isEdit ? 'Edit Signatory' : 'Add Signatory',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
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
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DropdownSearch<User>(
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: _fieldDecoration('Search user…'),
                          ),
                          itemBuilder: (ctx, user, isSelected) {
                            final pos = user.position;
                            return ListTile(
                              dense: true,
                              leading: CircleAvatar(
                                radius: 14,
                                backgroundColor: kPrimaryLight,
                                child: Text(
                                  _initial(user.fullName),
                                  style: GoogleFonts.plusJakartaSans(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              title: Text(
                                user.fullName,
                                style:
                                    GoogleFonts.plusJakartaSans(fontSize: 13),
                              ),
                              subtitle: (pos != null && pos.isNotEmpty)
                                  ? Text(
                                      pos,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: kLabel,
                                      ),
                                    )
                                  : null,
                            );
                          },
                        ),
                        items: widget.users,
                        itemAsString: (u) => u.fullName,
                        compareFn: (a, b) => a.id == b.id,
                        selectedItem: _selectedUser,
                        clearButtonProps: const ClearButtonProps(
                          isVisible: true,
                        ),
                        onChanged: (val) => setState(() => _selectedUser = val),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration:
                              _fieldDecoration('Default Signatory (optional)'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _labelCtrl,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter a label'
                            : null,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        decoration:
                            _fieldDecoration('Signatory Label', hint: 'e.g. QMR'),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _positionCtrl,
                        style: GoogleFonts.plusJakartaSans(fontSize: 13),
                        decoration: _fieldDecoration('Position (optional)'),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _statusCtrl,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Please enter a status'
                                  : null,
                              style: GoogleFonts.plusJakartaSans(fontSize: 13),
                              decoration: _fieldDecoration(
                                'Signatory Status',
                                hint: 'e.g. Pending',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 6, left: 2),
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
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: kBorder),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _StepButton(
                                      icon: Icons.remove_rounded,
                                      onTap: () => setState(() {
                                        if (_level > 1) _level--;
                                      }),
                                    ),
                                    SizedBox(
                                      width: 40,
                                      child: Center(
                                        child: Text(
                                          '$_level',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                            color: kText,
                                          ),
                                        ),
                                      ),
                                    ),
                                    _StepButton(
                                      icon: Icons.add_rounded,
                                      onTap: () => setState(() => _level++),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Active',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: kText,
                          ),
                        ),
                        value: _isActive,
                        activeThumbColor: primaryColor,
                        onChanged: (val) => setState(() => _isActive = val),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: kBorder)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
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
                    onPressed: _confirm,
                    icon: Icon(
                      _isEdit ? Icons.save_rounded : Icons.add_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: Text(
                      _isEdit ? 'Save Changes' : 'Add Signatory',
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
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 48,
          child: Icon(icon, size: 18, color: primaryColor),
        ),
      );
}

// =============================================================================
// CONFIRM DIALOG
// =============================================================================

class _ConfirmDialog extends StatelessWidget {
  final String title;
  final String body;
  final String confirmLabel;

  const _ConfirmDialog({
    required this.title,
    required this.body,
    required this.confirmLabel,
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
                  color: kPrimaryLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.help_outline_rounded,
                  color: primaryColor,
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
                        backgroundColor: primaryColor,
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