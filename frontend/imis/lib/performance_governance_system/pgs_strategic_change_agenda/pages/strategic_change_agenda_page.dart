// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/pgs_strategic_change_agenda/models/strategic_change_agenda.dart';
import 'package:imis/performance_governance_system/pgs_strategic_change_agenda/services/strategy_change_agenda_service.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/print_preview_util.dart';
import 'package:imis/widgets/common/pagination_controls.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StrategicChangeAgendaValueEntry {
  final int id;
  final String? rowVersion;
  int year;
  final TextEditingController controller;

  StrategicChangeAgendaValueEntry({
    this.id = 0,
    this.rowVersion,
    required this.year,
    String description = '',
  }) : controller = TextEditingController(text: description);

  void dispose() => controller.dispose();
}

class _RemovedItem {
  final int id;
  final String? rowVersion;
  final int year;
  final String description;

  _RemovedItem({
    required this.id,
    this.rowVersion,
    required this.year,
    required this.description,
  });
}

class StrategicChangeAgendaAreaEntry {
  int id;
  final TextEditingController areaCtrl;
  List<StrategicChangeAgendaValueEntry> valueEntries;
  final List<_RemovedItem> _removedItems = [];

  StrategicChangeAgendaAreaEntry({
    this.id = 0,
    String area = '',
    List<StrategicChangeAgendaValueEntry>? valueEntries,
  }) : areaCtrl = TextEditingController(text: area),
       valueEntries = valueEntries ?? [];

  void addValueColumn(int year) =>
      valueEntries.add(StrategicChangeAgendaValueEntry(year: year));

  void removeValueColumn(int index) {
    if (index < 0 || index >= valueEntries.length) return;

    final removed = valueEntries.removeAt(index);

    if (removed.id != 0) {
      _removedItems.add(
        _RemovedItem(
          id: removed.id,
          rowVersion: removed.rowVersion,
          year: removed.year,
          description: removed.controller.text,
        ),
      );
    }

    removed.dispose();
  }

  void updateColumnYear(int index, int newYear) {
    if (index < 0 || index >= valueEntries.length) return;
    valueEntries[index].year = newYear;
  }

  List<StrategicChangeAgendaItem> buildItems() {
    final area = areaCtrl.text.trim();

    return [
      ...valueEntries.map(
        (v) => StrategicChangeAgendaItem(
          id: v.id,
          isDeleted: false,
          rowVersion: v.rowVersion,
          area: area,
          year: v.year,
          description: v.controller.text.trim(),
        ),
      ),
      ..._removedItems.map(
        (r) => StrategicChangeAgendaItem(
          id: r.id,
          isDeleted: true,
          rowVersion: r.rowVersion,
          area: area,
          year: r.year,
          description: r.description,
        ),
      ),
    ];
  }

  void dispose() {
    areaCtrl.dispose();
    for (final v in valueEntries) {
      v.dispose();
    }
  }
}

class StrategicChangeAgendaPage extends StatefulWidget {
  const StrategicChangeAgendaPage({super.key});

  @override
  State<StrategicChangeAgendaPage> createState() =>
      _StrategicChangeAgendaPageState();
}

class _StrategicChangeAgendaPageState extends State<StrategicChangeAgendaPage> {
  int _currentPage = 1;
  final int _pageSize = 15;
  int totalCount = 0;
  bool _isLoading = false;

  List<StrategicChangeAgenda> _list = [];

  final _service = StrategyChangeAgendaService(Dio());

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<String> _getRoleId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? selectedRoleName = prefs.getString('selectedRole');
    final roles = await AuthUtil.fetchRoles();

    if (roles != null && roles.isNotEmpty) {
      var currentRole = roles.first;
      if (selectedRoleName != null) {
        try {
          currentRole = roles.firstWhere((r) => r.name == selectedRoleName);
        } catch (_) {}
      }
      return currentRole.id;
    }
    return '';
  }

  Future<void> _fetch({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _list = [];
    });

    try {
      // final roleId = await _getRoleId();

      final pageList = await _service.getStrategyChangeAgenda(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (!mounted) return;

      setState(() {
        _currentPage = pageList.page;
        totalCount = pageList.totalCount;
        _list = pageList.items;
      });
    } on DioException catch (e) {
      debugPrint('Dio error: $e');
    } catch (e) {
      debugPrint('Unexpected error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _openDialog({StrategicChangeAgenda? existing}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => StrategicChangeAgendaDialog(
            existing: existing,
            onSave: (_) => _fetch(page: _currentPage),
          ),
    );
  }

  Future<void> _onEditTap(StrategicChangeAgenda item) async {
    try {
      final full = await _service.getStrategicChangebyId(item.id);
      if (!mounted) return;
      _openDialog(existing: full);
    } catch (e) {
      debugPrint('Failed to fetch Strategic Change Agenda by ID: $e');
      if (!mounted) return;
      MotionToast.error(
        title: const Text('Load Failed'),
        description: const Text('Unable to load record for editing.'),
        toastDuration: const Duration(seconds: 4),
        toastAlignment: Alignment.topCenter,
      ).show(context);
    }
  }

  void _showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'Strategic Change Agenda',
            itemName: 'Strategic Change Agenda',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _service.deleteStrategicChangeAgenda(id);
                await _fetch(page: 1);
                if (mounted) {
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text(
                      'Strategic Change Agenda deleted successfully',
                      style: GoogleFonts.plusJakartaSans(),
                    ),
                  ).show(context);
                }
              } catch (_) {
                if (!mounted) return;
                MotionToast.error(
                  toastAlignment: Alignment.topCenter,
                  description: Text(
                    'Failed to delete Strategic Change Agenda',
                    style: GoogleFonts.plusJakartaSans(),
                  ),
                ).show(context);
              }
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isMobile),
          gap4px,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                "From",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                "To",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Actions",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 5),
                    Expanded(child: _buildList(isMobile)),
                    _buildPagination(),
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
                onPressed: () => _openDialog(),
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  Widget _buildList(bool isMobile) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: primaryColor));
    }

    if (_list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.trending_up_outlined,
              size: 50,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 10),
            const Text(
              'No Strategic Change Agenda available',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _list.length,
      separatorBuilder:
          (_, __) =>
              Divider(height: 1, color: Colors.grey.withValues(alpha: .2)),
      itemBuilder: (context, index) {
        final item = _list[index];
        final itemNumber = ((_currentPage - 1) * _pageSize) + index + 1;
        return isMobile
            ? _buildMobileRow(item, itemNumber)
            : _buildDesktopRow(item, itemNumber);
      },
    );
  }

  Widget _buildDesktopRow(StrategicChangeAgenda item, int itemNumber) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text("$itemNumber", style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 4,
            child: Text(
              item.from ?? '',
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              item.to ?? '',
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
                    onPressed: () => _onEditTap(item),
                  ),
                ),
                Tooltip(
                  message: 'Print Preview',
                  child: IconButton(
                    icon: const Icon(
                      Icons.description_outlined,
                      size: 16,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {
                      openStrategicChangeAgenda(item.id.toString(), '');
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    CupertinoIcons.delete_simple,
                    size: 16,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => _showDeleteDialog(item.id.toString()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileRow(StrategicChangeAgenda item, int itemNumber) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "$itemNumber",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                color: Theme.of(context).cardColor,
                icon: const Icon(Icons.more_vert),
                onSelected: (value) async {
                  if (value == 'edit') await _onEditTap(item);
                  if (value == 'delete') {
                    _showDeleteDialog(item.id.toString());
                  }
                  if (value == 'print preview') {
                    await openStrategicChangeAgenda(item.id.toString(), '');
                  }
                },
                itemBuilder:
                    (_) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: const Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 16),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'print preview',
                        child: const Row(
                          children: [
                            Icon(
                              Icons.description_outlined,
                              size: 16,
                              color: Colors.blueAccent,
                            ),
                            SizedBox(width: 8),
                            Text('Print Preview'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: const Row(
                          children: [
                            Icon(
                              CupertinoIcons.delete_simple,
                              size: 16,
                              color: Colors.redAccent,
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
          Text(
            'From: ${item.from ?? ''}',
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'To: ${item.to ?? ''}',
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      color: Theme.of(context).cardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PaginationInfo(
            currentPage: _currentPage,
            totalItems: totalCount,
            itemsPerPage: _pageSize,
          ),
          PaginationControls(
            currentPage: _currentPage,
            totalItems: totalCount,
            itemsPerPage: _pageSize,
            isLoading: _isLoading,
            onPageChanged: (page) => _fetch(page: page),
          ),
          const SizedBox(width: 60),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20, isMobile ? 12 : 16, 20, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.trending_up_outlined, color: primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Strategic Change Agenda',
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1D23),
                  ),
                ),
                Text(
                  '${_list.length} record${_list.length != 1 ? 's' : ''} found',
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile)
            ElevatedButton.icon(
              onPressed: () => _openDialog(),
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
              icon: const Icon(Icons.add, color: Colors.white, size: 16),
              label: const Text(
                'Add New',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }
}

class StrategicChangeAgendaDialog extends StatefulWidget {
  final StrategicChangeAgenda? existing;
  final void Function(StrategicChangeAgenda item) onSave;

  const StrategicChangeAgendaDialog({
    super.key,
    this.existing,
    required this.onSave,
  });

  @override
  State<StrategicChangeAgendaDialog> createState() =>
      _StrategicChangeAgendaDialogState();
}

class _StrategicChangeAgendaDialogState
    extends State<StrategicChangeAgendaDialog> {
  final _formKey = GlobalKey<FormState>();
  final _service = StrategyChangeAgendaService(Dio());
  final _commonService = CommonService(Dio());

  late TextEditingController _fromCtrl;
  late TextEditingController _toCtrl;

  List<StrategicChangeAgendaAreaEntry> _areas = [];
  bool _areasLoading = true;
  bool _isSaving = false;

  List<int> _selectedYears = [];
  final List<int> _availableYears = List.generate(
    16,
    (i) => 2015 + i,
  ); // 2015-2030

  @override
  void initState() {
    super.initState();

    final existing = widget.existing;

    _fromCtrl = TextEditingController(text: existing?.from ?? '');
    _toCtrl = TextEditingController(text: existing?.to ?? '');

    _loadDeliverables();
  }

  Future<void> _loadDeliverables() async {
    final existing = widget.existing;

    if (existing != null &&
        existing.strategicChangeAgendaDeliverable.isNotEmpty) {
      final years =
          existing.strategicChangeAgendaDeliverable.first.items
              .map((i) => i.year)
              .toList();

      setState(() {
        _selectedYears = years;
        _areas =
            existing.strategicChangeAgendaDeliverable.map((d) {
              final byYear = {for (final item in d.items) item.year: item};
              return StrategicChangeAgendaAreaEntry(
                id: d.id,
                area: d.area ?? '',
                valueEntries:
                    years.map((y) {
                      final item = byYear[y];
                      return StrategicChangeAgendaValueEntry(
                        id: item?.id ?? 0,
                        rowVersion: item?.rowVersion,
                        year: y,
                        description: item?.description ?? '',
                      );
                    }).toList(),
              );
            }).toList();
        _areasLoading = false;
      });
      return;
    }

    try {
      final kraList = await _commonService.fetchKra();
      if (!mounted) return;
      final defaultYear = DateTime.now().year;

      setState(() {
        _areas =
            kraList
                .map((kra) => StrategicChangeAgendaAreaEntry(area: kra.name))
                .toList();

        _selectedYears = [defaultYear];
        for (final entry in _areas) {
          entry.addValueColumn(defaultYear);
        }

        _areasLoading = false;
      });
    } catch (e) {
      debugPrint('Failed to load KRA list: $e');
      if (!mounted) return;
      setState(() => _areasLoading = false);
    }
  }

  void _addYearColumn() {
    final nextYear = _availableYears.firstWhere(
      (y) => !_selectedYears.contains(y),
      orElse: () => _availableYears.last,
    );

    setState(() {
      _selectedYears.add(nextYear);
      for (final entry in _areas) {
        entry.addValueColumn(nextYear);
      }
    });
  }

  void _removeYearColumn(int colIndex) {
    setState(() {
      _selectedYears.removeAt(colIndex);
      for (final entry in _areas) {
        entry.removeValueColumn(colIndex);
      }
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    final agenda = StrategicChangeAgenda(
      id: widget.existing?.id ?? 0,
      isDeleted: false,
      rowVersion: widget.existing?.rowVersion,
      from: _fromCtrl.text.trim(),
      to: _toCtrl.text.trim(),
      strategicChangeAgendaDeliverable:
          _areas.map((entry) {
            return StrategicChangeAgendaDeliverable(
              id: entry.id,
              area: entry.areaCtrl.text.trim(),
              items: entry.buildItems(),
            );
          }).toList(),
    );

    try {
      await _service.createStrategyChange(agenda);
      if (!mounted) return;

      widget.onSave(agenda);
      Navigator.pop(context);

      MotionToast.success(
        toastAlignment: Alignment.topCenter,
        description: Text(
          'Strategic Change Agenda saved successfully',
          style: GoogleFonts.plusJakartaSans(),
        ),
      ).show(context);
    } catch (e) {
      if (!mounted) return;
      MotionToast.error(
        toastAlignment: Alignment.topCenter,
        description: Text(
          'Failed to save Strategic Change Agenda',
          style: GoogleFonts.plusJakartaSans(),
        ),
      ).show(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    for (final e in _areas) {
      e.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 700;
    final dialogMaxWidth = size.width < 1500 ? size.width * 0.95 : 1500.0;

    return Dialog(
      backgroundColor: mainBgColor,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 24,
        vertical: isSmall ? 12 : 24,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogMaxWidth,
          maxHeight: size.height * 0.92,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDialogHeader(),
            Flexible(child: _buildDialogBody(isSmall)),
            const Divider(height: 1),
            _buildDialogActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'STRATEGIC CHANGE AGENDA',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.white70),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogBody(bool isSmall) {
    if (_areasLoading) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            isSmall
                ? Column(
                  children: [
                    _labeledField(
                      'FROM (current state)',
                      _fromCtrl,
                      maxLines: 3,
                      required: true,
                    ),
                    const SizedBox(height: 12),
                    _labeledField(
                      'TO (target state)',
                      _toCtrl,
                      maxLines: 3,
                      required: true,
                    ),
                  ],
                )
                : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _labeledField(
                        'FROM (current state)',
                        _fromCtrl,
                        maxLines: 3,
                        required: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _labeledField(
                        'TO (target state)',
                        _toCtrl,
                        maxLines: 3,
                        required: true,
                      ),
                    ),
                  ],
                ),
            const SizedBox(height: 20),
            _StrategicChangeAgendaTable(
              entries: _areas,
              isSmall: isSmall,
              selectedYears: _selectedYears,
              availableYears: _availableYears,
              onAddColumn: _addYearColumn,
              onRemoveColumn: _removeYearColumn,
              onYearChanged: (colIndex, newYear) {
                setState(() {
                  _selectedYears[colIndex] = newYear;
                  for (final entry in _areas) {
                    entry.updateColumnYear(colIndex, newYear);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogActions() {
    final isEditing = widget.existing != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _isSaving ? null : () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: primaryColor),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: (_areasLoading || _isSaving) ? null : _save,
            child:
                _isSaving
                    ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : Text(isEditing ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }

  Widget _labeledField(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: ctrl,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
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
          validator:
              required
                  ? (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    return null;
                  }
                  : null,
        ),
      ],
    );
  }
}

class _YearsDragScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };
}

class _StrategicChangeAgendaTable extends StatefulWidget {
  final List<StrategicChangeAgendaAreaEntry> entries;
  final bool isSmall;
  final List<int> selectedYears;
  final List<int> availableYears;
  final VoidCallback onAddColumn;
  final void Function(int colIndex) onRemoveColumn;
  final void Function(int colIndex, int newYear) onYearChanged;

  const _StrategicChangeAgendaTable({
    required this.entries,
    required this.isSmall,
    required this.selectedYears,
    required this.availableYears,
    required this.onAddColumn,
    required this.onRemoveColumn,
    required this.onYearChanged,
  });

  @override
  State<_StrategicChangeAgendaTable> createState() =>
      _StrategicChangeAgendaTableState();
}

class _StrategicChangeAgendaTableState
    extends State<_StrategicChangeAgendaTable> {
  static const double _areaColumnWidth = 240;
  static const double _yearColumnWidth = 190;
  static const double _headerRowHeight = 42;
  static const double _bodyRowHeight = 64;

  final ScrollController _yearsScrollController = ScrollController();

  @override
  void dispose() {
    _yearsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final naturalWidth =
        _areaColumnWidth + (widget.selectedYears.length * _yearColumnWidth);

    return LayoutBuilder(
      builder: (context, constraints) {
        final useFullWidth = widget.isSmall || widget.entries.isEmpty;
        final boxWidth =
            useFullWidth
                ? constraints.maxWidth
                : (naturalWidth < constraints.maxWidth
                    ? naturalWidth
                    : constraints.maxWidth);

        return Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: boxWidth,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Area Milestones',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: widget.onAddColumn,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: const Icon(
                            Icons.add,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Add Column',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.entries.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'No areas found. Make sure Key Result Areas are set up.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    )
                  else if (!widget.isSmall)
                    _buildDesktopTable()
                  else
                    _buildMobileCards(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Area column now scrolls together with the Year columns (no more frozen
  // sidebar). Each row is a single Row — Area cell + all Year cells — inside
  // one IntrinsicHeight, exactly like `_SwotContextTable`'s `_cell` pattern.
  // IntrinsicHeight makes every child in that Row stretch to match the
  // tallest one automatically, using Flutter's real layout system — no
  // manual text measurement, no guessed buffers, and it can never be wrong.
  Widget _buildDesktopTable() {
    if (widget.selectedYears.isEmpty) {
      return Container(
        height: _headerRowHeight + _bodyRowHeight,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          'No year columns yet — tap "Add Column" above to add one.',
          style: TextStyle(
            fontSize: 11,
            fontStyle: FontStyle.italic,
            color: Colors.grey.shade600,
          ),
        ),
      );
    }

    final totalWidth =
        _areaColumnWidth + (widget.selectedYears.length * _yearColumnWidth);

    return ScrollConfiguration(
      behavior: _YearsDragScrollBehavior(),
      child: Scrollbar(
        controller: _yearsScrollController,
        thumbVisibility: true,
        trackVisibility: true,
        child: SingleChildScrollView(
          controller: _yearsScrollController,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: totalWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderRow(),
                Divider(height: 1, color: Colors.grey.shade300),
                ...widget.entries.asMap().entries.map((entryData) {
                  final index = entryData.key;
                  final entry = entryData.value;
                  final isEven = index % 2 == 0;

                  return Container(
                    decoration: BoxDecoration(
                      color:
                          isEven
                              ? Colors.white
                              : primaryColor.withValues(alpha: 0.05),
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: _areaColumnWidth,
                            constraints: const BoxConstraints(
                              minHeight: _bodyRowHeight,
                            ),
                            padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Text(
                              entry.areaCtrl.text,
                              maxLines: null,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ...List.generate(
                            widget.selectedYears.length,
                            (colIndex) => SizedBox(
                              width: _yearColumnWidth,
                              child: _yearBodyCell(
                                entry.valueEntries[colIndex].controller,
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
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      color: Colors.grey.shade100,
      child: Row(
        children: [
          Container(
            width: _areaColumnWidth,
            height: _headerRowHeight,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey.shade300)),
            ),
            child: const Text(
              'Area',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 11,
                color: Colors.black87,
              ),
            ),
          ),
          ...widget.selectedYears.asMap().entries.map(
            (yearEntry) => SizedBox(
              width: _yearColumnWidth,
              child: _yearHeaderCell(yearEntry.key, yearEntry.value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _yearHeaderCell(int colIndex, int year) {
    return Container(
      height: _headerRowHeight,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade300)),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<int>(
            value: year,
            isDense: true,
            underline: const SizedBox(),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 11,
              color: Colors.black87,
            ),
            items:
                widget.availableYears
                    .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                    .toList(),
            onChanged: (newYear) {
              if (newYear == null) return;
              widget.onYearChanged(colIndex, newYear);
            },
          ),
          Spacer(),
          IconButton(
            icon: const Icon(
              CupertinoIcons.delete_simple,
              size: 14,
              color: Colors.redAccent,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Remove column',
            onPressed: () => widget.onRemoveColumn(colIndex),
          ),
        ],
      ),
    );
  }

  Widget _yearBodyCell(TextEditingController ctrl) {
    return Container(
      constraints: const BoxConstraints(minHeight: _bodyRowHeight),
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade300)),
      ),
      child: TextField(
        controller: ctrl,
        maxLines: null,
        minLines: 1,
        keyboardType: TextInputType.multiline,
        style: GoogleFonts.plusJakartaSans(fontSize: 12),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildMobileCards() {
    return Column(
      children: [
        if (widget.selectedYears.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Text(
              'No year columns yet — tap "Add Column" above to add one.',
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ...widget.entries.map((entry) {
          return Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Area',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  constraints: const BoxConstraints(minHeight: 46),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
                  child: Text(
                    entry.areaCtrl.text,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(widget.selectedYears.length, (colIndex) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButton<int>(
                              value: widget.selectedYears[colIndex],
                              isDense: true,
                              underline: const SizedBox(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                                color: Colors.black87,
                              ),
                              items:
                                  widget.availableYears
                                      .map(
                                        (y) => DropdownMenuItem(
                                          value: y,
                                          child: Text('$y'),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (newYear) {
                                if (newYear == null) return;
                                widget.onYearChanged(colIndex, newYear);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.redAccent,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              tooltip: 'Remove column',
                              onPressed: () => widget.onRemoveColumn(colIndex),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Container(
                          constraints: const BoxConstraints(minHeight: 46),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
                          child: TextField(
                            controller: entry.valueEntries[colIndex].controller,
                            maxLines: null,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            style: GoogleFonts.plusJakartaSans(fontSize: 12),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }
}
