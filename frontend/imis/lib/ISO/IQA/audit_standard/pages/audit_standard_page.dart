// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/ISO/IQA/audit_standard/models/audit_standard.dart';
import 'package:imis/ISO/IQA/audit_standard/services/audit_standard_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/widgets/dialog/dialog_field.dart';
import 'package:motion_toast/motion_toast.dart';

/// Settings -> Audit Standard. The standards kept here (e.g. "ISO 9001:2015")
/// are what the Audit Checklist prints as its audit scope and the Audit Report
/// prints as its audit standard.
class AuditStandardPage extends StatefulWidget {
  const AuditStandardPage({super.key});

  @override
  State<AuditStandardPage> createState() => _AuditStandardPageState();
}

class _AuditStandardPageState extends State<AuditStandardPage> {
  final _service = AuditStandardService(Dio());
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  List<AuditStandard> _all = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(() => setState(() {}));
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final list = await _service.getAll();
      if (mounted) setState(() => _all = list);
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<AuditStandard> get _filtered {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return _all;
    return _all.where((s) => s.name.toLowerCase().contains(q)).toList();
  }

  void _toast(String message, {bool error = false}) {
    final toast = error
        ? MotionToast.error(
            description: Text(message),
            toastAlignment: Alignment.topCenter,
          )
        : MotionToast.success(
            description: Text(message),
            toastAlignment: Alignment.topCenter,
          );
    toast.show(context);
  }

  // ---------------------------------------------------------------- form ---
  Future<void> _showForm({AuditStandard? existing}) async {
    final isEdit = existing != null;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: existing?.name ?? '');
    var isActive = existing?.isActive ?? true;
    var saving = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 420,
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
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.verified_outlined,
                          color: primaryColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEdit
                                ? 'Edit Audit Standard'
                                : 'Create Audit Standard',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: kText,
                            ),
                          ),
                          Text(
                            isEdit
                                ? 'Update the audit standard'
                                : 'Add a new audit standard',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: kMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: kBorder, height: 1),
                  const SizedBox(height: 20),
                  dialogField(
                    label: 'Audit Standard (e.g. ISO 9001:2015)',
                    controller: nameController,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please fill out this field'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: primaryColor,
                    title: Text(
                      'Active',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: kText,
                      ),
                    ),
                    subtitle: Text(
                      'An inactive standard is no longer used for new checklists.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: kMuted,
                      ),
                    ),
                    value: isActive,
                    onChanged: (v) => setDialogState(() => isActive = v),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: saving
                              ? null
                              : () => Navigator.pop(dialogContext),
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
                          icon: Icon(
                            isEdit ? Icons.save_rounded : Icons.add_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: Text(
                            isEdit ? 'Update' : 'Save',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: saving
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) return;
                                  setDialogState(() => saving = true);
                                  try {
                                    await _service.save(
                                      AuditStandard(
                                        id: existing?.id ?? 0,
                                        name: nameController.text.trim(),
                                        isActive: isActive,
                                        rowVersion: existing?.rowVersion,
                                      ),
                                    );
                                    if (dialogContext.mounted) {
                                      Navigator.pop(dialogContext);
                                    }
                                    _toast('Saved successfully!');
                                    await _load();
                                  } catch (e) {
                                    setDialogState(() => saving = false);
                                    _toast(
                                      e.toString().replaceFirst(
                                        'Exception: ',
                                        '',
                                      ),
                                      error: true,
                                    );
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    nameController.dispose();
  }

  // -------------------------------------------------------------- delete ---
  void _confirmDelete(AuditStandard standard) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: mainBgColor,
        title: const Text('Confirm Delete'),
        content: Text(
          'Are you sure you want to delete "${standard.name}"? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: TextStyle(color: primaryTextColor)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await _service.delete(standard.id);
                _toast('Audit standard deleted successfully');
                await _load();
              } catch (e) {
                _toast(
                  e.toString().replaceFirst('Exception: ', ''),
                  error: true,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------- build ---
  Widget _statusChip(bool active) {
    final color = active ? Colors.green.shade700 : Colors.grey.shade600;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        active ? 'Active' : 'Inactive',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _actions(AuditStandard standard) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Tooltip(
        message: 'Edit',
        child: IconButton(
          icon: const Icon(Icons.edit_outlined, size: 16),
          onPressed: () => _showForm(existing: standard),
        ),
      ),
      Tooltip(
        message: 'Delete',
        child: IconButton(
          icon: const Icon(
            CupertinoIcons.delete_simple,
            size: 16,
            color: Colors.redAccent,
          ),
          onPressed: () => _confirmDelete(standard),
        ),
      ),
    ],
  );

  Widget _row(AuditStandard standard, int number, bool isMobile) {
    if (!isMobile) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text('$number', style: const TextStyle(fontSize: 12)),
            ),
            Expanded(
              flex: 4,
              child: Text(
                standard.name,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _statusChip(standard.isActive),
              ),
            ),
            Expanded(flex: 2, child: _actions(standard)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$number. ${standard.name}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                _statusChip(standard.isActive),
              ],
            ),
          ),
          _actions(standard),
        ],
      ),
    );
  }

  Widget _body(List<AuditStandard> items, bool isMobile) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }
    if (items.isEmpty) {
      return Center(
        child: Text(
          'No audit standard yet.',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => _row(items[index], index + 1, isMobile),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final items = _filtered;

    const headStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Audit Standard',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'The audit standard is printed as the audit scope of the audit '
              'checklist and as the audit standard of the audit report.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  height: 36,
                  width: 250,
                  child: TextField(
                    focusNode: _searchFocus,
                    controller: _searchController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: lightGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Search...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: _searchFocus.hasFocus ? primaryColor : grey,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      filled: true,
                      fillColor: secondaryColor,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 5,
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const Spacer(),
                if (!isMobile)
                  ElevatedButton.icon(
                    onPressed: () => _showForm(),
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
              ],
            ),
            const SizedBox(height: 26),
            Expanded(
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
                            Expanded(flex: 1, child: Text('#', style: headStyle)),
                            Expanded(
                              flex: 4,
                              child: Text('Audit Standard', style: headStyle),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('Status', style: headStyle),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('Actions', style: headStyle),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 5),
                    Expanded(child: _body(items, isMobile)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isMobile
          ? FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () => _showForm(),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
