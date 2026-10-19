import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:motion_toast/motion_toast.dart';
import 'procedures_page.dart';

class ProcedureDoc {
  final int id;
  final Map<String, String> header;
  final String html;

  const ProcedureDoc({
    required this.id,
    required this.header,
    required this.html,
  });

  String get title => header['title'] ?? '';
  String get docCode => header['docCode'] ?? '';
  String get section => header['section'] ?? '';
  String get revision => header['revision'] ?? '';
  String get effectivity => header['effectivity'] ?? '';
  String get owner => header['owner'] ?? '';
}

class ProceduresListPage extends StatefulWidget {
  const ProceduresListPage({super.key});

  @override
  State<ProceduresListPage> createState() => _ProceduresListPageState();
}

class _ProceduresListPageState extends State<ProceduresListPage> {
  final _searchCtrl = TextEditingController();
  final int _pageSize = 15;

  // Palitan ng service call yung _items / _upsert / _remove (API fetch, save, delete).
  final List<ProcedureDoc> _items = [];
  int _nextId = 1;

  final bool _isLoading = false;
  int _currentPage = 1;
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<ProcedureDoc> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _items;
    return _items.where((d) {
      return d.title.toLowerCase().contains(q) ||
          d.docCode.toLowerCase().contains(q) ||
          d.section.toLowerCase().contains(q) ||
          d.owner.toLowerCase().contains(q);
    }).toList();
  }

  List<ProcedureDoc> get _paged {
    final all = _filtered;
    final start = (_currentPage - 1) * _pageSize;
    if (start >= all.length) return [];
    final end = (start + _pageSize).clamp(0, all.length);
    return all.sublist(start, end);
  }

  void _upsert(ProcedureDoc doc) {
    final i = _items.indexWhere((e) => e.id == doc.id);
    setState(() {
      if (i == -1) {
        _items.insert(0, doc);
      } else {
        _items[i] = doc;
      }
    });
  }

  void _remove(int id) => setState(() => _items.removeWhere((e) => e.id == id));

  // Editor is shown inside this page (same shell/sidebar), not a new route.
  bool _editing = false;
  ProcedureDoc? _editingDoc;
  int _editingId = 0;
  int _editorSeed = 0;

  void _openEditor({ProcedureDoc? doc}) {
    setState(() {
      _editingDoc = doc;
      _editingId = doc?.id ?? _nextId++;
      _editorSeed++;
      _editing = true;
    });
  }

  void _closeEditor() {
    if (mounted) setState(() => _editing = false);
  }

  void _confirmDelete(ProcedureDoc doc) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'Procedure',
            itemName: 'procedure',
            onDelete: () async {
              Navigator.pop(ctx);
              _remove(doc.id);
              if (!mounted) return;
              MotionToast.success(
                toastAlignment: Alignment.topCenter,
                description: Text(
                  'Procedure deleted successfully',
                  style: GoogleFonts.plusJakartaSans(),
                ),
              ).show(context);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_editing) {
      return ProceduresPage(
        key: ValueKey(_editorSeed),
        initialHtml: _editingDoc?.html,
        initialHeader: _editingDoc?.header,
        onClose: _closeEditor,
        onSaveDocument: (header, html) async {
          _upsert(ProcedureDoc(id: _editingId, header: header, html: html));
        },
      );
    }

    final isMobile = MediaQuery.of(context).size.width < 600;
    final rows = _paged;

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
                                  final doc = rows[index];
                                  final no =
                                      ((_currentPage - 1) * _pageSize) +
                                      index +
                                      1;
                                  return isMobile
                                      ? _buildMobileRow(no, doc)
                                      : _buildDesktopRow(no, doc);
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
                            totalItems: _filtered.length,
                            itemsPerPage: _pageSize,
                          ),
                          PaginationControls(
                            currentPage: _currentPage,
                            totalItems: _filtered.length,
                            itemsPerPage: _pageSize,
                            isLoading: _isLoading,
                            onPageChanged:
                                (page) => setState(() => _currentPage = page),
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
    final count = _filtered.length;

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
                      onChanged:
                          (v) => setState(() {
                            _query = v;
                            _currentPage = 1;
                          }),
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
                                  onPressed:
                                      () => setState(() {
                                        _searchCtrl.clear();
                                        _query = '';
                                        _currentPage = 1;
                                      }),
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
          Expanded(flex: 4, child: Text('Title', style: style)),
          Expanded(flex: 2, child: Text('Doc. Code', style: style)),
          Expanded(flex: 2, child: Text('Section', style: style)),
          Expanded(flex: 2, child: Text('Effectivity Date', style: style)),
          Expanded(flex: 2, child: Text('Actions', style: style)),
        ],
      ),
    );
  }

  Widget _buildDesktopRow(int no, ProcedureDoc doc) {
    const cell = TextStyle(fontSize: 12);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text('$no', style: cell)),
          Expanded(flex: 4, child: Text(doc.title, style: cell)),
          Expanded(flex: 2, child: Text(doc.docCode, style: cell)),
          Expanded(flex: 2, child: Text(doc.section, style: cell)),
          Expanded(flex: 2, child: Text(doc.effectivity, style: cell)),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Tooltip(
                  message: 'Edit',
                  child: IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    onPressed: () => _openEditor(doc: doc),
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
                    onPressed: () => _confirmDelete(doc),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileRow(int no, ProcedureDoc doc) {
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
                  if (v == 'edit') _openEditor(doc: doc);
                  if (v == 'delete') _confirmDelete(doc);
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
          Text('Title: ${doc.title}', style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            'Doc. Code: ${doc.docCode}',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text('Section: ${doc.section}', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
