// import 'package:flutter/material.dart';
// import 'package:imis/utils/api_endpoint.dart';
// import 'package:imis/widgets/universal_webview.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// class SampleReport extends StatefulWidget {
//   final bool isPdf;
//   final String pgsId;
//   const SampleReport({super.key, required this.isPdf, required this.pgsId});

//   @override
//   State<SampleReport> createState() => _SampleReportState();
// }

// class _SampleReportState extends State<SampleReport> {
//   final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         // child: SizedBox(
//         //   width: Adaptive.w(90),
//         //   height: Adaptive.h(95),
//         //   child:
//         //       widget.isPdf
//         //           ? SfPdfViewer.network(
//         //             ApiEndpoint().generatePdf,
//         //             key: _pdfViewerKey,
//         //           )
//         //           : UniversalWebView(url: ApiEndpoint().generatePdf),
//         // ),
//         child: SizedBox(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height * 0.95,
//           child:
//               widget.isPdf
//                   ? SfPdfViewer.network(
//                     '${ApiEndpoint().generatePdf}/${widget.pgsId}',
//                     key: _pdfViewerKey,
//                   )
//                   : UniversalWebView(
//                     url: '${ApiEndpoint().generatePdf}/${widget.pgsId}',
//                   ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:imis/utils/api_endpoint.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../widgets/universal_webview_web.dart';

class SampleReport extends StatefulWidget {
  final bool isPdf;
  final String pgsId;
  const SampleReport({super.key, required this.isPdf, required this.pgsId});

  @override
  State<SampleReport> createState() => _SampleReportState();
}

class _SampleReportState extends State<SampleReport> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  Uint8List? pdfBytes;

  @override
  void initState() {
    super.initState();
    if (widget.isPdf) {
      _loadPdf();
    }
  }

  Future<void> _loadPdf() async {
    final response = await http.get(
      Uri.parse('${ApiEndpoint().generatePdf}/${widget.pgsId}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        pdfBytes = response.bodyBytes;
      });
    } else {
      throw Exception("Failed to load PDF");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            widget.isPdf
                ? (pdfBytes != null
                    ? SfPdfViewer.memory(pdfBytes!, key: _pdfViewerKey)
                    : const CircularProgressIndicator())
                : UniversalWebView(
                  url: '${ApiEndpoint().generatePdf}/${widget.pgsId}',
                ),
      ),
    );
  }
}
