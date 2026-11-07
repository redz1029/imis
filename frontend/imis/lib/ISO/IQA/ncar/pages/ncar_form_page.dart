import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:imis/ISO/IQA/ncar/dialogs/ncar_attachments_dialog.dart';
import 'package:imis/ISO/IQA/ncar/models/nonconforming_action_report.dart';
import 'package:imis/ISO/IQA/ncar/pages/ncar_print_preview_page.dart';
import 'package:imis/ISO/IQA/ncar/services/ncar_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/permission_service.dart';

/// Opens the NCAR form (QP-03-F-08). Returns true when something was saved, so
/// the list can refresh.
Future<bool> showNcarForm(BuildContext context, int ncarId) async {
  final changed = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => NcarFormPage(ncarId: ncarId),
  );
  return changed == true;
}

/// The NCAR form, written by two sides in turn.
///
/// Auditor : the finding (issuance), then the verification, then the lead
///           auditor validates and closes.
/// Auditee : acknowledges, writes the root causes and the proposed actions,
///           and the department head approves them.
///
/// Every section can only be written by its own side and only while the form
/// has reached it; the server enforces the same rules.
class NcarFormPage extends StatefulWidget {
  const NcarFormPage({super.key, required this.ncarId});

  final int ncarId;

  @override
  State<NcarFormPage> createState() => _NcarFormPageState();
}

class _NcarFormPageState extends State<NcarFormPage> {
  final NcarService _service = NcarService(Dio());

  NonconformingActionReport? _ncar;
  bool _isLoading = true;
  bool _isAdmin = false;
  String? _loadError;

  /// The step being saved, or null.
  String? _busy;

  /// Something changed on the server: the list refreshes when the form closes.
  bool _changed = false;

  // Auditor: issuance
  final _standardCtrl = TextEditingController();
  final _requirementCtrl = TextEditingController();
  final _legalCtrl = TextEditingController();
  final _findingsCtrl = TextEditingController();
  bool _internalAudit = true;
  bool _externalAudit = false;
  bool _nonconformity = true;
  bool _internalCustomer = false;
  bool _externalCustomer = false;
  bool _complaint = false;
  bool _responseRate = false;
  bool _operations = false;

  // Auditee: response
  final List<TextEditingController> _rootCauses = [];
  final List<TextEditingController> _corrections = [];
  final List<TextEditingController> _correctives = [];

  // Auditor: verification
  final _verificationCtrl = TextEditingController();

  bool _can(String permission) =>
      _isAdmin || permissionService.hasPermission(permission);

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in [
      _standardCtrl,
      _requirementCtrl,
      _legalCtrl,
      _findingsCtrl,
      _verificationCtrl,
      ..._rootCauses,
      ..._corrections,
      ..._correctives,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    try {
      _isAdmin = await AuthUtil.isCurrentUserAdmin();
      final ncar = await _service.getNcarById(widget.ncarId);
      if (!mounted) return;
      if (ncar == null) {
        setState(() {
          _loadError = 'This NCAR could not be loaded.';
          _isLoading = false;
        });
        return;
      }
      _ncar = ncar;
      _fillIssuance(ncar);
      _fillResponse(ncar);
      _fillVerification(ncar);
      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = 'Error loading the NCAR: $e';
        _isLoading = false;
      });
    }
  }

  // --- filling the editors from the saved NCAR -------------------------------

  void _fillIssuance(NonconformingActionReport n) {
    _standardCtrl.text = n.relevantStandard;
    _requirementCtrl.text = n.standardRequirement;
    _legalCtrl.text = n.legalOrPolicyReference;
    _findingsCtrl.text = n.auditFindings;
    _internalAudit = n.isInternalAudit;
    _externalAudit = n.isExternalAudit;
    _nonconformity = n.isNonconformity;
    _internalCustomer = n.isInternalCustomer;
    _externalCustomer = n.isExternalCustomer;
    _complaint = n.isComplaint;
    _responseRate = n.isResponseRate;
    _operations = n.isOperations;
  }

  void _fillList(List<TextEditingController> target, List<String> values) {
    for (final c in target) {
      c.dispose();
    }
    target
      ..clear()
      ..addAll(values.map((v) => TextEditingController(text: v)));
    if (target.isEmpty) target.add(TextEditingController());
  }

  void _fillResponse(NonconformingActionReport n) {
    _fillList(_rootCauses, n.rootCauses);
    _fillList(_corrections, n.corrections);
    _fillList(_correctives, n.correctiveActions);
  }

  void _fillVerification(NonconformingActionReport n) {
    _verificationCtrl.text = n.verificationDetails ?? '';
  }

  // --- what each side may do now ---------------------------------------------

  bool get _closed => _ncar?.isClosed ?? false;
  bool get _acknowledged => _ncar?.acknowledgedDate != null;
  bool get _responded => _ncar?.proposedDate != null;
  bool get _approved => _ncar?.approvedDate != null;
  bool get _verified => _ncar?.verifiedDate != null;

  bool get _canEditIssuance =>
      !_closed && _can(AppPermissions.editNonconformingActionReport);
  bool get _canAcknowledge =>
      !_closed &&
      !_acknowledged &&
      _can(AppPermissions.nonconformingActionReportAcknowledge);
  bool get _canEditResponse =>
      !_closed &&
      _acknowledged &&
      !_approved &&
      _can(AppPermissions.nonconformingActionReportRespond);
  bool get _canApprove =>
      !_closed &&
      _responded &&
      !_approved &&
      _can(AppPermissions.nonconformingActionReportRespond);
  bool get _canVerify =>
      !_closed &&
      _approved &&
      _can(AppPermissions.nonconformingActionReportVerify);
  bool get _canClose =>
      !_closed &&
      _verified &&
      _can(AppPermissions.nonconformingActionReportValidateAndClose);

  // --- steps -----------------------------------------------------------------

  void _toast(String message, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: error ? Colors.red.shade700 : Colors.green.shade700,
        ),
      );
  }

  /// Runs one step; on success the saved NCAR replaces the loaded one.
  Future<void> _run(
    String step,
    Future<NonconformingActionReport> Function() action,
    String done, {
    void Function(NonconformingActionReport saved)? refill,
  }) async {
    if (_busy != null) return;
    setState(() => _busy = step);
    try {
      final saved = await action();
      if (!mounted) return;
      setState(() {
        _ncar = saved;
        _changed = true;
        refill?.call(saved);
      });
      _toast(done);
    } catch (e) {
      _toast(e.toString().replaceFirst('Exception: ', ''), error: true);
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  List<String> _texts(List<TextEditingController> controllers) => [
    for (final c in controllers)
      if (c.text.trim().isNotEmpty) c.text.trim(),
  ];

  Future<void> _saveIssuance() {
    if (_standardCtrl.text.trim().isEmpty) {
      _toast('The relevant standard is required.', error: true);
      return Future.value();
    }
    if (_requirementCtrl.text.trim().isEmpty) {
      _toast('The standard requirement is required.', error: true);
      return Future.value();
    }
    if (_findingsCtrl.text.trim().isEmpty) {
      _toast('The audit finding is required.', error: true);
      return Future.value();
    }
    return _run(
      'issuance',
      () => _service.saveIssuance(
        widget.ncarId,
        relevantStandard: _standardCtrl.text.trim(),
        standardRequirement: _requirementCtrl.text.trim(),
        legalOrPolicyReference: _legalCtrl.text.trim(),
        auditFindings: _findingsCtrl.text.trim(),
        isInternalAudit: _internalAudit,
        isExternalAudit: _externalAudit,
        isNonconformity: _nonconformity,
        isInternalCustomer: _internalCustomer,
        isExternalCustomer: _externalCustomer,
        isComplaint: _complaint,
        isResponseRate: _responseRate,
        isOperations: _operations,
      ),
      'Auditor section saved.',
      refill: _fillIssuance,
    );
  }

  Future<void> _acknowledge() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Acknowledge NCAR'),
        content: Text(
          'Acknowledge receipt of NCAR ${_ncar!.referenceNumber} for '
          '${_ncar!.office}? Your name and today\'s date are put on the form.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Acknowledge',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _run(
      'acknowledge',
      () => _service.acknowledge(widget.ncarId),
      'NCAR acknowledged.',
    );
  }

  Future<void> _saveResponse() {
    final rootCauses = _texts(_rootCauses);
    final corrections = _texts(_corrections);
    final correctives = _texts(_correctives);
    if (rootCauses.isEmpty) {
      _toast('Write at least one root cause.', error: true);
      return Future.value();
    }
    if (corrections.isEmpty && correctives.isEmpty) {
      _toast('Write at least one correction or corrective action.', error: true);
      return Future.value();
    }
    return _run(
      'response',
      () => _service.saveResponse(
        widget.ncarId,
        rootCauses: rootCauses,
        corrections: corrections,
        correctiveActions: correctives,
      ),
      'Response saved.',
      refill: _fillResponse,
    );
  }

  Future<void> _approve() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Approve proposed actions'),
        content: const Text(
          'Approve the root causes and the proposed actions as Department / '
          'Section Head? The office can no longer change them afterwards.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Approve', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _run(
      'approve',
      () => _service.approve(widget.ncarId),
      'Proposed actions approved.',
    );
  }

  Future<void> _saveVerification() {
    if (_verificationCtrl.text.trim().isEmpty) {
      _toast('Write what was observed when the actions were verified.', error: true);
      return Future.value();
    }
    return _run(
      'verification',
      () => _service.saveVerification(
        widget.ncarId,
        verificationDetails: _verificationCtrl.text.trim(),
      ),
      'Verification saved.',
      refill: _fillVerification,
    );
  }

  Future<void> _validateAndClose() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Validate & Close NCAR'),
        content: Text(
          'Validate the verification as Lead Auditor and close NCAR '
          '${_ncar!.referenceNumber}? A closed NCAR can no longer be changed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Validate & Close',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _run(
      'close',
      () => _service.validateAndClose(widget.ncarId),
      'NCAR validated and closed.',
    );
  }

  // --- building blocks -------------------------------------------------------

  String _date(DateTime? d) => d == null ? '—' : DateFormat('MMM d, yyyy').format(d);

  String _name(String? n) => (n == null || n.trim().isEmpty) ? '—' : n.trim();

  InputDecoration _decoration(String label, {String? hint}) => InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: const TextStyle(
      color: primaryColor,
      fontSize: 13,
      fontWeight: FontWeight.bold,
    ),
    alignLabelWithHint: true,
    isDense: true,
    filled: true,
    fillColor: const Color(0xFFFBFBFB),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
  );

  Widget _card({
    required String title,
    required String side,
    required Widget child,
    String? note,
  }) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: .04), blurRadius: 6),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: primaryColor,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: .08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                side,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ],
        ),
        const Divider(height: 20),
        child,
        if (note != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    note,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );

  /// "Label: value" line used for the signatures on the form.
  Widget _signed(String label, String? name, DateTime? date) => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Wrap(
      spacing: 24,
      runSpacing: 4,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$label ',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              TextSpan(
                text: _name(name),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Date: ',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              TextSpan(
                text: _date(date),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _fact(String label, String value) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.trim().isEmpty ? '—' : value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );

  Widget _saveButton({
    required String step,
    required String label,
    required VoidCallback onPressed,
    Color? color,
    IconData icon = Icons.save_outlined,
  }) => Align(
    alignment: Alignment.centerRight,
    child: Padding(
      padding: const EdgeInsets.only(top: 12),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: color ?? primaryColor),
        onPressed: _busy == null ? onPressed : null,
        icon:
            _busy == step
                ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                : Icon(icon, size: 16, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    ),
  );

  Widget _text(
    TextEditingController controller,
    String label, {
    required bool enabled,
    int minLines = 1,
    String? hint,
  }) => TextField(
    controller: controller,
    readOnly: !enabled,
    minLines: minLines,
    maxLines: null,
    keyboardType: TextInputType.multiline,
    style: const TextStyle(fontSize: 13),
    decoration: _decoration(label, hint: hint),
  );

  Widget _gap([double h = 12]) => SizedBox(height: h);

  /// A numbered list the auditee writes (root causes, corrections, ...).
  Widget _listEditor({
    required String label,
    required List<TextEditingController> controllers,
    required bool enabled,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
      const SizedBox(height: 8),
      for (var i = 0; i < controllers.length; i++)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 11, right: 8),
                child: Text(
                  '${i + 1}.',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controllers[i],
                  readOnly: !enabled,
                  minLines: 1,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xFFFBFBFB),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
              if (enabled)
                IconButton(
                  tooltip: 'Remove',
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed:
                      controllers.length > 1
                          ? () => setState(() {
                            controllers.removeAt(i).dispose();
                          })
                          : () => setState(() => controllers[i].clear()),
                ),
            ],
          ),
        ),
      if (enabled)
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => setState(() => controllers.add(TextEditingController())),
            icon: const Icon(Icons.add, color: primaryColor),
            label: const Text('Add'),
          ),
        ),
    ],
  );

  Widget _check(String label, bool value, ValueChanged<bool> onChanged, bool enabled) =>
      FilterChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        selected: value,
        onSelected: enabled ? onChanged : null,
        selectedColor: primaryColor.withValues(alpha: .15),
        checkmarkColor: primaryColor,
      );

  // --- sections --------------------------------------------------------------

  Widget _headerCard(NonconformingActionReport n) => _card(
    title: 'NONCONFORMING ACTION REPORT',
    side: n.isClosed ? 'CLOSED' : n.statusDisplay.toUpperCase(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _fact('REFERENCE NUMBER', n.referenceNumber),
            const SizedBox(width: 16),
            _fact('OFFICE', n.office),
            const SizedBox(width: 16),
            _fact('AUDIT DATE', _date(n.auditDate)),
          ],
        ),
      ],
    ),
  );

  Widget _issuanceCard(NonconformingActionReport n) {
    final enabled = _canEditIssuance;
    return _card(
      title: '1. THE FINDING',
      side: 'AUDITOR',
      note: enabled
          ? 'Written by the auditor. It can be changed until the NCAR is closed; '
              'a finding written here is no longer replaced by the checklist.'
          : _closed
          ? 'The NCAR is closed.'
          : 'Only an auditor can write this part.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NATURE / TYPE OF REPORT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _check('Internal Audit', _internalAudit, (v) => setState(() => _internalAudit = v), enabled),
              _check('External Audit', _externalAudit, (v) => setState(() => _externalAudit = v), enabled),
              _check('Nonconformity', _nonconformity, (v) => setState(() => _nonconformity = v), enabled),
              _check('Internal Customer / Interested Party', _internalCustomer, (v) => setState(() => _internalCustomer = v), enabled),
              _check('External Customer / Interested Party', _externalCustomer, (v) => setState(() => _externalCustomer = v), enabled),
              _check('Complaint', _complaint, (v) => setState(() => _complaint = v), enabled),
              _check('Response Rate', _responseRate, (v) => setState(() => _responseRate = v), enabled),
              _check('Operations', _operations, (v) => setState(() => _operations = v), enabled),
            ],
          ),
          _gap(),
          _text(_standardCtrl, 'RELEVANT STANDARD (CLAUSE)', enabled: enabled),
          _gap(),
          _text(
            _requirementCtrl,
            'THE STANDARD REQUIRES THAT...',
            enabled: enabled,
            minLines: 2,
          ),
          _gap(),
          _text(
            _legalCtrl,
            'LEGAL / POLICY REFERENCE (optional)',
            enabled: enabled,
            minLines: 2,
            hint: 'e.g. In accordance with AO 155, s. 2004, ...',
          ),
          _gap(),
          _text(
            _findingsCtrl,
            'AUDIT FINDING',
            enabled: enabled,
            minLines: 3,
            hint: 'At the time of the audit, ...',
          ),
          _signed('Issued by (Auditor):', n.issuedByAuditorName, n.issuedDate),
          if (enabled)
            _saveButton(
              step: 'issuance',
              label: 'Save Finding',
              onPressed: _saveIssuance,
            ),
        ],
      ),
    );
  }

  Widget _acknowledgeCard(NonconformingActionReport n) => _card(
    title: '2. ACKNOWLEDGEMENT',
    side: 'AUDITEE',
    note: _canAcknowledge
        ? 'The audited office confirms it received this NCAR.'
        : _acknowledged
        ? null
        : 'Waiting for the audited office to acknowledge.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _signed(
          'Acknowledged by (Auditee):',
          _acknowledged ? n.acknowledgedByAuditeeName : null,
          n.acknowledgedDate,
        ),
        if (_canAcknowledge)
          _saveButton(
            step: 'acknowledge',
            label: 'Acknowledge',
            onPressed: _acknowledge,
            icon: Icons.check,
          ),
      ],
    ),
  );

  Widget _responseCard(NonconformingActionReport n) {
    final enabled = _canEditResponse;
    return _card(
      title: '3. ROOT CAUSE ANALYSIS AND PROPOSED ACTIONS',
      side: 'AUDITEE',
      note: enabled
          ? 'Written by the audited office. It can be changed until the '
              'Department / Section Head approves it.'
          : !_acknowledged
          ? 'Open once the NCAR is acknowledged.'
          : _approved
          ? 'Approved: it can no longer be changed.'
          : 'Only the audited office can write this part.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _listEditor(
            label: 'ROOT CAUSE ANALYSIS',
            controllers: _rootCauses,
            enabled: enabled,
          ),
          _gap(8),
          _listEditor(
            label: 'CORRECTION',
            controllers: _corrections,
            enabled: enabled,
          ),
          _gap(8),
          _listEditor(
            label: 'CORRECTIVE',
            controllers: _correctives,
            enabled: enabled,
          ),
          _signed('Prepared by (Auditee):', _responded ? n.proposedByAuditeeName : null, n.proposedDate),
          if (enabled)
            _saveButton(
              step: 'response',
              label: _responded ? 'Update Response' : 'Submit Response',
              onPressed: _saveResponse,
            ),
        ],
      ),
    );
  }

  Widget _approvalCard(NonconformingActionReport n) => _card(
    title: '4. APPROVAL OF THE PROPOSED ACTIONS',
    side: 'DEPARTMENT / SECTION HEAD',
    note: _canApprove
        ? 'Approving puts the NCAR on the monitoring log and locks the response.'
        : !_responded
        ? 'Open once the audited office has submitted its response.'
        : null,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _signed(
          'Approved by (Department / Section Head):',
          _approved ? n.approvedByHeadName : null,
          n.approvedDate,
        ),
        if (_canApprove)
          _saveButton(
            step: 'approve',
            label: 'Approve',
            onPressed: _approve,
            icon: Icons.verified_outlined,
          ),
      ],
    ),
  );

  Widget _verificationCard(NonconformingActionReport n) {
    final enabled = _canVerify;
    return _card(
      title: '5. VERIFICATION',
      side: 'AUDITOR',
      note: enabled
          ? 'Written by the auditor after checking that the proposed actions were carried out.'
          : !_approved
          ? 'Open once the proposed actions are approved.'
          : _closed
          ? 'The NCAR is closed.'
          : 'Only an auditor can write this part.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _text(
            _verificationCtrl,
            'VERIFIED BY — WHAT WAS OBSERVED',
            enabled: enabled,
            minLines: 4,
            hint: 'Upon verification of the proposed action, it was observed that ...',
          ),
          _signed('Auditor:', _verified ? n.verifiedByAuditorName : null, n.verifiedDate),
          if (enabled)
            _saveButton(
              step: 'verification',
              label: _verified ? 'Update Verification' : 'Save Verification',
              onPressed: _saveVerification,
            ),
        ],
      ),
    );
  }

  Widget _validationCard(NonconformingActionReport n) => _card(
    title: '6. VALIDATION',
    side: 'LEAD AUDITOR',
    note: _canClose
        ? 'Validating closes the NCAR. A closed NCAR can no longer be changed.'
        : !_verified
        ? 'Open once the actions are verified.'
        : null,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _signed(
          'Validated by (Lead Auditor):',
          _closed ? n.validatedByLeadAuditorName : null,
          n.validatedDate,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              _closed ? Icons.check_box_outline_blank : Icons.check_box,
              size: 18,
              color: Colors.grey.shade700,
            ),
            const SizedBox(width: 4),
            const Text('Active', style: TextStyle(fontSize: 13)),
            const SizedBox(width: 20),
            Icon(
              _closed ? Icons.check_box : Icons.check_box_outline_blank,
              size: 18,
              color: Colors.grey.shade700,
            ),
            const SizedBox(width: 4),
            const Text('Closed', style: TextStyle(fontSize: 13)),
          ],
        ),
        if (_canClose)
          _saveButton(
            step: 'close',
            label: 'Validate & Close',
            onPressed: _validateAndClose,
            color: Colors.green.shade700,
            icon: Icons.check_circle_outline,
          ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final n = _ncar;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.pop(context, _changed);
      },
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 960,
            maxHeight: MediaQuery.of(context).size.height * .92,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF4F6F8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          n == null
                              ? 'NONCONFORMING ACTION REPORT (NCAR)'
                              : 'NCAR ${n.referenceNumber}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context, _changed),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child:
                      _isLoading
                          ? const Center(
                            child: CircularProgressIndicator(color: primaryColor),
                          )
                          : _loadError != null || n == null
                          ? Center(child: Text(_loadError ?? 'Unable to load.'))
                          : SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _headerCard(n),
                                _issuanceCard(n),
                                _acknowledgeCard(n),
                                _responseCard(n),
                                _approvalCard(n),
                                _verificationCard(n),
                                _validationCard(n),
                              ],
                            ),
                          ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (n != null)
                        OutlinedButton.icon(
                          onPressed: () => showNcarAttachmentsDialog(
                            context,
                            service: _service,
                            ncar: n,
                            canEdit:
                                !n.isClosed &&
                                _can(AppPermissions.nonconformingActionReportRespond),
                          ),
                          icon: const Icon(Icons.photo_library_outlined, size: 16),
                          label: const Text('Pictures'),
                        ),
                      if (n != null)
                        OutlinedButton.icon(
                          onPressed: () => openNcarPrintPreview(context, n.id),
                          icon: const Icon(Icons.print_outlined, size: 16),
                          label: const Text('Print'),
                        ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, _changed),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
