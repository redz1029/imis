import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/utils/api_endpoint.dart';
import '../../widgets/universal_webview_web.dart';

class PrintRoadmapPage extends StatelessWidget {
  final String roadmapId;

  const PrintRoadmapPage({super.key, required this.roadmapId});

  @override
  Widget build(BuildContext context) {
    final pdfUrl = "${ApiEndpoint().kraRoadMapReport}/$roadmapId";

    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: const Text("Roadmap Report"),
        backgroundColor: mainBgColor,
      ),
      body: UniversalWebView(url: pdfUrl),
    );
  }
}
