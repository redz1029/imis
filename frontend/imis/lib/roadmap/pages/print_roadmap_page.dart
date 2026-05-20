import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/api_endpoint.dart';

Future<void> openRoadmapInNewTab(
  String roadmapId,
  String kraNme, {
  BuildContext? context,
}) async {
  final dio = Dio();

  if (context != null && context.mounted) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => const AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: primaryColor),
                SizedBox(width: 16),
                Text(
                  "Generating PDF...",
                  style: TextStyle(color: primaryColor),
                ),
              ],
            ),
          ),
    );
  }

  try {
    if (kIsWeb) {
      final response = await AuthenticatedRequest.get(
        dio,
        '${ApiEndpoint().kraRoadMapReport}/$roadmapId',
        options: Options(
          responseType: ResponseType.bytes,
          headers: {"Accept": "application/pdf"},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final bytes = Uint8List.fromList(response.data);
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.window.open(url, "_blank");
        Future.delayed(const Duration(seconds: 15), () {
          html.Url.revokeObjectUrl(url);
        });
      }
    } else if (Platform.isAndroid || Platform.isIOS) {
      final response = await AuthenticatedRequest.get(
        dio,
        '${ApiEndpoint().generatePdf}/$roadmapId',
        options: Options(
          responseType: ResponseType.bytes,
          headers: {"Accept": "application/pdf"},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final bytes = Uint8List.fromList(response.data);
        final tempDir = await getTemporaryDirectory();
        final sanitized = kraNme.replaceAll(RegExp(r'[^\w\s]'), '_');
        final filePath = '${tempDir.path}/${sanitized}_$roadmapId.pdf';
        final file = File(filePath);
        await file.writeAsBytes(bytes);

        final result = await OpenFile.open(filePath);
        if (result.type != ResultType.done) {
          debugPrint("OpenFile error: ${result.message}");
        }
      }
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      final response = await AuthenticatedRequest.get(
        dio,
        '${ApiEndpoint().generatePdf}/$roadmapId',
        options: Options(
          responseType: ResponseType.bytes,
          headers: {"Accept": "application/pdf"},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final bytes = Uint8List.fromList(response.data);

        final dir =
            Platform.isWindows
                ? await getDownloadsDirectory()
                : await getApplicationDocumentsDirectory();

        final sanitized = kraNme.replaceAll(RegExp(r'[^\w\s]'), '_');
        final filePath = '${dir!.path}/${sanitized}_$roadmapId.pdf';
        final file = File(filePath);
        await file.writeAsBytes(bytes);

        final result = await OpenFile.open(filePath);
        if (result.type != ResultType.done) {
          debugPrint("OpenFile error: ${result.message}");
        }
      }
    }
  } catch (e) {
    debugPrint("Error opening PDF: $e");
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to open PDF. Please try again.")),
      );
    }
  } finally {
    // close loading dialog
    if (context != null && context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
