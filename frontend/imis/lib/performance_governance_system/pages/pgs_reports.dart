import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:printing/printing.dart';

class PgsReports extends StatefulWidget {
  final String pgsId;
  const PgsReports({super.key, required this.pgsId});

  @override
  State<PgsReports> createState() => PgsReportsPageState();
}

class PgsReportsPageState extends State<PgsReports> {
  final Dio _dio = Dio();
  Uint8List? _pdfBytes;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final response = await AuthenticatedRequest.get(
        _dio,
        '${ApiEndpoint().generatePdf}/${widget.pgsId}',
        options: Options(
          responseType: ResponseType.bytes,
          validateStatus: (status) => status! < 500,
          headers: {"Accept": "application/pdf"},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        if (mounted) {
          setState(() {
            _pdfBytes = Uint8List.fromList(response.data);
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBgColor,
      appBar: AppBar(
        title: const Text("Roadmap Report"),
        backgroundColor: mainBgColor,
        actions: [
          if (_pdfBytes != null) ...[
            Tooltip(
              message: 'Print',
              child: IconButton(
                icon: const Icon(Icons.print),
                onPressed: () {
                  Printing.layoutPdf(onLayout: (format) async => _pdfBytes!);
                },
              ),
            ),
            SizedBox(width: 9),
            Tooltip(
              message: 'Download',
              child: IconButton(
                icon: const Icon(Icons.download),
                onPressed: () {
                  Printing.sharePdf(
                    bytes: _pdfBytes!,
                    filename: "roadmap_report.pdf",
                  );
                },
              ),
            ),
          ],
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text(_error!))
              : PdfPreview(
                build: (format) async => _pdfBytes!,
                allowPrinting: false,
                allowSharing: false,
                canChangePageFormat: false,
                canChangeOrientation: false,
                canDebug: false,
              ),
    );
  }
}
