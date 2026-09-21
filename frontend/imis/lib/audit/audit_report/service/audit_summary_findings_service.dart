import 'package:dio/dio.dart';
import 'package:imis/audit/audit_report/model/audit_summary_findings.dart';

class AuditSummaryFindingsService {
  final Dio _dio;
  // UNCONFIRMED: no AuditSummaryFindingsEndPoints Carter module has been shown.
  // Verify this matches the real route before using.
  static const _base = '/auditsummaryfindings';

  AuditSummaryFindingsService(this._dio);

  Future<AuditSummaryFindings?> getById(int id) async {
    final res = await _dio.get('$_base/$id');
    if (res.statusCode == 404) return null;
    return AuditSummaryFindings.fromJson(res.data);
  }

  Future<List<AuditSummaryFindings>> getPage(int page, int pageSize) async {
    final res = await _dio.get('$_base/page', queryParameters: {
      'page': page,
      'pageSize': pageSize,
    });
    final items = res.data['items'] ?? res.data['Items'] ?? [];
    return (items as List)
        .map((e) => AuditSummaryFindings.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addOrUpdate(AuditSummaryFindings dto) async {
    if (dto.id == 0) {
      await _dio.post(_base, data: dto.toJson());
    } else {
      await _dio.put(_base, data: dto.toJson());
    }
  }

  Future<void> delete(int id) async {
    await _dio.delete('$_base/$id');
  }
}