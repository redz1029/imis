import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/performance_governance_system/models/performance_governance_system.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PgsPrintPage extends StatefulWidget {
  const PgsPrintPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PgsPrintPageState createState() => _PgsPrintPageState();
}

class _PgsPrintPageState extends State<PgsPrintPage> {
  List<Map<String, dynamic>> deliverableList = [];
  List<Map<String, dynamic>> filteredList = [];
  Map<int, String> selectedByWhen = {};
  final dio = Dio();

  // Define gap constants
  final SizedBox gap3 = const SizedBox(height: 3);
  final SizedBox gap5 = const SizedBox(height: 5);

  @override
  void initState() {
    super.initState();
    fetchPgs(pgsId: 120204);
  }

  Future<void> fetchPgs({required int? pgsId}) async {
    var url = ApiEndpoint().performancegovernancesystem;

    if (pgsId != null && pgsId != 0) {
      url = "$url/$pgsId";
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        debugPrint("Error: Access token is missing!");
        return;
      }

      var response = await dio.get(
        url,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final pgsList = data is List ? data : [data];

        List<Map<String, Object>> formattedData = [];

        for (var pgsJson in pgsList) {
          PerformanceGovernanceSystem pgs =
              PerformanceGovernanceSystem.fromJson(pgsJson);

          var deliverables = pgs.pgsDeliverables;
          for (var deliverable in deliverables) {
            formattedData.add({
              'kra': deliverable.kra.name,
              'Start Date': DateTimeConverter().toJson(pgs.pgsPeriod.startDate),
              'End Date': DateTimeConverter().toJson(pgs.pgsPeriod.endDate),
              'isDirect': deliverable.isDirect,
              'deliverableName': deliverable.deliverableName,
              'selectPeriod': pgs.pgsPeriod.id.toString(),
              'status': deliverable.status,
              'byWhen': DateTimeConverter().toJson(deliverable.byWhen),
              'percentDeliverables': pgs.percentDeliverables.toString(),
            });
          }
        }

        if (mounted) {
          setState(() {
            deliverableList = formattedData;
            filteredList = List.from(deliverableList);
          });
        }
      } else {
        debugPrint("Unexpected response format: ${response.data.runtimeType}");
      }
    } on DioException catch (e) {
      debugPrint("Dio error: ${e.response?.data ?? e.message}");
    } catch (e) {
      debugPrint("Unexpected error: $e");
    }
  }

  String _getStatusText(PgsStatus status) {
    switch (status) {
      case PgsStatus.notStarted:
        return 'Not Started';
      case PgsStatus.inProgress:
        return 'In Progress';
      case PgsStatus.onTrack:
        return 'On Track';
      case PgsStatus.delayed:
        return 'Delayed';
      case PgsStatus.needsImprovement:
        return 'Needs Improvement';
      case PgsStatus.completed:
        return 'Completed';
      case PgsStatus.exceeded:
        return 'Exceeded';
      case PgsStatus.onHold:
        return 'On Hold';
      case PgsStatus.cancelled:
        return 'Cancelled';
    }
  }

  Widget _buildHeader() {
    String pgsPeriodStartDate =
        deliverableList.isNotEmpty
            ? DateTimeConverter().toJson(
              DateTime.parse(deliverableList[0]['Start Date']),
            )
            : '';
    String pgsPeriodEndDate =
        deliverableList.isNotEmpty
            ? DateTimeConverter().toJson(
              DateTime.parse(deliverableList[0]['End Date']),
            )
            : '';

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/CRMC.png', height: 90),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'COTABATO REGIONAL AND MEDICAL CENTER',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '$pgsPeriodStartDate - $pgsPeriodEndDate',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Governance System'),
        actions: [
          TextButton(
            onPressed: generatePdf,
            child: const Row(
              children: [
                Icon(Icons.print, color: Colors.white),
                SizedBox(width: 4),
                Text('Print', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              _buildHeader(),
              _buildMainHeader(),
              Row(
                children: [
                  _buildHeaderCell('KRA', width: 110, height: 78),
                  _buildMergedAlignmentHeader(width: 200),
                  _buildHeaderCell('Deliverables', width: 550, height: 78),
                  _buildHeaderCell('When', width: 185, height: 78),
                  _buildHeaderCell('Status', width: 185, height: 78),
                ],
              ),
              DataTable(
                columnSpacing: 0,
                headingRowHeight: 0,
                dividerThickness: 0,
                horizontalMargin: 0,
                border: TableBorder.all(width: 0, color: Colors.transparent),
                columns: const [
                  DataColumn(label: SizedBox(width: 110)),
                  DataColumn(label: SizedBox(width: 100)),
                  DataColumn(label: SizedBox(width: 100)),
                  DataColumn(label: SizedBox()),
                  DataColumn(label: SizedBox(width: 185)),
                  DataColumn(label: SizedBox(width: 185)),
                ],
                rows: _buildRows(),
              ),
              gap7,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Submitted by:',
                        style: TextStyle(fontSize: 12),
                      ),
                      gap6,
                      Column(
                        children: [
                          Container(
                            width: 300,
                            height: 1,
                            color: primaryTextColor,
                          ),

                          const SizedBox(height: 8),
                          const Text(
                            'DR. HALIMA O. MOKAMAD-ROMANCAP',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          const Text(
                            'Head Department of Surgery',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 120),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Noted by:', style: TextStyle(fontSize: 12)),
                      gap6,
                      Column(
                        children: [
                          Container(
                            width: 300,
                            height: 1,
                            color: primaryTextColor,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'DR. JOHN MALIGA',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Chief of Medical Professional Staff II',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 120),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Approved by:',
                        style: TextStyle(fontSize: 12),
                      ),
                      gap6,
                      Column(
                        children: [
                          Container(
                            width: 300,
                            height: 1,
                            color: primaryTextColor,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'DR. ISHMAEL R. DIMAREN',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Medical Center Chief II',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainHeader() {
    String percentDeliverables =
        deliverableList.isNotEmpty
            ? deliverableList[0]['percentDeliverables'] ?? ''
            : '';
    String formattedPercent =
        percentDeliverables.isNotEmpty ? '$percentDeliverables%' : '';

    return Container(
      decoration: BoxDecoration(
        color: primaryLightColor,
        border: Border.all(color: Colors.black, width: 0),
      ),
      child: Row(
        children: [
          _buildMergedHeaderCell('Surgery', width: 310, height: 70),
          _buildMergedHeaderCell(
            'Strategic Contribution',
            width: 550,
            height: 70,
          ),
          _buildMergedHeaderCell(formattedPercent, width: 370, height: 70),
        ],
      ),
    );
  }

  List<DataRow> _buildRows() {
    return deliverableList.map((deliverable) {
      return DataRow(
        cells: [
          DataCell(_buildDataCell(deliverable['kra'] ?? '', width: 110)),
          DataCell(
            _buildDataCell(
              (deliverable['isDirect'] == true) ? 'True' : 'False',
              width: 100,
              isHighlighted: deliverable['isDirect'] == true,
            ),
          ),
          DataCell(
            _buildDataCell(
              (deliverable['isDirect'] == true) ? 'True' : 'False',
              width: 100,
              isHighlighted: deliverable['isDirect'] == false,
            ),
          ),
          DataCell(
            _buildDataCell(deliverable['deliverableName'] ?? '', width: 550),
          ),
          DataCell(_buildDataCell(deliverable['byWhen'] ?? '', width: 185)),
          DataCell(
            _buildDataCell(_getStatusText(deliverable['status']), width: 185),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildMergedAlignmentHeader({double width = 200}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0),
      ),
      child: Column(
        children: [
          _buildMergedHeaderCell('Alignment', width: width),
          Row(
            children: [
              _buildHeaderCell('Direct', width: width / 2, height: 40),
              _buildHeaderCell('Indirect', width: width / 2, height: 40),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMergedHeaderCell(
    String text, {
    double width = 100,
    double height = 40,
  }) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildHeaderCell(
    String text, {
    double width = 100,
    double height = 40,
  }) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDataCell(
    String text, {
    double width = 100,
    bool isHighlighted = false,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isHighlighted ? primaryLightColor : Colors.transparent,
        border: Border.all(color: Colors.black, width: 0.5),
      ),
      child: Center(
        child: Text(
          text == '✔' ? '' : text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color:
                (text == 'False' || text == 'True')
                    ? Colors.transparent
                    : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<Uint8List> _loadLogo() async {
    final ByteData data = await rootBundle.load('assets/CRMC.png');
    return data.buffer.asUint8List();
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    final Uint8List logoBytes = await _loadLogo();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              _buildPdfHeader(logoBytes),
              pw.SizedBox(height: 20),
              _buildPdfTable(),
              _buildPdfSignatures(),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _buildPdfHeader(Uint8List logoBytes) {
    String pgsPeriodStartDate =
        deliverableList.isNotEmpty
            ? DateTimeConverter().toJson(
              DateTime.parse(deliverableList[0]['Start Date']),
            )
            : '';
    String pgsPeriodEndDate =
        deliverableList.isNotEmpty
            ? DateTimeConverter().toJson(
              DateTime.parse(deliverableList[0]['End Date']),
            )
            : '';

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        pw.Image(pw.MemoryImage(logoBytes), height: 70),
        pw.SizedBox(width: 10),
        pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
              "COTABATO REGIONAL AND MEDICAL CENTER",
              style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              "$pgsPeriodStartDate - $pgsPeriodEndDate",
              style: const pw.TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPdfTable() {
    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: const pw.FlexColumnWidth(1.5),
        1: const pw.FlexColumnWidth(0.9),
        2: const pw.FlexColumnWidth(0.9),
        3: const pw.FlexColumnWidth(3),
        4: const pw.FlexColumnWidth(1),
        5: const pw.FlexColumnWidth(1),
      },
      children: [
        // Main Header
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.redAccent100),
          children: [
            _buildPdfHeaderCellWithPadding(
              'Surgery',
              PdfColors.white,
              fontSize: 16,
              padding: const pw.EdgeInsets.all(15),
            ),
            _buildPdfHeaderCellWithPadding(
              '',
              PdfColors.white,
              padding: const pw.EdgeInsets.all(15),
            ),
            _buildPdfHeaderCellWithPadding(
              '',
              PdfColors.white,
              padding: const pw.EdgeInsets.all(15),
            ),
            _buildPdfHeaderCellWithPadding(
              'Strategic Contributions',
              PdfColors.white,
              fontSize: 16,
              padding: const pw.EdgeInsets.all(15),
            ),
            _buildPdfHeaderCellWithPadding(
              deliverableList.isNotEmpty
                  ? '${deliverableList[0]['percentDeliverables']}%'
                  : '',
              PdfColors.white,
              fontSize: 16,
              padding: const pw.EdgeInsets.all(15),
            ),
            _buildPdfHeaderCellWithPadding(
              '',
              PdfColors.white,
              padding: const pw.EdgeInsets.all(15),
            ),
          ],
        ),

        // Sub Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.white),
          children: [
            _buildPdfHeaderCellWithPadding(
              'KRA',
              PdfColors.black,
              padding: pw.EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            ),
            _buildPdfHeaderCellWithPadding(
              'DIRECT',
              PdfColors.black,
              padding: pw.EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            ),
            _buildPdfHeaderCellWithPadding(
              'INDIRECT',
              PdfColors.black,
              padding: pw.EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            ),
            _buildPdfHeaderCellWithPadding(
              'DELIVERABLES',
              PdfColors.black,
              padding: pw.EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            ),
            _buildPdfHeaderCellWithPadding(
              'BY WHEN',
              PdfColors.black,
              padding: pw.EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            ),
            _buildPdfHeaderCellWithPadding(
              'STATUS',
              PdfColors.black,
              padding: pw.EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            ),
          ],
        ),

        // Data Rows
        ...deliverableList.map(
          (deliverable) => _buildPdfDataRow(
            deliverable['kra'] ?? '',
            deliverable['isDirect'] == true ? 'True' : '',
            deliverable['isDirect'] == false ? 'True' : '',
            deliverable['deliverableName'] ?? '',
            deliverable['byWhen'] ?? '',
            _getStatusText(deliverable['status']),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPdfSignatures() {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 30),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildPdfSignatureColumn(
            'Submitted by:',
            'DR. HALIMA O. MOKAMAD-ROMANCAP',
            'Head Department of Surgery',
          ),
          _buildPdfSignatureColumn(
            'Noted by:',
            'DR. JOHN MALIGA',
            'Chief of Medical Professional Staff II',
          ),
          _buildPdfSignatureColumn(
            'Approved by:',
            'DR. ISHMAEL R. DIMAREN',
            'Medical Center Chief II',
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfSignatureColumn(
    String title,
    String name,
    String position,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: const pw.TextStyle(fontSize: 12)),
        pw.SizedBox(height: 3),
        pw.Container(width: 150, height: 1, color: PdfColors.black),
        pw.SizedBox(height: 8),
        pw.Text(name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text(position, style: const pw.TextStyle(fontSize: 12)),
      ],
    );
  }

  pw.Widget _buildPdfHeaderCellWithPadding(
    String text,
    PdfColor color, {
    double fontSize = 12,
    required pw.EdgeInsets padding,
  }) {
    return pw.Container(
      padding: padding,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: pw.FontWeight.bold,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  // pw.TableRow _buildPdfDataRow(
  //   String kra,
  //   String direct,
  //   String indirect,
  //   String deliverables,
  //   String byWhen,
  //   String status,
  // ) {
  //   return pw.TableRow(
  //     children: [
  //       _buildPdfCell(kra, isBold: true),
  //       _buildPdfCell(direct),
  //       _buildPdfCell(indirect),
  //       _buildPdfCell(deliverables),
  //       _buildPdfCell(byWhen),
  //       _buildPdfCell(status),
  //     ],
  //   );
  // }
  pw.TableRow _buildPdfDataRow(
    String kra,
    String direct,
    String indirect,
    String deliverables,
    String byWhen,
    String status,
  ) {
    return pw.TableRow(
      decoration: pw.BoxDecoration(color: PdfColors.white),
      children: [
        _buildPdfCell(kra, isBold: true),
        _buildPdfCell('', hasBackground: direct.isNotEmpty),
        _buildPdfCell('', hasBackground: indirect.isNotEmpty),
        _buildPdfCell(deliverables),
        _buildPdfCell(byWhen),
        _buildPdfCell(status),
      ],
    );
  }

  pw.Widget _buildPdfCell(
    String text, {
    bool isBold = false,
    bool hasBackground = false,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration:
          hasBackground
              ? pw.BoxDecoration(color: PdfColors.redAccent100)
              : null,
      alignment: pw.Alignment.centerLeft,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}
