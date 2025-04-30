import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/enum/pgs_status.dart';
import 'package:imis/performance_governance_system/models/performance_governance_system.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/date_time_converter.dart';
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

  @override
  void initState() {
    super.initState();

    fetchPgs(pgsId: 120187);
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
              'isDirect': deliverable.isDirect,
              'deliverableName': deliverable.deliverableName,
              'status': deliverable.status,
              'byWhen': DateTimeConverter().toJson(deliverable.byWhen),
              'percentDeliverables': deliverable.percentDeliverables.toString(),
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
      default:
        return 'Unknown Status';
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo on the left side
          Image.asset('assets/CRMC.png', height: 90),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'COTABATO REGIONAL AND MEDICAL CENTER',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 5),
              Text(
                '2025',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
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
                columns: [
                  DataColumn(label: Container(width: 110)),
                  DataColumn(label: Container(width: 100)),
                  DataColumn(label: Container(width: 100)),
                  DataColumn(label: Container()),
                  DataColumn(label: Container(width: 185)),
                  DataColumn(label: Container(width: 185)),
                ],
                rows: _buildRows(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainHeader() {
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
          _buildMergedHeaderCell('30%', width: 370, height: 70),
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
              isHighlighted: deliverable['isDirect'] == false,
            ),
          ),

          DataCell(
            _buildDataCell(
              (deliverable['isDirect'] == true) ? 'True' : 'False',
              width: 100,
              isHighlighted: deliverable['isDirect'] == true,
            ),
          ),

          DataCell(
            _buildDataCell(deliverable['deliverableName'] ?? '', width: 550),
          ),
          DataCell(_buildDataCell(deliverable['byWhen'] ?? '', width: 185)),

          DataCell(
            _buildDataCell(
              _getStatusText(deliverable['status']), // Get the status text
              width: 185,
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildMergedAlignmentHeader({double width = 200}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0), // 🔹 Block Border
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
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0), // 🔹 Block Border
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
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
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0), // 🔹 Block Border
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
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
      padding: EdgeInsets.all(8),
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
}
