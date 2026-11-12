import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

import 'package:imis/ISO/IQA/ncar/models/ncar_attachment.dart';
import 'package:imis/ISO/IQA/ncar/models/nonconforming_action_report.dart';
import 'package:imis/ISO/IQA/ncar/services/ncar_service.dart';
import 'package:imis/constant/constant.dart';

/// Manages the pictures attached to an NCAR as proof the nonconformity was
/// resolved. They are printed on the second page of the NCAR form.
Future<void> showNcarAttachmentsDialog(
  BuildContext context, {
  required NcarService service,
  required NonconformingActionReport ncar,
  required bool canEdit,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) =>
        _NcarAttachmentsDialog(service: service, ncar: ncar, canEdit: canEdit),
  );
}

class _NcarAttachmentsDialog extends StatefulWidget {
  const _NcarAttachmentsDialog({
    required this.service,
    required this.ncar,
    required this.canEdit,
  });

  final NcarService service;
  final NonconformingActionReport ncar;
  final bool canEdit;

  @override
  State<_NcarAttachmentsDialog> createState() => _NcarAttachmentsDialogState();
}

class _NcarAttachmentsDialogState extends State<_NcarAttachmentsDialog> {
  static const int _maxBytes = 5 * 1024 * 1024;
  static const int _maxPictures = 10;

  final TextEditingController _caption = TextEditingController();
  List<NcarAttachment> _items = [];
  bool _loading = true;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await widget.service.getAttachments(widget.ncar.id);
      if (mounted) setState(() => _items = items);
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String message, {bool error = false}) {
    final text = Text(message);
    (error
            ? MotionToast.error(description: text)
            : MotionToast.success(description: text))
        .show(context);
  }

  Future<void> _add() async {
    if (_items.length >= _maxPictures) {
      _toast('An NCAR can hold at most $_maxPictures pictures.', error: true);
      return;
    }

    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['png', 'jpg', 'jpeg'],
      withData: true,
    );
    final file = picked?.files.single;
    if (file == null) return;

    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) {
      _toast('The picture could not be read.', error: true);
      return;
    }
    if (bytes.length > _maxBytes) {
      _toast('The picture is larger than 5 MB.', error: true);
      return;
    }

    setState(() => _busy = true);
    try {
      await widget.service.addAttachment(
        widget.ncar.id,
        bytes: bytes,
        fileName: file.name,
        caption: _caption.text,
      );
      _caption.clear();
      await _load();
    } catch (e) {
      if (mounted) {
        _toast(e.toString().replaceFirst('Exception: ', ''), error: true);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _remove(NcarAttachment a) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove picture'),
        content: const Text('Remove this picture from the NCAR?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _busy = true);
    try {
      await widget.service.deleteAttachment(widget.ncar.id, a.id);
      await _load();
    } catch (e) {
      if (mounted) {
        _toast(e.toString().replaceFirst('Exception: ', ''), error: true);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ref = widget.ncar.referenceNumber.isNotEmpty
        ? widget.ncar.referenceNumber
        : 'NCAR #${widget.ncar.id}';

    return AlertDialog(
      title: Text('Pictures - $ref'),
      content: SizedBox(
        width: 560,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pictures showing the nonconformity was resolved. They print on '
              'page 2 of the NCAR form (PNG or JPEG, up to 5 MB each).',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            if (widget.canEdit) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _caption,
                      enabled: !_busy,
                      decoration: const InputDecoration(
                        labelText: 'Caption for the next picture (optional)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    onPressed: _busy ? null : _add,
                    icon: const Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Add picture',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
            if (_busy) const LinearProgressIndicator(color: primaryColor),
            Flexible(
              child: _loading
                  ? const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                        child: CircularProgressIndicator(color: primaryColor),
                      ),
                    )
                  : _error != null
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : _items.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(24),
                              child: Center(child: Text('No pictures attached.')),
                            )
                          : SingleChildScrollView(
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  for (final a in _items) _tile(a),
                                ],
                              ),
                            ),
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
    );
  }

  Widget _tile(NcarAttachment a) {
    return SizedBox(
      width: 170,
      child: Card(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 120,
              child: Image.memory(
                a.bytes,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Center(child: Icon(Icons.broken_image_outlined)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 4, 0),
              child: Text(
                a.caption ?? a.fileName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            if (widget.canEdit)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: 'Remove',
                  visualDensity: VisualDensity.compact,
                  onPressed: _busy ? null : () => _remove(a),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              )
            else
              const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
