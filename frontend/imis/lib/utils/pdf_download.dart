import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:universal_html/html.dart' as html;

/// Saves a PDF to the device: a browser download on the web, the Downloads
/// folder on Windows, the app documents folder elsewhere (then opened).
Future<void> downloadPdf(
  BuildContext context,
  Uint8List bytes,
  String fileName,
) async {
  final name = fileName.toLowerCase().endsWith('.pdf')
      ? fileName
      : '$fileName.pdf';
  try {
    if (kIsWeb) {
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', name)
        ..click();
      html.Url.revokeObjectUrl(url);
      return;
    }

    final Directory? dir;
    if (Platform.isAndroid || Platform.isIOS) {
      dir = await getTemporaryDirectory();
    } else if (Platform.isWindows) {
      dir = await getDownloadsDirectory();
    } else {
      dir = await getApplicationDocumentsDirectory();
    }
    if (dir == null) throw Exception('No folder to save the file in.');

    final path = '${dir.path}${Platform.pathSeparator}$name';
    await File(path).writeAsBytes(bytes);
    final result = await OpenFile.open(path);
    if (result.type != ResultType.done) {
      debugPrint('OpenFile error: ${result.message}');
    }
  } catch (e) {
    debugPrint('Error downloading PDF: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to download the file.')),
      );
    }
  }
}

/// The preview's download button, used in place of the share button.
PdfPreviewAction downloadPdfAction(String fileName) => PdfPreviewAction(
  icon: const Icon(Icons.download),
  onPressed: (context, build, pageFormat) async {
    final bytes = await build(pageFormat);
    if (!context.mounted) return;
    await downloadPdf(context, bytes, fileName);
  },
);
