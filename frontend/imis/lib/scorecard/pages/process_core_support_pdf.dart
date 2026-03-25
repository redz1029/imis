// import 'package:flutter/material.dart';
// import 'package:imis/constant/constant.dart';
// import 'package:imis/utils/api_endpoint.dart';
// import '../../widgets/universal_webview_web.dart';

// class ProcessCoreSupportPdf extends StatelessWidget {
//   final String processCoreId;

//   const ProcessCoreSupportPdf({super.key, required this.processCoreId});

//   @override
//   Widget build(BuildContext context) {
//     final pdfUrl =
//         "${ApiEndpoint().kraRoadmapCoreAndSupport}/list-report/pdf?kraRoadMapPeriodId=$processCoreId";

//     return Scaffold(
//       backgroundColor: mainBgColor,
//       appBar: AppBar(
//         title: const Text("Process Core and Support Report"),
//         backgroundColor: mainBgColor,
//       ),
//       body: UniversalWebView(url: pdfUrl),
//     );
//   }
// }
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/api_endpoint.dart';

Future<void> openProcessCoreSupport(
  String processCoreId,
  String processCoreSupport,
) async {
  final dio = Dio();

  try {
    final response = await AuthenticatedRequest.get(
      dio,
      "${ApiEndpoint().kraRoadmapCoreAndSupport}/list-report/pdf?kraRoadMapPeriodId=$processCoreId",
      options: Options(
        responseType: ResponseType.bytes,
        headers: {"Accept": "application/pdf"},
      ),
    );
    if (response.statusCode == 200 && response.data != null) {
      final bytes = Uint8List.fromList(response.data);

      final pdfBlob = html.Blob([bytes], 'application/pdf');
      final pdfUrl = html.Url.createObjectUrlFromBlob(pdfBlob);

      final String htmlContent = '''
        <!DOCTYPE html>
        <html>
          <head>
            <title>$processCoreSupport</title>
            <style>
              body, html { margin: 0; padding: 0; height: 100%; overflow: hidden; background-color: #525659; }
              iframe { width: 100%; height: 100%; border: none; }
            </style>
          </head>
          <body>
            <iframe src="$pdfUrl"></iframe>
          </body>
        </html>
      ''';

      final htmlBlob = html.Blob([htmlContent], 'text/html');
      final htmlUrl = html.Url.createObjectUrlFromBlob(htmlBlob);

      html.window.open(htmlUrl, "_blank");

      Future.delayed(const Duration(seconds: 15), () {
        html.Url.revokeObjectUrl(pdfUrl);
        html.Url.revokeObjectUrl(htmlUrl);
      });
    }
  } catch (e) {
    debugPrint("Error opening new tab: $e");
  }
}
