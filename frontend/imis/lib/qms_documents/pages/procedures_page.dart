import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui_web' as ui_web;
import 'package:flutter/cupertino.dart';
import 'package:imis/constant/permissions.dart';
import 'package:imis/qms_documents/models/pap_history_log.dart';
import 'package:imis/qms_documents/models/pap_signatory.dart';
import 'package:imis/qms_documents/models/procedures.dart';
import 'package:imis/qms_documents/pages/dcrrf_tab.dart';
import 'package:imis/qms_documents/dcrrf/services/dcrrf_history_service.dart';
import 'package:imis/qms_documents/services/pap_history_log_service.dart';
import 'package:imis/qms_documents/services/procedures_service.dart';
import 'package:imis/qms_documents/template/qms_template.dart';
import 'package:dio/dio.dart';
import 'package:imis/utils/auth_util.dart';
import 'package:imis/utils/permission_service.dart';
import 'package:imis/widgets/permission/permission_widget.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:imis/constant/constant.dart';

const String _logoAssetUrl = 'assets/assets/CRMC.png';

class ProceduresPage extends StatefulWidget {
  final String? initialHtml;
  final Map<String, String>? initialHeader;

  final ProceduresService? service;

  final int? sectionId;

  final int? id;

  final List<PapSignatory>? initialSignatories;

  final String? initialRowVersion;

  final Future<void> Function(String html)? onSave;
  final Future<void> Function(Map<String, String> header, String html)?
  onSaveDocument;
  final VoidCallback? onClose;

  const ProceduresPage({
    super.key,
    this.service,
    this.initialHtml,
    this.initialHeader,
    this.sectionId,
    this.id,
    this.initialSignatories,
    this.initialRowVersion,
    this.onSave,
    this.onSaveDocument,
    this.onClose,
  });

  @override
  State<ProceduresPage> createState() => _ProceduresEditorPageState();
}

class _ProceduresEditorPageState extends State<ProceduresPage> {
  final HtmlEditorController _controller = HtmlEditorController(
    processInputHtml: false,
  );
  final _formKey = GlobalKey<FormState>();
  String? _previewHtml;
  bool _saving = false;
  int _step = 0;
  final _papHistoryLog = PapHistoryLogService(Dio());
  final _dcrrfKey = GlobalKey<DcrrfTabState>();
  final _dcrrfService = PapDcrrfService(Dio());
  String _initiatorName = '';

  int _tab = 0;

  static const _tabs = [
    'Policy and Procedures',
    'History Log',
    'DCRRF',
    'Document Master List',
    'Overall Document Masterlist',
    'Document Distribution List',
  ];

  DateTime? _effectivityDate;

  String? _previewUrl;
  String? _previewViewType;
  int _previewSeq = 0;
  int _previewReq = 0;
  bool _previewLoading = false;
  bool _editorReady = false;

  String? _latestHtml;
  String? _userId;

  int? _id;
  String _rowVersion = '';
  List<PapSignatory> _signatories = [];

  int? _sectionId;
  List<_SectionOption> _offices = [];
  bool _loadingOffices = false;
  bool _officesLoaded = false;

  PapHistoryLog? _history;
  bool _historyLoading = false;
  bool _historyLoaded = false;
  String? _historyError;
  List<_LogRow> _logRows = [];
  final List<_LogRow> _removedRows = [];
  bool _savingLog = false;
  bool _logDirty = false;

  bool _canConfirm = false;
  bool _canDraft = false;
  bool _confirmed = false;

  bool _ready = false;

  bool get _confirmOnly => _canConfirm && !_canDraft;

  List<int> get _visibleSteps =>
      _confirmOnly ? const [2] : List.generate(_steps.length, (i) => i);
  static const double _pageContentWidthPx = 602;
  static const double _pageContentHeightPx = 931;
  static const _headerKeys = [
    'title',
    'section',
    'owner',
    'docCode',
    'revision',
    'reference',
    'pages',
    'effectivity',
  ];

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

  static const _steps = [
    (
      'Document Header',
      'Provide key details to define the document.',
      Icons.description_outlined,
    ),
    ('Procedure', 'Write the procedure content.', Icons.edit_note_rounded),
    (
      'Preview',
      'See how the document will look when printed.',
      Icons.visibility_outlined,
    ),
    ('Review', 'Check everything and save.', Icons.fact_check_outlined),
  ];

  late final Map<String, TextEditingController> _hdr = {
    for (final k in _headerKeys)
      k: TextEditingController(text: widget.initialHeader?[k] ?? ''),
  };

  @override
  void initState() {
    super.initState();
    _startFrameGuard();
    _latestHtml = widget.initialHtml;
    _id = widget.id;
    _rowVersion = widget.initialRowVersion ?? '';
    _sectionId = widget.sectionId ?? int.tryParse(_hdr['section']!.text.trim());
    _signatories = List<PapSignatory>.from(
      widget.initialSignatories ?? const [],
    );
    _effectivityDate = _parseEffectivity(_hdr['effectivity']!.text);
    _initialize();
  }

  @override
  void dispose() {
    for (final c in _hdr.values) {
      c.dispose();
    }
    for (final r in _logRows) {
      r.dispose();
    }
    for (final r in _removedRows) {
      r.dispose();
    }
    _frameGuard?.cancel();
    if (_previewUrl != null) html.Url.revokeObjectUrl(_previewUrl!);
    super.dispose();
  }

  DateTime? _parseEffectivity(String? s) {
    if (s == null || s.trim().isEmpty) return null;
    try {
      return DateFormat('MMMM d, y').parse(s.trim());
    } catch (_) {
      return DateTime.tryParse(s.trim());
    }
  }

  void _close() {
    if (widget.onClose != null) {
      widget.onClose!();
    } else {
      Navigator.maybePop(context);
    }
  }

  Future<void> _requestClose() async {
    if (!await _confirmLeaveHistory()) return;
    if (!mounted) return;
    _close();
  }

  void _syncListMarkers() {
    _controller.evaluateJavascriptWeb('syncListMarkers');
    _controller.evaluateJavascriptWeb('imgFix');
  }

  Future<void> _captureEditor() async {
    if (!_editorReady) {
      return;
    }
    try {
      final t = await _controller.getText();
      _latestHtml = t;
    } catch (e) {
      debugPrint('Capture editor failed: $e');
    }
  }

  bool _hasPerm(String p) => PermissionService().hasPermission(p);

  Future<void> _initialize() async {
    final user = await AuthUtil.fetchLoggedUser();

    if (!mounted) return;

    final fullName = [
      user?.firstName,
      user?.middleName,
      user?.lastName,
    ].where((e) => e != null && e.trim().isNotEmpty).join(' ');

    final canConfirm = _hasPerm(AppPermissions.confirmPolicyAndProcedure);
    final canDraft = _hasPerm(AppPermissions.draftPolicyAndProcedure);
    final confirmOnly = canConfirm && !canDraft;

    setState(() {
      _userId = user?.id;
      _initiatorName = fullName;
      _canConfirm = canConfirm;
      _canDraft = canDraft;
      if (confirmOnly) _step = 2;

      if (_hdr['owner']!.text.trim().isEmpty) {
        _hdr['owner']!.text = fullName;
      }
      _ready = true;
    });

    await _hydrateFromServer();
    await _loadOffices();
    if ((widget.initialHtml ?? '').isNotEmpty) await _refreshPages();

    if (confirmOnly && mounted) {
      await _loadPreview();
    }
  }

  Future<void> _hydrateFromServer() async {
    if (_id == null) return;
    try {
      final p = await _service.getById(_id!);
      if (!mounted) return;
      setState(() {
        _sectionId = p.sectionId ?? _sectionId;
        final name = (p.officeName ?? '').trim();
        if (name.isNotEmpty) _hdr['section']!.text = name;
        if ((p.rowVersion ?? '').isNotEmpty) _rowVersion = p.rowVersion!;
        if (_signatories.isEmpty && p.papSignatories != null) {
          _signatories = List<PapSignatory>.from(p.papSignatories!);
        }
      });
    } catch (_) {
      // ignore: hydrate is best-effort
    }
  }

  Future<void> _loadOffices() async {
    setState(() => _loadingOffices = true);
    try {
      final names = await AuthUtil.fetchOfficeNames();
      final ids = await AuthUtil.fetchOfficeIds();

      final offices = <_SectionOption>[];
      if (names != null && ids != null) {
        for (var i = 0; i < ids.length && i < names.length; i++) {
          final isHead = await AuthUtil.getIsOfficeHead(ids[i]);
          final id = int.tryParse(ids[i]);
          if (isHead == true && id != null) {
            offices.add(_SectionOption(id, names[i]));
          }
        }
      }
      if (!mounted) return;

      final byId = _sectionId;
      final byName = _hdr['section']!.text.trim();
      final matches = offices.where(
        (o) =>
            (byId != null && o.id == byId) ||
            (byName.isNotEmpty && o.name == byName),
      );
      final match = matches.isEmpty ? null : matches.first;

      setState(() {
        _offices = offices;
        if (match != null) {
          _sectionId = match.id;
          _hdr['section']!.text = match.name;
        }
      });
    } catch (e) {
      debugPrint('Load offices failed: $e');
    } finally {
      if (mounted) {
        setState(() {
          _loadingOffices = false;
          _officesLoaded = true;
        });
      }
    }
  }

  void _onSectionSelected(int id) {
    final matches = _offices.where((e) => e.id == id);
    setState(() {
      _sectionId = id;
      if (matches.isNotEmpty) _hdr['section']!.text = matches.first.name;
    });
  }

  Future<String> _currentHtml() async {
    await _captureEditor(); // laging fresh mula sa editor
    return _latestHtml ?? widget.initialHtml ?? '';
  }

  late final ProceduresService _service =
      widget.service ?? ProceduresService(Dio());

  Procedures _buildProcedure(String htmlText, {required bool isDraft}) {
    return Procedures(
      id: _id,
      rowVersion: _rowVersion,
      title: _hdr['title']!.text.trim(),
      processOwner: _hdr['owner']!.text.trim(),
      regulatoryStandard: _hdr['reference']!.text.trim(),
      effectiveDate: _effectivityDate,
      sectionId: _sectionId,
      documentCode: _hdr['docCode']!.text.trim(),
      revision: _hdr['revision']!.text.trim(),
      content: htmlText,
      isMasterCopy: true,
      isControlledCopy: true,
      removeAttachment: false,
      papSignatories: _signatories,
      isDeleted: false,
      isDraft: isDraft,
      forSignature: false,
    );
  }

  void _applySaved(Procedures saved) {
    _id = saved.id ?? _id;

    if (saved.rowVersion != null && saved.rowVersion!.isNotEmpty) {
      _rowVersion = saved.rowVersion!;
    }
    if (saved.papSignatories != null) _signatories = saved.papSignatories!;
  }

  Future<void> _save({bool close = false}) async {
    if (_saving) return;

    if (_userId == null) {
      MotionToast.error(
        title: const Text('User Not Found'),
        description: const Text('Please log in again.'),
        toastAlignment: Alignment.center,
      ).show(context);
      return;
    }

    if (!_headerValid()) {
      setState(() {
        _tab = 0;
        _step = 0;
      });
      return;
    }
    setState(() => _saving = true);
    bool saved = false;
    try {
      final htmlText = await _currentHtml();

      final result = await _service.saveDraft(
        _userId!,
        _buildProcedure(htmlText, isDraft: true),
      );
      _applySaved(result);
      saved = true;

      try {
        await widget.onSave?.call(htmlText);
        await widget.onSaveDocument?.call({
          for (final k in _headerKeys) k: _hdr[k]!.text.trim(),
        }, htmlText);
      } catch (e, st) {
        debugPrint('Post-save callback error: $e\n$st');
      }

      if (!mounted) return;
      MotionToast.success(
        title: const Text('Success'),
        description: const Text('Saved successfully'),
        toastAlignment: Alignment.center,
      ).show(context);

      if (close) {
        await Future.delayed(const Duration(milliseconds: 600));
        if (!mounted) return;
        _close();
      }
    } catch (e, st) {
      debugPrint('Save error: $e\n$st');
      if (!mounted) return;
      if (saved) {
        MotionToast.warning(
          title: const Text('Saved'),
          description: Text(
            'Saved, but a follow-up step failed: $e',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          toastAlignment: Alignment.center,
        ).show(context);
      } else {
        MotionToast.error(
          title: const Text('Failed to Save'),
          description: Text('$e', maxLines: 3, overflow: TextOverflow.ellipsis),
          toastAlignment: Alignment.center,
        ).show(context);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _submit() async {
    if (_saving) return;

    if (_userId == null) {
      MotionToast.error(
        title: const Text('User Not Found'),
        description: const Text('Please log in again.'),
        toastAlignment: Alignment.center,
      ).show(context);
      return;
    }

    if (!_headerValid()) {
      setState(() {
        _tab = 0;
        _step = 0;
      });
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Confirm Submit'),
            content: const Text(
              'Are you sure you want to submit this document? ',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Yes'),
              ),
            ],
          ),
    );
    if (confirmed != true) return;

    setState(() => _saving = true);
    bool submitted = false;
    try {
      final htmlText = await _currentHtml();

      await _service.submit(
        _userId!,
        _buildProcedure(htmlText, isDraft: false),
      );
      submitted = true;

      try {
        await widget.onSave?.call(htmlText);
        await widget.onSaveDocument?.call({
          for (final k in _headerKeys) k: _hdr[k]!.text.trim(),
        }, htmlText);
      } catch (e, st) {
        debugPrint('Post-submit callback error: $e\n$st');
      }

      if (!mounted) return;
      MotionToast.success(
        title: const Text('Success'),
        description: const Text('Submitted successfully'),
        toastAlignment: Alignment.center,
      ).show(context);

      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      _close();
    } catch (e, st) {
      debugPrint('Submit error: $e\n$st');
      if (!mounted) return;
      if (submitted) {
        MotionToast.warning(
          title: const Text('Submitted'),
          description: Text(
            'Submitted, but a follow-up step failed: $e',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          toastAlignment: Alignment.center,
        ).show(context);
      } else {
        MotionToast.error(
          title: const Text('Failed to Submit'),
          description: Text('$e', maxLines: 3, overflow: TextOverflow.ellipsis),
          toastAlignment: Alignment.center,
        ).show(context);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _confirm() async {
    if (_saving || _confirmed || _id == null || _userId == null) return;

    final ok = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Confirm Document'),
            content: const Text(
              'Are you sure you want to confirm this document?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Yes'),
              ),
            ],
          ),
    );
    if (ok != true) return;

    setState(() => _saving = true);
    try {
      final htmlText = await _currentHtml();
      await _service.submit(
        _userId!,
        _buildProcedure(htmlText, isDraft: false),
      );

      if (!mounted) return;
      setState(() => _confirmed = true);
      MotionToast.success(
        title: const Text('Success'),
        description: const Text('Confirmed successfully'),
        toastAlignment: Alignment.center,
      ).show(context);
    } catch (e, st) {
      debugPrint('Confirm error: $e\n$st');
      if (!mounted) return;
      MotionToast.error(
        title: const Text('Failed to Confirm'),
        description: Text('$e', maxLines: 3, overflow: TextOverflow.ellipsis),
        toastAlignment: Alignment.center,
      ).show(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Map<String, String> _localHeader() => {
    for (final k in _headerKeys) k: _hdr[k]!.text.trim(),
  };

  String _buildHeaderHtml([Map<String, String>? h]) {
    h ??= _localHeader();
    String v(String key) => const HtmlEscape(
      HtmlEscapeMode.element,
    ).convert((h![key] ?? '').trim()).replaceAll('\n', '<br>');

    final logo = Uri.base.resolve(_logoAssetUrl).toString();
    return '''
<div class="hdr-top">
  <div>Republic of the Philippines</div>
  <div>Department of Health</div>
  <div class="hdr-center">COTABATO REGIONAL AND MEDICAL CENTER</div>
</div>
<div style="height: 14pt;"></div>
<table class="hdr">
  <colgroup>
    <col style="width: 15%">
    <col style="width: 43%">
    <col style="width: 42%">
  </colgroup>
  <tr>
    <td class="logo" rowspan="5"><div class="logo-box"><img src="$logo" onerror="this.style.display='none'"></div></td>
    <td rowspan="2">TITLE: <b>${v('title')}</b></td>
    <td>SECTION: <b>${v('section')}</b></td>
  </tr>
  <tr>
    <td>DOC. CODE: <b>${v('docCode')}</b></td>
  </tr>
  <tr>
    <td>PROCESS OWNER: <b>${v('owner')}</b></td>
    <td>REVISION: <b>${v('revision')}</b></td>
  </tr>
  <tr>
    <td>REGULATORY/STANDARD REFERENCE(S): <b>${v('reference')}</b></td>
    <td>PAGES: <b>${v('pages')}</b></td>
  </tr>
  <tr>
    <td colspan="2">EFFECTIVITY DATE: <b>${v('effectivity')}</b></td>
  </tr>
</table>''';
  }

  Future<int?> _countPages(String fullHtml) async {
    final id = 'pp${DateTime.now().microsecondsSinceEpoch}';
    final probe =
        '<script>window.addEventListener("load",function(){'
        'setTimeout(function(){'
        'var h=Math.max(document.documentElement.scrollHeight,'
        'document.body?document.body.scrollHeight:0);'
        'parent.postMessage("pagesProbe|$id|"+h,"*");'
        '},300);});</script>';
    final i = fullHtml.lastIndexOf('</body>');
    final probed =
        i == -1
            ? fullHtml + probe
            : fullHtml.substring(0, i) + probe + fullHtml.substring(i);

    final done = Completer<int?>();
    late final StreamSubscription<html.MessageEvent> sub;
    sub = html.window.onMessage.listen((e) {
      final d = e.data;
      if (d is! String || !d.startsWith('pagesProbe|$id|')) return;
      final h = double.tryParse(d.split('|').last);
      if (done.isCompleted) return;
      if (h == null) {
        done.complete(null);
        return;
      }
      final pages = math.max(1, (h / _pageContentHeightPx).ceil());
      debugPrint(
        'Pages: contentHeight=$h, page=$_pageContentHeightPx -> $pages',
      );
      done.complete(pages);
    });

    final frame =
        html.IFrameElement()
          ..style.position = 'fixed'
          ..style.left = '-10000px'
          ..style.top = '0'
          ..style.width = '${_pageContentWidthPx}px'
          ..style.height = '${_pageContentHeightPx}px'
          ..style.border = 'none'
          ..style.visibility = 'hidden'
          ..srcdoc = probed;
    html.document.body?.append(frame);

    try {
      return await done.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => null,
      );
    } catch (e) {
      debugPrint('Count pages failed: $e');
      return null;
    } finally {
      await sub.cancel();
      frame.remove();
    }
  }

  Future<void> _refreshPages([String? body]) async {
    body ??= sanitize(await _currentHtml());
    final n = await _countPages(buildPreviewDocument(_buildHeaderHtml(), body));
    if (n == null || !mounted) return;
    _hdr['pages']!.text = n <= 1 ? '1' : '1-$n';
  }

  Future<void> _loadPreview() async {
    final req = ++_previewReq;
    setState(() {
      _previewLoading = true;
      _previewViewType = null;
      _previewHtml = null;
    });
    try {
      final (rawBody, hdr) = await _previewSource();
      final body = sanitize(rawBody);

      // bilangin ang pages mula sa parehong data
      final n = await _countPages(
        buildPreviewDocument(_buildHeaderHtml(hdr), body),
      );
      if (n != null) {
        hdr['pages'] = n <= 1 ? '1' : '1-$n';
        _hdr['pages']!.text = hdr['pages']!;
      }
      if (!mounted || req != _previewReq) return;

      final fullHtml = buildPreviewDocument(_buildHeaderHtml(hdr), body);
      _previewHtml = fullHtml;

      const hideToolbar = '''
<script>
(function () {
  document.querySelectorAll('button, a, [role="button"]').forEach(function (el) {
    var t = (el.textContent || '').trim();
    if (t === 'Close' || t.indexOf('Print') === 0) el.style.display = 'none';
  });
})();
</script>''';
      final i = fullHtml.lastIndexOf('</body>');
      final inlineHtml =
          i == -1
              ? fullHtml + hideToolbar
              : fullHtml.substring(0, i) + hideToolbar + fullHtml.substring(i);

      final viewType = 'procedure-preview-${_previewSeq++}';

      ui_web.platformViewRegistry.registerViewFactory(viewType, (int _) {
        final frame =
            html.IFrameElement()
              ..srcdoc = inlineHtml
              ..style.border = 'none'
              ..style.width = '100%'
              ..style.height = '100%';
        return frame;
      });

      setState(() => _previewViewType = viewType);
    } catch (e) {
      debugPrint('Preview failed: $e');
    } finally {
      if (mounted && req == _previewReq) {
        setState(() => _previewLoading = false);
      }
    }
  }

  Future<(String, Map<String, String>)> _previewSource() async {
    final local = _localHeader();
    if (_id == null) return (await _currentHtml(), local);

    try {
      final p = await _service.getById(_id!);
      final eff = p.effectiveDate;
      final office = (p.officeName ?? '').trim();
      final hdr = <String, String>{
        'title': (p.title ?? '').trim(),
        'section': office.isNotEmpty ? office : local['section']!,
        'owner': (p.processOwner ?? '').trim(),
        'docCode': (p.documentCode ?? '').trim(),
        'revision': (p.revision ?? '').trim(),
        'reference': (p.regulatoryStandard ?? '').trim(),
        'pages': local['pages']!,
        'effectivity':
            (eff == null || eff.year < 2000)
                ? ''
                : DateFormat('MMMM d, y').format(eff.toLocal()),
      };
      return (p.content ?? '', hdr);
    } catch (e) {
      debugPrint('Preview fetch failed, using local data: $e');
      return (await _currentHtml(), local);
    }
  }

  Future<void> _openPreview() async {
    await _loadPreview(); // laging bagong build, walang cache
    if (_previewHtml == null) return;
    final blob = html.Blob([_previewHtml!], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, '_blank');
    Future.delayed(
      const Duration(minutes: 5),
      () => html.Url.revokeObjectUrl(url),
    );
  }

  void _insertBoxList() {
    _controller.insertHtml(
      '<ul style="list-style-type: &quot;☐  &quot;;"><li><br></li></ul>',
    );
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _effectivityDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d == null) return;
    setState(() {
      _effectivityDate = d;
      _hdr['effectivity']!.text = '${_months[d.month - 1]} ${d.day}, ${d.year}';
    });
  }

  bool _headerValid() => _formKey.currentState?.validate() ?? true;

  Future<void> _goTo(int i) async {
    if (_confirmOnly) return;
    if (i == _step) return;
    if (i > _step && !_headerValid()) return;
    if (_step == 1) await _captureEditor();
    if (i != 1 && i != 2) {
      await _refreshPages();
    }
    if (!mounted) return;
    setState(() => _step = i);
    if (i == 2) _loadPreview();
  }

  void _next() {
    if (_step < _steps.length - 1) {
      _goTo(_step + 1);
    } else {
      _save(close: true);
    }
  }

  Future<void> _back() async {
    if (_step > 0) {
      if (_step == 1) await _captureEditor();
      if (_step - 1 == 0 || _step - 1 == 3) await _refreshPages();
      if (!mounted) return;
      setState(() => _step--);
      if (_step == 2) _loadPreview();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 700;
    final isLast = _step == _steps.length - 1;

    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: IconButton(
            tooltip: 'Close',
            icon: const Icon(Icons.close, size: 18),
            style: IconButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
            ),
            onPressed: _requestClose,
          ),
        ),
        title: Text(
          'Policy and Procedures',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBar:
          !_ready
              ? null
              : _tab == 0
              ? (_confirmOnly ? _buildConfirmFooter() : _buildFooter(isLast))
              : null,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            !_ready
                ? const Center(
                  child: CircularProgressIndicator(color: primaryColor),
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTopTabs(),
                    const SizedBox(height: 12),
                    Expanded(
                      child: IndexedStack(
                        index: _tab,
                        children: [
                          _buildPolicyBody(isSmall),
                          _buildHistoryTab(),
                          _buildDcrrfTab(),
                          for (int i = 3; i < _tabs.length; i++)
                            _buildPlaceholderTab(_tabs[i]),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Future<void> _switchTab(int i) async {
    if (i == _tab) return;
    if (_tab == 1 && !await _confirmLeaveHistory()) return;
    if (_tab == 0 && _step == 1) await _captureEditor();
    if (i == 1) await _refreshPages();
    if (!mounted) return;
    setState(() => _tab = i);
    if (i == 1) _loadHistory();
    if (i == 2) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _dcrrfKey.currentState?.reload(),
      );
    }
    if (i == 0 && _step == 2) _loadPreview();
  }

  void _disposeLogRows() {
    for (final r in _logRows) {
      r.dispose();
    }
    for (final r in _removedRows) {
      r.dispose();
    }
    _logRows = [];
    _removedRows.clear();
  }

  Future<void> _loadHistory() async {
    if (_id == null) {
      setState(() {
        _history = null;
        _historyError = null;
      });
      return;
    }
    if (_historyLoaded) return;

    setState(() {
      _historyLoading = true;
      _historyError = null;
    });
    try {
      final h = await _papHistoryLog.getHistoryLog(_id!);
      if (!mounted) return;
      _disposeLogRows();
      final rows = [
        for (final l in h.policyAndProcedureLogList) _LogRow.fromModel(l),
      ];
      if (rows.isEmpty) {
        rows.add(_LogRow()..page.text = _hdr['pages']!.text);
      }
      setState(() {
        _history = h;
        _logRows = rows;
        _historyLoaded = true;
        _logDirty = false;
      });
    } catch (e) {
      debugPrint('History load failed: $e');
      if (!mounted) return;
      setState(() => _historyError = 'Failed to load history log');
    } finally {
      if (mounted) setState(() => _historyLoading = false);
    }
  }

  void _addLogRow() => setState(() {
    final r = _LogRow();
    r.page.text = _hdr['pages']!.text;
    _logRows.add(r);
    _logDirty = true;
  });

  void _removeLogRow(int i) {
    setState(() {
      final r = _logRows.removeAt(i);
      if (r.source != null) {
        _removedRows.add(r);
      } else {
        r.dispose();
      }
      _logDirty = true;
    });
  }

  Future<void> _pickLogDate(_LogRow r) async {
    final d = await showDatePicker(
      context: context,
      initialDate: r.date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d == null) return;
    setState(() {
      r.date = d;
      _logDirty = true;
    });
  }

  bool _isRowEmpty(_LogRow r) =>
      r.code.text.trim().isEmpty &&
      r.page.text.trim().isEmpty &&
      r.revision.text.trim().isEmpty &&
      r.reasons.text.trim().isEmpty;

  void _pruneEmptyRows() {
    final empty = _logRows.where(_isRowEmpty).toList();
    if (empty.isEmpty) return;
    setState(() {
      _logRows.removeWhere(empty.contains);
      for (final r in empty) {
        if (r.source != null) {
          _removedRows.add(r);
          _logDirty = true;
        } else {
          r.dispose();
        }
      }
    });
  }

  String? _validateLog() {
    for (var i = 0; i < _logRows.length; i++) {
      final r = _logRows[i];
      final n = i + 1;
      if (r.code.text.trim().isEmpty) {
        return 'Row $n: Document Code is required';
      }
      if (r.date == null) return 'Row $n: Date is required';
      if (r.reasons.text.trim().isEmpty) return 'Row $n: Reason is required';
    }
    return null;
  }

  Future<bool> _saveHistory() async {
    if (_savingLog || _id == null) return false;

    _pruneEmptyRows();

    final err = _validateLog();
    if (err != null) {
      MotionToast.error(
        title: const Text('Incomplete Row'),
        description: Text(err),
        toastAlignment: Alignment.center,
      ).show(context);
      return false;
    }

    setState(() => _savingLog = true);
    try {
      final h = _history;

      Map<String, dynamic> rowJson(_LogRow r, {bool deleted = false}) => {
        'id': r.source?.id ?? 0,
        'isDeleted': deleted,
        'rowVersion': r.source?.rowVersion,
        'policyAndProcedureHistoryLogId': h?.id ?? 0,
        'documentCode': r.code.text.trim(),
        'pageNo': r.page.text.trim(),
        'revision': r.revision.text.trim(),
        'date': (r.date ?? DateTime.now()).toIso8601String(),
        'reasons': r.reasons.text.trim(),
      };

      final body = {
        'id': h?.id ?? 0,
        'isDeleted': false,
        'rowVersion': h?.rowVersion,
        'policyAndProcedureId': _id,
        'titleName':
            (h?.titleName.isNotEmpty ?? false)
                ? h!.titleName
                : _hdr['title']!.text.trim(),
        'date':
            (h?.effectiveDate ?? _effectivityDate ?? DateTime.now())
                .toIso8601String(),
        'policyAndProcedureLogList': [
          for (final r in _logRows) rowJson(r),
          for (final r in _removedRows) rowJson(r, deleted: true),
        ],
      };

      await _papHistoryLog.saveHistoryLog(body);

      if (!mounted) return true;
      _logDirty = false;
      _historyLoaded = false;
      MotionToast.success(
        title: const Text('Success'),
        description: const Text('History log saved'),
        toastAlignment: Alignment.center,
      ).show(context);
      await _loadHistory();
      return true;
    } catch (e) {
      if (!mounted) return false;
      MotionToast.error(
        title: const Text('Failed to Save'),
        description: Text('$e', maxLines: 3, overflow: TextOverflow.ellipsis),
        toastAlignment: Alignment.center,
      ).show(context);
      return false;
    } finally {
      if (mounted) setState(() => _savingLog = false);
    }
  }

  Future<bool> _confirmLeaveHistory() async {
    _pruneEmptyRows();
    if (!_logDirty) return true;

    final choice = await showDialog<String>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Unsaved changes'),
            content: const Text(
              'You have unsaved changes in the History Log. What do you want to do?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, 'cancel'),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, 'discard'),
                child: const Text('Discard'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, 'save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save'),
              ),
            ],
          ),
    );

    if (choice == 'discard') {
      _logDirty = false;
      _historyLoaded = false;
      _removedRows.clear();
      return true;
    }
    if (choice == 'save') return _saveHistory();
    return false;
  }

  Widget _buildTopTabs() {
    const d = 14.0;
    const gap = 4.0;
    const h = 44.0;
    const minW = 190.0;

    return LayoutBuilder(
      builder: (context, c) {
        final n = _tabs.length;
        final fit = (c.maxWidth + (n - 1) * (d - gap)) / n;
        final scroll = fit < minW;
        final w = scroll ? minW : fit;
        final total = n * w - (n - 1) * (d - gap);

        final bar = SizedBox(
          width: total,
          height: h,
          child: Stack(
            children: [
              for (int i = 0; i < n; i++)
                Positioned(
                  left: i * (w - d + gap),
                  top: 0,
                  width: w,
                  height: h,
                  child: _chevronTab(i, d),
                ),
            ],
          ),
        );

        return SizedBox(
          height: h,
          child:
              scroll
                  ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: bar,
                  )
                  : bar,
        );
      },
    );
  }

  Widget _chevronTab(int i, double d) {
    final active = i == _tab;
    return ClipPath(
      clipper: _ChevronClipper(
        first: i == 0,
        last: i == _tabs.length - 1,
        depth: d,
      ),
      child: Material(
        color: active ? primaryColor : Colors.white,
        child: InkWell(
          onTap: () => _switchTab(i),
          child: Padding(
            padding: EdgeInsets.only(left: i == 0 ? 16 : d + 12, right: d + 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _tabs[i],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPolicyBody(bool isSmall) {
    if (_confirmOnly) return _buildContent();
    return isSmall
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStepperHorizontal(),
            const SizedBox(height: 12),
            Expanded(child: _buildContent()),
          ],
        )
        : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 260, child: _buildStepperVertical()),
            const SizedBox(width: 16),
            Expanded(child: _buildContent()),
          ],
        );
  }

  InputDecoration _logDecoration({String? hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      isDense: true,
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      border: _outline(Colors.grey.shade300),
      enabledBorder: _outline(Colors.grey.shade300),
      focusedBorder: _outline(primaryColor),
    );
  }

  Widget _logField(
    TextEditingController c, {
    String? hint,
    int? maxLines = 1,
    int minLines = 1,
    bool readOnly = false,
  }) {
    return TextField(
      controller: c,
      readOnly: readOnly,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: TextInputType.multiline,
      onChanged: (_) => _logDirty = true,
      style: GoogleFonts.plusJakartaSans(fontSize: 12),
      decoration: _logDecoration(hint: hint),
    );
  }

  Widget _logDateField(_LogRow r) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _pickLogDate(r),
      child: InputDecorator(
        decoration: _logDecoration(
          suffix: const Icon(Icons.calendar_today_outlined, size: 16),
        ),
        child: Text(
          r.date == null
              ? 'Select date'
              : DateFormat('MMM d, y').format(r.date!),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: r.date == null ? Colors.grey.shade500 : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _logHeaderCell(String t) => Text(
    t,
    style: GoogleFonts.plusJakartaSans(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: Colors.black54,
    ),
  );

  Widget _buildHistoryLocked([String name = 'History Log']) {
    return _card(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline, size: 40, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                '$name is locked',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "You can't use this form yet. Save the document first to unlock the $name.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (_historyLoading) {
      return _card(child: const Center(child: CircularProgressIndicator()));
    }
    if (_id == null) return _buildHistoryLocked();
    if (_historyError != null) {
      return _card(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_historyError!, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _loadHistory,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final h = _history;
    final title =
        (h?.titleName.isNotEmpty ?? false)
            ? h!.titleName
            : _hdr['title']!.text.trim();
    final docDate = h?.effectiveDate ?? _effectivityDate;
    final dateText =
        docDate == null ? '—' : DateFormat('MMMM d, y').format(docDate);

    Widget info(String label, String value) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value.isEmpty ? '—' : value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );

    const actionW = 40.0;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Revision History Log',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton.icon(
                    onPressed: _addLogRow,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text(
                      'Add Row',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: BorderSide(color: primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _savingLog ? null : _saveHistory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        _savingLog
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                            : const Text(
                              'Save',
                              style: TextStyle(fontSize: 12),
                            ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          _cols([info('Document Title', title), info('Date', dateText)]),
          _divider(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) {
                final w = math.max(c.maxWidth, 860.0);
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _logHeaderCell('Document Code'),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: _logHeaderCell('Page No.')),
                            const SizedBox(width: 8),
                            Expanded(child: _logHeaderCell('Revision No.')),
                            const SizedBox(width: 8),
                            Expanded(flex: 2, child: _logHeaderCell('Date')),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 4,
                              child: _logHeaderCell(
                                'Reasons / Details of Revision',
                              ),
                            ),
                            const SizedBox(width: actionW),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.separated(
                            itemCount: _logRows.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(height: 10),
                            itemBuilder: (_, i) {
                              final r = _logRows[i];
                              return Row(
                                key: ObjectKey(r),
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: _logField(
                                      r.code,
                                      hint: 'e.g. NS-MHU-PP-02',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _logField(
                                      r.page,
                                      hint: 'Auto',
                                      // bagong row = auto, lumang rows = saved value
                                      readOnly: r.source == null,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _logField(
                                      r.revision,
                                      hint: 'e.g. 1',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 2, child: _logDateField(r)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 4,
                                    child: _logField(
                                      r.reasons,
                                      hint: 'Reason / details of revision',
                                      maxLines: null,
                                      minLines: 1,
                                    ),
                                  ),
                                  SizedBox(
                                    width: actionW,
                                    child: IconButton(
                                      tooltip: 'Remove row',
                                      icon: Icon(
                                        CupertinoIcons.delete_simple,
                                        size: 20,
                                        color: Colors.red.shade400,
                                      ),
                                      onPressed: () => _removeLogRow(i),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDcrrfTab() {
    if (_id == null) return _buildHistoryLocked('DCRRF');
    return DcrrfTab(
      key: _dcrrfKey,
      procedureId: _id,
      header: _localHeader,
      initiatorName: _initiatorName,
      service: _dcrrfService,
    );
  }

  Widget _buildPlaceholderTab(String title) {
    return _card(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.table_chart_outlined,
              size: 40,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Coming soon',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmFooter() {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              onPressed: (_saving || _confirmed) ? null : _confirm,
              icon:
                  _saving
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : Icon(
                        _confirmed ? Icons.check : Icons.verified_outlined,
                        size: 18,
                      ),
              label: Text(_confirmed ? 'Confirmed' : 'Confirm'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: primaryColor.withAlpha(140),
                disabledForegroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(bool isLast) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Wrap(
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            if (_step > 0) _outlineBtn('Back', _back),
            PermissionWidget(
              permission: AppPermissions.draftPolicyAndProcedure,
              child: _outlineBtn('Save as Draft', _saving ? null : _save),
            ),
            if (isLast && _id != null)
              PermissionWidget(
                permission: AppPermissions.submitPolicyAndProcedure,
                child: OutlinedButton.icon(
                  onPressed: _saving ? null : _submit,
                  icon: const Icon(Icons.send_rounded, size: 16),
                  label: const Text('Submit', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: BorderSide(color: primaryColor),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: _saving ? null : _next,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child:
                  _saving
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : Text(isLast ? 'Save' : 'Next'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _outlineBtn(String label, VoidCallback? onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black87,
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _stepIcon(int i, {double size = 34}) {
    final done = i < _step || _confirmed;
    final active = i == _step;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active || done ? Colors.white : Colors.grey.shade100,
        border: Border.all(
          color: active || done ? primaryColor : Colors.grey.shade300,
        ),
      ),
      child: Icon(
        done ? Icons.check : _steps[i].$3,
        size: size * 0.5,
        color: active || done ? primaryColor : Colors.grey,
      ),
    );
  }

  Widget _buildStepperVertical() {
    final visible = _visibleSteps;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          for (final i in visible) ...[
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => _goTo(i),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient:
                      i == _step
                          ? LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              primaryColor.withAlpha(55),
                              primaryColor.withAlpha(8),
                            ],
                          )
                          : null,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _stepIcon(i),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'STEP ${i + 1}',
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.grey,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _steps[i].$1,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight:
                                  i == _step
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                            ),
                          ),
                          if (i == _step) ...[
                            const SizedBox(height: 4),
                            Text(
                              _steps[i].$2,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (i != visible.last)
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 28),
                  width: 1,
                  height: 14,
                  color: Colors.grey.shade300,
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepperHorizontal() {
    final visible = _visibleSteps;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (final i in visible) ...[
            InkWell(
              onTap: () => _goTo(i),
              child: Row(
                children: [
                  _stepIcon(i, size: 28),
                  if (i == _step) ...[
                    const SizedBox(width: 8),
                    Text(
                      _steps[i].$1,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (i != visible.last)
              Expanded(
                child: Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  color: Colors.grey.shade300,
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent() {
    return IndexedStack(
      index: _step,
      children: [
        _buildHeaderStep(),
        _buildEditorStep(),
        _buildPreviewStep(),
        _buildReviewStep(),
      ],
    );
  }

  Timer? _frameGuard;

  void _setFramePointer(bool blocked) {
    final v = blocked ? 'none' : 'auto';

    final frames = <html.Element>[
      ...html.document.querySelectorAll('iframe'),
      ...?html.document
          .querySelector('flt-glass-pane')
          ?.shadowRoot
          ?.querySelectorAll('iframe'),
    ];

    for (final frame in frames) {
      frame.style.pointerEvents = v;

      html.Element? p = frame.parent;
      for (var i = 0; i < 4 && p != null; i++) {
        if ((p.localName).startsWith('flt-platform-view')) {
          p.style.pointerEvents = v;
        }
        p = p.parent;
      }
    }
  }

  void _startFrameGuard() {
    _frameGuard ??= Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!mounted) return;
      bool popupOnTop(NavigatorState nav) {
        Route<dynamic>? top;
        nav.popUntil((r) {
          top = r;
          return true;
        });
        return top is PopupRoute;
      }

      final blocked =
          popupOnTop(Navigator.of(context, rootNavigator: true)) ||
          popupOnTop(Navigator.of(context));
      _setFramePointer(blocked);
    });
  }

  Widget _buildPreviewStep() {
    return _card(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Preview Document',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: _previewLoading ? null : _loadPreview,
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text('Refresh', style: TextStyle(fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _previewLoading ? null : _openPreview,
                icon: const Icon(Icons.open_in_new, size: 20),
                label: const Text(
                  'Open in New Tab',
                  style: TextStyle(fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    (_step == 2 && _previewViewType != null && !_previewLoading)
                        ? HtmlElementView(
                          key: ValueKey(_previewViewType),
                          viewType: _previewViewType!,
                        )
                        : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child, EdgeInsets? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Text(
      t,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 18),
    child: Divider(height: 1, color: Colors.grey.shade200),
  );

  Widget _field(
    String key,
    String label, {
    String? hint,
    bool required = false,
    Widget? suffix,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          required ? '$label *' : label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _hdr[key],
          readOnly: readOnly,
          onTap: onTap,
          minLines: 1,
          maxLines: readOnly ? 1 : null,
          keyboardType: TextInputType.multiline,
          style: GoogleFonts.plusJakartaSans(fontSize: 12),
          validator:
              required
                  ? (v) =>
                      (v == null || v.trim().isEmpty)
                          ? '$label is required'
                          : null
                  : null,
          decoration: InputDecoration(
            hintText: hint ?? 'Enter ${label.toLowerCase()}',
            hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            isDense: true,
            suffixIcon: suffix,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: _outline(Colors.grey.shade300),
            enabledBorder: _outline(Colors.grey.shade300),
            focusedBorder: _outline(primaryColor),
            errorBorder: _outline(Colors.red.shade300),
            focusedErrorBorder: _outline(Colors.red.shade400),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionDropdown() {
    Widget body;

    if (_loadingOffices) {
      body = const Padding(
        padding: EdgeInsets.symmetric(vertical: 14),
        child: LinearProgressIndicator(minHeight: 2, color: primaryColor),
      );
    } else if (_offices.isEmpty && _sectionId == null) {
      body =
          _officesLoaded
              ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No section is assigned to you. Please contact the admin.',
                  style: TextStyle(fontSize: 11, color: Colors.red.shade400),
                ),
              )
              : const SizedBox(height: 40);
    } else {
      final items = <DropdownMenuItem<int>>[
        for (final o in _offices)
          DropdownMenuItem<int>(
            value: o.id,
            child: Text(o.name, overflow: TextOverflow.ellipsis),
          ),
      ];

      final hasCurrent =
          _sectionId != null && _offices.any((o) => o.id == _sectionId);
      if (_sectionId != null && !hasCurrent) {
        final name = _hdr['section']!.text.trim();
        items.insert(
          0,
          DropdownMenuItem<int>(
            value: _sectionId,
            child: Text(
              name.isEmpty ? 'Section #$_sectionId' : name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }

      body = DropdownButtonFormField<int>(
        key: ValueKey(_sectionId),
        value: _sectionId,
        isExpanded: true,
        dropdownColor: Colors.white,
        style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.black87),
        hint: Text(
          'Select section…',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          border: _outline(Colors.grey.shade300),
          enabledBorder: _outline(Colors.grey.shade300),
          focusedBorder: _outline(primaryColor),
          errorBorder: _outline(Colors.red.shade300),
          focusedErrorBorder: _outline(Colors.red.shade400),
        ),
        validator: (v) => v == null ? 'Section is required' : null,
        items: items,
        onChanged: (id) {
          if (id != null) _onSectionSelected(id);
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Section *',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        body,
      ],
    );
  }

  OutlineInputBorder _outline(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: c),
  );

  Widget _cols(List<Widget> children) {
    final isSmall = MediaQuery.of(context).size.width < 700;
    if (isSmall) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1) const SizedBox(height: 14),
          ],
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < children.length; i++) ...[
          Expanded(child: children[i]),
          if (i != children.length - 1) const SizedBox(width: 16),
        ],
      ],
    );
  }

  Widget _buildHeaderStep() {
    return SingleChildScrollView(
      child: _card(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _sectionTitle('Document Detail'),
              _field(
                'title',
                'Title',
                hint: 'Enter document title',
                required: true,
              ),
              const SizedBox(height: 14),
              _cols([
                _buildSectionDropdown(),
                _field('owner', 'Process Owner', readOnly: true),
              ]),
              const SizedBox(height: 14),
              _cols([
                _field(
                  'docCode',
                  'Doc. Code',
                  hint: 'e.g. CRMC-QMS-001',
                  required: true,
                ),
                _field('revision', 'Revision', hint: 'e.g. 00'),
              ]),
              _divider(),
              _sectionTitle('Reference & Validity'),
              _field(
                'reference',
                'Regulatory/Standard Reference(s)',
                hint: 'Enter regulatory or standard reference(s)',
              ),
              const SizedBox(height: 14),
              _cols([
                _field('pages', 'Pages', hint: 'Auto', readOnly: true),
                _field(
                  'effectivity',
                  'Effectivity Date',
                  hint: 'Select Date',
                  readOnly: true,
                  onTap: _pickDate,
                  suffix: IconButton(
                    icon: const Icon(Icons.calendar_today_outlined, size: 20),
                    onPressed: _pickDate,
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tbIcon(IconData icon, String tip, VoidCallback onTap) =>
      IconButton(tooltip: tip, icon: Icon(icon, size: 20), onPressed: onTap);

  Widget _buildEditorStep() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: LayoutBuilder(
          builder: (context, c) {
            return HtmlEditor(
              controller: _controller,
              callbacks: Callbacks(
                onInit: () {
                  _editorReady = true;
                  _syncListMarkers();
                },
                onChangeContent: (s) {
                  if (s != null) _latestHtml = s;
                  _syncListMarkers();
                },
                onChangeSelection: (_) => _syncListMarkers(),
              ),
              htmlEditorOptions: HtmlEditorOptions(
                hint: 'Type here...',
                initialText: widget.initialHtml,
                autoAdjustHeight: false,
                webInitialScripts: UnmodifiableListView([
                  WebScript(name: 'syncListMarkers', script: syncListScript),
                  WebScript(name: 'imgFix', script: imageFixScript),
                  ...paragraphScripts,
                  ...imageScripts,
                ]),
              ),
              htmlToolbarOptions: HtmlToolbarOptions(
                toolbarType: ToolbarType.nativeGrid,
                defaultToolbarButtons: [
                  StyleButtons(),
                  FontSettingButtons(),
                  FontButtons(),
                  ColorButtons(),
                  ListButtons(),
                  ParagraphButtons(
                    textDirection: false,
                    caseConverter: false,
                    lineHeight: false,
                  ),
                  InsertButtons(audio: false, video: false, otherFile: false),
                  OtherButtons(),
                ],
                customToolbarButtons: [
                  _tbIcon(
                    Icons.check_box_outline_blank,
                    'Checkbox list',
                    _insertBoxList,
                  ),
                  PopupMenuButton<String>(
                    tooltip: 'Line spacing',
                    icon: const Icon(Icons.format_line_spacing, size: 20),
                    onSelected:
                        (name) => _controller.evaluateJavascriptWeb(name),
                    itemBuilder:
                        (_) => const [
                          PopupMenuItem(value: 'lsp10', child: Text('1.0')),
                          PopupMenuItem(value: 'lsp115', child: Text('1.15')),
                          PopupMenuItem(value: 'lsp15', child: Text('1.5')),
                          PopupMenuItem(value: 'lsp20', child: Text('2.0')),
                          PopupMenuItem(value: 'lsp25', child: Text('2.5')),
                          PopupMenuItem(value: 'lsp30', child: Text('3.0')),
                        ],
                  ),
                  _tbIcon(
                    Icons.vertical_align_center,
                    'Remove space after paragraph',
                    () => _controller.evaluateJavascriptWeb('spaceRemove'),
                  ),
                  _tbIcon(
                    Icons.space_bar,
                    'Add space after paragraph',
                    () => _controller.evaluateJavascriptWeb('spaceAdd'),
                  ),
                  PopupMenuButton<String>(
                    tooltip: 'Image size (click image first)',
                    icon: const Icon(Icons.photo_size_select_large, size: 20),
                    onSelected:
                        (name) => _controller.evaluateJavascriptWeb(name),
                    itemBuilder:
                        (_) => const [
                          PopupMenuItem(value: 'imgW25', child: Text('25%')),
                          PopupMenuItem(value: 'imgW50', child: Text('50%')),
                          PopupMenuItem(value: 'imgW75', child: Text('75%')),
                          PopupMenuItem(value: 'imgW100', child: Text('100%')),
                        ],
                  ),
                  PopupMenuButton<String>(
                    tooltip: 'Image align (click image first)',
                    icon: const Icon(Icons.align_horizontal_left, size: 20),
                    onSelected:
                        (name) => _controller.evaluateJavascriptWeb(name),
                    itemBuilder:
                        (_) => const [
                          PopupMenuItem(value: 'imgLeft', child: Text('Left')),
                          PopupMenuItem(
                            value: 'imgCenter',
                            child: Text('Center'),
                          ),
                          PopupMenuItem(
                            value: 'imgRight',
                            child: Text('Right'),
                          ),
                        ],
                  ),
                ],
              ),
              otherOptions: OtherOptions(height: c.maxHeight),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReviewStep() {
    const rows = [
      ('title', 'Title'),
      ('section', 'Section'),
      ('owner', 'Process Owner'),
      ('docCode', 'Doc. Code'),
      ('revision', 'Revision'),
      ('reference', 'Regulatory/Standard Reference(s)'),
      ('pages', 'Pages'),
      ('effectivity', 'Effectivity Date'),
    ];

    return SingleChildScrollView(
      child: _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sectionTitle('Review Document Header'),
            for (final r in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        r.$2,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _hdr[r.$1]!.text.trim().isEmpty
                            ? '—'
                            : _hdr[r.$1]!.text.trim(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionOption {
  final int id;
  final String name;
  const _SectionOption(this.id, this.name);
}

class _LogRow {
  final PolicyandProceduresLogList? source;
  final TextEditingController code;
  final TextEditingController page;
  final TextEditingController revision;
  final TextEditingController reasons;
  DateTime? date;

  _LogRow({this.source, this.date})
    : code = TextEditingController(text: source?.documentCode ?? ''),
      page = TextEditingController(text: source?.pageNo ?? ''),
      revision = TextEditingController(text: source?.revision ?? ''),
      reasons = TextEditingController(text: source?.reasons ?? '');

  factory _LogRow.fromModel(PolicyandProceduresLogList m) =>
      _LogRow(source: m, date: m.date);

  void dispose() {
    code.dispose();
    page.dispose();
    revision.dispose();
    reasons.dispose();
  }
}

class _ChevronClipper extends CustomClipper<Path> {
  final bool first;
  final bool last;
  final double depth;

  const _ChevronClipper({
    required this.first,
    required this.last,
    required this.depth,
  });

  @override
  Path getClip(Size s) {
    final r = last ? s.width : s.width - depth;
    final p = Path()..moveTo(0, 0);
    p.lineTo(r, 0);
    if (!last) p.lineTo(s.width, s.height / 2);
    p.lineTo(r, s.height);
    p.lineTo(0, s.height);
    if (!first) p.lineTo(depth, s.height / 2);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(_ChevronClipper old) =>
      old.first != first || old.last != last || old.depth != depth;
}
