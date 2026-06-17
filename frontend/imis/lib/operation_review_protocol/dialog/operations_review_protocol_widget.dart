// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/models/pgs_deliverable_accomplishment.dart';
import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/operation_review_protocol/models/operations_review_protocol.dart';
import 'package:imis/performance_governance_system/models/performance_governance_system.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/widgets/permission/permission_widget.dart';
import 'package:imis/widgets/common/status_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' as html;
import 'package:dio/dio.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:motion_toast/motion_toast.dart';

class OperationsReviewDialog extends StatefulWidget {
  final PerformanceGovernanceSystem data;
  final List<PgsDeliverableAccomplishment> accomplishments;
  final DateTime month;
  final OperationsReviewProtocol? existingProtocol;
  final Future<bool> Function(
    OperationsReviewProtocol request, {
    Uint8List? minutesBytes,
    String? minutesFileName,
  })
  onSave;
  final Future<bool> Function(List<({int id, int status})> updates)
  onSaveAccomplishments;
  const OperationsReviewDialog({
    super.key,
    required this.data,
    required this.accomplishments,
    required this.month,
    this.existingProtocol,
    required this.onSave,
    required this.onSaveAccomplishments,
  });

  @override
  State<OperationsReviewDialog> createState() => _OperationsReviewDialogState();
}

class _OperationsReviewDialogState extends State<OperationsReviewDialog> {
  String _serviceName = '—';
  final _deputyController = TextEditingController();
  final _documenterController = TextEditingController();
  final _venueController = TextEditingController();
  final _frequencyScheduleController = TextEditingController();
  final _scoreboardLocationController = TextEditingController();
  final _scoreboardOICController = TextEditingController();
  final _actionPointsController = TextEditingController();
  final _frequencyUpdateController = TextEditingController();
  final _celebrateWinsController = TextEditingController();
  final _recognizeRewardController = TextEditingController();
  final _frequencyController = TextEditingController();
  String? _minutesFileName;
  Uint8List? _minutesBytes;
  bool _minutesDeleted = false;
  String? _existingMinutesPath;
  bool _minutesLoading = false;
  Uint8List? _minutesServerImageCache;
  final Dio _dio = Dio();
  String _headName = '—';
  bool _deputyError = false;
  bool _frequencyScheduleError = false;
  bool _venueError = false;
  bool _scoreboardLocationError = false;
  bool _scoreboardOICError = false;
  bool _actionPlanError = false;
  bool _frequencyUpdateError = false;
  bool _celebrateWinsError = false;
  bool _recognizeRewardError = false;
  bool _frequencyError = false;
  bool _documenterError = false;
  bool _minutesFileError = false;
  bool _isSaving = false;
  final Map<int, PgsStatus> _selectedStatuses = {};
  String get _monthLabel {
    const names = [
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
    return '${names[widget.month.month - 1]} ${widget.month.year}';
  }

  @override
  void dispose() {
    _deputyController.dispose();
    _documenterController.dispose();
    _venueController.dispose();
    _frequencyScheduleController.dispose();
    _scoreboardLocationController.dispose();
    _scoreboardOICController.dispose();
    _actionPointsController.dispose();
    _frequencyUpdateController.dispose();
    _celebrateWinsController.dispose();
    _recognizeRewardController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _populateExistingData();
    _loadHeadName();
    _loadParentService();

    for (var acc in widget.accomplishments) {
      _selectedStatuses[acc.id] = _resolveStatus(
        pgsStatus: acc.pgsStatus,
        statusInt: acc.status,
      );
    }
  }

  Future<void> _loadParentService() async {
    try {
      final loggedUser = await AuthUtil.processTokenValidity(_dio, context);
      final token = loggedUser?.accessToken;
      if (token == null) return;

      final response = await _dio.get<String>(
        '${ApiEndpoint.baseUrl}/office/${widget.data.office.id}/parent',
        options: Options(
          responseType: ResponseType.plain,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (!mounted) return;
      setState(() {
        _serviceName = (response.data ?? '').replaceAll('"', '');
      });
    } catch (e) {
      debugPrint('Failed to load parent service: $e');
    }
  }

  void _populateExistingData() {
    final p = widget.existingProtocol;
    if (p == null) return;
    _deputyController.text = p.deputy ?? '';
    _documenterController.text = p.documenter ?? '';
    _venueController.text = p.venue ?? '';
    _frequencyScheduleController.text = p.frequencySchedule ?? '';
    _scoreboardLocationController.text = p.scoreboardLocation ?? '';
    _scoreboardOICController.text = p.scoreboardOIC ?? '';
    _actionPointsController.text = p.actionPlan ?? '';
    _frequencyUpdateController.text = p.frequencyUpdate ?? '';
    _celebrateWinsController.text = p.form1 ?? '';
    _recognizeRewardController.text = p.form2 ?? '';
    _frequencyController.text = p.frequency ?? '';
    _existingMinutesPath = p.minutesAttachmentPath;
    if (_existingMinutesPath != null && _existingMinutesPath!.isNotEmpty) {
      _minutesFileName = _existingMinutesPath!.split('/').last;
      _prefetchMinutesImage();
    }
  }

  Future<void> _loadHeadName() async {
    final existing = widget.existingProtocol;
    if (existing?.fullName != null && existing!.fullName!.isNotEmpty) {
      setState(() => _headName = existing.fullName!);
      return;
    }

    final user = await AuthUtil.fetchLoggedUser();
    if (user == null || !mounted) return;

    setState(() {
      final first = user.firstName ?? '';
      final middle = user.middleName ?? '';
      final last = user.lastName ?? '';
      _headName = [
        first,
        middle.isNotEmpty ? '${middle[0]}.' : '',
        last,
      ].where((s) => s.isNotEmpty).join(' ');
    });
  }

  bool _isPdf(String? name) =>
      name != null && name.toLowerCase().endsWith('.pdf');

  Future<void> _prefetchMinutesImage() async {
    final p = widget.existingProtocol;
    if (p == null) return;
    final name = _minutesFileName ?? '';
    if (_isPdf(name) || name.isEmpty) return;

    try {
      final loggedUser = await AuthUtil.processTokenValidity(_dio, context);
      final token = loggedUser?.accessToken;
      if (token == null) return;

      final previewUrl = '${ApiEndpoint.baseUrl}/${p.id}/download-preview';

      final response = await _dio.get<List<int>>(
        previewUrl,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (mounted) {
        setState(() {
          _minutesServerImageCache = Uint8List.fromList(response.data!);
        });
      }
    } catch (e) {
      debugPrint('Minutes thumbnail prefetch failed');
    }
  }

  Future<void> _pickMinutesFile() async {
    setState(() => _minutesLoading = true);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        allowMultiple: false,
        withData: true,
      );

      if (result != null) {
        final file = result.files.first;
        final fileSizeInMB = file.size / (1024 * 1024);

        if (fileSizeInMB > 10) {
          MotionToast.warning(
            description: const Text(
              'File too large! Maximum allowed size is 10 MB.',
            ),
            toastDuration: const Duration(seconds: 3),
            toastAlignment: Alignment.topCenter,
          ).show(context);
          setState(() => _minutesLoading = false);
          return;
        }

        Uint8List bytes;
        if (kIsWeb) {
          bytes = file.bytes!;
        } else {
          bytes = await File(file.path!).readAsBytes();
        }

        setState(() {
          _minutesFileName = file.name;
          _minutesBytes = bytes;
          _minutesDeleted = false;
          _minutesServerImageCache = null;
        });
      }
    } catch (e) {
      debugPrint('Minutes file picking failed: $e');
    } finally {
      setState(() => _minutesLoading = false);
    }
  }

  Future<void> _openMinutesPreview() async {
    final loggedUser = await AuthUtil.processTokenValidity(_dio, context);
    final token = loggedUser?.accessToken;
    if (token == null) return;
    final name = _minutesFileName ?? 'minutes';
    final isPdf = _isPdf(name);
    if (_minutesBytes != null) {
      if (kIsWeb) {
        if (isPdf) {
          final blob = html.Blob([_minutesBytes!], 'application/pdf');
          final url = html.Url.createObjectUrlFromBlob(blob);
          html.window.open(url, '_blank');
          Future.delayed(
            const Duration(seconds: 5),
            () => html.Url.revokeObjectUrl(url),
          );
        } else {
          _showImageDialog(context, MemoryImage(_minutesBytes!), name);
        }
      } else {
        if (isPdf) {
          final tmp = File('${Directory.systemTemp.path}/$name');
          await tmp.writeAsBytes(_minutesBytes!);
          await OpenFile.open(tmp.path);
        } else {
          _showImageDialog(context, MemoryImage(_minutesBytes!), name);
        }
      }
      return;
    }

    final p = widget.existingProtocol;
    if (p == null) return;

    final previewUrl = '${ApiEndpoint.baseUrl}/${p.id}/download-preview';

    if (kIsWeb) {
      if (isPdf) {
        html.window.open(previewUrl, '_blank');
      } else {
        try {
          final response = await _dio.get<List<int>>(
            previewUrl,
            options: Options(
              responseType: ResponseType.bytes,
              headers: {'Authorization': 'Bearer $token'},
            ),
          );
          final bytes = Uint8List.fromList(response.data!);
          _showImageDialog(context, MemoryImage(bytes), name);
        } catch (e) {
          debugPrint('Minutes preview fetch failed: $e');
        }
      }
    } else {
      try {
        final tmp = File('${Directory.systemTemp.path}/$name');
        await _dio.download(
          previewUrl,
          tmp.path,
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
        if (await tmp.exists()) {
          if (isPdf) {
            await OpenFile.open(tmp.path);
          } else {
            final bytes = await tmp.readAsBytes();
            _showImageDialog(context, MemoryImage(bytes), name);
          }
        }
      } catch (e) {
        debugPrint('Minutes preview download failed: $e');
      }
    }
  }

  void _showImageDialog(
    BuildContext context,
    ImageProvider image,
    String title,
  ) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.black87,
            insetPadding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.75,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: InteractiveViewer(
                    child: Image(
                      image: image,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (_, __, ___) => const Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'Unable to load image.',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
    );
  }

  Uint8List? get _minutesThumbnailBytes =>
      _minutesBytes ?? _minutesServerImageCache;

  bool get _hasMinutesAttachment {
    if (_minutesBytes != null) return true;
    if (!_minutesDeleted &&
        _existingMinutesPath != null &&
        _existingMinutesPath!.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> _save() async {
    setState(() {
      _deputyError = _deputyController.text.trim().isEmpty;
      _documenterError = _documenterController.text.trim().isEmpty;
      _frequencyError = _frequencyController.text.trim().isEmpty;
      _frequencyScheduleError =
          _frequencyScheduleController.text.trim().isEmpty;
      _venueError = _venueController.text.trim().isEmpty;
      _scoreboardLocationError =
          _scoreboardLocationController.text.trim().isEmpty;
      _scoreboardOICError = _scoreboardOICController.text.trim().isEmpty;
      _actionPlanError = _actionPointsController.text.trim().isEmpty;
      _frequencyUpdateError = _frequencyUpdateController.text.trim().isEmpty;
      _celebrateWinsError = _celebrateWinsController.text.trim().isEmpty;
      _recognizeRewardError = _recognizeRewardController.text.trim().isEmpty;
      _minutesFileError = !_hasMinutesAttachment;
    });

    if (_deputyError ||
        _documenterError ||
        _frequencyError ||
        _frequencyScheduleError ||
        _venueError ||
        _scoreboardLocationError ||
        _scoreboardOICError ||
        _actionPlanError ||
        _frequencyUpdateError ||
        _celebrateWinsError ||
        _recognizeRewardError ||
        _minutesFileError) {
      return;
    }

    setState(() => _isSaving = true);

    final user = await AuthUtil.fetchLoggedUser();
    if (user == null) return;

    final request = OperationsReviewProtocol(
      widget.existingProtocol?.id ?? 0,
      widget.data.office.id,
      user.id,
      _deputyController.text.trim(),
      _documenterController.text.trim(),
      widget.data.id,
      _venueController.text.trim(),
      _scoreboardLocationController.text.trim(),
      _scoreboardOICController.text.trim(),
      _actionPointsController.text.trim(),
      _celebrateWinsController.text.trim(),
      _recognizeRewardController.text.trim(),
      null,
      _frequencyScheduleController.text.trim(),
      _frequencyUpdateController.text.trim(),
      _frequencyController.text.trim(),
      _minutesDeleted ? '' : (_existingMinutesPath ?? ''),
      widget.month,
      false,
    );

    final accomplishmentUpdates =
        _selectedStatuses.entries.map((entry) {
          return (id: entry.key, status: _pgsStatusToInt(entry.value));
        }).toList();

    final results = await Future.wait([
      widget.onSave(
        request,
        minutesBytes: _minutesBytes,
        minutesFileName: _minutesFileName,
      ),
      widget.onSaveAccomplishments(accomplishmentUpdates),
    ]);

    if (!mounted) return;
    setState(() => _isSaving = false);
    final allSuccess = results.every((r) => r);
    if (allSuccess) {
      Navigator.pop(context);
      MotionToast.success(
        toastAlignment: Alignment.topCenter,
        description: Text('Saved successfully'),
      ).show(context);
    } else {
      MotionToast.error(
        toastAlignment: Alignment.topCenter,
        description: Text('Failed to save'),
      ).show(context);
    }
  }

  int _pgsStatusToInt(PgsStatus status) {
    switch (status) {
      case PgsStatus.notStarted:
        return 0;
      case PgsStatus.onGoing:
        return 1;
      case PgsStatus.completed:
        return 2;
    }
  }

  PgsStatus _resolveStatus({String? pgsStatus, int? statusInt}) {
    if (pgsStatus != null) {
      switch (pgsStatus) {
        case 'onGoing':
          return PgsStatus.onGoing;
        case 'completed':
          return PgsStatus.completed;
        default:
          return PgsStatus.notStarted;
      }
    }
    if (statusInt == 2) return PgsStatus.completed;
    if (statusInt == 1) return PgsStatus.onGoing;
    return PgsStatus.notStarted;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 700;

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.transparent,
      child: Container(
        width: isMobile ? double.infinity : size.width * 0.82,
        height: size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildTopInfo(isMobile),
                      const SizedBox(height: 18),
                      _buildStrategicSection(isMobile),
                      const SizedBox(height: 18),
                      _buildConversationSection(isMobile),
                      const SizedBox(height: 18),
                      _buildFeedbackSection(isMobile),
                      const SizedBox(height: 18),
                      _buildRecognitionSection(isMobile),
                    ],
                  ),
                ),
              ),
              _buildBottomButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      color: primaryColor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'OPERATIONS REVIEW PROTOCOL',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _monthLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 13,
                ),
              ),
            ],
          ),

          Positioned(
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white70, size: 20),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopInfo(bool isMobile) {
    final p = widget.existingProtocol;
    final office = widget.data.office;

    final departmentLabel = p?.departmentName ?? office.name;

    final bool showHead = p != null;

    if (isMobile) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Column(
          children: [
            _readOnlyField('Department', departmentLabel),

            _readOnlyField('Service', _serviceName),

            if (showHead) _readOnlyField('Head', p.fullName ?? _headName),
            _requiredInputField(
              label: 'Documenter',
              controller: _documenterController,
              hasError: _documenterError,
            ),
            _requiredInputField(
              label: 'Deputy',
              controller: _deputyController,
              hasError: _deputyError,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                _readOnlyField('Department', departmentLabel),
                _readOnlyField('Service', _serviceName),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              children: [
                if (showHead) _readOnlyField('Head', p.fullName ?? _headName),
                _requiredInputField(
                  label: 'Documenter',
                  controller: _documenterController,
                  hasError: _documenterError,
                ),
                _requiredInputField(
                  label: 'Deputy',
                  controller: _deputyController,
                  hasError: _deputyError,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrategicSection(bool isMobile) {
    final accomplishments = widget.accomplishments;
    final fmt = DateFormat('MMM dd, yyyy');
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Center(
                    child: Text(
                      'STRATEGIC CONTRIBUTIONS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'DUE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'STATUS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (accomplishments.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'No deliverables found for this month.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children:
                    accomplishments.map((acc) {
                      final byWhen =
                          acc.byWhen != null ? fmt.format(acc.byWhen!) : '—';
                      _resolveStatus(
                        pgsStatus: acc.pgsStatus,
                        statusInt: acc.status,
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child:
                            isMobile
                                ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _readOnlyField(
                                      'Deliverable',
                                      acc.deliverableName ?? '—',
                                    ),
                                    _readOnlyField('DUE', byWhen),
                                    statusDropdown(
                                      label: 'Status',
                                      value:
                                          _selectedStatuses[acc.id] ??
                                          PgsStatus.notStarted,
                                      onChanged: (value) {
                                        if (value == null) return;

                                        setState(() {
                                          _selectedStatuses[acc.id] = value;
                                        });
                                      },
                                    ),
                                    const Divider(),
                                  ],
                                )
                                : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: _readOnlyField(
                                        'Deliverable',
                                        acc.deliverableName ?? '—',
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      flex: 2,
                                      child: _readOnlyField('Due', byWhen),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      flex: 2,

                                      child: statusDropdown(
                                        label: 'Status',
                                        value:
                                            _selectedStatuses[acc.id] ??
                                            PgsStatus.notStarted,
                                        onChanged: (value) {
                                          if (value == null) return;

                                          setState(() {
                                            _selectedStatuses[acc.id] = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                      );
                    }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConversationSection(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child:
          isMobile
              ? Column(
                children: [
                  _sectionTitle('CONVERSATION'),
                  _requiredInputField(
                    label: 'Venue',
                    controller: _venueController,
                    hasError: _venueError,
                  ),
                  _requiredInputField(
                    label: 'Frequency & Schedule',
                    controller: _frequencyScheduleController,
                    hasError: _frequencyScheduleError,
                  ),
                  _buildMinutesAttachmentField(),
                ],
              )
              : Column(
                children: [
                  _sectionTitle('CONVERSATION'),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            _requiredInputField(
                              label: 'Venue',
                              controller: _venueController,
                              hasError: _venueError,
                            ),
                            _buildMinutesAttachmentField(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _requiredInputField(
                          label: 'Frequency & Schedule',
                          controller: _frequencyScheduleController,
                          hasError: _frequencyScheduleError,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
    );
  }

  Widget _buildMinutesAttachmentField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meeting Minutes',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child:
                _minutesLoading
                    ? const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                    : _hasMinutesAttachment
                    ? _buildMinutesWithAttachment()
                    : _buildMinutesEmpty(),
          ),
        ],
      ),
    );
  }

  Widget _buildMinutesEmpty() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            Icons.upload_file_outlined,
            color: _minutesFileError ? Colors.red : Colors.blue,
          ),
          onPressed: _pickMinutesFile,
        ),

        Text(
          'Upload 1 supported file: Image only. Max 10 MB',
          style: TextStyle(
            color: _minutesFileError ? Colors.red : Colors.grey.shade500,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),

        if (_minutesFileError)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'Minutes file is required',
              style: TextStyle(color: Colors.red, fontSize: 11),
            ),
          ),
      ],
    );
  }

  Widget _buildMinutesWithAttachment() {
    final name =
        _minutesFileName ??
        _existingMinutesPath?.split('/').last ??
        'attachment';
    final isPdf = _isPdf(name);
    final thumbBytes = _minutesThumbnailBytes;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _openMinutesPreview,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child:
                isPdf
                    ? _buildPdfThumbnail(name)
                    : thumbBytes != null
                    ? Image.memory(
                      thumbBytes,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildImageErrorBox(),
                    )
                    : _buildImageLoadingBox(),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: _openMinutesPreview,
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 11,
                    decoration: TextDecoration.underline,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
            SizedBox(
              width: 28,
              height: 28,
              child: IconButton(
                icon: Icon(Icons.delete, size: 16, color: Colors.grey.shade500),
                padding: EdgeInsets.zero,
                tooltip: 'Delete',
                onPressed: () {
                  setState(() {
                    _minutesFileName = null;
                    _minutesBytes = null;
                    _minutesServerImageCache = null;
                    _minutesDeleted = true;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageLoadingBox() => Container(
    width: 72,
    height: 72,
    color: Colors.grey[200],
    child: const Center(
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    ),
  );

  Widget _buildImageErrorBox() => Container(
    width: 72,
    height: 72,
    color: Colors.grey[200],
    child: const Icon(Icons.broken_image, color: Colors.grey),
  );

  Widget _buildPdfThumbnail(String name) => Container(
    width: 72,
    height: 72,
    decoration: BoxDecoration(
      color: Colors.red.shade50,
      border: Border.all(color: Colors.red.shade200),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.picture_as_pdf, color: Colors.red.shade400, size: 32),
        const SizedBox(height: 4),
        const Text(
          'PDF',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ],
    ),
  );
  Widget _buildFeedbackSection(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child:
          isMobile
              ? Column(
                children: [
                  _sectionTitle('FEEDBACK'),
                  _requiredInputField(
                    label: 'Scoreboard Location',
                    controller: _scoreboardLocationController,
                    hasError: _scoreboardLocationError,
                  ),
                  _requiredInputField(
                    label: 'Scoreboard OIC',
                    controller: _scoreboardOICController,
                    hasError: _scoreboardOICError,
                  ),
                  _requiredInputField(
                    label: 'Action Plan/Point',
                    controller: _actionPointsController,
                    maxLines: 4,
                    hasError: _actionPlanError,
                  ),
                  _requiredInputField(
                    label: 'Frequency of update',
                    controller: _frequencyUpdateController,
                    hasError: _frequencyUpdateError,
                  ),
                ],
              )
              : Column(
                children: [
                  _sectionTitle('FEEDBACK'), // ← shared header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            _requiredInputField(
                              label: 'Scoreboard Location',
                              controller: _scoreboardLocationController,
                              hasError: _scoreboardLocationError,
                            ),
                            _requiredInputField(
                              label: 'Scoreboard OIC',
                              controller: _scoreboardOICController,
                              hasError: _scoreboardOICError,
                            ),
                            _requiredInputField(
                              label: 'Action Plan/Point',
                              controller: _actionPointsController,
                              maxLines: 4,
                              hasError: _actionPlanError,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _requiredInputField(
                          // ← aligned with Scoreboard Location
                          label: 'Frequency of update',
                          controller: _frequencyUpdateController,
                          hasError: _frequencyUpdateError,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
    );
  }

  Widget _buildRecognitionSection(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child:
          isMobile
              ? Column(
                children: [
                  _sectionTitle('RECOGNITION'),
                  _requiredInputField(
                    label: 'How do we celebrate wins as a unit?',
                    controller: _celebrateWinsController,
                    hasError: _celebrateWinsError,
                    maxLines: 3,
                  ),
                  _requiredInputField(
                    label:
                        'How do we recognize and reward the best performing members?',
                    controller: _recognizeRewardController,
                    hasError: _recognizeRewardError,
                    maxLines: 3,
                  ),
                  _requiredInputField(
                    label: 'Frequency',
                    controller: _frequencyController,
                    hasError: _frequencyError,
                  ),
                ],
              )
              : Column(
                children: [
                  _sectionTitle('RECOGNITION'),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            _requiredInputField(
                              label: 'How do we celebrate wins as a unit?',
                              controller: _celebrateWinsController,
                              maxLines: 3,
                              hasError: _celebrateWinsError,
                            ),
                            _requiredInputField(
                              label:
                                  'How do we recognize and reward the best performing members?',
                              controller: _recognizeRewardController,
                              maxLines: 3,
                              hasError: _recognizeRewardError,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _requiredInputField(
                          label: 'Frequency',
                          controller: _frequencyController,
                          hasError: _frequencyError,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _isSaving ? null : () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: primaryTextColor),
            ),
          ),
          const SizedBox(width: 12),
          PermissionWidget(
            permission: AppPermissions.addOperationReviewProtocol,
            child: ElevatedButton(
              onPressed:
                  _isSaving
                      ? null
                      : () async {
                        setState(() {
                          _deputyError = _deputyController.text.trim().isEmpty;
                          _documenterError =
                              _documenterController.text.trim().isEmpty;
                          _frequencyError =
                              _frequencyController.text.trim().isEmpty;
                          _frequencyScheduleError =
                              _frequencyScheduleController.text.trim().isEmpty;
                          _venueError = _venueController.text.trim().isEmpty;
                          _scoreboardLocationError =
                              _scoreboardLocationController.text.trim().isEmpty;
                          _scoreboardOICError =
                              _scoreboardOICController.text.trim().isEmpty;
                          _actionPlanError =
                              _actionPointsController.text.trim().isEmpty;
                          _frequencyUpdateError =
                              _frequencyUpdateController.text.trim().isEmpty;
                          _celebrateWinsError =
                              _celebrateWinsController.text.trim().isEmpty;
                          _recognizeRewardError =
                              _recognizeRewardController.text.trim().isEmpty;
                          _minutesFileError = !_hasMinutesAttachment;
                        });

                        if (_deputyError ||
                            _documenterError ||
                            _frequencyError ||
                            _frequencyScheduleError ||
                            _venueError ||
                            _scoreboardLocationError ||
                            _scoreboardOICError ||
                            _actionPlanError ||
                            _frequencyUpdateError ||
                            _celebrateWinsError ||
                            _recognizeRewardError ||
                            _minutesFileError) {
                          return;
                        }

                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder:
                              (ctx) => AlertDialog(
                                title: Text(
                                  widget.existingProtocol != null
                                      ? 'Confirm Update'
                                      : 'Confirm Save',
                                ),
                                content: Text(
                                  widget.existingProtocol != null
                                      ? 'Are you sure you want to update this record?'
                                      : 'Are you sure you want to save this record?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: Text(
                                      'No',
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(color: primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                        );

                        if (confirmed == true) await _save();
                      },

              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(_isSaving ? 'Saving...' : 'Save'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _readOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: TextEditingController(text: value),
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _requiredInputField({
    required String label,
    required TextEditingController controller,
    bool hasError = false,
    int? maxLines,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        onChanged: (_) {
          if (hasError) setState(() {});
        },
        decoration: InputDecoration(
          labelText: '$label *',
          alignLabelWithHint: (maxLines ?? 1) > 1,
          filled: true,
          fillColor: Colors.grey.shade50,
          errorText:
              hasError && controller.text.trim().isEmpty
                  ? '$label is required'
                  : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(
              color:
                  hasError && controller.text.trim().isEmpty
                      ? Colors.red
                      : Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.grey.shade200),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
