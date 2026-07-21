import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/osm_calendar_activity/models/osm_calendar_activity.dart';
import 'package:imis/osm_calendar_activity/pages/calendar_event.dart';
import 'package:imis/osm_calendar_activity/services/osm_calendar_activity_services.dart';
import 'package:imis/user/models/user_registration.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/widgets/common/search_dropdown.dart';
import 'package:imis/widgets/dialog/delete_dialog.dart';
import 'package:imis/widgets/dialog/dialog_field.dart';
import 'package:imis/widgets/permission/permission_widget.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' as html;

class EventDetailDialog extends StatefulWidget {
  final OsmCalendarActivity event;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const EventDetailDialog({
    super.key,
    required this.event,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<EventDetailDialog> createState() => _EventDetailDialogState();
}

class _EventDetailDialogState extends State<EventDetailDialog> {
  final _service = OsmCalendarActivityServices(Dio());
  Uint8List? _imageBytes;
  bool _imageLoading = false;
  bool _imageFailed = false;

  OsmCalendarActivity get event => widget.event;

  bool get _isPdf =>
      (event.attachmentName ?? '').toLowerCase().endsWith('.pdf');

  bool get _hasAttachment =>
      event.attachmentName != null && event.attachmentName!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (_hasAttachment && !_isPdf) _loadImage();
  }

  Future<void> _loadImage() async {
    setState(() => _imageLoading = true);
    try {
      final bytes = await _service.getActivityAttachmentPreview(event.id);
      if (mounted) {
        setState(() {
          _imageBytes = Uint8List.fromList(bytes);
          _imageLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Attachment image load failed: $e');
      if (mounted) {
        setState(() {
          _imageFailed = true;
          _imageLoading = false;
        });
      }
    }
  }

  Future<void> _openAttachment() async {
    final name = event.attachmentName ?? 'attachment';

    if (_isPdf) {
      try {
        final bytes = await _service.getActivityAttachmentPreview(event.id);

        if (kIsWeb) {
          // On web, open bytes as a blob URL
          final blob = html.Blob([bytes], 'application/pdf');
          final url = html.Url.createObjectUrlFromBlob(blob);
          html.window.open(url, '_blank');
          html.Url.revokeObjectUrl(url);
        } else {
          final tempFile = File('${Directory.systemTemp.path}/$name');
          await tempFile.writeAsBytes(bytes);
          await OpenFile.open(tempFile.path);
        }
      } catch (e) {
        debugPrint('PDF open failed: $e');
      }
      return;
    }

    if (_imageBytes != null) {
      _showImageViewer(MemoryImage(_imageBytes!), name);
    }
  }

  void _showImageViewer(ImageProvider image, String title) {
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
                    child: Image(image: image, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? userFullName = event.userFullName;
    final String? officeName = event.officeName;
    final String officeUser = '$userFullName • $officeName';
    return Dialog(
      backgroundColor: kSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Event Details',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: kText,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: kMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildEventCard(event),
              const SizedBox(height: 14),
              _infoCard(
                Icons.calendar_today_outlined,
                'DATE',
                formatDate(event.dateOnly),
              ),
              const SizedBox(height: 10),
              _infoCard(Icons.access_time, 'TIME', event.timeLabel),

              if ((event.location ?? '').isNotEmpty) ...[
                const SizedBox(height: 10),
                _infoCard(
                  Icons.location_on_outlined,
                  'LOCATION',
                  event.location!,
                ),
              ],
              const SizedBox(height: 10),
              _infoCard(
                Icons.assignment_ind_outlined,
                'SCHEDULED BY',
                officeUser,
              ),
              if (_hasAttachment) ...[
                const SizedBox(height: 14),
                Text(
                  'ATTACHMENT',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: kMuted,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 8),
                _buildAttachmentPreview(),
              ],

              const SizedBox(height: 22),

              PermissionWidget(
                permission: AppPermissions.editCalendarActivity,
                child: Row(
                  children: [
                    if (widget.onDelete != null)
                      PermissionWidget(
                        permission: AppPermissions.deleteCalendarActivity,
                        child: Expanded(
                          child: OutlinedButton.icon(
                            onPressed:
                                () => showDeleteDialog(event.id.toString()),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: kBorder),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(
                              CupertinoIcons.delete_simple,
                              size: 18,
                              color: kDanger,
                            ),
                            label: Text(
                              'Delete',
                              style: GoogleFonts.plusJakartaSans(
                                color: kDanger,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (widget.onDelete != null && widget.onEdit != null)
                      const SizedBox(width: 10),
                    if (widget.onEdit != null)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            widget.onEdit!();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Edit',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDeleteDialog(String id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (ctx) => DeleteDialog(
            title: 'Event',
            itemName: 'event',
            onDelete: () async {
              Navigator.pop(ctx);
              try {
                await _service.deleteCalendar(id);
                if (!mounted) return;
                MotionToast.success(
                  toastAlignment: Alignment.topCenter,
                  description: Text(
                    'Event deleted successfully',
                    style: GoogleFonts.plusJakartaSans(),
                  ),
                ).show(context);
                Navigator.pop(context);
                widget.onDelete?.call();
              } catch (e) {
                debugPrint('Delete calendar failed: $e');
                if (!mounted) return;
                MotionToast.error(
                  toastAlignment: Alignment.topCenter,
                  description: Text(
                    'Failed to delete event',
                    style: GoogleFonts.plusJakartaSans(),
                  ),
                ).show(context);
              }
            },
          ),
    );
  }

  Widget _buildEventCard(OsmCalendarActivity event) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: kBackground,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 5, color: event.displayColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        event.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: kText,
                        ),
                      ),
                      if ((event.description ?? '').isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          event.description!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: kMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(
    IconData icon,
    String label,
    String value, {
    Color? highlightColor,
  }) {
    final accent = highlightColor;
    final bgColor = accent?.withOpacity(0.08) ?? kBackground;
    final borderColor = accent ?? kBorder;
    final iconBg = accent?.withOpacity(0.15) ?? kSurface;
    final iconColor = accent ?? kMuted;
    final labelColor = accent ?? kMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: accent != null ? 1.5 : 1),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor),
            ),
            child: Icon(icon, size: 17, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: labelColor,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? '—' : value,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentPreview() {
    final name = event.attachmentName ?? 'attachment';

    return GestureDetector(
      onTap: _openAttachment,
      child: Container(
        decoration: BoxDecoration(
          color: kBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kBorder),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  _isPdf
                      ? Container(
                        width: 56,
                        height: 56,
                        color: Colors.red.shade50,
                        child: Icon(
                          Icons.picture_as_pdf,
                          color: Colors.red.shade400,
                          size: 28,
                        ),
                      )
                      : _imageLoading
                      ? Container(
                        width: 56,
                        height: 56,
                        color: Colors.grey[200],
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      )
                      : (_imageBytes != null && !_imageFailed)
                      ? Image.memory(
                        _imageBytes!,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      )
                      : Container(
                        width: 56,
                        height: 56,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(fontSize: 13, color: kText),
              ),
            ),
            Icon(Icons.zoom_in, size: 18, color: kMuted),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime d) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
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
    return '${weekdays[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}';
  }
}

class AddEditEventDialog extends StatefulWidget {
  final DateTime initialDate;
  final OsmCalendarActivity? existing;

  const AddEditEventDialog({
    super.key,
    required this.initialDate,
    this.existing,
  });

  @override
  State<AddEditEventDialog> createState() => _AddEditEventDialogState();
}

class _AddEditEventDialogState extends State<AddEditEventDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _locationController;
  late TextEditingController _meetingLinkController;
  late Color _selectedColor;
  late DateTime _selectedDate;
  bool _isAllDay = false;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  String? _attachmentName;
  String? _attachmentPath;
  final _commonService = CommonService(Dio());
  List<Office> _officeList = [];
  Office? _selectedOffice;

  PlatformFile? _pickedFile;

  bool _attachmentWasRemoved = false;
  String userId = "";
  bool _isSaving = false;
  bool get _isEditMode => widget.existing != null;
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _titleController = TextEditingController(text: e?.title ?? '');
    _descController = TextEditingController(text: e?.description ?? '');
    _locationController = TextEditingController(text: e?.location ?? '');
    _meetingLinkController = TextEditingController(text: e?.meetingLink ?? '');
    _selectedColor = e?.displayColor ?? kCalendarColorPalette.first;
    _selectedDate = e?.dateOnly ?? widget.initialDate;
    _isAllDay = e?.isAllDay ?? false;
    _startTime =
        _parseTimeString(e?.startTime) ?? const TimeOfDay(hour: 9, minute: 0);
    _endTime =
        _parseTimeString(e?.endTime) ?? const TimeOfDay(hour: 10, minute: 0);
    _attachmentName = e?.attachmentName;
    _attachmentPath = e?.attachmentPath;

    _loadOffices();
  }

  TimeOfDay? _parseTimeString(String? value) {
    if (value == null) return null;
    final parts = value.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _loadOffices() async {
    try {
      UserRegistration? user = await AuthUtil.fetchLoggedUser();
      if (user == null) return;
      setState(() => userId = user.id ?? "");
      final offices = await _commonService.fetchOffices();
      if (!mounted) return;
      setState(() {
        _officeList = offices;
        if (widget.existing?.officeId != null) {
          _selectedOffice = _officeList.firstWhere(
            (o) => o.id == widget.existing!.officeId,
            orElse:
                () =>
                    _officeList.isNotEmpty
                        ? _officeList.first
                        : Office(
                          id: 0,
                          name: '',
                          officeTypeId: null,
                          parentOfficeId: null,
                          isDeleted: false,
                          isActive: true,
                        ),
          );
        }
      });
    } catch (e) {
      debugPrint('Failed to fetch offices: $e');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    _meetingLinkController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder:
          (context, child) => Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: primaryColor,
                onPrimary: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(foregroundColor: primaryColor),
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: (isStart ? _startTime : _endTime) ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _pickAttachment() async {
    final result = await FilePicker.platform.pickFiles(withData: true);
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      setState(() {
        _pickedFile = file;
        _attachmentName = file.name;
        _attachmentPath = file.path;
        _attachmentWasRemoved = false;
      });
    }
  }

  void _removeAttachment() {
    setState(() {
      _pickedFile = null;
      _attachmentName = null;
      _attachmentPath = null;
      _attachmentWasRemoved = true;
    });
  }

  String? _formatTimeOfDay(TimeOfDay? t) {
    if (t == null) return null;
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m:00';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final activityId = widget.existing?.id ?? 0;

      final activity = OsmCalendarActivity(
        activityId,
        _titleController.text.trim(),
        _selectedDate,
        location: _locationController.text,
        description: _descController.text.trim(),
        isAllDay: _isAllDay,
        color: '#${_selectedColor.value.toRadixString(16).substring(2)}',
        startTime: _isAllDay ? null : _formatTimeOfDay(_startTime),
        endTime: _isAllDay ? null : _formatTimeOfDay(_endTime),
        userId: userId,
        officeId: _selectedOffice?.id,
        officeName: _selectedOffice?.name,
        attachmentPath: _attachmentPath,
        meetingLink: _meetingLinkController.text,
      );

      final formData = await buildCalendarActivityFormData(
        activity: activity,
        pickedFile: _pickedFile,
        removeAttachment: _attachmentWasRemoved,
      );

      final service = OsmCalendarActivityServices(dio);
      await service.saveOsmActivity(
        formData,
        id: activityId > 0 ? activityId : null,
      );

      if (mounted) Navigator.pop(context, activity);
    } catch (e) {
      if (mounted) {
        MotionToast.error(
          title: const Text('Save failed'),
          description: Text('Could not save the activity: $e'),
        ).show(context);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: kSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
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
                        child: Icon(
                          Icons.event_note_outlined,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEditMode ? 'Edit Event' : 'Create Event',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                color: kText,
                              ),
                            ),
                            Text(
                              _isEditMode
                                  ? 'Update event details'
                                  : 'Add a new event',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: kMuted,
                              ),
                            ),
                          ],
                          // child: Text(
                          //   _isEditMode ? 'Edit Event' : 'New Event',
                          //   style: GoogleFonts.plusJakartaSans(
                          //     fontSize: 18,
                          //     fontWeight: FontWeight.w700,
                          //     color: kText,
                          //   ),
                          // ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20, color: kMuted),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  dialogField(
                    label: 'Title',
                    controller: _titleController,
                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Please fill out this field'
                                : null,
                  ),
                  const SizedBox(height: 14),

                  dialogField(
                    label: 'Description (optional)',
                    controller: _descController,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 14),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            dialogField(
                              label: 'Conference Link (optional)',
                              controller: _meetingLinkController,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            dialogField(
                              label: 'Location (optional)',
                              controller: _locationController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: SearchDropdown<Office>(
                          label: 'Scheduled by',
                          hintText: 'Select office',
                          items: _officeList,
                          itemAsString: (o) => o.name,
                          selectedItem: _selectedOffice,
                          onChanged: (value) {
                            setState(() => _selectedOffice = value);
                          },
                          validator:
                              (value) =>
                                  value == null
                                      ? 'Please select an office'
                                      : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: _pickDate,
                          borderRadius: BorderRadius.circular(10),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Date',
                              labelStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: kMuted,
                              ),
                              floatingLabelStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              filled: true,
                              fillColor: kBackground,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: kBorder),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: kBorder),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: primaryColor,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 16,
                                  color: kMuted,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      color: kText,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'All day',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: kMuted,
                        ),
                      ),
                      Switch(
                        value: _isAllDay,
                        activeColor: primaryColor,
                        onChanged: (v) => setState(() => _isAllDay = v),
                      ),
                      const SizedBox(width: 12),
                      Container(width: 1, height: 30, color: kBorder),
                      const SizedBox(width: 12),
                      Text(
                        'Color',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: kMuted,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ...kCalendarColorPalette.map((c) {
                        final isSelected = c.value == _selectedColor.value;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedColor = c),
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: c,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      isSelected ? kText : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child:
                                  isSelected
                                      ? const Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                      : null,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),

                  if (!_isAllDay) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _timeField(
                            label: 'Start time',
                            time: _startTime,
                            onTap: () => _pickTime(isStart: true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _timeField(
                            label: 'End time',
                            time: _endTime,
                            onTap: () => _pickTime(isStart: false),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 14),

                  InkWell(
                    onTap: _pickAttachment,
                    borderRadius: BorderRadius.circular(10),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Attachment (optional)',
                        labelStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: kMuted,
                        ),
                        floatingLabelStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                        filled: true,
                        fillColor: kBackground,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: kBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: kBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: primaryColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.attach_file,
                            size: 16,
                            color: kMuted,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _attachmentName ?? 'Tap to attach a file',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: _attachmentName == null ? kMuted : kText,
                              ),
                            ),
                          ),
                          if (_attachmentName != null)
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 16,
                                color: kMuted,
                              ),
                              onPressed: _removeAttachment,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  PermissionWidget(
                    permission: AppPermissions.addCalendarActivity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: kBorder),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(8),
                              ),
                            ),
                            onPressed:
                                _isSaving ? null : () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.plusJakartaSans(
                                color: kMuted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _save,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
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
                                    : Text(
                                      _isEditMode
                                          ? 'Save Changes'
                                          : 'Add Event',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _timeField({
    required String label,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: kBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kBorder),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time, size: 16, color: kMuted),
            const SizedBox(width: 8),
            Text(
              time == null ? label : time.format(context),
              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: kText),
            ),
          ],
        ),
      ),
    );
  }
}
