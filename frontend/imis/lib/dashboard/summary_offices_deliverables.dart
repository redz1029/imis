import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/common_services/common_service.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/office/services/office_service.dart';
import 'package:imis/performance_governance_system/pgs_period/models/pgs_period.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/widgets/common/button_filter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:universal_html/html.dart' as html;

class PgsServiceOfficePeriodReportPage extends StatefulWidget {
  const PgsServiceOfficePeriodReportPage({super.key});

  @override
  State<PgsServiceOfficePeriodReportPage> createState() =>
      _PgsServiceOfficePeriodReportPageState();
}

class _PgsServiceOfficePeriodReportPageState
    extends State<PgsServiceOfficePeriodReportPage> {
  final _commonService = CommonService(Dio());
  final _officeService = OfficeService(Dio());
  final _dio = Dio();

  List<Office> _serviceList = [];
  List<Office> _officeList = [];
  List<PgsPeriod> _periodList = [];

  bool _isLoadingServices = false;
  bool _isLoadingOffices = false;
  bool _isLoadingPeriods = false;
  bool _isGenerating = false;

  int? _selectedServiceId;
  int? _selectedOfficeId;
  int? _selectedPeriodId;

  Uint8List? _pdfBytes;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadServices();
    _loadOffices();
    _loadPeriods();
  }

  Future<void> _loadServices() async {
    setState(() => _isLoadingServices = true);
    try {
      final services = await _commonService.fetchService();
      if (mounted) setState(() => _serviceList = services);
    } catch (e) {
      debugPrint('Failed to load services: $e');
    } finally {
      if (mounted) setState(() => _isLoadingServices = false);
    }
  }

  Future<void> _loadOffices() async {
    setState(() => _isLoadingOffices = true);
    try {
      final pageList = await _officeService.getOffice(page: 1, pageSize: 9999);
      if (mounted) setState(() => _officeList = pageList.items);
    } catch (e) {
      debugPrint('Failed to load offices: $e');
    } finally {
      if (mounted) setState(() => _isLoadingOffices = false);
    }
  }

  Future<void> _loadPeriods() async {
    setState(() => _isLoadingPeriods = true);
    try {
      final periods = await _commonService.fetchPeriod();
      if (mounted) setState(() => _periodList = periods);
    } catch (e) {
      debugPrint('Failed to load periods: $e');
    } finally {
      if (mounted) setState(() => _isLoadingPeriods = false);
    }
  }

  String _monthName(int m) =>
      const [
        '',
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ][m];

  String _periodLabel(PgsPeriod p) {
    return '${_monthName(p.startDate.month)} ${p.startDate.year} – '
        '${_monthName(p.endDate.month)} ${p.endDate.year}';
  }

  void _resetFilters() {
    setState(() {
      _selectedServiceId = null;
      _selectedOfficeId = null;
      _selectedPeriodId = null;
      _pdfBytes = null;
      _error = null;
    });
  }

  bool get _hasActiveFilters =>
      _selectedServiceId != null ||
      _selectedOfficeId != null ||
      _selectedPeriodId != null;

  Future<void> _generateReport() async {
    setState(() {
      _isGenerating = true;
      _error = null;
      _pdfBytes = null;
    });

    try {
      final queryParams = <String, dynamic>{};
      if (_selectedPeriodId != null) {
        queryParams['periodId'] = _selectedPeriodId;
      }
      if (_selectedOfficeId != null) {
        queryParams['officeId'] = _selectedOfficeId;
      }
      if (_selectedServiceId != null) {
        queryParams['parentOfficeId'] = _selectedServiceId;
      }

      final response = await AuthenticatedRequest.get(
        _dio,
        ApiEndpoint().serviceOfficePeriodReport,
        queryParameters: queryParams,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'Accept': 'application/pdf'},
        ),
      );

      debugPrint('status: ${response.statusCode}');
      debugPrint('content-type: ${response.headers.value('content-type')}');
      debugPrint('data runtimeType: ${response.data.runtimeType}');
      debugPrint('data length: ${response.data?.length}');

      if (response.statusCode == 200 && response.data != null) {
        final bytes = Uint8List.fromList(response.data);
        if (mounted) {
          setState(() {
            _pdfBytes = bytes;
          });
        }
      } else {
        if (mounted) {
          setState(() => _error = 'Failed to generate report.');
        }
      }
    } catch (e) {
      debugPrint('Error generating PGS service/office/period report: $e');
      if (mounted) {
        setState(() => _error = 'Failed to generate report. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<void> _downloadReport() async {
    if (_pdfBytes == null) return;

    final fileName =
        'pgs_report_'
        '${_selectedServiceId ?? 'all'}_'
        '${_selectedOfficeId ?? 'all'}_'
        '${_selectedPeriodId ?? 'all'}.pdf';

    try {
      if (kIsWeb) {
        final blob = html.Blob([_pdfBytes!], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..setAttribute('download', fileName)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else if (Platform.isAndroid || Platform.isIOS) {
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/$fileName';
        await File(filePath).writeAsBytes(_pdfBytes!);
        final result = await OpenFile.open(filePath);
        if (result.type != ResultType.done) {
          debugPrint('OpenFile error: ${result.message}');
        }
      } else {
        final dir =
            Platform.isWindows
                ? await getDownloadsDirectory()
                : await getApplicationDocumentsDirectory();
        final filePath = '${dir!.path}/$fileName';
        await File(filePath).writeAsBytes(_pdfBytes!);
        final result = await OpenFile.open(filePath);
        if (result.type != ResultType.done) {
          debugPrint('OpenFile error: ${result.message}');
        }
      }
    } catch (e) {
      debugPrint('Error downloading report: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to download report.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterBar(isMobile),
          Expanded(child: _buildPreviewArea(isMobile)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.summarize_outlined,
              color: primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Summary of Offices with PGS Deliverables',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kText,
                  ),
                ),
                Text(
                  'Generate a filtered PGS report by service, office, and period produced deliiverables ',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: kMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(bool isMobile) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEFF2)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: isMobile ? _buildMobileFilters() : _buildDesktopFilters(),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Filter by',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: kMuted,
              ),
            ),
            const Spacer(),
            if (_hasActiveFilters)
              TextButton.icon(
                onPressed: _resetFilters,
                icon: Icon(Icons.refresh, size: 14, color: Colors.red.shade400),
                label: Text(
                  'Clear',
                  style: TextStyle(fontSize: 12, color: Colors.red.shade400),
                ),
              ),
          ],
        ),
        SizedBox(height: 38, child: _servicesDropdown()),
        const SizedBox(height: 8),
        SizedBox(height: 38, child: _officesDropdown()),
        const SizedBox(height: 8),
        SizedBox(height: 38, child: _periodsDropdown()),
        const SizedBox(height: 12),
        Align(alignment: Alignment.centerRight, child: _generateButton()),
      ],
    );
  }

  Widget _buildDesktopFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.tune, size: 14, color: Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(
              'Filter by',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const Spacer(),
            if (_hasActiveFilters)
              TextButton.icon(
                onPressed: _resetFilters,
                icon: Icon(Icons.refresh, size: 13, color: Colors.red.shade400),
                label: Text(
                  'Clear filters',
                  style: TextStyle(fontSize: 11, color: Colors.red.shade400),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(width: 220, child: _servicesDropdown()),
                  SizedBox(width: 220, child: _officesDropdown()),
                  SizedBox(width: 220, child: _periodsDropdown()),
                ],
              ),
            ),
            const SizedBox(width: 10),
            _generateButton(),
          ],
        ),
      ],
    );
  }

  Widget _servicesDropdown() {
    return SearchableDropdown(
      items: ['All Services', ..._serviceList.map((o) => o.name)],
      selectedItem:
          _selectedServiceId == null
              ? 'All Services'
              : (_serviceList
                      .where((o) => o.id == _selectedServiceId)
                      .firstOrNull
                      ?.name ??
                  'All Services'),
      hintText: _isLoadingServices ? 'Loading…' : 'Service',
      searchHint: 'Search services...',
      prefixIcon: Icons.miscellaneous_services,
      onChanged: (value) {
        setState(() {
          if (value == 'All Services') {
            _selectedServiceId = null;
          } else {
            final service = _serviceList.firstWhere(
              (o) => o.name == value,
              orElse: () => Office(id: 0, name: value),
            );
            _selectedServiceId = service.id;
          }
        });
      },
    );
  }

  Widget _officesDropdown() {
    return SearchableDropdown(
      items: ['All Offices', ..._officeList.map((o) => o.name)],
      selectedItem:
          _selectedOfficeId == null
              ? 'All Offices'
              : (_officeList
                      .where((o) => o.id == _selectedOfficeId)
                      .firstOrNull
                      ?.name ??
                  'All Offices'),
      hintText: _isLoadingOffices ? 'Loading…' : 'Office',
      searchHint: 'Search offices...',
      prefixIcon: Icons.business_outlined,
      onChanged: (value) {
        setState(() {
          if (value == 'All Offices') {
            _selectedOfficeId = null;
          } else {
            final office = _officeList.firstWhere(
              (o) => o.name == value,
              orElse: () => Office(id: 0, name: value),
            );
            _selectedOfficeId = office.id;
          }
        });
      },
    );
  }

  Widget _periodsDropdown() {
    return SearchableDropdown(
      items: ['All Periods', ..._periodList.map((p) => _periodLabel(p))],
      selectedItem:
          _selectedPeriodId == null
              ? 'All Periods'
              : (_periodList
                      .where((p) => p.id == _selectedPeriodId)
                      .map(_periodLabel)
                      .firstOrNull ??
                  'All Periods'),
      hintText: _isLoadingPeriods ? 'Loading…' : 'Period',
      searchHint: 'Search period...',
      prefixIcon: Icons.calendar_month_outlined,
      onChanged: (value) {
        setState(() {
          if (value == 'All Periods') {
            _selectedPeriodId = null;
          } else {
            final period = _periodList.firstWhere(
              (p) => _periodLabel(p) == value,
              orElse: () => _periodList.first,
            );
            _selectedPeriodId = period.id;
          }
        });
      },
    );
  }

  Widget _generateButton() {
    return ElevatedButton.icon(
      onPressed: _isGenerating ? null : _generateReport,
      icon:
          _isGenerating
              ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
              : const Icon(Icons.picture_as_pdf_outlined, size: 18),
      label: Text(_isGenerating ? 'Generating…' : 'Generate Report'),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildPreviewArea(bool isMobile) {
    if (_isGenerating) {
      return const Center(
        child: CircularProgressIndicator(color: primaryColor),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: kDanger),
            const SizedBox(height: 12),
            Text(
              _error!,
              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: kDanger),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _generateReport,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: const BorderSide(color: primaryColor),
              ),
            ),
          ],
        ),
      );
    }

    if (_pdfBytes == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.picture_as_pdf_outlined,
                size: 56,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No report generated yet',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Choose your filters above, then tap "Generate Report".',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(isMobile ? 8 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: PdfPreview(
        key: ValueKey(_pdfBytes.hashCode),
        build: (format) async => _pdfBytes!,
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        useActions: true,
        allowSharing: false,
        maxPageWidth: 1000,
        actions: [
          PdfPreviewAction(
            icon: const Icon(Icons.download),
            onPressed: (context, build, pageFormat) async {
              await _downloadReport();
            },
          ),
        ],
      ),
    );
  }
}
