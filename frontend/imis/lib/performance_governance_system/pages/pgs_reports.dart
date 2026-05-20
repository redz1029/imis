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

Future<void> _openPdfPreview({
  required String webEndpoint,
  required String pgsId,
  required String officeName,
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
    final String endpoint =
        kIsWeb ? webEndpoint : '${ApiEndpoint().generatePdf}/$pgsId';

    final response = await AuthenticatedRequest.get(
      dio,
      endpoint,
      options: Options(
        responseType: ResponseType.bytes,
        headers: {"Accept": "application/pdf"},
      ),
    );

    if (response.statusCode != 200 || response.data == null) return;

    final bytes = Uint8List.fromList(response.data);

    if (kIsWeb) {
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.window.open(url, "_blank");
      Future.delayed(
        const Duration(seconds: 15),
        () => html.Url.revokeObjectUrl(url),
      );
    } else {
      final Directory dir;
      if (Platform.isAndroid || Platform.isIOS) {
        dir = await getTemporaryDirectory();
      } else if (Platform.isWindows) {
        dir = (await getDownloadsDirectory())!;
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final sanitized = officeName.replaceAll(RegExp(r'[^\w\s]'), '_');
      final filePath = '${dir.path}/${sanitized}_$pgsId.pdf';
      await File(filePath).writeAsBytes(bytes);

      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        debugPrint("OpenFile error: ${result.message}");
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
    if (context != null && context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}

Future<void> openAllCombinedPGSPreview(
  String pgsId,
  String officeName, {
  BuildContext? context,
}) => _openPdfPreview(
  webEndpoint: '${ApiEndpoint().generatePdf}/$pgsId',
  pgsId: pgsId,
  officeName: officeName,
  context: context,
);

Future<void> openReadinessRatingPreview(
  String pgsId,
  String officeName, {
  BuildContext? context,
}) => _openPdfPreview(
  webEndpoint: '${ApiEndpoint().pgs}/pgsreadiness/pdf/$pgsId',
  pgsId: pgsId,
  officeName: officeName,
  context: context,
);

Future<void> openPGSDeliverablesStatusPreview(
  String pgsId,
  String officeName, {
  BuildContext? context,
}) => _openPdfPreview(
  webEndpoint: '${ApiEndpoint().pgs}/pgsdeliverablestatus/pdf/$pgsId',
  pgsId: pgsId,
  officeName: officeName,
  context: context,
);

Future<void> openDeliverablesOnlyPreview(
  String pgsId,
  String officeName, {
  BuildContext? context,
}) => _openPdfPreview(
  webEndpoint: '${ApiEndpoint().pgs}/specificpgsdelivrable/pdf/$pgsId',
  pgsId: pgsId,
  officeName: officeName,
  context: context,
);
