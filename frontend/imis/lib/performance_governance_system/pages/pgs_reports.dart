import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/utils/api_endpoint.dart';
import '../../widgets/universal_webview_web.dart';

class ReportViewerPage extends StatelessWidget {
  final String pgsId;

  const ReportViewerPage({super.key, required this.pgsId});

  @override
  Widget build(BuildContext context) {
    final pdfUrl = "${ApiEndpoint().generatePdf}/$pgsId";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Performance Governance Report"),
        backgroundColor: mainBgColor,
      ),
      body: UniversalWebView(url: pdfUrl),
    );
  }
}
