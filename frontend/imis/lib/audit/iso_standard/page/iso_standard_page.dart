import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/audit/iso_standard/models/clause_item.dart';
import 'package:imis/audit/iso_standard/service/iso_standard_service.dart';

class ClauseLibraryPage extends StatefulWidget {
  final int? versionId;

  const ClauseLibraryPage({super.key, this.versionId});

  @override
  State<ClauseLibraryPage> createState() => _ClauseLibraryPageState();
}

class _ClauseLibraryPageState extends State<ClauseLibraryPage> {
  static const Color primaryThemeColor = Color(0xFF883942);

  final IsoStandardService _service = IsoStandardService(Dio());
  final TextEditingController _searchController = TextEditingController();

  List<ClauseItem> _clauses = [];
  String _activeSearchQuery = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadClauses();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadClauses() async {
    setState(() => _isLoading = true);
    // Initialize with all 33 official ISO 9001:2015 standard clauses in exact natural order
    final items = List<ClauseItem>.from(kDefaultIsoClauses);

    try {
      final backendStandards = await _service.getAll();
      if (backendStandards.isNotEmpty) {
        for (var std in backendStandards) {
          final idx = items.indexWhere((c) => c.clause == std.clauseRef);
          if (idx != -1) {
            items[idx] = items[idx].copyWith(id: std.id);
          }
        }
      }
    } catch (_) {}

    items.sort((a, b) => compareClauseNumbers(a.clause, b.clause));

    if (mounted) {
      setState(() {
        _clauses = items;
        _isLoading = false;
      });
    }
  }

  void _onSearch() {
    setState(() {
      _activeSearchQuery = _searchController.text.trim();
    });
  }

  List<ClauseItem> get _filteredClauses {
    final query = _activeSearchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return _clauses;
    }
    return _clauses.where((c) {
      return c.clause.toLowerCase().contains(query) ||
          c.group.toLowerCase().contains(query) ||
          c.title.toLowerCase().contains(query) ||
          c.requirement.toLowerCase().contains(query);
    }).toList();
  }

  void _openEditDialog(ClauseItem item) {
    final clauseController = TextEditingController(text: item.clause);
    final groupController = TextEditingController(text: item.group);
    final titleController = TextEditingController(text: item.title);
    final requirementController = TextEditingController(text: item.requirement);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Edit Clause ${item.clause}',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldLabel('Clause Number'),
                const SizedBox(height: 6),
                TextField(
                  controller: clauseController,
                  decoration: _dialogInputDecoration('e.g. 4.1, 7.1.1'),
                ),
                const SizedBox(height: 14),
                _buildFieldLabel('Group'),
                const SizedBox(height: 6),
                TextField(
                  controller: groupController,
                  decoration: _dialogInputDecoration('e.g. 4 - Context of the organization'),
                ),
                const SizedBox(height: 14),
                _buildFieldLabel('Title'),
                const SizedBox(height: 6),
                TextField(
                  controller: titleController,
                  decoration: _dialogInputDecoration('Clause Title'),
                ),
                const SizedBox(height: 14),
                _buildFieldLabel('Requirement'),
                const SizedBox(height: 6),
                TextField(
                  controller: requirementController,
                  maxLines: 4,
                  decoration: _dialogInputDecoration('Requirement Description'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: Colors.grey.shade700)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryThemeColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            onPressed: () {
              final newClause = clauseController.text.trim();
              final newGroup = groupController.text.trim();
              final newTitle = titleController.text.trim();
              final newReq = requirementController.text.trim();

              if (newClause.isEmpty) return;

              final index = _clauses.indexOf(item);
              if (index != -1) {
                setState(() {
                  _clauses[index] = item.copyWith(
                    clause: newClause,
                    group: newGroup,
                    title: newTitle,
                    requirement: newReq,
                  );
                  _clauses.sort((a, b) => compareClauseNumbers(a.clause, b.clause));
                });
              }
              Navigator.pop(ctx);
            },
            child: Text('Save Changes', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _confirmRemove(ClauseItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Remove Clause'),
        content: Text('Are you sure you want to remove Clause ${item.clause}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: Colors.grey.shade700)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            onPressed: () {
              if (item.id != null) {
                _service.deleteStandard(item.id!);
              }
              setState(() {
                _clauses.remove(item);
              });
              Navigator.pop(ctx);
            },
            child: Text('Remove', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _openAddDialog() {
    final clauseController = TextEditingController();
    final groupController = TextEditingController();
    final titleController = TextEditingController();
    final requirementController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Add New Clause',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFieldLabel('Clause Number'),
                const SizedBox(height: 6),
                TextField(
                  controller: clauseController,
                  decoration: _dialogInputDecoration('e.g. 4.1, 7.1.1'),
                ),
                const SizedBox(height: 14),
                _buildFieldLabel('Group'),
                const SizedBox(height: 6),
                TextField(
                  controller: groupController,
                  decoration: _dialogInputDecoration('e.g. 4 - Context of the organization'),
                ),
                const SizedBox(height: 14),
                _buildFieldLabel('Title'),
                const SizedBox(height: 6),
                TextField(
                  controller: titleController,
                  decoration: _dialogInputDecoration('Clause Title'),
                ),
                const SizedBox(height: 14),
                _buildFieldLabel('Requirement'),
                const SizedBox(height: 6),
                TextField(
                  controller: requirementController,
                  maxLines: 4,
                  decoration: _dialogInputDecoration('Requirement Description'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: Colors.grey.shade700)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryThemeColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            onPressed: () {
              final newClause = clauseController.text.trim();
              final newGroup = groupController.text.trim();
              final newTitle = titleController.text.trim();
              final newReq = requirementController.text.trim();

              if (newClause.isEmpty) return;

              setState(() {
                _clauses.add(ClauseItem(
                  clause: newClause,
                  group: newGroup,
                  title: newTitle,
                  requirement: newReq,
                ));
                _clauses.sort((a, b) => compareClauseNumbers(a.clause, b.clause));
              });
              Navigator.pop(ctx);
            },
            child: Text('Add Clause', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w600,
        fontSize: 13,
        color: const Color(0xFF374151),
      ),
    );
  }

  InputDecoration _dialogInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.grey.shade400),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
        borderSide: const BorderSide(color: primaryThemeColor, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredClauses;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'Auditor Guide — Clause Library',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: const Color(0xFF111827),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryThemeColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Search and Add Controls
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          constraints: const BoxConstraints(maxWidth: 420),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFD1D5DB)),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onSubmitted: (_) => _onSearch(),
                            onChanged: (val) {
                              setState(() => _activeSearchQuery = val);
                            },
                            style: GoogleFonts.plusJakartaSans(fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Search clause number, title or requirement',
                              hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFF9CA3AF)),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 16, color: Colors.grey),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _activeSearchQuery = '');
                                      },
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: _onSearch,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Search',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: const Color(0xFF374151),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryThemeColor,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        onPressed: _openAddDialog,
                        icon: const Icon(Icons.add, size: 16, color: Colors.white),
                        label: Text(
                          'Add Clause',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Table Container Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 1100),
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
                          headingRowHeight: 48,
                          dataRowMinHeight: 64,
                          dataRowMaxHeight: 90,
                          horizontalMargin: 20,
                          columnSpacing: 24,
                          columns: [
                            DataColumn(
                              label: Text(
                                'CLAUSE',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  letterSpacing: 0.5,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'GROUP',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  letterSpacing: 0.5,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'TITLE',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  letterSpacing: 0.5,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'REQUIREMENT',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  letterSpacing: 0.5,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                '',
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          ],
                          rows: filtered.isEmpty
                              ? [
                                  DataRow(
                                    cells: [
                                      const DataCell(Text('')),
                                      const DataCell(Text('')),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            'No clauses match your search.',
                                            style: GoogleFonts.plusJakartaSans(color: Colors.grey.shade600),
                                          ),
                                        ),
                                      ),
                                      const DataCell(Text('')),
                                      const DataCell(Text('')),
                                    ],
                                  ),
                                ]
                              : filtered.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          item.clause,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: const Color(0xFF111827),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 220,
                                          child: Text(
                                            item.group,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 13,
                                              color: const Color(0xFF374151),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        SizedBox(
                                          width: 260,
                                          child: Text(
                                            item.title,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 13,
                                              color: const Color(0xFF374151),
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Container(
                                          constraints: const BoxConstraints(maxWidth: 460),
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          child: Text(
                                            item.requirement,
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 13,
                                              color: const Color(0xFF4B5563),
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () => _openEditDialog(item),
                                              borderRadius: BorderRadius.circular(6),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFF3F4F6),
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(color: const Color(0xFFE5E7EB)),
                                                ),
                                                child: Text(
                                                  'Edit',
                                                  style: GoogleFonts.plusJakartaSans(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color: const Color(0xFF374151),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            InkWell(
                                              onTap: () => _confirmRemove(item),
                                              borderRadius: BorderRadius.circular(6),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFF3F4F6),
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(color: const Color(0xFFE5E7EB)),
                                                ),
                                                child: Text(
                                                  'Remove',
                                                  style: GoogleFonts.plusJakartaSans(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color: const Color(0xFF374151),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
