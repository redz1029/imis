// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/iso_standard/models/iso_standard.dart';
import 'package:imis/iso_standard/service/iso_standard_service.dart';
import 'package:imis/standard_version/models/standard_version.dart';
import 'package:imis/standard_version/service/standard_version_service.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/filter_search_result_util.dart';
import 'package:imis/utils/pagination_util.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:imis/utils/permission_string.dart';
import 'package:imis/widgets/pagination_controls.dart';
import 'package:imis/widgets/dotted_button.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Simple node used to build a parent/child tree from flat IsoStandard list
class _IsoNode {
  final IsoStandard iso;
  final List<_IsoNode> children = [];
  _IsoNode(this.iso);
}

/// ISO Standards Settings Page implementing SRS requirements
/// FR-01 to FR-11, NFR: Performance, Security, Audit Trail
class IsoStandardPage extends StatefulWidget {
  const IsoStandardPage({super.key});

  @override
  IsoStandardPageState createState() => IsoStandardPageState();
}

class IsoStandardPageState extends State<IsoStandardPage> {
  final _isoStandardService = IsoStandardService(Dio());
  final _standardVersionService = StandardVersionService(Dio());
  final _paginationUtils = PaginationUtil(Dio());
  late FilterSearchResultUtil<IsoStandard> isoStandardSearchUtil;
  final _formKey = GlobalKey<FormState>();

  List<IsoStandard> isoStandardList = [];
  List<IsoStandard> filteredList = [];
  List<StandardVersion> availableVersions = [];
  TextEditingController searchController = TextEditingController();
  final FocusNode isSearchfocus = FocusNode();

  int _currentPage = 1;
  final int _pageSize = 15;
  int _totalCount = 0;
  bool _isLoading = false;
  bool _showClause4to10 = false;
  bool _hasAllData = false;

  // Track deleted item IDs to filter them out permanently
  final Set<String> _deletedIds = {};

  // Bulk Add Mode State (FR-03, FR-04)
  List<Map<String, dynamic>> _bulkRows = [];

  // Permissions (FR-01, FR-02, FR-03, FR-10)
  bool get isAdmin =>
      permissionService.currentRole == PermissionString.roleAdmin;
  bool get hasViewPermission =>
      isAdmin || permissionService.hasPermission(AppPermissions.viewIso);
  bool get hasAddPermission =>
      isAdmin || permissionService.hasPermission(AppPermissions.addIso);
  bool get hasEditPermission =>
      isAdmin || permissionService.hasPermission(AppPermissions.editIso);

  final dio = Dio();

  @override
  void initState() {
    super.initState();
    _initialize();
    isoStandardSearchUtil = FilterSearchResultUtil<IsoStandard>(
      paginationUtils: _paginationUtils,
      endpoint: ApiEndpoint().isoStandard,
      pageSize: _pageSize,
      fromJson: (json) => IsoStandard.fromJson(json),
    );
    isSearchfocus.addListener(() {
      setState(() {});
    });
  }

  /// Initialize data - load deleted IDs then fetch data
  Future<void> _initialize() async {
    await _loadDeletedIds();
    // Load the full dataset so ExpansionTiles render correctly
    await fetchAllIsoStandards();
    fetchStandardVersions();
  }

  /// Load deleted IDs from SharedPreferences
  Future<void> _loadDeletedIds() async {
    final prefs = await SharedPreferences.getInstance();
    final deletedList = prefs.getStringList('iso_deleted_ids') ?? [];
    _deletedIds.addAll(deletedList);
  }

  /// Save deleted IDs to SharedPreferences
  Future<void> _saveDeletedIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('iso_deleted_ids', _deletedIds.toList());
  }

  /// Fetch all available Standard Versions (FR-05)
  /// Uses GET /api/StandardVersion/ to get all versions
  Future<void> fetchStandardVersions() async {
    try {
      // Use getAllStandardVersions which calls GET /api/StandardVersion/
      final allVersions = await _standardVersionService
          .getAllStandardVersions();
      if (mounted) {
        setState(() {
          // FR-11: Filter active versions only for dropdowns
          availableVersions = allVersions.where((v) => v.isActive).toList();
        });
      }
    } catch (e) {
      debugPrint('Error fetching versions from StandardVersion endpoint: $e');
      // Fallback: Extract unique versions from IsoStandard data
      try {
        final isoPageList = await _isoStandardService.getIsoStandards(
          page: 1,
          pageSize: 500, // Get more to extract unique versions
        );
        if (mounted) {
          // Extract unique versions from IsoStandard data
          final Map<int, StandardVersion> uniqueVersions = {};
          for (var iso in isoPageList.items) {
            if (iso.version != null &&
                iso.version!.isActive &&
                !uniqueVersions.containsKey(iso.version!.id)) {
              uniqueVersions[iso.version!.id] = iso.version!;
            }
          }
          setState(() {
            availableVersions = uniqueVersions.values.toList();
          });
        }
      } catch (fallbackError) {
        debugPrint(
          'Error fetching versions from IsoStandard fallback: $fallbackError',
        );
        if (mounted) {
          setState(() {
            availableVersions = [];
          });
        }
      }
    }
  }

  Future<void> fetchIsoStandards({int page = 1, String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final pageList = await _isoStandardService.getIsoStandards(
        page: page,
        pageSize: _pageSize,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = pageList.page;
          // Show all items (both active and inactive) but filter out deleted ones
          isoStandardList = pageList.items
              .where((item) => !_deletedIds.contains(item.id.toString()))
              .toList();
          filteredList = List.from(isoStandardList);

          // Calculate actual total count based on items received
          // If we got less than a full page, we're on the last page
          if (isoStandardList.length < _pageSize) {
            _totalCount =
                ((_currentPage - 1) * _pageSize) + isoStandardList.length;
          } else {
            // Subtract deleted items from total count
            _totalCount = pageList.totalCount - _deletedIds.length;
          }
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Fetch all ISO standards from backend in a single call and prepare lists.
  Future<void> fetchAllIsoStandards({String? searchQuery}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      // Request a very large pageSize to retrieve all items from the backend
      final pageList = await _isoStandardService.getIsoStandards(
        page: 1,
        pageSize: 1000000,
        searchQuery: searchQuery,
      );

      if (mounted) {
        setState(() {
          _currentPage = 1;
          isoStandardList = pageList.items
              .where((item) => !_deletedIds.contains(item.id.toString()))
              .toList();
          filteredList = List.from(isoStandardList);
          _totalCount = pageList.totalCount - _deletedIds.length;
          _hasAllData = false;
          _hasAllData = true;
        });
      }
    } catch (e) {
      debugPrint('Error fetching all ISO standards: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> filterSearchResults(String query) async {
    // If we have the full dataset loaded locally, perform client-side
    // filtering for instant results and to avoid extra API calls.
    if (_hasAllData) {
      final search = query.toLowerCase();
      final results = isoStandardList.where((isoStandard) {
        return isoStandard.particulars.toLowerCase().contains(search) ||
            (isoStandard.description ?? '').toLowerCase().contains(search) ||
            isoStandard.clauseRef.toLowerCase().contains(search);
      }).toList();

      setState(() {
        filteredList = results;
      });
      return;
    }

    // Fallback to server-side filtering when we don't have the full dataset
    final results = await isoStandardSearchUtil.filter(
      query,
      (isoStandard, search) =>
          (isoStandard.particulars).toLowerCase().contains(
            search.toLowerCase(),
          ) ||
          (isoStandard.description ?? '').toLowerCase().contains(
            search.toLowerCase(),
          ) ||
          (isoStandard.clauseRef).toLowerCase().contains(search.toLowerCase()),
    );

    if (mounted) {
      setState(() {
        filteredList = results;
      });
    }
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    searchController.dispose();
    super.dispose();
  }

  // Helper node removed; top-level _IsoNode is used instead

  // Build a forest of root nodes from the flat list using parentID links.
  List<_IsoNode> _buildHierarchy(List<IsoStandard> items) {
    final Map<int, _IsoNode> nodeById = {};
    final Map<String, _IsoNode> nodeByRef = {};
    final List<_IsoNode> roots = [];

    // Flatten any nested children provided by the backend so we can build
    // a consistent flat index used by the existing parent/clauses inference
    // logic. This ensures backend-provided `children` are respected.
    final List<IsoStandard> flatItems = [];
    void _flatten(IsoStandard i) {
      flatItems.add(i);
      if (i.children != null) {
        for (var c in i.children!) _flatten(c);
      }
    }

    for (var it in items) {
      _flatten(it);
    }

    // Helper to normalize clauseRef and produce a version-scoped key
    String normalizeRef(String? ref) {
      if (ref == null) return '';
      var r = ref.trim();
      // Remove trailing dots and spaces, and collapse internal spaces
      r = r.replaceAll(RegExp(r"\.+\s*"), '.');
      r = r.replaceAll(' ', '');
      r = r.replaceAll(RegExp(r"\.+\$"), '');
      return r;
    }

    // Create nodes and maps for quick lookup (do not overwrite duplicate refs)
    for (var item in flatItems) {
      final node = _IsoNode(item);
      nodeById[item.id] = node;
      final normalized = normalizeRef(item.clauseRef);
      if (normalized.isNotEmpty) {
        final versionId = item.versionID;
        final scopedKey = '$versionId::$normalized';
        if (!nodeByRef.containsKey(scopedKey)) {
          nodeByRef[scopedKey] = node;
        }
      }
    }

    // Ensure synthetic major parents (4..10) exist per version so that
    // children like `4.1`, `5.2` etc. attach under a visible parent even
    // when the explicit major clause record is missing from the dataset.
    final versionIds = flatItems.map((e) => e.versionID).toSet();
    for (var versionId in versionIds) {
      for (var major = 4; major <= 10; major++) {
        final scopedKey = '$versionId::$major';
        if (!nodeByRef.containsKey(scopedKey)) {
          // Create a synthetic IsoStandard as a placeholder parent.
          final syntheticIso = IsoStandard(
            id: -(versionId * 1000 + major),
            clauseRef: '$major',
            particulars: 'Section $major',
            description: null,
            version: items.firstWhere((it) => it.versionID == versionId,
                orElse: () => items.first).version,
            versionID: versionId,
            isDeleted: false,
            isActive: true,
          );
          final syntheticNode = _IsoNode(syntheticIso);
          nodeByRef[scopedKey] = syntheticNode;
          // Add to roots so it will be visible if not attached later.
          // We'll keep it in roots now; children will be attached to it
          // during the clauseRef prefix inference below.
          roots.add(syntheticNode);
        }
      }
    }

    // 1) Attach nodes with explicit parentID
    for (var item in flatItems) {
      final node = nodeById[item.id]!;
      final parentId = item.parentID;
      if (parentId != null && nodeById.containsKey(parentId)) {
        final parentNode = nodeById[parentId]!;
        if (!parentNode.children.contains(node)) parentNode.children.add(node);
      }
    }

    // Helper comparator for clauseRef segments (numeric first, then alpha)
    int clauseComparator(String a, String b) {
      final pa = a.split('.');
      final pb = b.split('.');
      final len = pa.length < pb.length ? pa.length : pb.length;
      for (var i = 0; i < len; i++) {
        final sa = pa[i];
        final sb = pb[i];
        final numaStr = RegExp(r"^\d+").stringMatch(sa) ?? '';
        final numbStr = RegExp(r"^\d+").stringMatch(sb) ?? '';
        final numa = numaStr.isEmpty ? null : int.tryParse(numaStr);
        final numb = numbStr.isEmpty ? null : int.tryParse(numbStr);
        if (numa != null && numb != null) {
          if (numa != numb) return numa.compareTo(numb);
          final alphaA = sa.substring(numaStr.length);
          final alphaB = sb.substring(numbStr.length);
          if (alphaA != alphaB) return alphaA.compareTo(alphaB);
        } else {
          final res = sa.compareTo(sb);
          if (res != 0) return res;
        }
      }
      return pa.length.compareTo(pb.length);
    }

    // 2) Infer parents by clauseRef prefix where possible
    for (var item in flatItems) {
      final node = nodeById[item.id]!;
      // Skip if already attached via parentID
      final alreadyAttached = nodeById.values.any(
        (n) => n.children.contains(node),
      );
      if (alreadyAttached) continue;

      final clause = normalizeRef(item.clauseRef);
      if (clause.isNotEmpty) {
        final parts = clause.split('.');
        final versionId = item.versionID;
        bool attached = false;
        for (int len = parts.length - 1; len >= 1; len--) {
          final candidate = parts.sublist(0, len).join('.');
          final scopedKey = '$versionId::$candidate';
          if (nodeByRef.containsKey(scopedKey)) {
            final parentNode = nodeByRef[scopedKey]!;
            if (parentNode.iso.id != node.iso.id &&
                !parentNode.children.contains(node)) {
              parentNode.children.add(node);
              attached = true;
              break;
            }
          }
        }
        if (!attached) {
          roots.add(node);
        }
      } else {
        roots.add(node);
      }
    }

    // 3) For remaining roots within same major prefix, create sequential chains
    //    to support the structure: major -> major.1 -> major.2 -> major.3
    final Map<String, List<_IsoNode>> groups = {};
    for (var node in roots.toList()) {
      final clause = normalizeRef(node.iso.clauseRef);
      if (clause.isEmpty) continue;
      final major = clause.split('.').first;
      final key = '${node.iso.versionID}::$major';
      groups.putIfAbsent(key, () => []).add(node);
    }

    for (var entry in groups.entries) {
      final list = entry.value;
      // Sort by clause depth then comparator
      list.sort(
        (a, b) => clauseComparator(
          normalizeRef(a.iso.clauseRef),
          normalizeRef(b.iso.clauseRef),
        ),
      );
      // If there is an explicit major root (exact match), find it
      final versionId = entry.key.split('::').first;
      final major = entry.key.split('::').last;
      final rootScoped = '$versionId::$major';
      final majorRoot = nodeByRef[rootScoped];

      if (majorRoot != null) {
        // Attach first item to majorRoot if it's not the majorRoot itself
        _IsoNode prev = majorRoot;
        for (var node in list) {
          if (node.iso.id == majorRoot.iso.id) continue;
          if (!prev.children.contains(node)) prev.children.add(node);
          prev = node;
          // Remove from top-level roots since now attached
          roots.remove(node);
        }
      } else {
        // No explicit major root - chain list sequentially
        for (int i = 0; i < list.length; i++) {
          if (i == 0) continue; // keep first as root
          final parent = list[i - 1];
          final child = list[i];
          if (!parent.children.contains(child)) parent.children.add(child);
          roots.remove(child);
        }
      }
    }

    // Final pass: Ensure nodes whose major prefix matches an existing major
    // root are attached. This is a safety net for cases where earlier
    // inference didn't attach children (e.g., backend-provided children
    // with slight formatting differences).
    for (var node in nodeById.values) {
      // Skip if already attached to any parent
      final attached = nodeById.values.any((n) => n.children.contains(node));
      if (attached) continue;

      final clause = normalizeRef(node.iso.clauseRef);
      if (clause.isEmpty) continue;
      final major = clause.split('.').first;
      final scopedMajor = '${node.iso.versionID}::$major';
      final majorRoot = nodeByRef[scopedMajor];
      if (majorRoot != null && majorRoot.iso.id != node.iso.id) {
        if (!majorRoot.children.contains(node)) majorRoot.children.add(node);
        roots.remove(node);
      }
    }

    // Optionally sort roots and children for predictable ordering using
    // the numeric-aware clause comparator so '10' sorts after '9'.
    void sortRecursively(List<_IsoNode> list) {
      list.sort((a, b) => clauseComparator(
          normalizeRef(a.iso.clauseRef), normalizeRef(b.iso.clauseRef)));
      for (var n in list) {
        if (n.children.isNotEmpty) sortRecursively(n.children);
      }
    }

    sortRecursively(roots);
    return roots;
  }

  bool _isMajorInFourToTen(String? clauseRef) {
    if (clauseRef == null) return false;
    final m = RegExp(r"^\s*(\d+)").firstMatch(clauseRef);
    if (m == null) return false;
    final v = int.tryParse(m.group(1) ?? '');
    return v != null && v >= 4 && v <= 10;
  }

  // Return true only when clauseRef is a pure major number (e.g. '4', '10')
  bool _isMajorRootFourToTen(String? clauseRef) {
    if (clauseRef == null) return false;
    final m = RegExp(r"^\s*(\d+)\s*$").firstMatch(clauseRef);
    if (m == null) return false;
    final v = int.tryParse(m.group(1) ?? '');
    return v != null && v >= 4 && v <= 10;
  }

  // Compact renderer: shows only clauseRef in a nested ExpansionTile/ListTile
  Widget _buildCompactNodeWidget(_IsoNode node, int depth) {
    final title = Padding(
      padding: EdgeInsets.only(left: depth * 16.0),
      child: Text(node.iso.clauseRef),
    );

    if (node.children.isEmpty) {
      return ListTile(title: title);
    }

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: title,
      children: node.children.map((c) => _buildCompactNodeWidget(c, depth + 1)).toList(),
    );
  }

  // Render a node (parent or child). Depth used for indentation.
  Widget _buildNodeWidget(_IsoNode node, int depth) {
    final iso = node.iso;

    Widget rowContent = Padding(
      padding: EdgeInsets.only(left: depth * 16.0, right: 8, top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                if (iso.id > 0) {
                  showFormDialog(
                    id: iso.id.toString(),
                    clauseRef: iso.clauseRef,
                    particulars: iso.particulars,
                    description: iso.description,
                    version: iso.version,
                    versionID: iso.versionID,
                    isActive: iso.isActive,
                  );
                }
              },
              child: Text(
                iso.clauseRef,
                style: TextStyle(
                  color: iso.id > 0 ? primaryColor : null,
                  decoration: iso.id > 0 ? TextDecoration.underline : null,
                ),
              ),
            ),
          ),
          Expanded(flex: 2, child: Text(iso.version?.versionName ?? 'N/A')),
          Expanded(
            flex: 4,
            child: Text(
              iso.particulars.length > 80
                  ? '${iso.particulars.substring(0, 80)}...'
                  : iso.particulars,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              (iso.description ?? '').length > 60
                  ? '${iso.description!.substring(0, 60)}...'
                  : (iso.description ?? '-'),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: iso.isActive
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                iso.isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  fontSize: 12,
                  color: iso.isActive
                      ? Colors.green.shade800
                      : Colors.red.shade800,
                ),
              ),
            ),
          ),
          if (hasEditPermission && iso.id > 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => showFormDialog(
                    id: iso.id.toString(),
                    clauseRef: iso.clauseRef,
                    particulars: iso.particulars,
                    description: iso.description,
                    version: iso.version,
                    versionID: iso.versionID,
                    isActive: iso.isActive,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: primaryColor),
                  onPressed: () {
                    showDeleteDialog(iso.id.toString());
                  },
                ),
              ],
            ),
        ],
      ),
    );

    if (node.children.isEmpty) return rowContent;

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: rowContent,
      children: node.children
          .map((c) => _buildNodeWidget(c, depth + 1))
          .toList(),
    );
  }

  /// Single Edit Dialog (FR-10: Edit permission)
  void showFormDialog({
    String? id,
    String? clauseRef,
    String? particulars,
    String? description,
    StandardVersion? version,
    int? versionID,
    bool? isActive,
  }) async {
    // FR-10: Check Edit permission (Admin bypasses this check)
    if (id != null && !hasEditPermission && !isAdmin) {
      MotionToast.error(
        description: Text('You do not have permission to edit ISO Standards'),
      ).show(context);
      return;
    }

    // Check Add permission for new records (Admin bypasses this check)
    if (id == null && !hasAddPermission && !isAdmin) {
      MotionToast.error(
        description: Text('You do not have permission to add ISO Standards'),
      ).show(context);
      return;
    }

    TextEditingController clauseRefController = TextEditingController(
      text: clauseRef,
    );
    TextEditingController particularsController = TextEditingController(
      text: particulars,
    );
    TextEditingController descriptionController = TextEditingController(
      text: description,
    );
    TextEditingController versionController = TextEditingController(
      text: version?.versionName ?? '',
    );

    StandardVersion? selectedVersion = version;
    bool activeStatus = isActive ?? true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: mainBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              titlePadding: EdgeInsets.zero,
              title: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: primaryLightColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  id == null ? 'Create ISO Standard' : 'Edit ISO Standard',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              content: Form(
                key: _formKey,
                child: SizedBox(
                  width: 480,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Standard Version Dropdown with Autocomplete (FR-05)
                      SizedBox(
                        height: 65,
                        child: Autocomplete<StandardVersion>(
                          initialValue: TextEditingValue(
                            text: versionController.text,
                          ),
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            versionController.text = textEditingValue.text;
                            if (textEditingValue.text.isEmpty) {
                              return availableVersions;
                            }
                            // FR-05: Auto-complete under 200ms (simple string matching)
                            return availableVersions.where(
                              (version) =>
                                  version.versionName.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase(),
                                  ),
                            );
                          },
                          displayStringForOption: (version) =>
                              version.versionName,
                          fieldViewBuilder:
                              (
                                context,
                                controller,
                                focusNode,
                                onFieldSubmitted,
                              ) {
                                return TextFormField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                    labelText: 'Standard Version',
                                    hintText:
                                        'Select or type new version (e.g., ISO 9001:2015)',
                                    focusColor: primaryColor,
                                    floatingLabelStyle: TextStyle(
                                      color: primaryColor,
                                    ),
                                    border: OutlineInputBorder(),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please select or enter a version';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    versionController.text = value;
                                    // Clear selectedVersion if user types something different
                                    if (selectedVersion != null &&
                                        selectedVersion!.versionName != value) {
                                      setDialogState(() {
                                        selectedVersion = null;
                                      });
                                    }
                                  },
                                );
                              },
                          onSelected: (version) {
                            versionController.text = version.versionName;
                            setDialogState(() {
                              selectedVersion = version;
                            });
                          },
                        ),
                      ),
                      gap16px,
                      // Clause Reference (FR-07: Must be unique per version)
                      SizedBox(
                        height: 65,
                        child: TextFormField(
                          controller: clauseRefController,
                          decoration: InputDecoration(
                            labelText: 'Clause Reference',
                            hintText: 'e.g., 4.1',
                            focusColor: primaryColor,
                            floatingLabelStyle: TextStyle(color: primaryColor),
                            border: OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                          ),
                          validator: (value) {
                            // FR-09: Required field validation
                            if (value == null || value.trim().isEmpty) {
                              return 'Please fill out this field';
                            }
                            return null;
                          },
                        ),
                      ),
                      gap16px,
                      // Particulars (Required)
                      SizedBox(
                        height: 100,
                        child: TextFormField(
                          controller: particularsController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Particulars',
                            hintText: 'Enter the particulars',
                            focusColor: primaryColor,
                            floatingLabelStyle: TextStyle(color: primaryColor),
                            border: OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            // FR-09: Required field validation
                            if (value == null || value.trim().isEmpty) {
                              return 'Please fill out this field';
                            }
                            return null;
                          },
                        ),
                      ),
                      gap16px,
                      // Description (Optional)
                      SizedBox(
                        height: 100,
                        child: TextFormField(
                          controller: descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Description (Optional)',
                            hintText: 'Additional description',
                            focusColor: primaryColor,
                            floatingLabelStyle: TextStyle(color: primaryColor),
                            border: OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            alignLabelWithHint: true,
                          ),
                        ),
                      ),
                      gap16px,
                      // FR-10: isActive status toggle for Edit
                      if (id != null)
                        Row(
                          children: [
                            Checkbox(
                              value: activeStatus,
                              onChanged: (value) {
                                setDialogState(() {
                                  activeStatus = value ?? true;
                                });
                              },
                            ),
                            Text('Active'),
                            SizedBox(width: 8),
                            Tooltip(
                              message:
                                  'Inactive standards will not appear in new audit plans',
                              child: Icon(
                                Icons.info_outline,
                                size: 16,
                                color: grey,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text('Cancel', style: TextStyle(color: primaryColor)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // FR-07: Check for duplicate clause reference
                      if (selectedVersion != null) {
                        final isDuplicate = await _checkDuplicateClauseRef(
                          selectedVersion!.id,
                          clauseRefController.text.trim(),
                          currentId: id,
                        );

                        if (isDuplicate) {
                          if (mounted) {
                            MotionToast.error(
                              description: Text(
                                'Clause "${clauseRefController.text}" already exists for ${selectedVersion!.versionName}',
                              ),
                            ).show(context);
                          }
                          return;
                        }
                      }

                      bool? confirmAction = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              id == null ? "Confirm Save" : "Confirm Update",
                            ),
                            content: Text(
                              id == null
                                  ? "Are you sure you want to save this record?"
                                  : "Are you sure you want to update this record?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(
                                  "No",
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  "Yes",
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmAction == true) {
                        try {
                          // FR-06: Create new version if doesn't exist
                          StandardVersion versionToUse;
                          final typedVersionName = versionController.text
                              .trim();

                          if (selectedVersion != null &&
                              selectedVersion!.versionName ==
                                  typedVersionName) {
                            // User selected an existing version
                            versionToUse = selectedVersion!;
                          } else {
                            // User typed a new version name - check if it exists
                            final existingVersion = availableVersions
                                .firstWhere(
                                  (v) =>
                                      v.versionName.toLowerCase() ==
                                      typedVersionName.toLowerCase(),
                                  orElse: () => StandardVersion(
                                    id: 0,
                                    versionName: typedVersionName,
                                    isActive: true,
                                  ),
                                );

                            if (existingVersion.id == 0) {
                              // Create new version first
                              try {
                                await _standardVersionService
                                    .createOrUpdateStandardVersion(
                                      existingVersion,
                                    );
                                // Refresh versions list
                                await fetchStandardVersions();
                                // Get the newly created version
                                versionToUse = availableVersions.firstWhere(
                                  (v) =>
                                      v.versionName.toLowerCase() ==
                                      typedVersionName.toLowerCase(),
                                  orElse: () => existingVersion,
                                );
                              } catch (e) {
                                debugPrint('Error creating version: $e');
                                if (!mounted) return;

                                // Show specific error about version creation
                                if (mounted) {
                                  MotionToast.error(
                                    toastAlignment: Alignment.topCenter,
                                    description: Text(
                                      'Failed to create version "$typedVersionName": ${e.toString()}',
                                    ),
                                  ).show(context);
                                }
                                return; // Stop the save process
                              }
                            } else {
                              versionToUse = existingVersion;
                            }
                          }

                          final isoStandard = IsoStandard(
                            id: int.tryParse(id ?? '0') ?? 0,
                            clauseRef: clauseRefController.text.trim(),
                            particulars: particularsController.text.trim(),
                            description:
                                descriptionController.text.trim().isEmpty
                                ? null
                                : descriptionController.text.trim(),
                            version: versionToUse,
                            versionID: versionToUse.id,
                            isDeleted: false,
                            isActive: activeStatus,
                          );

                          await _isoStandardService.createOrUpdateIsoStandard(
                            isoStandard,
                          );

                          if (!mounted) return;

                          Navigator.pop(context);

                          // Refresh full list to keep hierarchy up-to-date
                          await fetchAllIsoStandards();

                          if (mounted) {
                            MotionToast.success(
                              toastAlignment: Alignment.topCenter,
                              description: Text(
                                id == null
                                    ? 'ISO Standard created successfully'
                                    : 'ISO Standard updated successfully',
                              ),
                            ).show(context);
                          }
                        } catch (e) {
                          if (!mounted) return;

                          Navigator.pop(context);

                          if (mounted) {
                            MotionToast.error(
                              toastAlignment: Alignment.topCenter,
                              description: Text(
                                'Failed to save: ${e.toString()}',
                              ),
                            ).show(context);
                          }

                          debugPrint('Error saving ISO standard: $e');
                        }
                      }
                    }
                  },
                  child: Text(
                    id == null ? 'Save' : 'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// FR-07: Check for duplicate Clause Reference within same version
  Future<bool> _checkDuplicateClauseRef(
    int versionId,
    String clauseRef, {
    String? currentId,
  }) async {
    try {
      final existing = isoStandardList.where(
        (iso) =>
            iso.versionID == versionId &&
            iso.clauseRef.toLowerCase() == clauseRef.toLowerCase() &&
            iso.id.toString() != (currentId ?? ''),
      );

      return existing.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking duplicate: $e');
      return false;
    }
  }

  /// FR-03, FR-04: Bulk Add Dialog with multi-row input
  void showBulkAddDialog() async {
    // FR-03: Check Add permission (Admin bypasses this check)
    if (!hasAddPermission && !isAdmin) {
      MotionToast.error(
        description: Text('You do not have permission to add ISO Standards'),
      ).show(context);
      return;
    }

    // Initialize with 5 empty rows
    _bulkRows = List.generate(
      5,
      (index) => {
        'clauseRef': TextEditingController(),
        'particulars': TextEditingController(),
        'description': TextEditingController(),
        'version': null,
        'hasError': false,
      },
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: mainBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              titlePadding: EdgeInsets.zero,
              title: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: primaryLightColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bulk Add ISO Clauses',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${_bulkRows.length} rows',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              content: SizedBox(
                width: 1100,
                height: 500,
                child: Column(
                  children: [
                    // FR-04: Add Row Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DottedButton(
                          onPressed: () {
                            setDialogState(() {
                              _bulkRows.add({
                                'clauseRef': TextEditingController(),
                                'particulars': TextEditingController(),
                                'description': TextEditingController(),
                                'version': null,
                                'hasError': false,
                              });
                            });
                          },
                          text: 'Add Row',
                          prefixIcon: Icon(Icons.add),
                        ),
                      ],
                    ),
                    gap8px,
                    // Bulk Input Table
                    Expanded(
                      child: SingleChildScrollView(
                        child: DataTable(
                          columnSpacing: 12,
                          headingRowColor: WidgetStatePropertyAll(
                            secondaryColor,
                          ),
                          columns: const [
                            DataColumn(label: Text('#')),
                            DataColumn(label: Text('Standard Version *')),
                            DataColumn(label: Text('Clause Ref *')),
                            DataColumn(label: Text('Particulars *')),
                            DataColumn(label: Text('Description')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: _bulkRows.asMap().entries.map((entry) {
                            int index = entry.key;
                            var row = entry.value;
                            return DataRow(
                              color: row['hasError']
                                  ? WidgetStatePropertyAll(Colors.red.shade50)
                                  : null,
                              cells: [
                                DataCell(Text('${index + 1}')),
                                // Version Dropdown
                                DataCell(
                                  SizedBox(
                                    width: 150,
                                    child:
                                        DropdownButtonFormField<
                                          StandardVersion
                                        >(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(8),
                                            hintText: 'Select',
                                          ),
                                          items: availableVersions
                                              .map(
                                                (version) =>
                                                    DropdownMenuItem<
                                                      StandardVersion
                                                    >(
                                                      value: version,
                                                      child: Text(
                                                        version.versionName,
                                                      ),
                                                    ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            setDialogState(() {
                                              row['version'] = value;
                                              row['hasError'] = false;
                                            });
                                          },
                                        ),
                                  ),
                                ),
                                // Clause Reference
                                DataCell(
                                  SizedBox(
                                    width: 100,
                                    child: TextField(
                                      controller: row['clauseRef'],
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                        hintText: 'e.g., 4.1',
                                        contentPadding: EdgeInsets.all(8),
                                      ),
                                      onChanged: (_) {
                                        setDialogState(() {
                                          row['hasError'] = false;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                // Particulars (Required)
                                DataCell(
                                  SizedBox(
                                    width: 200,
                                    child: TextField(
                                      controller: row['particulars'],
                                      maxLines: 2,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                        hintText: 'Enter particulars',
                                        contentPadding: EdgeInsets.all(8),
                                      ),
                                      onChanged: (_) {
                                        setDialogState(() {
                                          row['hasError'] = false;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                // Description (Optional)
                                DataCell(
                                  SizedBox(
                                    width: 200,
                                    child: TextField(
                                      controller: row['description'],
                                      maxLines: 2,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                        hintText: 'Optional',
                                        contentPadding: EdgeInsets.all(8),
                                      ),
                                      onChanged: (_) {
                                        setDialogState(() {
                                          row['hasError'] = false;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                // Delete Row
                                DataCell(
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: primaryColor,
                                    ),
                                    onPressed: () {
                                      setDialogState(() {
                                        _bulkRows.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Clear controllers
                    for (var row in _bulkRows) {
                      (row['clauseRef'] as TextEditingController).dispose();
                      (row['particulars'] as TextEditingController).dispose();
                      (row['description'] as TextEditingController).dispose();
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Cancel', style: TextStyle(color: primaryColor)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () async {
                    // FR-08: Validate all rows before saving
                    bool hasErrors = false;
                    List<IsoStandard> standardsToSave = [];

                    for (var row in _bulkRows) {
                      final version = row['version'] as StandardVersion?;
                      final clauseRef =
                          (row['clauseRef'] as TextEditingController).text
                              .trim();
                      final particulars =
                          (row['particulars'] as TextEditingController).text
                              .trim();
                      final description =
                          (row['description'] as TextEditingController).text
                              .trim();

                      // FR-09: Required field validation (version, clauseRef, particulars)
                      if (version == null ||
                          clauseRef.isEmpty ||
                          particulars.isEmpty) {
                        setDialogState(() {
                          row['hasError'] = true;
                        });
                        hasErrors = true;
                        continue;
                      }

                      // FR-07: Check duplicates
                      final isDuplicate = await _checkDuplicateClauseRef(
                        version.id,
                        clauseRef,
                      );

                      if (isDuplicate) {
                        setDialogState(() {
                          row['hasError'] = true;
                        });
                        hasErrors = true;
                        if (mounted) {
                          MotionToast.error(
                            description: Text(
                              'Duplicate: "$clauseRef" in ${version.versionName}',
                            ),
                          ).show(context);
                        }
                        continue;
                      }

                      standardsToSave.add(
                        IsoStandard(
                          id: 0,
                          clauseRef: clauseRef,
                          particulars: particulars,
                          description: description.isEmpty ? null : description,
                          version: version,
                          versionID: version.id,
                          isDeleted: false,
                          isActive: true,
                        ),
                      );
                    }

                    // FR-08: Block submission if any row has errors
                    if (hasErrors) {
                      if (mounted) {
                        MotionToast.error(
                          description: Text(
                            'Please fix all errors before saving (highlighted in red)',
                          ),
                        ).show(context);
                      }
                      return;
                    }

                    if (standardsToSave.isEmpty) {
                      if (mounted) {
                        MotionToast.warning(
                          description: Text('No valid records to save'),
                        ).show(context);
                      }
                      return;
                    }

                    // Confirm before saving
                    bool? confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirm Bulk Save'),
                        content: Text(
                          'Save ${standardsToSave.length} ISO Clause(s)?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('No'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('Yes'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      try {
                        // FR-08: Atomic bulk save with transaction support
                        await _isoStandardService.bulkCreateIsoStandards(
                          standardsToSave,
                        );

                        if (!mounted) return;

                        // Refresh full list after bulk save
                        await fetchAllIsoStandards();

                        if (mounted) {
                          MotionToast.success(
                            toastAlignment: Alignment.topCenter,
                            description: Text(
                              '${standardsToSave.length} records saved successfully',
                            ),
                          ).show(context);

                          // Clear and close
                          for (var row in _bulkRows) {
                            (row['clauseRef'] as TextEditingController)
                                .dispose();
                            (row['particulars'] as TextEditingController)
                                .dispose();
                            (row['description'] as TextEditingController)
                                .dispose();
                          }
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        if (mounted) {
                          MotionToast.error(
                            description: Text(
                              'Bulk save failed: ${e.toString()}',
                            ),
                          ).show(context);
                        }
                      }
                    }
                  },
                  child: Text(
                    'Save All',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMinimized = MediaQuery.of(context).size.width < 600;

    // FR-02: View permission check - if no view permission, show empty state
    if (!hasViewPermission) {
      return Scaffold(
        backgroundColor: mainBgColor,
        appBar: AppBar(
          title: const Text('ISO Standards'),
          backgroundColor: mainBgColor,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: grey),
              gap16px,
              Text(
                'You do not have permission to view ISO Standards',
                style: TextStyle(color: grey, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: const Text('ISO Standards'),
        backgroundColor: mainBgColor,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 300,
                      child: TextField(
                        focusNode: isSearchfocus,
                        controller: searchController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: lightGrey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelStyle: TextStyle(color: grey, fontSize: 14),
                          labelText: 'Search...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: isSearchfocus.hasFocus ? primaryColor : grey,
                            size: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          filled: true,
                          fillColor: secondaryColor,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 5,
                          ),
                        ),
                        onChanged: filterSearchResults,
                      ),
                    ),
                    SizedBox(width: 12),
                    // Toggle to show only Clause 4-10
                    Row(
                      children: [
                        Checkbox(
                          value: _showClause4to10,
                          onChanged: (v) async {
                            final newVal = v ?? false;
                            setState(() {
                              _showClause4to10 = newVal;
                            });
                            // Always use full dataset to preserve hierarchy
                            await fetchAllIsoStandards();
                          },
                        ),
                        Text('Show Clause 4–10'),
                      ],
                    ),
                    if (!isMinimized)
                      Row(
                        children: [
                          // Combined Add button with dropdown (only if Add permission)
                          if (hasAddPermission)
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'single') {
                                  showFormDialog();
                                } else if (value == 'bulk') {
                                  showBulkAddDialog();
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'single',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: primaryColor,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Add Single Entry'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'bulk',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.playlist_add,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text('Bulk Add Entries'),
                                    ],
                                  ),
                                ),
                              ],
                              child: ElevatedButton.icon(
                                onPressed: null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  disabledBackgroundColor: primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Add New',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: filteredList.isEmpty && !_isLoading
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.description_outlined,
                                size: 64,
                                color: grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No ISO Standards found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Add new standards to get started',
                                style: TextStyle(fontSize: 14, color: grey),
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header row matching the original table columns
                              Container(
                                color: secondaryColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 8,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(flex: 1, child: SizedBox()),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Clause Reference',
                                        style: TextStyle(color: grey),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Version Name',
                                        style: TextStyle(color: grey),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        'Particulars',
                                        style: TextStyle(color: grey),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Description',
                                        style: TextStyle(color: grey),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Status',
                                        style: TextStyle(color: grey),
                                      ),
                                    ),
                                    if (hasEditPermission) SizedBox(width: 120),
                                  ],
                                ),
                              ),
                              // Hierarchical content
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Builder(builder: (context) {
                                  final roots = _buildHierarchy(filteredList);
                                    final rootsToShow = _showClause4to10
                                      ? roots
                                        .where((n) =>
                                          _isMajorRootFourToTen(
                                            n.iso.clauseRef))
                                        .toList()
                                      : roots;

                                  return ListView.builder(
                                    itemCount: rootsToShow.length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final node = rootsToShow[index];
                                      return _showClause4to10
                                          ? _buildCompactNodeWidget(node, 0)
                                          : _buildNodeWidget(node, 0);
                                    },
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                ),
                // Pagination intentionally removed to preserve ExpansionTile
                // behavior. The full dataset is loaded and rendered as a
                // hierarchical tree, so page controls are not shown here.
              ],
            ),
          );
        },
      ),
      floatingActionButton: isMinimized && hasAddPermission
          ? FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () => showFormDialog(),
              child: Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  void showDeleteDialog(String id) {
    // FR-10: Check Edit permission for delete (Admin bypasses this check)
    if (!hasEditPermission && !isAdmin) {
      MotionToast.error(
        description: Text('You do not have permission to delete ISO Standards'),
      ).show(context);
      return;
    }

    // Capture the page context before showing dialog
    final pageContext = context;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete this ISO Standard? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text("Cancel", style: TextStyle(color: primaryTextColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                // Item and index are not needed here; directly refresh after delete

                try {
                  // Call delete API first
                  await _isoStandardService.deleteIsoStandard(id);
                  if (!mounted) return;

                  // Add to deleted IDs set so it stays removed
                  _deletedIds.add(id);
                  await _saveDeletedIds(); // Persist to local storage
                  // Refresh full list to ensure children/parents update correctly
                  if (mounted) {
                    await fetchAllIsoStandards();

                    MotionToast.success(
                      toastAlignment: Alignment.topCenter,
                      description: Text('ISO Standard deleted successfully'),
                    ).show(pageContext);
                  }
                } catch (e) {
                  if (mounted) {
                    MotionToast.error(
                      description: Text('Failed to Delete ISO Standard'),
                    ).show(pageContext);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
