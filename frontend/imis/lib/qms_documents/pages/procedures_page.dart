import 'dart:collection';
import 'dart:convert';
import 'package:imis/qms_documents/template/qms_template.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:imis/constant/constant.dart';

const String _logoAssetUrl = 'assets/assets/CRMC.png';

class ProceduresPage extends StatefulWidget {
  final String? initialHtml;

  final Map<String, String>? initialHeader;

  final Future<void> Function(String html)? onSave;

  final Future<void> Function(Map<String, String> header, String html)?
  onSaveDocument;

  final VoidCallback? onClose;

  const ProceduresPage({
    super.key,
    this.initialHtml,
    this.initialHeader,
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

  bool _saving = false;
  int _step = 0;

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
    ('Review', 'Check everything and save.', Icons.fact_check_outlined),
  ];

  late final Map<String, TextEditingController> _hdr = {
    for (final k in _headerKeys)
      k: TextEditingController(text: widget.initialHeader?[k] ?? ''),
  };

  @override
  void dispose() {
    for (final c in _hdr.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _close() {
    if (widget.onClose != null) {
      widget.onClose!();
    } else {
      Navigator.maybePop(context);
    }
  }

  void _syncListMarkers() {
    _controller.evaluateJavascriptWeb('syncListMarkers');
  }

  Future<void> _save({bool close = false}) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final htmlText = await _controller.getText();
      await widget.onSave?.call(htmlText);
      await widget.onSaveDocument?.call({
        for (final k in _headerKeys) k: _hdr[k]!.text.trim(),
      }, htmlText);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Saved successfully')));
      if (close) _close();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to save')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _v(String key) => const HtmlEscape(
    HtmlEscapeMode.element,
  ).convert(_hdr[key]!.text.trim()).replaceAll('\n', '<br>');

  String _buildHeaderHtml() {
    final logo = Uri.base.resolve(_logoAssetUrl).toString();
    return '''
<div class="hdr-top">
  <div>Republic of the Philippines</div>
  <div>Department of Health</div>
  <div class="hdr-center">COTABATO REGIONAL AND MEDICAL CENTER</div>
</div>
<table class="hdr">
  <colgroup>
    <col style="width: 15%">
    <col style="width: 43%">
    <col style="width: 42%">
  </colgroup>
  <tr>
    <td class="logo" rowspan="5"><div class="logo-box"><img src="$logo" onerror="this.style.display='none'"></div></td>
    <td rowspan="2">TITLE: <b>${_v('title')}</b></td>
    <td>SECTION: <b>${_v('section')}</b></td>
  </tr>
  <tr>
    <td>DOC. CODE: <b>${_v('docCode')}</b></td>
  </tr>
  <tr>
    <td>PROCESS OWNER: <b>${_v('owner')}</b></td>
    <td>REVISION: <b>${_v('revision')}</b></td>
  </tr>
  <tr>
    <td>REGULATORY/STANDARD REFERENCE(S): <b>${_v('reference')}</b></td>
    <td>PAGES: <b>${_v('pages')}</b></td>
  </tr>
  <tr>
    <td colspan="2">EFFECTIVITY DATE: <b>${_v('effectivity')}</b></td>
  </tr>
</table>''';
  }

  Future<void> _openPreview() async {
    final body = sanitize(await _controller.getText());
    final blob = html.Blob([
      buildPreviewDocument(_buildHeaderHtml(), body),
    ], 'text/html');
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
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d == null) return;
    _hdr['effectivity']!.text = '${_months[d.month - 1]} ${d.day}, ${d.year}';
  }

  bool _headerValid() => _formKey.currentState?.validate() ?? true;

  void _goTo(int i) {
    if (i == _step) return;
    if (i > _step && !_headerValid()) return;
    setState(() => _step = i);
  }

  void _next() {
    if (_step < _steps.length - 1) {
      _goTo(_step + 1);
    } else {
      _save(close: true);
    }
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  // ───────────────────────── build ─────────────────────────

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
            onPressed: _close,
          ),
        ),
        title: Text(
          'Procedures',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBar: _buildFooter(isLast),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            isSmall
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
            _outlineBtn('Preview', _openPreview),
            _outlineBtn('Save as Draft', _saving ? null : _save),
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

  // ───────────────────────── stepper ─────────────────────────

  Widget _stepIcon(int i, {double size = 34}) {
    final done = i < _step;
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
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          for (int i = 0; i < _steps.length; i++) ...[
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
            if (i != _steps.length - 1)
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (int i = 0; i < _steps.length; i++) ...[
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
            if (i != _steps.length - 1)
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

  // ───────────────────────── content ─────────────────────────

  Widget _buildContent() {
    // IndexedStack para hindi ma-destroy yung editor kapag nag-switch ng step
    return IndexedStack(
      index: _step,
      children: [_buildHeaderStep(), _buildEditorStep(), _buildReviewStep()],
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

  // STEP 1 — Document Header
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
                _field('section', 'Section'),
                _field('owner', 'Process Owner'),
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
                _field('pages', 'Pages', hint: 'e.g. 1 of 6'),
                _field(
                  'effectivity',
                  'Effectivity Date',
                  hint: 'Select Date',
                  readOnly: true,
                  onTap: _pickDate,
                  suffix: IconButton(
                    icon: const Icon(Icons.calendar_today_outlined, size: 16),
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

  // STEP 2 — Procedure editor
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
                onInit: _syncListMarkers,
                onChangeContent: (_) => _syncListMarkers(),
                onChangeSelection: (_) => _syncListMarkers(),
              ),
              htmlEditorOptions: HtmlEditorOptions(
                hint: 'Type here...',
                initialText: widget.initialHtml,
                autoAdjustHeight: false,
                webInitialScripts: UnmodifiableListView([
                  WebScript(name: 'syncListMarkers', script: syncListScript),
                  ...paragraphScripts,
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
                  IconButton(
                    tooltip: 'Checkbox list',
                    icon: const Icon(Icons.check_box_outline_blank, size: 20),
                    onPressed: _insertBoxList,
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
                  IconButton(
                    tooltip: 'Remove space after paragraph',
                    icon: const Icon(Icons.vertical_align_center, size: 20),
                    onPressed:
                        () => _controller.evaluateJavascriptWeb('spaceRemove'),
                  ),
                  IconButton(
                    tooltip: 'Add space after paragraph',
                    icon: const Icon(Icons.space_bar, size: 20),
                    onPressed:
                        () => _controller.evaluateJavascriptWeb('spaceAdd'),
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

  // STEP 3 — Review
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
