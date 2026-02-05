// ignore_for_file: use_build_context_synchronously

import 'package:data_table_2/data_table_2.dart';
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
    fetchIsoStandards();
    fetchStandardVersions();
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
            if (iso.version.isActive &&
                !uniqueVersions.containsKey(iso.version.id)) {
              uniqueVersions[iso.version.id] = iso.version;
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
          _totalCount = pageList.totalCount;
          isoStandardList = pageList.items;
          filteredList = List.from(isoStandardList);
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

  Future<void> filterSearchResults(String query) async {
    final results = await isoStandardSearchUtil.filter(
      query,
      (isoStandard, search) =>
          (isoStandard.description).toLowerCase().contains(
            search.toLowerCase(),
          ) ||
          (isoStandard.clauseRef).toLowerCase().contains(search.toLowerCase()),
    );

    setState(() {
      filteredList = results;
    });
  }

  @override
  void dispose() {
    isSearchfocus.dispose();
    searchController.dispose();
    super.dispose();
  }

  /// Single Edit Dialog (FR-10: Edit permission)
  void showFormDialog({
    String? id,
    String? clauseRef,
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
                      // Description
                      SizedBox(
                        height: 100,
                        child: TextFormField(
                          controller: descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Description',
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
                          MotionToast.error(
                            description: Text(
                              'Clause "${clauseRefController.text}" already exists for ${selectedVersion!.versionName}',
                            ),
                          ).show(context);
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
                                MotionToast.error(
                                  toastAlignment: Alignment.topCenter,
                                  description: Text(
                                    'Failed to create version "$typedVersionName": ${e.toString()}',
                                  ),
                                ).show(context);
                                return; // Stop the save process
                              }
                            } else {
                              versionToUse = existingVersion;
                            }
                          }

                          final isoStandard = IsoStandard(
                            id: int.tryParse(id ?? '0') ?? 0,
                            clauseRef: clauseRefController.text.trim(),
                            description: descriptionController.text.trim(),
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

                          await fetchIsoStandards();

                          MotionToast.success(
                            toastAlignment: Alignment.topCenter,
                            description: Text(
                              id == null
                                  ? 'ISO Standard created successfully'
                                  : 'ISO Standard updated successfully',
                            ),
                          ).show(context);
                        } catch (e) {
                          if (!mounted) return;

                          Navigator.pop(context);

                          MotionToast.error(
                            toastAlignment: Alignment.topCenter,
                            description: Text(
                              'Failed to save: ${e.toString()}',
                            ),
                          ).show(context);

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
                width: 900,
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
                            DataColumn(label: Text('Description *')),
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
                                // Description
                                DataCell(
                                  SizedBox(
                                    width: 300,
                                    child: TextField(
                                      controller: row['description'],
                                      maxLines: 2,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        isDense: true,
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
                      final description =
                          (row['description'] as TextEditingController).text
                              .trim();

                      // FR-09: Empty field validation
                      if (version == null ||
                          clauseRef.isEmpty ||
                          description.isEmpty) {
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
                        MotionToast.error(
                          description: Text(
                            'Duplicate: "$clauseRef" in ${version.versionName}',
                          ),
                        ).show(context);
                        continue;
                      }

                      standardsToSave.add(
                        IsoStandard(
                          id: 0,
                          clauseRef: clauseRef,
                          description: description,
                          version: version,
                          versionID: version.id,
                          isDeleted: false,
                          isActive: true,
                        ),
                      );
                    }

                    // FR-08: Block submission if any row has errors
                    if (hasErrors) {
                      MotionToast.error(
                        description: Text(
                          'Please fix all errors before saving (highlighted in red)',
                        ),
                      ).show(context);
                      return;
                    }

                    if (standardsToSave.isEmpty) {
                      MotionToast.warning(
                        description: Text('No valid records to save'),
                      ).show(context);
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

                        await fetchIsoStandards();

                        MotionToast.success(
                          toastAlignment: Alignment.topCenter,
                          description: Text(
                            '${standardsToSave.length} records saved successfully',
                          ),
                        ).show(context);

                        // Clear and close
                        for (var row in _bulkRows) {
                          (row['clauseRef'] as TextEditingController).dispose();
                          (row['description'] as TextEditingController)
                              .dispose();
                        }
                        Navigator.pop(context);
                      } catch (e) {
                        MotionToast.error(
                          description: Text(
                            'Bulk save failed: ${e.toString()}',
                          ),
                        ).show(context);
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
          bool isMobile = constraints.maxWidth < 600;

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
                    if (!isMinimized)
                      Row(
                        children: [
                          // FR-03: Bulk Add button (only if Add permission)
                          if (hasAddPermission)
                            ElevatedButton.icon(
                              onPressed: showBulkAddDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              icon: const Icon(
                                Icons.playlist_add,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Bulk Add',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          if (hasAddPermission) SizedBox(width: 8),
                          // FR-01, FR-03: Add New button (only if Add permission)
                          if (hasAddPermission)
                            ElevatedButton.icon(
                              onPressed: () => showFormDialog(),
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
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: DataTable2(
                    columnSpacing: isMobile ? 16 : 40,
                    headingRowColor: WidgetStatePropertyAll(secondaryColor),
                    dataRowColor: WidgetStatePropertyAll(mainBgColor),
                    headingTextStyle: const TextStyle(color: grey),
                    horizontalMargin: 12,
                    minWidth: constraints.maxWidth,
                    fixedTopRows: 1,
                    border: TableBorder(
                      horizontalInside: BorderSide(color: Colors.grey.shade100),
                    ),
                    columns: [
                      DataColumn2(label: Text('#'), fixedWidth: 40),
                      DataColumn2(
                        label: Text('Clause Reference'),
                        size: ColumnSize.L,
                      ),
                      DataColumn(label: Text('Version Name')),
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Status')),
                      // FR-02, FR-10: Show Actions only if has Edit permission
                      if (hasEditPermission) DataColumn(label: Text('Actions')),
                    ],
                    rows: filteredList.asMap().entries.map((entry) {
                      int index = entry.key;
                      var isoStandard = entry.value;
                      int itemNumber =
                          ((_currentPage - 1) * _pageSize) + index + 1;

                      return DataRow(
                        cells: [
                          DataCell(Text(itemNumber.toString())),
                          DataCell(Text(isoStandard.clauseRef)),
                          DataCell(Text(isoStandard.version.versionName)),
                          DataCell(
                            Text(
                              isoStandard.description.length > 50
                                  ? '${isoStandard.description.substring(0, 50)}...'
                                  : isoStandard.description,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isoStandard.isActive
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isoStandard.isActive ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isoStandard.isActive
                                      ? Colors.green.shade800
                                      : Colors.red.shade800,
                                ),
                              ),
                            ),
                          ),
                          // FR-10: Edit and Delete buttons (only if has Edit permission)
                          if (hasEditPermission)
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => showFormDialog(
                                      id: isoStandard.id.toString(),
                                      clauseRef: isoStandard.clauseRef,
                                      description: isoStandard.description,
                                      version: isoStandard.version,
                                      versionID: isoStandard.versionID,
                                      isActive: isoStandard.isActive,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: primaryColor,
                                    ),
                                    onPressed: () {
                                      showDeleteDialog(
                                        isoStandard.id.toString(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  color: secondaryColor,
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
                        onPageChanged: (page) => fetchIsoStandards(page: page),
                      ),
                      Container(width: 60),
                    ],
                  ),
                ),
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

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text(
            "Are you sure you want to delete this ISO Standard? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: primaryTextColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await _isoStandardService.deleteIsoStandard(id);
                  await fetchIsoStandards();
                  MotionToast.success(
                    toastAlignment: Alignment.topCenter,
                    description: Text('ISO Standard deleted successfully'),
                  ).show(context);
                } catch (e) {
                  MotionToast.error(
                    description: Text('Failed to Delete ISO Standard'),
                  ).show(context);
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
