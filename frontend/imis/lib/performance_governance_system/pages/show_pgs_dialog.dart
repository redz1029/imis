// pgs_form_dialog.dart
// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/performance_governance_system/pgs_signatory_template/models/pgs_signatory.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Responsive breakpoints ───────────────────────────────────────────────────
const double _kMobileBreak = 600;
const double _kTabletBreak = 900;

// ─── Public entry-point (call this instead of showDialog directly) ────────────
Future<void> showPgsFormDialog({
  required BuildContext context,

  // identity / edit mode
  String? userId,
  String? id,

  // office
  String? officename,
  int? officenameid,

  // scores
  String? competencescore,
  String? resourcescore,
  String? confidencescore,

  // period
  String? startDate,
  String? endDate,
  String? selectPeriod,

  // deliverables
  String? percentDeliverables,
  List<dynamic>? deliverabledIds,
  List<PgsDeliverables>? deliverables,

  // signatories
  List<PgsSignatory>? signatories,

  // misc
  bool? isDraft,
  String? pgsId,
  String? remarks,
  int? index,

  // callbacks — the host page wires these in
  required PgsFormCallbacks callbacks,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => _PgsFormDialog(
      userId: userId,
      id: id,
      officename: officename,
      officenameid: officenameid,
      competencescore: competencescore,
      resourcescore: resourcescore,
      confidencescore: confidencescore,
      startDate: startDate,
      endDate: endDate,
      percentDeliverables: percentDeliverables,
      deliverables: deliverables,
      signatories: signatories,
      isDraft: isDraft,
      remarks: remarks,
      callbacks: callbacks,
    ),
  );
}

// ─── Callback bundle ─────────────────────────────────────────────────────────
class PgsFormCallbacks {
  const PgsFormCallbacks({
    required this.onSaveAsDraft,
    required this.onSubmit,
    required this.onConfirm,
    required this.onClearSelections,
    required this.buildStrategicTabContent,
    required this.buildReadinessTabContent,
    required this.buildDeliverableStatusTabContent,
    this.permissionService,
  });

  /// Called when "Save as Draft" is tapped.
  final Future<void> Function() onSaveAsDraft;

  /// Called when "Submit" is tapped.
  final Future<void> Function() onSubmit;

  /// Called when "Confirm" (signatory approval) is tapped.
  final Future<void> Function() onConfirm;

  /// Called when the dialog is closed – clear host-page state.
  final VoidCallback onClearSelections;

  /// Builders – the host page injects these so the dialog stays dumb.
  final Widget Function(String officename, Function setDialogState)
  buildStrategicTabContent;
  final Widget Function(String officename, Function setDialogState)
  buildReadinessTabContent;
  final Widget Function(String officename, Function setDialogState)
  buildDeliverableStatusTabContent;

  final PermissionService? permissionService;
}

// ─── Private dialog widget ────────────────────────────────────────────────────
class _PgsFormDialog extends StatefulWidget {
  const _PgsFormDialog({
    this.userId,
    this.id,
    this.officename,
    this.officenameid,
    this.competencescore,
    this.resourcescore,
    this.confidencescore,
    this.startDate,
    this.endDate,
    this.percentDeliverables,
    this.deliverables,
    this.signatories,
    this.isDraft,
    this.remarks,
    required this.callbacks,
  });

  final String? userId;
  final String? id;
  final String? officename;
  final int? officenameid;
  final String? competencescore;
  final String? resourcescore;
  final String? confidencescore;
  final String? startDate;
  final String? endDate;
  final String? percentDeliverables;
  final List<PgsDeliverables>? deliverables;
  final List<PgsSignatory>? signatories;
  final bool? isDraft;
  final String? remarks;
  final PgsFormCallbacks callbacks;

  @override
  State<_PgsFormDialog> createState() => _PgsFormDialogState();
}

class _PgsFormDialogState extends State<_PgsFormDialog>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _isSaving = false;

  // ── derived helpers ──────────────────────────────────────────────────────
  bool get _isEditMode => widget.id != null;

  bool get _isAnyDisapproved =>
      widget.deliverables?.any((d) => d.isDisapproved == true) ?? false;

  bool get _hasSigantories =>
      widget.signatories != null && widget.signatories!.isNotEmpty;

  PermissionService get _perm =>
      widget.callbacks.permissionService ?? PermissionService();

  String get _officename => widget.officename ?? '';

  // ── lifecycle ────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── close helper ─────────────────────────────────────────────────────────
  Future<void> _closeDialog() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selectedOfficeId');
    await prefs.remove('selectedOfficeName');
    widget.callbacks.onClearSelections();
    if (mounted) Navigator.pop(context);
  }

  // ── action helpers ────────────────────────────────────────────────────────
  Future<void> _handleAction(Future<void> Function() action) async {
    setState(() => _isSaving = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ── build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < _kMobileBreak;
    final isTablet = size.width >= _kMobileBreak && size.width < _kTabletBreak;

    // Dialog dimensions scale with screen
    final dialogWidth = isMobile
        ? size.width * 0.97
        : isTablet
        ? size.width * 0.92
        : size.width * 0.88;
    final dialogHeight = isMobile ? size.height * 0.93 : size.height * 0.87;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 6 : 20,
        vertical: isMobile ? 10 : 24,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: dialogWidth,
        height: dialogHeight,
        decoration: BoxDecoration(
          color: mainBgColor,
          borderRadius: BorderRadius.circular(isMobile ? 14 : 18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 32,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isMobile ? 14 : 18),
          child: Column(
            children: [
              _DialogHeader(
                isMobile: isMobile,
                officename: _officename,
                onClose: _closeDialog,
                tabController: _tabController,
              ),
              Expanded(
                child: _DialogBody(
                  tabController: _tabController,
                  isMobile: isMobile,
                  officename: _officename,
                  callbacks: widget.callbacks,
                ),
              ),
              _DialogFooter(
                isMobile: isMobile,
                isSaving: _isSaving,
                isEditMode: _isEditMode,
                isAnyDisapproved: _isAnyDisapproved,
                hasSignatories: _hasSigantories,
                isDraft: widget.isDraft ?? false,
                signatories: widget.signatories,
                userId: widget.userId,
                permissionService: _perm,
                onSaveAsDraft: () =>
                    _handleAction(widget.callbacks.onSaveAsDraft),
                onSubmit: () => _handleAction(widget.callbacks.onSubmit),
                onConfirm: () => _handleAction(widget.callbacks.onConfirm),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────
class _DialogHeader extends StatelessWidget {
  const _DialogHeader({
    required this.isMobile,
    required this.officename,
    required this.onClose,
    required this.tabController,
  });

  final bool isMobile;
  final String officename;
  final VoidCallback onClose;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryLightColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Title row ──────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 14 : 24,
              isMobile ? 12 : 16,
              8,
              0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo + title
                Expanded(
                  child: isMobile
                      ? _MobileTitleBlock(officename: officename)
                      : _DesktopTitleBlock(officename: officename),
                ),
                // Close button
                _CloseButton(onClose: onClose),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // ── Tab bar ────────────────────────────────────────────────────
          _PgsTabBar(
            controller: tabController,
            isMobile: isMobile,
            officename: officename,
          ),
        ],
      ),
    );
  }
}

class _MobileTitleBlock extends StatelessWidget {
  const _MobileTitleBlock({required this.officename});
  final String officename;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/CRMC.png', height: 44),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'COTABATO REGIONAL AND MEDICAL CENTER',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Performance Governance System',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.80),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DesktopTitleBlock extends StatelessWidget {
  const _DesktopTitleBlock({required this.officename});
  final String officename;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/CRMC.png', height: 68),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'COTABATO REGIONAL AND MEDICAL CENTER',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Performance Governance System',
              style: TextStyle(
                color: Colors.white.withOpacity(0.78),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Close',
      child: InkWell(
        onTap: onClose,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 36,
          height: 36,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

class _PgsTabBar extends StatelessWidget {
  const _PgsTabBar({
    required this.controller,
    required this.isMobile,
    required this.officename,
  });

  final TabController controller;
  final bool isMobile;
  final String officename;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _TabItem(
        icon: Icons.flag_outlined,
        label: isMobile ? 'Contributions' : 'Strategic Contributions',
      ),
      _TabItem(
        icon: Icons.bar_chart_outlined,
        label: isMobile
            ? 'Readiness'
            : 'Readiness Rating${officename.isNotEmpty ? ' – $officename' : ''}',
      ),
      _TabItem(
        icon: Icons.check_circle_outline,
        label: isMobile ? 'Status' : 'PGS Deliverables Status',
      ),
    ];

    return TabBar(
      controller: controller,
      isScrollable: isMobile,
      tabAlignment: isMobile ? TabAlignment.start : TabAlignment.fill,
      indicatorColor: Colors.white,
      indicatorWeight: 3,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white.withOpacity(0.55),
      labelStyle: TextStyle(
        fontSize: isMobile ? 11 : 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: isMobile ? 10 : 12,
        fontWeight: FontWeight.w400,
      ),
      tabs: tabs
          .map(
            (t) => Tab(
              height: isMobile ? 44 : 48,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(t.icon, size: isMobile ? 14 : 16),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      t.label,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _TabItem {
  const _TabItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

// ─── Body ─────────────────────────────────────────────────────────────────────
class _DialogBody extends StatelessWidget {
  const _DialogBody({
    required this.tabController,
    required this.isMobile,
    required this.officename,
    required this.callbacks,
  });

  final TabController tabController;
  final bool isMobile;
  final String officename;
  final PgsFormCallbacks callbacks;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        _TabShell(
          child: Builder(
            builder: (ctx) => callbacks.buildStrategicTabContent(
              officename,
              // setDialogState shim — StatefulBuilder not needed here
              // because host page calls setState internally
              (_) {},
            ),
          ),
        ),
        _TabShell(
          child: Builder(
            builder: (ctx) =>
                callbacks.buildReadinessTabContent(officename, (_) {}),
          ),
        ),
        _TabShell(
          child: Builder(
            builder: (ctx) =>
                callbacks.buildDeliverableStatusTabContent(officename, (_) {}),
          ),
        ),
      ],
    );
  }
}

/// Thin wrapper that gives every tab the same padding / scroll behaviour.
class _TabShell extends StatelessWidget {
  const _TabShell({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(color: mainBgColor, child: child);
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────
class _DialogFooter extends StatelessWidget {
  const _DialogFooter({
    required this.isMobile,
    required this.isSaving,
    required this.isEditMode,
    required this.isAnyDisapproved,
    required this.hasSignatories,
    required this.isDraft,
    required this.signatories,
    required this.userId,
    required this.permissionService,
    required this.onSaveAsDraft,
    required this.onSubmit,
    required this.onConfirm,
  });

  final bool isMobile;
  final bool isSaving;
  final bool isEditMode;
  final bool isAnyDisapproved;
  final bool hasSignatories;
  final bool isDraft;
  final List<PgsSignatory>? signatories;
  final String? userId;
  final PermissionService permissionService;
  final VoidCallback onSaveAsDraft;
  final VoidCallback onSubmit;
  final VoidCallback onConfirm;

  bool get _showDraftButton =>
      !isEditMode || isAnyDisapproved || !hasSignatories;

  bool get _showSubmitButton =>
      (isAnyDisapproved || isEditMode) && !hasSignatories;

  bool get _showConfirmButton {
    if (isDraft) return false;
    // orderLevel + signatory check mirrors original logic
    final currentSignatory = signatories?.firstWhere(
      (s) => s.signatoryId?.toString() == userId?.toString(),
      orElse: () => PgsSignatory(
        0,
        0,
        0,
        'signatoryName',
        'signatoryId',
        'label',
        'status',
        false,
        0,
        DateTime.now(),
        false,
        '',
      ),
    );
    final orderLevel = currentSignatory?.orderLevel ?? 0;
    return orderLevel >= 1;
  }

  @override
  Widget build(BuildContext context) {
    final buttons = <Widget>[];

    if (_showDraftButton) {
      buttons.add(
        PermissionWidget(
          permission: AppPermissions.draftPerformanceGovernanceSystem,
          child: _FooterButton(
            label: 'Save as Draft',
            icon: Icons.save_outlined,
            style: _FooterButtonStyle.outlined,
            isMobile: isMobile,
            isLoading: isSaving,
            onPressed: onSaveAsDraft,
          ),
        ),
      );
    }

    if (_showSubmitButton) {
      buttons.add(
        PermissionWidget(
          permission: AppPermissions.draftPerformanceGovernanceSystem,
          child: _FooterButton(
            label: 'Submit',
            icon: Icons.send_outlined,
            style: _FooterButtonStyle.filled,
            isMobile: isMobile,
            isLoading: isSaving,
            onPressed: onSubmit,
          ),
        ),
      );
    }

    if (_showConfirmButton) {
      buttons.add(
        PermissionWidget(
          permission: AppPermissions.confirmPerformanceGovernanceSystem,
          child: _FooterButton(
            label: 'Confirm',
            icon: Icons.check_circle_outline,
            style: _FooterButtonStyle.filled,
            isMobile: isMobile,
            isLoading: isSaving,
            onPressed: onConfirm,
          ),
        ),
      );
    }

    if (buttons.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: isMobile ? 10 : 14,
      ),
      decoration: BoxDecoration(
        color: mainBgColor,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
                  buttons.expand((b) => [b, const SizedBox(height: 8)]).toList()
                    ..removeLast(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:
                  buttons.expand((b) => [b, const SizedBox(width: 10)]).toList()
                    ..removeLast(),
            ),
    );
  }
}

enum _FooterButtonStyle { outlined, filled }

class _FooterButton extends StatelessWidget {
  const _FooterButton({
    required this.label,
    required this.icon,
    required this.style,
    required this.isMobile,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final _FooterButtonStyle style;
  final bool isMobile;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final double fontSize = isMobile ? 13 : 14;
    final EdgeInsets padding = EdgeInsets.symmetric(
      horizontal: isMobile ? 16 : 20,
      vertical: isMobile ? 10 : 11,
    );

    if (style == _FooterButtonStyle.outlined) {
      return OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: primaryColor, width: 1.4),
          foregroundColor: primaryColor,
          padding: padding,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primaryColor,
                ),
              )
            : Icon(icon, size: 16),
        label: Text(label, style: TextStyle(fontSize: fontSize)),
      );
    }

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: padding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(icon, size: 16),
      label: Text(label, style: TextStyle(fontSize: fontSize)),
    );
  }
}

// ─── Status helpers (unchanged from host page) ────────────────────────────────
Color getStatusColor(String status) {
  switch (status) {
    case 'Approved':
      return const Color(0xFF16A34A);
    case 'For Approval':
      return const Color(0xFFD97706);
    case 'Disapproved':
      return const Color(0xFFDC2626);
    default: // Draft
      return const Color(0xFF6B7280);
  }
}

Widget getStatusIcon(String status) {
  IconData icon;
  switch (status) {
    case 'Approved':
      icon = Icons.check;
      break;
    case 'For Approval':
      icon = Icons.hourglass_top_rounded;
      break;
    case 'Disapproved':
      icon = Icons.close;
      break;
    default:
      icon = Icons.edit_outlined;
  }
  return Icon(icon, size: 10, color: Colors.white);
}

// ─── Responsive score-row card (replaces buildScoreRow in host) ───────────────
/// Drop-in replacement for the existing `buildScoreRow` widget.
/// Layout automatically switches between horizontal (desktop) and
/// vertical (mobile) depending on available width.
class PgsScoreRow extends StatelessWidget {
  const PgsScoreRow({
    super.key,
    required this.title,
    required this.descriptions,
    required this.selectedValue,
  });

  final String title;
  final List<String> descriptions;
  final ValueNotifier<double> selectedValue;

  static const List<Color> _boxColors = [
    Color.fromARGB(197, 235, 235, 235),
    Color(0xFFE8F4FD),
    Color(0xFF1E5799),
  ];

  static const List<Color> _textColors = [
    Colors.black87,
    Colors.black87,
    Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < _kMobileBreak;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
        isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(
          descriptions.length,
          (i) => Expanded(
            child: _ScoreCard(
              index: i,
              description: descriptions[i],
              bgColor: _boxColors[i],
              textColor: _textColors[i],
            ),
          ),
        ),
        const SizedBox(width: 8),
        _ScoreDropdown(
          descriptions: descriptions,
          selectedValue: selectedValue,
          width: 130,
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        ...List.generate(
          descriptions.length,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _ScoreCard(
              index: i,
              description: descriptions[i],
              bgColor: _boxColors[i],
              textColor: _textColors[i],
              isCompact: true,
            ),
          ),
        ),
        const SizedBox(height: 4),
        _ScoreDropdown(
          descriptions: descriptions,
          selectedValue: selectedValue,
          width: double.infinity,
        ),
      ],
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.index,
    required this.description,
    required this.bgColor,
    required this.textColor,
    this.isCompact = false,
  });

  final int index;
  final String description;
  final Color bgColor;
  final Color textColor;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: isCompact ? null : 110,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.black12),
      ),
      child: isCompact
          ? Row(
              children: [
                _ScoreBadge(score: index * 0.5),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    description,
                    style: TextStyle(fontSize: 12, color: textColor),
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ScoreBadge(score: index * 0.5),
                const SizedBox(height: 6),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: textColor),
                ),
              ],
            ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.score});
  final double score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        score.toStringAsFixed(1),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _ScoreDropdown extends StatelessWidget {
  const _ScoreDropdown({
    required this.descriptions,
    required this.selectedValue,
    required this.width,
  });

  final List<String> descriptions;
  final ValueNotifier<double> selectedValue;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width == double.infinity ? double.infinity : width,
      child: ValueListenableBuilder<double>(
        valueListenable: selectedValue,
        builder: (context, value, _) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: DropdownButton<double>(
              value: value,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              onChanged: (v) => selectedValue.value = v!,
              items: List.generate(
                descriptions.length,
                (i) => DropdownMenuItem(
                  value: i * 0.5,
                  child: Text('${(i * 0.5).toStringAsFixed(1)}'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Empty-state placeholder shown when deliverables list is empty ─────────────
class PgsEmptyDeliverables extends StatelessWidget {
  const PgsEmptyDeliverables({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'No deliverables yet',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap "Add Row" to start adding deliverables.',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
