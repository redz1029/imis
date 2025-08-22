import 'package:flutter/material.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/widgets/universal_webview.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SampleReport extends StatefulWidget {
  final bool isPdf;
  final String pgsId;
  const SampleReport({super.key, required this.isPdf, required this.pgsId});

  @override
  State<SampleReport> createState() => _SampleReportState();
}

class _SampleReportState extends State<SampleReport> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          // width: Adaptive.w(90),
          // height: Adaptive.h(95),
          child:
              widget.isPdf
                  ? SfPdfViewer.network(
                    '${ApiEndpoint().generatePdf}/${widget.pgsId}',
                    key: _pdfViewerKey,
                  )
                  : UniversalWebView(
                    url: '${ApiEndpoint().generatePdf}/${widget.pgsId}',
                  ),
        ),
      ),
    );
  }
}

// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:http/http.dart' as http;

// class ReportViewerPage extends StatefulWidget {
//   final String pdfUrl;

//   const ReportViewerPage({super.key, required this.pdfUrl});

//   @override
//   State<ReportViewerPage> createState() => _ReportViewerPageState();
// }

// class _ReportViewerPageState extends State<ReportViewerPage> {
//   Uint8List? pdfBytes;

//   @override
//   void initState() {
//     super.initState();
//     _loadPdf();
//   }

//   Future<void> _loadPdf() async {
//     try {
//       final response = await http.get(Uri.parse(widget.pdfUrl));

//       if (response.statusCode == 200) {
//         setState(() {
//           pdfBytes = response.bodyBytes;
//         });
//       } else {}
//       // ignore: empty_catches
//     } catch (e) {}
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//           pdfBytes == null
//               ? const Center(child: CircularProgressIndicator())
//               : SfPdfViewer.memory(pdfBytes!),
//     );
//   }
// }
