import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/utils/api_endpoint.dart';
import '../../widgets/universal_webview_web.dart';

class ProcessCoreSupportPdf extends StatelessWidget {
  final String processCoreId;

  const ProcessCoreSupportPdf({super.key, required this.processCoreId});

  @override
  Widget build(BuildContext context) {
    final pdfUrl =
        "${ApiEndpoint().kraRoadmapCoreAndSupport}/list-report/pdf?kraRoadMapPeriodId=$processCoreId";

    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: const Text("Process Core and Support Report"),
        backgroundColor: mainBgColor,
      ),
      body: UniversalWebView(url: pdfUrl),
    );
  }
}
