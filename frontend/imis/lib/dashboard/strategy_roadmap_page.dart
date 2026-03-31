import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imis/constant/constant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;

class StrategyRoadmapPage extends StatefulWidget {
  const StrategyRoadmapPage({super.key});

  @override
  State<StrategyRoadmapPage> createState() => _RoadmapState();
}

class _RoadmapState extends State<StrategyRoadmapPage> {
  Future<void> _downloadPdf() async {
    try {
      final data = await rootBundle.load('assets/strategy_map.pdf');
      final bytes = data.buffer.asUint8List();

      if (kIsWeb) {
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor =
            html.AnchorElement(href: url)
              ..setAttribute('download', 'strategy_map.pdf')
              ..click();
        html.Url.revokeObjectUrl(url);
      } else if (Platform.isAndroid) {
        final external = await getExternalStorageDirectory();
        final rootPath = external!.path.split('Android').first;
        final dir = Directory('${rootPath}Download');
        if (!await dir.exists()) await dir.create(recursive: true);
        final file = File('${dir.path}/strategy_map.pdf');
        await file.writeAsBytes(bytes);
      } else if (Platform.isIOS) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/strategy_map.pdf');
        await file.writeAsBytes(bytes);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withValues(alpha: 0.05),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Export Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _downloadPdf,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                      icon: Icon(
                        Icons.download_outlined,
                        size: 18,
                        color: Theme.of(context).cardColor,
                      ),
                      label: Text(
                        "Export as PDF",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Center(
                      child: InteractiveViewer(
                        child: Image.asset(
                          'assets/strat_map.png',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
