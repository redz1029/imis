// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/performance_governance_system/process_core_support/models/key_result_area.dart';
import 'package:imis/roadmap/models/kpi_roadmap.dart';
import 'package:imis/roadmap/models/kra_roadmap_role.dart';
import 'package:imis/roadmap/models/roadmap.dart';
import 'package:imis/roadmap/models/roadmap_deliverables.dart';
import 'package:imis/roadmap/pages/print_roadmap_page.dart';
import 'package:imis/roadmap/services/roadmap_service.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:imis/widgets/filter_widget/button_filter.dart';
import 'package:imis/widgets/no_permission_widget.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:imis/widgets/permission_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common_services/common_service.dart';
import '../../utils/auth_util.dart';
import '../kra_period_roadmap/models/kra_roadmap_period.dart';

enum _Screen { small, medium, large }

_Screen _screenOf(BuildContext ctx) {
  final w = MediaQuery.of(ctx).size.width;
  if (w < 600) return _Screen.small;
  if (w < 900) return _Screen.medium;
  return _Screen.large;
}

const double kActionColW = 72.0;
const double kEnablerColW = 72.0;

class _KpiEntry {
  final TextEditingController kpiCtrl;
  final TextEditingController targetCtrl;
  final TextEditingController baselineCtrl;

  _KpiEntry({String kpi = '', String target = '', String baseline = ''})
    : kpiCtrl = TextEditingController(text: kpi),
      targetCtrl = TextEditingController(text: target),
      baselineCtrl = TextEditingController(text: baseline);
}

class _RowEntry {
  final TextEditingController kraCtrl;
  final Map<String, TextEditingController> yearCtrls;
  bool enabler;
  DeliverableGroup? existingGroup;

  _RowEntry(
    List<String> years, {
    String kra = '',
    this.enabler = false,
    this.existingGroup,
  }) : kraCtrl = TextEditingController(text: kra),
       yearCtrls = {for (final y in years) y: TextEditingController()};
}

class _ResponsiveDialog extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const _ResponsiveDialog({required this.child, this.maxWidth = 480});

  @override
  Widget build(BuildContext context) {
    final screen = _screenOf(context);
    final size = MediaQuery.of(context).size;
    final hPad = screen == _Screen.small ? 12.0 : 32.0;
    final vPad = screen == _Screen.small ? 8.0 : 40.0;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: size.height * (screen == _Screen.small ? 0.94 : 0.88),
        ),
        child: child,
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onClose;
  final bool centerTitle;

  const _DialogHeader({
    required this.title,
    this.subtitle,
    required this.onClose,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        border: Border(bottom: BorderSide(color: primaryColor)),
      ),
      child: centerTitle ? _buildCentered() : _buildDefault(),
    );
  }

  Widget _buildDefault() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(fontSize: 12, color: Colors.white54),
                ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 18, color: Colors.white70),
          onPressed: onClose,
        ),
      ],
    );
  }

  Widget _buildCentered() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.white70),
            onPressed: onClose,
          ),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final _Screen screen;
  final VoidCallback onBack;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _Footer({
    required this.screen,
    required this.onBack,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screen == _Screen.small ? 10 : 16,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, size: 15),
            label: const Text('Back'),
            style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
          ),
          Row(
            children: [
              TextButton(
                onPressed: onCancel,
                style: TextButton.styleFrom(foregroundColor: primaryColor),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: screen == _Screen.small ? 16 : 24,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: onSave,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatefulCheckbox extends StatefulWidget {
  final bool initial;
  final String? label;
  final void Function(bool) onChanged;

  const _StatefulCheckbox({
    this.initial = false,
    this.label,
    required this.onChanged,
  });

  @override
  State<_StatefulCheckbox> createState() => _StatefulCheckboxState();
}

class _StatefulCheckboxState extends State<_StatefulCheckbox> {
  late bool _val;

  @override
  void initState() {
    super.initState();
    _val = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final box = Checkbox(
      value: _val,
      activeColor: primaryColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onChanged: (v) {
        setState(() => _val = v ?? false);
        widget.onChanged(_val);
      },
    );

    if (widget.label == null) return box;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        box,
        Text(
          widget.label!,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _ExpandableCell extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool bordered;

  const _ExpandableCell({
    required this.controller,
    required this.hint,
    this.bordered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 46),
      decoration: BoxDecoration(
        border:
            bordered
                ? Border.all(color: Colors.grey.shade300)
                : Border(right: BorderSide(color: Colors.grey.shade300)),
        borderRadius: bordered ? BorderRadius.circular(4) : null,
      ),
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
      child: TextField(
        controller: controller,
        maxLines: null,
        minLines: 1,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}

class _BorderedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _BorderedTextField({required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        expands: true,
        maxLines: null,
        minLines: null,

        keyboardType: TextInputType.multiline,
        textAlignVertical: TextAlignVertical.top,

        style: const TextStyle(fontSize: 14),

        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),

          isDense: true,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
      ),
    );
  }
}

class _KpiLabel extends StatelessWidget {
  final String text;
  const _KpiLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }
}

class _StrategicSection extends StatelessWidget {
  final _Screen screen;
  final String? strategicObjective;
  final List<_KpiEntry> kpis;
  final VoidCallback onAddKpi;
  final void Function(int) onRemoveKpi;

  const _StrategicSection({
    required this.screen,
    required this.strategicObjective,
    required this.kpis,
    required this.onAddKpi,
    required this.onRemoveKpi,
  });

  @override
  Widget build(BuildContext context) {
    final isSmall = screen == _Screen.small;

    Widget kpiPanel = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...kpis.asMap().entries.map((e) {
          final idx = e.key;
          final kpi = e.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child:
                isSmall
                    ? _KpiRowSmall(
                      idx: idx,
                      kpi: kpi,
                      canDelete: kpis.length > 1,
                      onDelete:
                          () => showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder:
                                (ctx) => AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: const Text(
                                    'Are you sure you want to remove this KPI? This action cannot be undone.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        onRemoveKpi(idx);
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                          ),
                    )
                    : _KpiRowLarge(
                      idx: idx,
                      kpi: kpi,
                      canDelete: kpis.length > 1,
                      onDelete:
                          () => showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder:
                                (ctx) => AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: const Text(
                                    'Are you sure you want to remove this KPI? This action cannot be undone.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(color: primaryColor),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        onRemoveKpi(idx);
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                          ),
                    ),
          );
        }),
        PermissionWidget(
          permission: AppPermissions.editKraRoadMap,
          child: TextButton.icon(
            onPressed: onAddKpi,
            icon: const Icon(Icons.add, size: 15, color: primaryColor),
            label: const Text(
              'Add KPI',
              style: TextStyle(color: primaryColor, fontSize: 14),
            ),
          ),
        ),
      ],
    );

    Widget objectivePanel = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Strategic Objective',
          style: TextStyle(
            color: primaryColor,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          strategicObjective ?? '',
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );

    if (!isSmall) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: objectivePanel,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: kpiPanel,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: objectivePanel,
          ),
          Padding(padding: const EdgeInsets.all(10), child: kpiPanel),
        ],
      ),
    );
  }
}

class _KpiRowLarge extends StatelessWidget {
  final int idx;
  final _KpiEntry kpi;
  final bool canDelete;
  final VoidCallback onDelete;

  const _KpiRowLarge({
    required this.idx,
    required this.kpi,
    required this.canDelete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _KpiLabel('KPI ${idx + 1}:'),
        const SizedBox(width: 5),
        Expanded(
          child: _BorderedTextField(controller: kpi.kpiCtrl, hint: 'KPI'),
        ),
        const SizedBox(width: 8),
        _KpiLabel('Target ${idx + 1}:'),
        const SizedBox(width: 5),
        Expanded(
          child: _BorderedTextField(controller: kpi.targetCtrl, hint: 'Target'),
        ),
        const SizedBox(width: 8),
        _KpiLabel('Baseline ${idx + 1}:'),
        const SizedBox(width: 5),
        Expanded(
          child: _BorderedTextField(
            controller: kpi.baselineCtrl,
            hint: 'Baseline',
          ),
        ),
        const SizedBox(width: 2),
        PermissionWidget(
          permission: AppPermissions.editKraRoadMap,
          child: IconButton(
            icon: Icon(
              CupertinoIcons.delete_simple,
              color: canDelete ? Colors.red : Colors.grey[300],
              size: 19,
            ),
            onPressed: canDelete ? onDelete : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          ),
        ),
      ],
    );
  }
}

class _KpiRowSmall extends StatelessWidget {
  final int idx;
  final _KpiEntry kpi;
  final bool canDelete;
  final VoidCallback onDelete;

  const _KpiRowSmall({
    required this.idx,
    required this.kpi,
    required this.canDelete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 6, 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'KPI ${idx + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: primaryColor,
                ),
              ),
              const Spacer(),
              if (canDelete)
                PermissionWidget(
                  permission: AppPermissions.editKraRoadMap,
                  child: GestureDetector(
                    onTap: onDelete,
                    child: const Icon(
                      CupertinoIcons.delete_simple,
                      color: Colors.red,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _SmallLabelField(label: 'KPI', controller: kpi.kpiCtrl),
          const SizedBox(height: 6),
          _SmallLabelField(label: 'Target', controller: kpi.targetCtrl),
          const SizedBox(height: 6),
          _SmallLabelField(label: 'Baseline', controller: kpi.baselineCtrl),
        ],
      ),
    );
  }
}

class _SmallLabelField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const _SmallLabelField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        _BorderedTextField(controller: controller, hint: label),
      ],
    );
  }
}

class _LargeTableSection extends StatelessWidget {
  final _Screen screen;
  final List<String> years;
  final List<_RowEntry> rows;
  final VoidCallback onAddRow;
  final void Function(int) onRemoveRow;
  final void Function(int, bool) onEnablerChanged;

  const _LargeTableSection({
    required this.screen,
    required this.years,
    required this.rows,
    required this.onAddRow,
    required this.onRemoveRow,
    required this.onEnablerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderRow(),
          Divider(height: 1, color: Colors.grey.shade300),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children:
                    rows.asMap().entries.map((e) {
                      final idx = e.key;
                      final row = e.value;
                      return _buildDataRow(
                        row: row,
                        onDelete: () => _confirmRemoveRow(context, idx),
                        onEnablerChanged: (v) => onEnablerChanged(idx, v),
                        index: idx,
                      );
                    }).toList(),
              ),
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade300),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Align(
              alignment: Alignment.center,
              child: PermissionWidget(
                permission: AppPermissions.editKraRoadMap,
                child: TextButton.icon(
                  onPressed: onAddRow,
                  icon: const Icon(Icons.add, size: 15, color: primaryColor),
                  label: const Text(
                    'Add Row',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmRemoveRow(BuildContext context, int idx) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text(
              'Are you sure you want to remove this row? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: primaryColor),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  onRemoveRow(idx);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      color: Colors.grey.shade100,
      child: Row(
        children: [
          _FixedHeaderCell('Action', width: kActionColW),
          _FixedHeaderCell('Enablers', width: kEnablerColW),
          _FlexHeaderCell('KRA', flex: 3),
          ...years.map((y) => _FlexHeaderCell(y, flex: 2)),
        ],
      ),
    );
  }

  Widget _buildDataRow({
    required _RowEntry row,
    required VoidCallback onDelete,
    required void Function(bool) onEnablerChanged,
    required int index,
  }) {
    final isEven = index % 2 == 0;
    return Container(
      decoration: BoxDecoration(
        color: isEven ? Colors.white : primaryColor.withValues(alpha: 0.08),
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: kActionColW,
              child: Center(
                child: PermissionWidget(
                  permission: AppPermissions.editKraRoadMap,
                  child: IconButton(
                    icon: const Icon(
                      CupertinoIcons.delete_simple,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 30,
                      minHeight: 30,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: kEnablerColW,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.grey.shade300),
                  right: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Center(
                child: _StatefulCheckbox(
                  initial: row.enabler,
                  onChanged: onEnablerChanged,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: _ExpandableCell(
                controller: row.kraCtrl,
                hint: 'Key Result Area',
              ),
            ),
            ...years.map(
              (y) => Expanded(
                flex: 2,
                child: _ExpandableCell(controller: row.yearCtrls[y]!, hint: ''),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FixedHeaderCell extends StatelessWidget {
  final String label;
  final double width;
  const _FixedHeaderCell(this.label, {required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _FlexHeaderCell extends StatelessWidget {
  final String label;
  final int flex;
  const _FlexHeaderCell(this.label, {this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _RowCard extends StatelessWidget {
  final _RowEntry row;
  final List<String> years;
  final VoidCallback onDelete;
  final void Function(bool) onEnablerChanged;

  const _RowCard({
    required this.row,
    required this.years,
    required this.onDelete,
    required this.onEnablerChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final yearFieldW = (screenW - 60) / 2;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.grey.shade300),
          right: BorderSide(color: Colors.grey.shade300),
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatefulCheckbox(
                initial: row.enabler,
                label: 'Enabler',
                onChanged: onEnablerChanged,
              ),
              const Spacer(),
              PermissionWidget(
                permission: AppPermissions.editKraRoadMap,
                child: IconButton(
                  icon: const Icon(
                    CupertinoIcons.delete_simple,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 30,
                    minHeight: 30,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'KRA',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          _ExpandableCell(
            controller: row.kraCtrl,
            hint: 'Key Result Area',
            bordered: true,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                years.map((y) {
                  return SizedBox(
                    width: yearFieldW,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          y,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 3),
                        _ExpandableCell(
                          controller: row.yearCtrls[y]!,
                          hint: '',
                          bordered: true,
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}

class _RoadmapMainDialog extends StatefulWidget {
  final String kraName;
  final String strategicObjective;
  final KraRoadmapPeriod period;
  final KraRoadmapRole selectedKra;
  final Roadmap? roadmapToEdit;
  final Future<void> Function(
    List<_KpiEntry> kpis,
    List<_RowEntry> rows,
    List<String> years,
    bool isEdit,
  )
  onSave;
  final VoidCallback onBack;

  const _RoadmapMainDialog({
    required this.kraName,
    required this.strategicObjective,
    required this.period,
    required this.selectedKra,
    this.roadmapToEdit,
    required this.onSave,
    required this.onBack,
  });

  @override
  State<_RoadmapMainDialog> createState() => _RoadmapMainDialogState();
}

class _RoadmapMainDialogState extends State<_RoadmapMainDialog> {
  late List<String> _years;
  late List<_KpiEntry> _kpis;
  late List<_RowEntry> _rows;

  @override
  void initState() {
    super.initState();
    _years = _buildYears();
    _initData();
  }

  List<String> _buildYears() {
    final start = widget.period.startYear.year;
    final end = widget.period.endYear.year;
    return List.generate(end - start + 1, (i) => '${start + i}');
  }

  void _initData() {
    final roadmap = widget.roadmapToEdit;

    if (roadmap != null) {
      // Load KPIs
      _kpis =
          (roadmap.kpis ?? [])
              .map(
                (k) => _KpiEntry(
                  kpi: k.kpiDescription ?? '',
                  target: k.target ?? '',
                  baseline: k.baseLine ?? '',
                ),
              )
              .toList();
      if (_kpis.isEmpty) _kpis = [_KpiEntry()];

      _rows =
          (roadmap.deliverables ?? []).map((group) {
            final entry = _RowEntry(
              _years,
              kra: group.kraDescription ?? '',
              enabler: group.items?.any((item) => item.isEnabler) ?? false,
              existingGroup: group,
            );
            for (final item in group.items ?? []) {
              final key = item.year.toString();
              if (entry.yearCtrls.containsKey(key)) {
                entry.yearCtrls[key]!.text = item.deliverableDescription ?? '';
              }
            }
            return entry;
          }).toList();
      if (_rows.isEmpty) _rows = [_RowEntry(_years)];
    } else {
      _kpis = [_KpiEntry()];
      _rows = [_RowEntry(_years)];
    }
  }

  void _addKpi() => setState(() => _kpis.add(_KpiEntry()));
  void _removeKpi(int i) => setState(() => _kpis.removeAt(i));
  void _addRow() => setState(() => _rows.add(_RowEntry(_years)));
  void _removeRow(int i) => setState(() => _rows.removeAt(i));

  @override
  Widget build(BuildContext context) {
    final screen = _screenOf(context);
    final size = MediaQuery.of(context).size;
    final isSmall = screen == _Screen.small;
    final hPad = isSmall ? 4.0 : 8.0;
    final vPad = isSmall ? 6.0 : 12.0;
    final maxH = size.height * (isSmall ? 0.97 : 0.95);

    final title = '${widget.kraName.toUpperCase()} ROADMAP';
    final subtitle =
        '${widget.period.startYear.year} - ${widget.period.endYear.year}';

    return Dialog(
      backgroundColor: mainBgColor,
      insetPadding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: double.infinity, maxHeight: maxH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DialogHeader(
              title: title,
              centerTitle: true,
              subtitle: subtitle,
              onClose: () => Navigator.pop(context),
            ),
            Expanded(
              child:
                  isSmall
                      ? SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(10, 12, 10, 4),
                        child: Container(
                          color: Theme.of(context).cardColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _StrategicSection(
                                screen: screen,
                                strategicObjective:
                                    widget.selectedKra.strategicObjectives,
                                kpis: _kpis,
                                onAddKpi: _addKpi,
                                onRemoveKpi: _removeKpi,
                              ),
                              const SizedBox(height: 14),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 9,
                                ),
                                decoration: const BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'KRA & Year Targets',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              ..._rows.asMap().entries.map((e) {
                                final idx = e.key;
                                final row = e.value;
                                return _RowCard(
                                  row: row,
                                  years: _years,
                                  onDelete: () => _removeRow(idx),
                                  onEnablerChanged:
                                      (v) => setState(
                                        () => _rows[idx].enabler = v,
                                      ),
                                );
                              }),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                    right: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                    bottom: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(8),
                                  ),
                                ),
                                child: PermissionWidget(
                                  permission: AppPermissions.editKraRoadMap,
                                  child: TextButton.icon(
                                    onPressed: _addRow,
                                    icon: const Icon(
                                      Icons.add,
                                      size: 15,
                                      color: primaryColor,
                                    ),
                                    label: const Text(
                                      'Add Row',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      )
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                            child: _StrategicSection(
                              screen: screen,
                              strategicObjective:
                                  widget.selectedKra.strategicObjectives,
                              kpis: _kpis,
                              onAddKpi: _addKpi,
                              onRemoveKpi: _removeKpi,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: _LargeTableSection(
                                screen: screen,
                                rows: _rows,
                                years: _years,
                                onAddRow: _addRow,
                                onRemoveRow: _removeRow,
                                onEnablerChanged:
                                    (i, v) =>
                                        setState(() => _rows[i].enabler = v),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
            ),
            const Divider(height: 1),
            PermissionWidget(
              permission: AppPermissions.addKraRoadMap,
              child: _Footer(
                screen: screen,
                onBack: () {
                  Navigator.pop(context);
                  widget.onBack();
                },
                onCancel: () => Navigator.pop(context),
                onSave: () async {
                  setState(() {
                    _rows.removeWhere((row) {
                      final kraEmpty = row.kraCtrl.text.trim().isEmpty;
                      final allYearsEmpty = row.yearCtrls.values.every(
                        (ctrl) => ctrl.text.trim().isEmpty,
                      );
                      return kraEmpty && allYearsEmpty;
                    });
                  });
                  final Set<String> kraSet = {};
                  for (final row in _rows) {
                    final kraText = row.kraCtrl.text.trim().toLowerCase();
                    if (kraText.isEmpty) continue;
                    if (kraSet.contains(kraText)) {
                      MotionToast.warning(
                        toastAlignment: Alignment.topCenter,
                        description: const Text(
                          'Duplicate KRA found. Please ensure each KRA is unique.',
                        ),
                      ).show(context);
                      return;
                    }
                    kraSet.add(kraText);
                  }

                  final filledKpiCount =
                      _kpis
                          .where((k) => k.kpiCtrl.text.trim().isNotEmpty)
                          .length;
                  if (filledKpiCount < 1) {
                    MotionToast.warning(
                      title: const Text("Insufficient KPI"),
                      description: const Text(
                        "Please provide at least 1 or 2 KPIs only.",
                      ),
                      toastAlignment: Alignment.center,
                    ).show(context);
                    return;
                  }

                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder:
                        (ctx) => AlertDialog(
                          title: const Text('Confirm Save'),
                          content: Text(
                            widget.roadmapToEdit != null
                                ? 'Are you sure you want to save this roadmap?'
                                : 'Are you sure you want to save this roadmap?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text(
                                'Confirm',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                  );

                  if (confirm != true) return;

                  Navigator.pop(context);
                  await widget.onSave(
                    _kpis,
                    _rows,
                    _years,
                    widget.roadmapToEdit != null,
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

class RoadmapPage extends StatefulWidget {
  const RoadmapPage({super.key});

  @override
  State<RoadmapPage> createState() => RoadmapDialogPageState();
}

class RoadmapDialogPageState extends State<RoadmapPage> {
  final FocusNode isSearchfocus = FocusNode();
  final _commonService = CommonService(Dio());
  final _roadmapService = RoadmapService(Dio());
  TextEditingController searchController = TextEditingController();
  List<Roadmap> filteredList = [];
  List<Roadmap> roadmapList = [];
  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;
  final dio = Dio();
  String roleId = "";
  final List<DeliverableGroup> deliverables = [];
  List<KeyResultArea> kraList = [];
  List<KraRoadmapRole> kraListRoadmap = [];
  List<KraRoadmapPeriod> kraPeriodList = [];
  final List<KpiRoadmap> kpiList = [];
  final permissionService = PermissionService();
  String selectedFilter = "All Process (Core&Support)";

  @override
  void initState() {
    super.initState();
    _loadCurrentRoleId();
    isSearchfocus.addListener(() => setState(() {}));
    () async {
      final kra = await _commonService.fetchKra();
      final kraPeriod = await _commonService.fetchKraPeriod();
      final kraRoadmap = await _roadmapService.getKraRoadmapByRoleId();
      if (!mounted) return;
      setState(() {
        kraList = kra;
        kraPeriodList = kraPeriod;
        kraListRoadmap = kraRoadmap;
      });
    }();
  }

  Future<void> _loadCurrentRoleId() async {
    await AuthUtil.processTokenValidity(dio, context);
    final roles = await AuthUtil.fetchRoles();
    final prefs = await SharedPreferences.getInstance();
    final String? selectedRoleName = prefs.getString('selectedRole');
    String tempRoleId = "";
    if (roles != null && roles.isNotEmpty) {
      var currentRole = roles.first;
      if (selectedRoleName != null) {
        try {
          currentRole = roles.firstWhere((r) => r.name == selectedRoleName);
          // ignore: empty_catches
        } catch (e) {}
      }
      tempRoleId = currentRole.id;
    }
    if (mounted) {
      setState(() => roleId = tempRoleId);
      if (roleId.isNotEmpty) fetchRoadmap();
    }
  }

  Future<void> fetchRoadmap({int page = 1, String? searchQuery}) async {
    if (_isLoading || roleId.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final pageList = await _roadmapService.getRoadmap(
        roleId: roleId,
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );
      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          _totalCount = pageList.totalCount;
          roadmapList = pageList.items;
          filteredList = List.from(roadmapList);
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> filterSearchResults(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => filteredList = List.from(roadmapList));
      return;
    }
    final results =
        roadmapList.where((r) {
          final matchedKra = kraList.firstWhere(
            (kra) => kra.id == r.kraId,
            orElse: () => KeyResultArea(0, '', '', '', false),
          );
          final matchedKraPeriod = kraPeriodList.firstWhere(
            (p) => p.id == r.kraRoadMapPeriodId,
            orElse:
                () => KraRoadmapPeriod(
                  0,
                  DateTime.now(),
                  DateTime.now(),
                  isDeleted: false,
                  rowVersion: '',
                ),
          );
          final periodString =
              '${matchedKraPeriod.startYear.year} - ${matchedKraPeriod.endYear.year}';
          final kpiMatch = (r.kpis ?? []).any(
            (k) => (k.kpiDescription ?? '').toLowerCase().contains(q),
          );
          return matchedKra.name.toLowerCase().contains(q) ||
              periodString.contains(q) ||
              kpiMatch;
        }).toList();
    setState(() => filteredList = results);
  }

  void showProcess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => _ResponsiveDialog(
            maxWidth: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DialogHeader(
                  title: 'SELECT ROADMAP',
                  onClose: () => Navigator.pop(ctx),
                ),
                Container(
                  color: Theme.of(context).cardColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: FutureBuilder<List<KraRoadmapRole>>(
                          future: _roadmapService.getKraRoadmapByRoleId(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text('Failed to load core and support'),
                              );
                            }
                            final kras = snapshot.data ?? [];
                            if (kras.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text('No process available'),
                              );
                            }
                            return ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              itemCount: kras.length,
                              separatorBuilder:
                                  (_, __) => Divider(
                                    height: 1,
                                    color: Colors.grey.shade200,
                                  ),
                              itemBuilder: (context, index) {
                                final kra = kras[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.pop(ctx);
                                    showPeriodPanel(selectedKra: kra);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 13,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.map_outlined,
                                          color: primaryColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            kra.kraName,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: Colors.grey,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Container(
                  color: Theme.of(context).cardColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              style: TextButton.styleFrom(
                                foregroundColor: primaryColor,
                              ),
                              child: const Text('Cancel'),
                            ),
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

  void showPeriodPanel({KraRoadmapRole? selectedKra}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => _ResponsiveDialog(
            maxWidth: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DialogHeader(
                  title: 'SELECT PERIOD',
                  subtitle: selectedKra?.kraName,
                  onClose: () => Navigator.pop(ctx),
                ),
                Container(
                  color: Theme.of(context).cardColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Flexible(
                        child: FutureBuilder<List<KraRoadmapPeriod>>(
                          future: _commonService.fetchKraPeriod(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text('Failed to load periods'),
                              );
                            }
                            final periods = snapshot.data ?? [];
                            if (periods.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text('No periods available'),
                              );
                            }
                            return ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              itemCount: periods.length,
                              separatorBuilder:
                                  (_, __) => Divider(
                                    height: 1,
                                    color: Colors.grey.shade200,
                                  ),
                              itemBuilder: (context, index) {
                                final period = periods[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.pop(ctx);
                                    _showRoadmapMainDialog(
                                      period: period,
                                      selectedKra: selectedKra!,
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 13,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.date_range,
                                          color: primaryColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            '${period.startYear.year} - ${period.endYear.year}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: Colors.grey,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Container(
                  color: Theme.of(context).cardColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Navigator.pop(ctx);
                                showProcess();
                              },
                              icon: const Icon(Icons.arrow_back, size: 15),
                              label: const Text('Back'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey[700],
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              style: TextButton.styleFrom(
                                foregroundColor: primaryColor,
                              ),
                              child: const Text('Cancel'),
                            ),
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

  void _showRoadmapMainDialog({
    required KraRoadmapPeriod period,
    required KraRoadmapRole selectedKra,
    Roadmap? roadmapToEdit,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => _RoadmapMainDialog(
            kraName: selectedKra.kraName,
            strategicObjective: selectedKra.strategicObjectives ?? '',
            period: period,
            selectedKra: selectedKra,
            roadmapToEdit: roadmapToEdit,
            onBack: () => showPeriodPanel(selectedKra: selectedKra),
            onSave: (kpis, rows, years, isEdit) async {
              final List<DeliverableGroup> allGroups = [];
              final yearColumns = years.map((y) => int.parse(y)).toList();

              for (int r = 0; r < rows.length; r++) {
                final row = rows[r];
                final existingGroup = row.existingGroup;
                final List<RoadmapDeliverableItem> items = [];

                for (int c = 0; c < yearColumns.length; c++) {
                  final year = yearColumns[c];
                  final text =
                      row.yearCtrls[year.toString()]?.text.trim() ?? '';
                  final existingItem = existingGroup?.items?.firstWhere(
                    (i) => i.year == year,
                    orElse:
                        () => RoadmapDeliverableItem(
                          id: 0,
                          deliverableDescription: '',
                          year: year,
                          kraDescription: row.kraCtrl.text,
                          isEnabler: c == 0 ? row.enabler : false,
                          isDeleted: false,
                          rowVersion: '',
                        ),
                  );
                  items.add(
                    RoadmapDeliverableItem(
                      id: isEdit ? existingItem?.id ?? 0 : 0,
                      deliverableDescription: text,
                      year: year,
                      kraDescription: row.kraCtrl.text,
                      isEnabler: c == 0 ? row.enabler : false,
                      isDeleted: false,
                      rowVersion: existingItem?.rowVersion ?? '',
                    ),
                  );
                }

                allGroups.add(
                  DeliverableGroup(
                    id: isEdit ? existingGroup?.id ?? 0 : 0,
                    kraDescription: row.kraCtrl.text,
                    items: items,
                    isDeleted: false,
                    rowVersion: existingGroup?.rowVersion ?? '',
                  ),
                );
              }

              kpiList.clear();
              for (final kpi in kpis) {
                final kpiText = kpi.kpiCtrl.text.trim();
                final targetText = kpi.targetCtrl.text.trim();
                final baselineText = kpi.baselineCtrl.text.trim();
                if (kpiText.isEmpty &&
                    targetText.isEmpty &&
                    baselineText.isEmpty) {
                  continue;
                }
                kpiList.add(
                  KpiRoadmap(
                    id: 0,
                    kpiDescription: kpiText,
                    target: targetText,
                    baseLine: baselineText,
                  ),
                );
              }

              final roadmap = Roadmap(
                isEdit ? roadmapToEdit!.id : 0,
                selectedKra.kraId,
                period.id,
                period,
                allGroups,
                kpiList,
                roleId,
                isDeleted: false,
                rowVersion: roadmapToEdit?.rowVersion ?? '',
              );

              await _roadmapService.createRoadmap(roadmap);
              await fetchRoadmap();
              setState(() {});

              MotionToast.success(
                toastAlignment: Alignment.topCenter,
                description: Text(
                  isEdit ? 'Saved successfully' : 'Saved successfully',
                ),
              ).show(context);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final hasPermission = permissionService.hasPermission(
      AppPermissions.viewKraRoadMap,
    );

    if (!hasPermission) return noPermissionScreen();

    List<Roadmap> filteredRoadmaps =
        selectedFilter == "All Process (Core&Support)"
            ? roadmapList
            : roadmapList.where((roadmap) {
              final kra = kraList.firstWhere(
                (k) => k.id == roadmap.kraId,
                orElse: () => KeyResultArea(0, '', '', '', false),
              );
              return kra.name.trim().toLowerCase() ==
                  selectedFilter.trim().toLowerCase();
            }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPageHeader(isMobile),
          _buildFilterBar(isMobile),
          gap4px,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                    if (!isMobile)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "#",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "Process (Core & Support)",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Period",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Actions",
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                              : ListView.separated(
                                itemCount: filteredRoadmaps.length,
                                separatorBuilder:
                                    (_, __) => Divider(
                                      height: 1,
                                      color: Colors.grey.withValues(alpha: .2),
                                    ),
                                itemBuilder: (context, index) {
                                  final roadmap = filteredRoadmaps[index];
                                  final matchedKra = kraList.firstWhere(
                                    (kra) => kra.id == roadmap.kraId,
                                    orElse:
                                        () =>
                                            KeyResultArea(0, '', '', '', false),
                                  );
                                  final matchedKraRoadmap = kraListRoadmap
                                      .firstWhere(
                                        (kra) => kra.kraId == roadmap.kraId,
                                        orElse:
                                            () => KraRoadmapRole(
                                              kraId: 0,
                                              roleId: 'roleId',
                                              kraName: matchedKra.name,
                                              strategicObjectives: '',
                                            ),
                                      );
                                  final matchedKraPeriod = kraPeriodList
                                      .firstWhere(
                                        (p) =>
                                            p.id == roadmap.kraRoadMapPeriodId,
                                        orElse:
                                            () => KraRoadmapPeriod(
                                              0,
                                              DateTime.now(),
                                              DateTime.now(),
                                              isDeleted: false,
                                              rowVersion: '',
                                            ),
                                      );
                                  final kraPeriod =
                                      "${matchedKraPeriod.startYear.year} - ${matchedKraPeriod.endYear.year}";
                                  final itemNumber =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;

                                  if (!isMobile) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text("$itemNumber"),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(matchedKra.name),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(kraPeriod),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                PermissionWidget(
                                                  permission:
                                                      AppPermissions
                                                          .editKraRoadMap,
                                                  child: Tooltip(
                                                    message: 'Edit',
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.edit_outlined,
                                                        size: 18,
                                                      ),
                                                      onPressed: () async {
                                                        final roadmapDetails =
                                                            await _roadmapService
                                                                .getRoadmapId(
                                                                  roadmap.id!,
                                                                );
                                                        _showRoadmapMainDialog(
                                                          period:
                                                              matchedKraPeriod,
                                                          selectedKra:
                                                              matchedKraRoadmap,
                                                          roadmapToEdit:
                                                              roadmapDetails,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),

                                                Tooltip(
                                                  message: 'Print Preview',
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons
                                                          .description_outlined,
                                                      size: 18,
                                                      color: Colors.blueAccent,
                                                    ),
                                                    onPressed: () {
                                                      openRoadmapInNewTab(
                                                        roadmap.id.toString(),
                                                        roadmap.kra?.name ??
                                                            "Roadmap Report",
                                                      );
                                                    },
                                                  ),
                                                ),
                                                PermissionWidget(
                                                  permission:
                                                      AppPermissions
                                                          .editKraRoadMap,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      CupertinoIcons
                                                          .delete_simple,
                                                      size: 18,
                                                      color: Colors.redAccent,
                                                    ),
                                                    onPressed:
                                                        () => showDeleteDialog(
                                                          roadmap.id.toString(),
                                                        ),
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
                                              ),
                                            ),
                                            const Spacer(),
                                            PopupMenuButton<String>(
                                              color:
                                                  Theme.of(context).cardColor,
                                              icon: const Icon(Icons.more_vert),
                                              onSelected: (value) async {
                                                if (value == 'edit' &&
                                                    permissionService
                                                        .hasPermission(
                                                          AppPermissions
                                                              .editKraRoadMap,
                                                        )) {
                                                  final roadmapDetails =
                                                      await _roadmapService
                                                          .getRoadmapId(
                                                            roadmap.id!,
                                                          );
                                                  _showRoadmapMainDialog(
                                                    period: matchedKraPeriod,
                                                    selectedKra:
                                                        matchedKraRoadmap,
                                                    roadmapToEdit:
                                                        roadmapDetails,
                                                  );
                                                }
                                                if (value == 'preview') {
                                                  openRoadmapInNewTab(
                                                    roadmap.id.toString(),
                                                    roadmap.kra?.name ??
                                                        "Roadmap Report",
                                                  );
                                                }
                                                if (value == 'delete' &&
                                                    permissionService
                                                        .hasPermission(
                                                          AppPermissions
                                                              .editKraRoadMap,
                                                        )) {
                                                  showDeleteDialog(
                                                    roadmap.id.toString(),
                                                  );
                                                }
                                              },
                                              itemBuilder:
                                                  (_) => [
                                                    PopupMenuItem(
                                                      value: 'edit',
                                                      child: PermissionWidget(
                                                        permission:
                                                            AppPermissions
                                                                .viewKraRoadMap,
                                                        child: const Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .edit_outlined,
                                                              size: 18,
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text('Edit'),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const PopupMenuItem(
                                                      value: 'preview',
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .description_outlined,
                                                            size: 18,
                                                            color:
                                                                Colors
                                                                    .blueAccent,
                                                          ),
                                                          SizedBox(width: 8),
                                                          Text('Print preview'),
                                                        ],
                                                      ),
                                                    ),
                                                    PopupMenuItem(
                                                      value: 'delete',
                                                      child: PermissionWidget(
                                                        permission:
                                                            AppPermissions
                                                                .editKraRoadMap,
                                                        child: const Row(
                                                          children: [
                                                            Icon(
                                                              CupertinoIcons
                                                                  .delete_simple,
                                                              color: Colors.red,
                                                              size: 18,
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text('Delete'),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Process (Core & Support): ${matchedKra.name}",
                                        ),
                                        const SizedBox(height: 4),
                                        Text("Period: $kraPeriod"),
                                      ],
                                    ),
                                  );
                                },
                              ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: Theme.of(context).cardColor,
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
                            onPageChanged: (page) => fetchRoadmap(page: page),
                          ),
                          const SizedBox(width: 60),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton:
          isMobile
              ? FloatingActionButton(
                backgroundColor: primaryColor,
                onPressed: () => showProcess(),
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  Widget _buildPageHeader(bool isMobile) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.map, color: primaryColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Roadmap Information",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1D23),
                      ),
                    ),
                    Text(
                      "${filteredList.length} roadmap${filteredList.length != 1 ? 's' : ''} found",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isMobile)
                PermissionWidget(
                  permission: AppPermissions.addKraRoadMap,
                  child: ElevatedButton.icon(
                    onPressed: () => showProcess(),
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
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  bool get _hasActiveFilters => selectedFilter != "All Process (Core&Support)";

  void _resetFilters() {
    setState(() => selectedFilter = "All Process (Core&Support)");
  }

  Widget _buildFilterBar(bool isMobile) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEFF2)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: isMobile ? _buildMobileFilters() : _buildDesktopFilters(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.tune, size: 15, color: Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(
              "Filter by",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const Spacer(),
            if (_hasActiveFilters)
              TextButton.icon(
                onPressed: _resetFilters,
                icon: Icon(Icons.refresh, size: 14, color: Colors.red.shade400),
                label: Text(
                  'Clear filters',
                  style: TextStyle(fontSize: 12, color: Colors.red.shade400),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(spacing: 10, runSpacing: 10, children: [_buildRoadmapFilter()]),
      ],
    );
  }

  Widget _buildRoadmapFilter() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 400),
      child: SizedBox(
        height: 38,
        child: SearchableDropdown(
          items: [
            "All Process (Core&Support)",
            ...kraList.map((kra) => kra.name),
          ],
          prefixIcon: Icons.account_tree_outlined,
          selectedItem: selectedFilter,
          hintText: "Filter KRA",
          searchHint: "Search Process...",
          onChanged: (value) => setState(() => selectedFilter = value),
        ),
      ),
    );
  }

  Widget _buildMobileFilters() {
    return Row(
      children: [
        const Text(
          "Filter by",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 38,
            child: SearchableDropdown(
              items: [
                "All Process (Core&Support)",
                ...kraList.map((kra) => kra.name),
              ],
              selectedItem: selectedFilter,
              hintText: "Filter KRA",
              searchHint: "Search Process...",
              onChanged: (value) => setState(() => selectedFilter = value),
            ),
          ),
        ),
        if (_hasActiveFilters) ...[
          const SizedBox(width: 4),
          IconButton(
            onPressed: _resetFilters,
            icon: Icon(Icons.refresh, size: 18, color: Colors.red.shade400),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          ),
        ],
      ],
    );
  }

  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Confirm Delete"),
            content: const Text(
              "Are you sure you want to delete this Roadmap? This action cannot be undone.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: primaryTextColor),
                ),
              ),
              TextButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await _roadmapService.deleteRoadmap(id);
                    await fetchRoadmap();
                    MotionToast.success(
                      toastAlignment: Alignment.topCenter,
                      description: const Text('Deleted successfully'),
                    ).show(context);
                  } catch (e) {
                    MotionToast.error(
                      description: const Text('Failed to Delete'),
                    ).show(context);
                  }
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
