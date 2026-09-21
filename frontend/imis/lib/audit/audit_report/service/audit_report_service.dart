import 'package:dio/dio.dart';
import 'package:imis/audit/audit_report/model/audit_report.dart';
  
class AuditReportService {
  final Dio _dio;
  static const _base = '/auditreport';

  AuditReportService(this._dio);

  Future<AuditReport?> getById(int id) async {
    final res = await _dio.get('$_base/$id');
    if (res.statusCode == 404) return null;
    return AuditReport.fromJson(res.data);
  }

  Future<List<AuditReport>> getPage(int page, int pageSize) async {
    final res = await _dio.get('$_base/page', queryParameters: {
      'page': page,
      'pageSize': pageSize,
    });
    final items = res.data['items'] ?? res.data['Items'] ?? [];
    return (items as List).map((e) => AuditReport.fromJson(e)).toList();
  }

  Future<void> addOrUpdate(Map<String, dynamic> payload) async {
    final isCreate = (payload['id'] ?? 0) == 0;
    if (isCreate) {
      await _dio.post(_base, data: payload);
    } else {
      await _dio.put(_base, data: payload);
    }
  }
  Future<List<AuditReport>> getAllAuditReports() async {
  // No dedicated "get all" endpoint exists on the backend — reusing the
  // paginated route with a large page size, same limitation the
  // Programme list doesn't have (it has a true getAll endpoint).
  // Replace with a real /auditreport (no id) GET-all route if you add one.
  final res = await _dio.get('$_base/page', queryParameters: {
    'page': 1,
    'pageSize': 9999,
  });
  final items = res.data['items'] ?? res.data['Items'] ?? [];
  return (items as List)
      .map((e) => AuditReport.fromJson(e as Map<String, dynamic>))
      .toList();
}

  Future<void> delete(int id) async {
    await _dio.delete('$_base/$id');
  }

  // ASSUMPTION: no such endpoint confirmed yet — you need a real one on
  // the backend (e.g. GET /auditplanentry) that returns AuditPlanEntry
  // rows with their nested AuditPlanProcesses/IsoAuditors so this picker
  // can show office/team/date per entry. Do not ship this call until
  // that endpoint exists.
  Future<List<Map<String, dynamic>>> getAuditPlanEntries() async {
    final res = await _dio.get('/auditplanentry');
    return List<Map<String, dynamic>>.from(res.data);
  }
}