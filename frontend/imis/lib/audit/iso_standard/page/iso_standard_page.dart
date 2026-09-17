import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/audit/iso_standard/models/iso_standard.dart';
import 'package:imis/audit/iso_standard/service/iso_standard_service.dart';
import 'package:imis/constant/constant.dart';

class ClauseLibraryPage extends StatefulWidget {
  final int? versionId;

  // Made versionId optional - no required parameters
  const ClauseLibraryPage({super.key, this.versionId});

  @override
  State<ClauseLibraryPage> createState() => _ClauseLibraryPageState();
}

class _ClauseLibraryPageState extends State<ClauseLibraryPage> {
  static const Color primaryThemeColor = Color(0xFF883942);

  final IsoStandardService _service = IsoStandardService(Dio());

  bool _isLoading = true;
  String? _errorMessage;
  List<IsoStandard> _tree = [];

  final TextEditingController _searchController = TextEditingController();
  List<IsoStandard>? _searchResults;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Default to version ID 1 if none was provided in navigation
      final effectiveVersionId = widget.versionId ?? 1;
      _tree = await _service.getTree(effectiveVersionId);
    } catch (e) {
      _errorMessage = 'Failed to load clause library: $e';
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _search(String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      setState(() => _searchResults = null);
      return;
    }
    try {
      final results = await _service.searchByClauseRef(trimmed);
      if (mounted) setState(() => _searchResults = results);
    } catch (e) {
      if (mounted) setState(() => _searchResults = []);
    }
  }

  void _showClauseDetail(IsoStandard clause) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clause ${clause.clauseRef}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if ((clause.description ?? '').isNotEmpty) ...[
                Text(
                  clause.description!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              if (clause.particulars.isNotEmpty)
                Text(
                  clause.particulars,
                  style: const TextStyle(fontSize: 13),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildClauseTile(IsoStandard clause, {int depth = 0}) {
    final hasChildren = clause.children.isNotEmpty;

    if (!hasChildren) {
      return Padding(
        padding: EdgeInsets.only(left: depth * 16.0),
        child: ListTile(
          dense: true,
          title: Text(
            '${clause.clauseRef}  ${clause.description ?? ''}',
            style: const TextStyle(fontSize: 13),
          ),
          onTap: () => _showClauseDetail(clause),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: depth * 16.0),
      child: ExpansionTile(
        title: Text(
          '${clause.clauseRef}  ${clause.description ?? ''}',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: primaryThemeColor,
          ),
        ),
        children: clause.children
            .map((c) => _buildClauseTile(c, depth: depth + 1))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text('Auditor Guide — Clause Library'),
        backgroundColor: mainBgColor,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: primaryThemeColor),
            )
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by clause (e.g. 8.3, 9.2)',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: primaryThemeColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          isDense: true,
                        ),
                        onChanged: _search,
                      ),
                    ),
                    Expanded(
                      child: _searchResults != null
                          ? ListView(
                              children: _searchResults!
                                  .map(
                                    (c) => ListTile(
                                      dense: true,
                                      title: Text(
                                        '${c.clauseRef}  ${c.description ?? ''}',
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      onTap: () => _showClauseDetail(c),
                                    ),
                                  )
                                  .toList(),
                            )
                          : ListView(
                              children: _tree
                                  .map((c) => _buildClauseTile(c))
                                  .toList(),
                            ),
                    ),
                  ],
                ),
    );
  }
}