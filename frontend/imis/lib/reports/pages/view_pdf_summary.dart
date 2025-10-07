import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/utils/api_endpoint.dart';
import '../../widgets/universal_webview_web.dart';

class ViewPdfSummary extends StatelessWidget {
  final String pgsPeriodId;
  final String officeId;

  const ViewPdfSummary({
    super.key,
    required this.pgsPeriodId,
    required this.officeId,
  });

  @override
  Widget build(BuildContext context) {
    final pdfUrl =
        "${ApiEndpoint().pgsSummaryNarrativeListReport}?PgsPeriodId=$pgsPeriodId&OfficeId=$officeId&Page=1&PageSize=25";

    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: const Text("Summary Narrative Report"),
        backgroundColor: mainBgColor,
      ),
      body: UniversalWebView(url: pdfUrl),
    );
  }
}
