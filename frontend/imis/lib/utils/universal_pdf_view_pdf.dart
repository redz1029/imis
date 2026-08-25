import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

/// Displays PDF bytes across web and native platforms using the
/// `printing` package's PdfPreview widget.
class UniversalPdfView extends StatelessWidget {
  final Uint8List bytes;
  final bool allowPrinting;
  final bool allowSharing;
  final bool canChangeOrientation;
  final bool canChangePageFormat;

  const UniversalPdfView({
    super.key,
    required this.bytes,
    this.allowPrinting = true,
    this.allowSharing = true,
    this.canChangeOrientation = false,
    this.canChangePageFormat = false,
  });

  @override
  Widget build(BuildContext context) {
    return PdfPreview(
      build: (format) async => bytes,
      canChangeOrientation: canChangeOrientation,
      canChangePageFormat: canChangePageFormat,
      allowPrinting: allowPrinting,
      allowSharing: allowSharing,
    );
  }
}
