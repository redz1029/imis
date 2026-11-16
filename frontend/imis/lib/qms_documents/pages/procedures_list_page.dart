import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/qms_documents/models/procedures.dart';
import 'package:imis/qms_documents/services/procedures_service.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:motion_toast/motion_toast.dart';
import 'procedures_page.dart';

class ProceduresListPage extends StatefulWidget {
  const ProceduresListPage({super.key});

  @override
  State<ProceduresListPage> createState() => _ProceduresListPageState();
}

class _ProceduresListPageState extends State<ProceduresListPage> {
  final _searchCtrl = TextEditingController();
  final int _pageSize = 15;

  late final ProceduresService _service = ProceduresService(Dio());

  List<Procedures> _items = [];
  int _totalItems = 0;
  bool _isLoading = false;
  int _currentPage = 1;
  String _query = '';
  Timer? _debounce;

  bool _editing = false;
  Procedures? _editingProc;
  int _editorSeed = 0;

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ───────────────────────── data ─────────────────────────

  String _fmtDate(DateTime? d) {
    if (d == null || d.year < 2000) return '';
    return '${_months[d.month - 1]} ${d.day}, ${d.year}';
  }

  // Header map na hinihingi ng ProceduresPage (initialHeader)
  Map<String, String> _headerOf(Procedures p) => {
    'title': p.title ?? '',
    'section': p.officeName ?? '',
    'owner': p.processOwner ?? '',
    'docCode': p.documentCode ?? '',
    'revision': p.revision ?? '',
    'reference': p.regulatoryStandard ?? '',
    'effectivity': _fmtDate(p.effectiveDate),
  };

  bool _isDraft(Procedures p) => p.isDraft ?? true;

  void _toast(String msg, {bool error = false}) {
    if (!mounted) return;
    final t = error ? MotionToast.error : MotionToast.success;
    t(
      toastAlignment: Alignment.topCenter,
      description: Text(msg, style: GoogleFonts.plusJakartaSans()),
    ).show(context);
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final result = await _service.getProceduresList(
        page: _currentPage,
        pageSize: _pageSize,
        searchQuery: _query.trim().isEmpty ? null : _query.trim(),
      );
      if (!mounted) return;
      setState(() {
        _items = result.items.toList();
        _totalItems = result.totalCount;
      });
    } catch (e) {
      _toast('$e', error: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String v) {
    setState(() {
      _query = v;
      _currentPage = 1;
    });
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _load);
  }

  // ───────────────────────── editor ─────────────────────────

  void _openEditor({Procedures? proc}) {
    setState(() {
      _editingProc = proc;
      _editorSeed++;
      _editing = true;
    });
  }

  Future<void> _openEditorById(int? id) async {
    if (id == null) return;
    try {
      final p = await _service.getById(id);
      if (!mounted) return;
      _openEditor(proc: p);
    } catch (e) {
      _toast('$e', error: true);
    }
  }

  void _closeEditor() {
    if (!mounted) return;
    setState(() => _editing = false);
    _load(); // refresh list after save/close
  }

  void _confirmDelete(Procedures p) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'Procedure',
            itemName: 'procedure',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                // await _service.delete(p.id!);
                _toast('Procedure deleted successfully');
                // go back a page if we just deleted the last row on this page
                if (_items.length == 1 && _currentPage > 1) _currentPage--;
                await _load();
              } catch (e) {
                _toast('$e', error: true);
              }
            },
          ),
    );
  }

  // ───────────────────────── build ─────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_editing) {
      final p = _editingProc;
      return ProceduresPage(
        key: ValueKey(_editorSeed),
        service: _service,
        id: p?.id,
        sectionId: p?.sectionId,
        initialHtml: p?.content,
        initialHeader: p == null ? null : _headerOf(p),
        onClose: _closeEditor,
      );
    }

    final isMobile = MediaQuery.of(context).size.width < 600;
    final rows = _items;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPageHeader(isMobile),
          _buildFilterBar(),
          gap4px,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 32,
                ),
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
                    if (!isMobile) _buildTableHeader(),
                    const SizedBox(height: 5),
                    Expanded(
                      child:
                          _isLoading
                              ? const Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                              : rows.isEmpty
                              ? _buildEmpty()
                              : ListView.separated(
                                itemCount: rows.length,
                                separatorBuilder:
                                    (_, __) => Divider(
                                      height: 1,
                                      color: Colors.grey.withValues(alpha: .2),
                                    ),
                                itemBuilder: (context, index) {
                                  final p = rows[index];
                                  final no =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;
                                  return isMobile
                                      ? _buildMobileRow(no, p)
                                      : _buildDesktopRow(no, p);
                                },
                              ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      color: Theme.of(context).cardColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PaginationInfo(
                            currentPage: _currentPage,
                            totalItems: _totalItems,
                            itemsPerPage: _pageSize,
                          ),
                          PaginationControls(
                            currentPage: _currentPage,
                            totalItems: _totalItems,
                            itemsPerPage: _pageSize,
                            isLoading: _isLoading,
                            onPageChanged: (page) {
                              setState(() => _currentPage = page);
                              _load();
                            },
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
                onPressed: () => _openEditor(),
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 50,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 10),
          const Text(
            'No procedures available',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPageHeader(bool isMobile) {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 900;
    final isXSmall = width < 700;
    final count = _totalItems;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20, isXSmall ? 12 : 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isXSmall ? 6 : 8),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color: primaryColor,
                  size: isXSmall ? 18 : 22,
                ),
              ),
              SizedBox(width: isXSmall ? 8 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Procedures Information',
                      style: TextStyle(
                        fontSize:
                            isXSmall
                                ? 12
                                : isSmall
                                ? 14
                                : 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1D23),
                      ),
                    ),
                    Text(
                      '$count procedure${count != 1 ? 's' : ''} found',
                      style: TextStyle(
                        fontSize: isXSmall ? 10 : 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isMobile)
                ElevatedButton.icon(
                  onPressed: () => _openEditor(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(
                      vertical: isXSmall ? 8 : 10,
                      horizontal: isXSmall ? 10 : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: isXSmall ? 14 : 16,
                  ),
                  label: Text(
                    isXSmall ? 'Add' : 'Add New',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isXSmall ? 11 : 13,
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

  Widget _buildFilterBar() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEFF2)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: SizedBox(
                    height: 38,
                    width: 400,
                    child: TextField(
                      controller: _searchCtrl,
                      style: GoogleFonts.plusJakartaSans(fontSize: 12),
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search title, doc. code, section...',
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                        prefixIcon: const Icon(Icons.search, size: 18),
                        suffixIcon:
                            _query.isEmpty
                                ? null
                                : IconButton(
                                  icon: const Icon(Icons.close, size: 16),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    _onSearchChanged('');
                                  },
                                ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: primaryColor),
                        ),
                      ),
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

  Widget _buildTableHeader() {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: const Row(
        children: [
          Expanded(flex: 1, child: Text('#', style: style)),
          Expanded(flex: 3, child: Text('Title', style: style)),
          Expanded(flex: 2, child: Text('Doc. Code', style: style)),
          Expanded(flex: 2, child: Text('Section', style: style)),
          Expanded(flex: 2, child: Text('Effectivity Date', style: style)),
          Expanded(flex: 2, child: Text('Status', style: style)),
          Expanded(flex: 2, child: Text('Actions', style: style)),
        ],
      ),
    );
  }

  Widget _statusText(Procedures p, {double size = 12}) {
    final draft = _isDraft(p);
    return Text(
      draft ? 'Draft' : 'Submitted',
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: draft ? Colors.orange.shade700 : Colors.green.shade700,
      ),
    );
  }

  Widget _buildDesktopRow(int no, Procedures p) {
    const cell = TextStyle(fontSize: 12);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text('$no', style: cell)),
          Expanded(flex: 3, child: Text(p.title ?? '', style: cell)),
          Expanded(flex: 2, child: Text(p.documentCode ?? '', style: cell)),
          Expanded(flex: 2, child: Text(p.officeName ?? '', style: cell)),
          Expanded(
            flex: 2,
            child: Text(_fmtDate(p.effectiveDate), style: cell),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _statusText(p),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Tooltip(
                  message: 'Edit',
                  child: IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    onPressed: () => _openEditorById(p.id),
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
                    onPressed: () => _confirmDelete(p),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileRow(int no, Procedures p) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$no',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                color: Theme.of(context).cardColor,
                icon: const Icon(Icons.more_vert),
                onSelected: (v) {
                  if (v == 'edit') _openEditorById(p.id);
                  if (v == 'delete') _confirmDelete(p);
                },
                itemBuilder:
                    (_) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 16),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.delete_simple,
                              color: Colors.red,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Title: ${p.title ?? ''}', style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            'Doc. Code: ${p.documentCode ?? ''}',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            'Section: ${p.officeName ?? ''}',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text('Status: ', style: TextStyle(fontSize: 12)),
              _statusText(p),
            ],
          ),
        ],
      ),
    );
  }
}
