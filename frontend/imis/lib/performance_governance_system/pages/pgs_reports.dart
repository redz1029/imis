import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/api_endpoint.dart';

Future<void> openPGSReportNewTab(String pgsId, String officeName) async {
  final dio = Dio();

  try {
    final response = await AuthenticatedRequest.get(
      dio,
      '${ApiEndpoint().generatePdf}/$pgsId',
      options: Options(
        responseType: ResponseType.bytes,
        headers: {"Accept": "application/pdf"},
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final bytes = Uint8List.fromList(response.data);

      if (kIsWeb) {
        final pdfBlob = html.Blob([bytes], 'application/pdf');
        final pdfUrl = html.Url.createObjectUrlFromBlob(pdfBlob);
        html.window.open(pdfUrl, "_blank");
        Future.delayed(const Duration(seconds: 15), () {
          html.Url.revokeObjectUrl(pdfUrl);
        });
      } else {
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/$officeName.pdf');
        await file.writeAsBytes(bytes);
        await OpenFile.open(file.path);
      }
    }
  } catch (e) {
    debugPrint("Error opening PDF: $e");
  }
}
