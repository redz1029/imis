import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/utils/api_endpoint.dart';
import '../../widgets/universal_webview_web.dart';

class ViewPdfSummary extends StatelessWidget {
  final String pgsPeriodId;

  const ViewPdfSummary({super.key, required this.pgsPeriodId});

  @override
  Widget build(BuildContext context) {
    final pdfUrl =
        "${ApiEndpoint().pgsSummaryNarrativeListReport}?PgsPeriodId=$pgsPeriodId&Page=1&PageSize=25";

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
