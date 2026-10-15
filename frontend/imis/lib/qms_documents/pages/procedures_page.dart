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

  const ProceduresPage({
    super.key,
    this.initialHtml,
    this.initialHeader,
    this.onSave,
  });

  @override
  State<ProceduresPage> createState() => _ProceduresEditorPageState();
}

class _ProceduresEditorPageState extends State<ProceduresPage> {
  final HtmlEditorController _controller = HtmlEditorController(
    processInputHtml: false,
  );
  bool _saving = false;
  bool _headerOpen = true;

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

  void _syncListMarkers() {
    _controller.evaluateJavascriptWeb('syncListMarkers');
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final htmlText = await _controller.getText();
      await widget.onSave?.call(htmlText);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Saved successfully')));
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

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: const Text('Procedures'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Print Preview',
            icon: const Icon(Icons.preview_outlined),
            onPressed: _openPreview,
          ),
          _saving
              ? const Padding(
                padding: EdgeInsets.all(14),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
              : IconButton(
                tooltip: 'Save',
                icon: const Icon(Icons.save_outlined),
                onPressed: _save,
              ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderCard(isSmall),
            const SizedBox(height: 12),
            Expanded(child: _buildEditorCard()),
          ],
        ),
      ),
    );
  }

  BoxDecoration get _cardDecoration => BoxDecoration(
    border: Border.all(color: Colors.grey.shade300),
    borderRadius: BorderRadius.circular(8),
    color: Colors.white,
  );

  Widget _titleBar(String title, {Widget? trailing}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.vertical(
          top: const Radius.circular(8),
          bottom: Radius.circular(trailing == null ? 0 : 0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildHeaderCard(bool isSmall) {
    final border = BorderSide(color: Colors.grey.shade300);

    Widget cell(String key, String label, {bool last = false, int lines = 1}) {
      return Container(
        constraints: const BoxConstraints(minHeight: 58),
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        decoration: BoxDecoration(
          border: Border(right: last || isSmall ? BorderSide.none : border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 3),
            TextField(
              controller: _hdr[key],
              minLines: 1,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: GoogleFonts.plusJakartaSans(fontSize: 12),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      );
    }

    Widget row(List<(int, Widget)> cells, {bool last = false}) {
      final decoration = BoxDecoration(
        border: last ? null : Border(bottom: border),
      );
      if (isSmall) {
        return Container(
          decoration: decoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int i = 0; i < cells.length; i++) ...[
                cells[i].$2,
                if (i != cells.length - 1)
                  Divider(height: 1, color: Colors.grey.shade200),
              ],
            ],
          ),
        );
      }
      return Container(
        decoration: decoration,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final c in cells) Expanded(flex: c.$1, child: c.$2),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            onTap: () => setState(() => _headerOpen = !_headerOpen),
            child: _titleBar(
              'Document Header',
              trailing: AnimatedRotation(
                turns: _headerOpen ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child:
                _headerOpen
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        row([
                          (3, cell('title', 'Title')),
                          (2, cell('section', 'Section', last: true)),
                        ]),
                        row([
                          (3, cell('owner', 'Process Owner')),
                          (1, cell('docCode', 'Doc. Code')),
                          (1, cell('revision', 'Revision', last: true)),
                        ]),
                        row([
                          (
                            3,
                            cell(
                              'reference',
                              'Regulatory/Standard Reference(s)',
                            ),
                          ),
                          (1, cell('pages', 'Pages (e.g. 1 of 6)')),
                          (
                            1,
                            cell('effectivity', 'Effectivity Date', last: true),
                          ),
                        ], last: true),
                      ],
                    )
                    : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorCard() {
    return Container(
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _titleBar('Procedure'),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(8),
              ),
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
                        WebScript(
                          name: 'syncListMarkers',
                          script: syncListScript,
                        ),
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
                        InsertButtons(
                          audio: false,
                          video: false,
                          otherFile: false,
                        ),
                        OtherButtons(),
                      ],
                      customToolbarButtons: [
                        IconButton(
                          tooltip: 'Checkbox list',
                          icon: const Icon(
                            Icons.check_box_outline_blank,
                            size: 20,
                          ),
                          onPressed: _insertBoxList,
                        ),
                        PopupMenuButton<String>(
                          tooltip: 'Line spacing',
                          icon: const Icon(Icons.format_line_spacing, size: 20),
                          onSelected:
                              (name) => _controller.evaluateJavascriptWeb(name),
                          itemBuilder:
                              (_) => const [
                                PopupMenuItem(
                                  value: 'lsp10',
                                  child: Text('1.0'),
                                ),
                                PopupMenuItem(
                                  value: 'lsp115',
                                  child: Text('1.15'),
                                ),
                                PopupMenuItem(
                                  value: 'lsp15',
                                  child: Text('1.5'),
                                ),
                                PopupMenuItem(
                                  value: 'lsp20',
                                  child: Text('2.0'),
                                ),
                                PopupMenuItem(
                                  value: 'lsp25',
                                  child: Text('2.5'),
                                ),
                                PopupMenuItem(
                                  value: 'lsp30',
                                  child: Text('3.0'),
                                ),
                              ],
                        ),
                        IconButton(
                          tooltip: 'Remove space after paragraph',
                          icon: const Icon(
                            Icons.vertical_align_center,
                            size: 20,
                          ),
                          onPressed:
                              () => _controller.evaluateJavascriptWeb(
                                'spaceRemove',
                              ),
                        ),
                        IconButton(
                          tooltip: 'Add space after paragraph',
                          icon: const Icon(Icons.space_bar, size: 20),
                          onPressed:
                              () =>
                                  _controller.evaluateJavascriptWeb('spaceAdd'),
                        ),
                      ],
                    ),
                    otherOptions: OtherOptions(height: c.maxHeight),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
