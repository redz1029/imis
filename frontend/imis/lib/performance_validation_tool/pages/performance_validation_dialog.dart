import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

class PerformanceValidationDialog extends StatefulWidget {
  const PerformanceValidationDialog({super.key});

  @override
  State<PerformanceValidationDialog> createState() =>
      _PerformanceValidationDialogState();
}

class _PerformanceValidationDialogState
    extends State<PerformanceValidationDialog> {
  final _formKey = GlobalKey<FormState>();

  final _monthCtrl = TextEditingController();
  final List<TextEditingController> _validatorCtrls = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final _officeDeptCtrl = TextEditingController();
  final _headCtrl = TextEditingController();
  final _validationDateCtrl = TextEditingController();
  final _periodCoveredCtrl = TextEditingController();

  final List<Map<String, dynamic>> _findingRows = List.generate(
    10,
    (i) => {
      'no': i + 1,
      'deliverable': TextEditingController(),
      'findings': TextEditingController(),
      'nc': false,
      'ofi': false,
    },
  );

  final List<TextEditingController> _commendationCtrls = List.generate(
    3,
    (_) => TextEditingController(),
  );

  String? _conclusion;
  final List<String> _conclusionOptions = [
    'Fully Compliant',
    'Compliant with Minor Opportunities for Improvement',
    'Partially Compliant',
    'Requires Immediate Corrective Action',
  ];

  final _preparedByCtrl = TextEditingController();
  final _preparedDateCtrl = TextEditingController();
  final _acknowledgedByCtrl = TextEditingController();
  final _acknowledgedDateCtrl = TextEditingController();
  final _approvedByCtrl = TextEditingController();
  final _approvedDateCtrl = TextEditingController();

  bool _submitting = false;

  @override
  void dispose() {
    _monthCtrl.dispose();
    for (final c in _validatorCtrls) {
      c.dispose();
    }
    _officeDeptCtrl.dispose();
    _headCtrl.dispose();
    _validationDateCtrl.dispose();
    _periodCoveredCtrl.dispose();
    for (final row in _findingRows) {
      (row['deliverable'] as TextEditingController).dispose();
      (row['findings'] as TextEditingController).dispose();
    }
    for (final c in _commendationCtrls) {
      c.dispose();
    }
    _preparedByCtrl.dispose();
    _preparedDateCtrl.dispose();
    _acknowledgedByCtrl.dispose();
    _acknowledgedDateCtrl.dispose();
    _approvedByCtrl.dispose();
    _approvedDateCtrl.dispose();
    super.dispose();
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(top: 18, bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: primaryColor,
        letterSpacing: 0.3,
      ),
    ),
  );

  Widget _fieldLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: primaryTextColor,
      ),
    ),
  );

  Widget _inputField(
    TextEditingController ctrl, {
    String hint = '',
    bool required = false,
    int maxLines = 1,
  }) => TextFormField(
    controller: ctrl,
    maxLines: maxLines,
    style: const TextStyle(fontSize: 12),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade400),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: kBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: kBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    ),
    validator:
        required
            ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
            : null,
  );

  Widget _buildGeneralInfo(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('I. GENERAL INFORMATION'),
        _fieldLabel('For the month of'),
        _inputField(_monthCtrl, hint: 'e.g. January 2025', required: true),
        const SizedBox(height: 12),
        _fieldLabel('Validators (up to 6)'),
        isMobile
            ? Column(
              children: List.generate(
                6,
                (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22,
                        child: Text(
                          '${i + 1}.',
                          style: const TextStyle(
                            fontSize: 12,
                            color: primaryTextColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _inputField(
                          _validatorCtrls[i],
                          hint: 'Validator ${i + 1}',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: List.generate(
                      3,
                      (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 22,
                              child: Text(
                                '${i + 1}.',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: primaryTextColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: _inputField(
                                _validatorCtrls[i],
                                hint: 'Validator ${i + 1}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: List.generate(
                      3,
                      (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 22,
                              child: Text(
                                '${i + 4}.',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: primaryTextColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: _inputField(
                                _validatorCtrls[i + 3],
                                hint: 'Validator ${i + 4}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        const SizedBox(height: 10),
        _fieldLabel('Validated Office/Department/Section/Unit/Committee'),
        _inputField(_officeDeptCtrl, hint: 'Office name', required: true),
        const SizedBox(height: 10),
        _fieldLabel('Head of Validated Office/Unit'),
        _inputField(_headCtrl, hint: 'Full name', required: true),
        const SizedBox(height: 10),
        isMobile
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fieldLabel('Validation Date'),
                _inputField(
                  _validationDateCtrl,
                  hint: 'e.g. January 15, 2025',
                  required: true,
                ),
                const SizedBox(height: 10),
                _fieldLabel('Validation Period Covered'),
                _inputField(
                  _periodCoveredCtrl,
                  hint: 'e.g. Jan – Dec 2024',
                  required: true,
                ),
              ],
            )
            : Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('Validation Date'),
                      _inputField(
                        _validationDateCtrl,
                        hint: 'e.g. January 15, 2025',
                        required: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldLabel('Validation Period Covered'),
                      _inputField(
                        _periodCoveredCtrl,
                        hint: 'e.g. Jan – Dec 2024',
                        required: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
      ],
    );
  }

  Widget _buildValidationObjectives() {
    final objectives = [
      'Assess compliance with the Performance Governance System (PGS)',
      'Verify implementation of approved strategic initiatives',
      'Monitor progress of deliverables',
      'Identify opportunities for improvement',
      'Validate submitted reports and supporting documents',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('II. VALIDATION OBJECTIVES'),
        const Text(
          'The validation was conducted to:',
          style: TextStyle(fontSize: 12, color: primaryTextColor),
        ),
        const SizedBox(height: 6),
        ...objectives.map(
          (o) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    o,
                    style: const TextStyle(
                      fontSize: 12,
                      color: primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCriteriaDocuments() {
    final items = [
      'PGS Framework',
      'Strategy Map',
      'Scorecard/KPIs',
      'Office Performance Commitment',
      'Approved Policies and Procedures',
      'Monthly Accomplishment Reports',
      'Relevant Documented Information (such as SPCR, IPCR, WFP, 5-Year Development Plan, RMR, SWOT, QOTP)',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('III. VALIDATION CRITERIA / REFERENCE DOCUMENTS'),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• ',
                  style: TextStyle(fontSize: 12, color: primaryTextColor),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 12,
                      color: primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValidationFindings(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('IV. VALIDATION FINDINGS'),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: kBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              // Table header
              Container(
                color: kPrimaryLight,
                child:
                    isMobile
                        ? const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 28,
                                child: Text(
                                  'No.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Deliverable',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Findings',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: 36,
                                child: Text(
                                  'NC',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 36,
                                child: Text(
                                  'OFI',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        : const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 32,
                                child: Text(
                                  'No.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Deliverable',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Findings',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              SizedBox(
                                width: 44,
                                child: Text(
                                  'NC',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 44,
                                child: Text(
                                  'OFI',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
              ),
              const Divider(height: 1, color: kBorder),
              // Rows
              ...List.generate(_findingRows.length, (i) {
                final row = _findingRows[i];
                final isEven = i.isEven;
                return Container(
                  color: isEven ? Colors.white : const Color(0xFFF8FAFD),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 8 : 10,
                      vertical: 4,
                    ),
                    child:
                        isMobile
                            ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 28,
                                  child: Text(
                                    '${row['no']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: _inputField(
                                    row['deliverable'] as TextEditingController,
                                    hint: 'Enter deliverable…',
                                    maxLines: 2,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  flex: 2,
                                  child: _inputField(
                                    row['findings'] as TextEditingController,
                                    hint: 'Findings…',
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(
                                  width: 36,
                                  child: Checkbox(
                                    value: row['nc'] as bool,
                                    activeColor: primaryColor,
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    onChanged:
                                        (v) => setState(
                                          () => row['nc'] = v ?? false,
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  width: 36,
                                  child: Checkbox(
                                    value: row['ofi'] as bool,
                                    activeColor: Colors.orange,
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    onChanged:
                                        (v) => setState(
                                          () => row['ofi'] = v ?? false,
                                        ),
                                  ),
                                ),
                              ],
                            )
                            : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 32,
                                  child: Text(
                                    '${row['no']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: _inputField(
                                    row['deliverable'] as TextEditingController,
                                    hint: 'Copy and paste deliverable here…',
                                    maxLines: 2,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 3,
                                  child: _inputField(
                                    row['findings'] as TextEditingController,
                                    hint: 'Enter findings…',
                                    maxLines: 2,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 44,
                                  child: Center(
                                    child: Checkbox(
                                      value: row['nc'] as bool,
                                      activeColor: primaryColor,
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      onChanged:
                                          (v) => setState(
                                            () => row['nc'] = v ?? false,
                                          ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 44,
                                  child: Center(
                                    child: Checkbox(
                                      value: row['ofi'] as bool,
                                      activeColor: Colors.orange,
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      onChanged:
                                          (v) => setState(
                                            () => row['ofi'] = v ?? false,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('V. COMMENDATIONS'),
        ...List.generate(
          3,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 22,
                  child: Text(
                    '${i + 1}.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: primaryTextColor,
                    ),
                  ),
                ),
                Expanded(
                  child: _inputField(
                    _commendationCtrls[i],
                    hint: 'Commendation ${i + 1}',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConclusion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('VI. VALIDATION CONCLUSION'),
        const Text(
          'Based on the validation conducted, the validated office/unit is assessed as:',
          style: TextStyle(fontSize: 12, color: primaryTextColor),
        ),
        const SizedBox(height: 8),
        ..._conclusionOptions.map(
          (opt) => RadioListTile<String>(
            dense: true,
            activeColor: primaryColor,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            title: Text(opt, style: const TextStyle(fontSize: 12)),
            value: opt,
            groupValue: _conclusion,
            onChanged: (v) => setState(() => _conclusion = v),
          ),
        ),
      ],
    );
  }

  Widget _buildSignatories(bool isMobile) {
    Widget sigField(
      String label,
      TextEditingController nameCtrl,
      TextEditingController dateCtrl,
    ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel(label),
          _inputField(nameCtrl, hint: 'Full name'),
          const SizedBox(height: 4),
          _inputField(dateCtrl, hint: 'Date'),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 24, color: kBorder),
        isMobile
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sigField(
                  'Prepared by (Head of Validated Office)',
                  _preparedByCtrl,
                  _preparedDateCtrl,
                ),
                const SizedBox(height: 12),
                sigField(
                  'Acknowledged by (Validation Team Leader)',
                  _acknowledgedByCtrl,
                  _acknowledgedDateCtrl,
                ),
                const SizedBox(height: 12),
                sigField(
                  'Approved by (Team Leader, OSM – Performance Management and Analytics)',
                  _approvedByCtrl,
                  _approvedDateCtrl,
                ),
              ],
            )
            : Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: sigField(
                        'Prepared by (Head of Validated Office)',
                        _preparedByCtrl,
                        _preparedDateCtrl,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: sigField(
                        'Acknowledged by (Validation Team Leader)',
                        _acknowledgedByCtrl,
                        _acknowledgedDateCtrl,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: sigField(
                        'Approved by (Team Leader, OSM – Performance Management and Analytics)',
                        _approvedByCtrl,
                        _approvedDateCtrl,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ],
            ),
      ],
    );
  }

  // ─── footer ──────────────────────────────────────────────────────────────

  Widget _buildFooter(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: isMobile ? 10 : 14,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFD),
        border: Border(top: BorderSide(color: kBorder)),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_submitting)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primaryColor,
                ),
              ),
            ),
          OutlinedButton(
            onPressed: _submitting ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: const BorderSide(color: primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 14 : 22,
                vertical: isMobile ? 8 : 12,
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: isMobile ? 11 : 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed:
                _submitting
                    ? null
                    : () async {
                      if (!_formKey.currentState!.validate()) return;
                      if (_conclusion == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please select a Validation Conclusion.',
                            ),
                          ),
                        );
                        return;
                      }
                      setState(() => _submitting = true);
                      // TODO: wire to your save service here
                      await Future.delayed(const Duration(milliseconds: 800));
                      if (mounted) {
                        setState(() => _submitting = false);
                        Navigator.pop(context, true);
                      }
                    },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 18 : 28,
                vertical: isMobile ? 8 : 12,
              ),
              elevation: 2,
            ),
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: isMobile ? 11 : 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = size.width < 640;
    final dWidth =
        isMobile
            ? size.width * 0.97
            : size.width < 900
            ? size.width * 0.92
            : size.width < 1200
            ? size.width * 0.80
            : size.width * 0.65;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 4 : 24,
        vertical: isMobile ? 8 : 20,
      ),
      child: Container(
        width: dWidth,
        constraints: BoxConstraints(maxHeight: size.height * 0.93),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(.15),
              blurRadius: 40,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Dialog header
            Container(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 14 : 24,
                isMobile ? 14 : 18,
                14,
                12,
              ),
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.fact_check_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Performance Validation Tool',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: isMobile ? 13 : 15,
                          ),
                        ),
                        Text(
                          'Cotabato Regional and Medical Center',
                          style: TextStyle(
                            color: Colors.white.withOpacity(.75),
                            fontSize: isMobile ? 10 : 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // ── Scrollable body
            Flexible(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 14 : 28,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildGeneralInfo(isMobile),
                      _buildValidationObjectives(),
                      _buildCriteriaDocuments(),
                      _buildValidationFindings(isMobile),
                      _buildCommendations(),
                      _buildConclusion(),
                      _buildSignatories(isMobile),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),

            // ── Footer
            _buildFooter(isMobile),
          ],
        ),
      ),
    );
  }
}
