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
  required String id,
  required String name,
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
        kIsWeb ? webEndpoint : '${ApiEndpoint().generatePdf}/$id';

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

      final sanitized = name.replaceAll(RegExp(r'[^\w\s]'), '_');
      final filePath = '${dir.path}/${sanitized}_$id.pdf';
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

Future<void> _openPdfPreviewWithParams({
  required String endpoint,
  required String reportName,
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

      final sanitized = reportName.replaceAll(RegExp(r'[^\w\s]'), '_');
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${dir.path}/${sanitized}_$timestamp.pdf';
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
  id: pgsId,
  name: officeName,
  context: context,
);

Future<void> openReadinessRatingPreview(
  String pgsId,
  String officeName, {
  BuildContext? context,
}) => _openPdfPreview(
  webEndpoint: '${ApiEndpoint().pgs}/pgsreadiness/pdf/$pgsId',
  id: pgsId,
  name: officeName,
  context: context,
);

Future<void> openPGSDeliverablesStatusPreview(
  String pgsId,
  String officeName, {
  BuildContext? context,
}) => _openPdfPreview(
  webEndpoint: '${ApiEndpoint().pgs}/pgsdeliverablestatus/pdf/$pgsId',
  id: pgsId,
  name: officeName,
  context: context,
);

Future<void> openDeliverablesOnlyPreview(
  String pgsId,
  String officeName, {
  BuildContext? context,
}) => _openPdfPreview(
  webEndpoint: '${ApiEndpoint().pgs}/specificpgsdelivrable/pdf/$pgsId',
  id: pgsId,
  name: officeName,
  context: context,
);

Future<void> openRoadmapInNewTab(
  String roadmapId,
  String kraNme, {
  BuildContext? context,
}) => _openPdfPreview(
  webEndpoint: '${ApiEndpoint().kraRoadMapReport}/$roadmapId',
  id: roadmapId,
  name: kraNme,
  context: context,
);

Future<void> viewAuditorSummaryNarrativeReport(
  String pgsPeriodId,
  String officeId, {
  BuildContext? context,
}) => _openPdfPreview(
  webEndpoint:
      "${ApiEndpoint().pgsSummaryNarrativeListReport}?PgsPeriodId=$pgsPeriodId",
  id: pgsPeriodId,
  name: officeId,
  context: context,
);

Future<void> openProcessCoreSupportPrintPreview(
  String processCoreId,
  String processCoreSupport, {
  BuildContext? context,
}) => _openPdfPreview(
  webEndpoint:
      "${ApiEndpoint().kraRoadmapCoreAndSupport}/list-report/pdf?kraRoadMapPeriodId=$processCoreId",
  id: processCoreId,
  name: processCoreSupport,
  context: context,
);

Future<void> openStrategyReviewReportPreview(
  String strategyReviewId,
  String strategyReviewReport, {
  BuildContext? context,
}) => _openPdfPreview(
  webEndpoint: "${ApiEndpoint().strategyReview}/pdf/$strategyReviewId",
  id: strategyReviewId,
  name: strategyReviewReport,
  context: context,
);

Future<void> openPendingAuditsReportPreviewbyTeam({
  int? teamId,
  int? auditorId,
  int? officeId,
  int? month,
  required int year,
  BuildContext? context,
}) async {
  final queryParams = <String>[];

  if (teamId != null) queryParams.add('teamId=$teamId');
  if (auditorId != null) queryParams.add('auditorId=$auditorId');
  if (officeId != null) queryParams.add('officeId=$officeId');
  if (month != null) queryParams.add('month=$month');
  queryParams.add('year=$year');

  final queryString = queryParams.join('&');
  final endpoint =
      '${ApiEndpoint.baseUrl}/auditor/pending-audits-report?$queryString';

  return _openPdfPreviewWithParams(
    endpoint: endpoint,
    reportName: 'Pending_Audits_Report',
    context: context,
  );
}

Future<void> openPendingAuditsReportPreviewByService({
  int? teamId,
  int? auditorId,
  int? officeId,
  int? parentOfficeId,
  int? month,
  required int year,
  BuildContext? context,
}) async {
  final queryParams = <String>[];

  if (teamId != null) queryParams.add('teamId=$teamId');
  if (auditorId != null) queryParams.add('auditorId=$auditorId');
  if (officeId != null) queryParams.add('officeId=$officeId');
  if (month != null) queryParams.add('month=$month');
  if (parentOfficeId != null) queryParams.add('parentOfficeId=$parentOfficeId');
  queryParams.add('year=$year');

  final queryString = queryParams.join('&');
  final endpoint =
      '${ApiEndpoint.baseUrl}/auditor/pending-audits-sortbyservice-report?$queryString';

  return _openPdfPreviewWithParams(
    endpoint: endpoint,
    reportName: 'Pending_Audits_Report',
    context: context,
  );
}
