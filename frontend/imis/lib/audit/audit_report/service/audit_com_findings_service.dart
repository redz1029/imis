import 'package:dio/dio.dart';
import 'package:imis/audit/audit_report/model/audit_com_findings.dart';
  
class AuditComFindingsService {
  final Dio _dio;
  static const _base = '/auditcomfindings';

  AuditComFindingsService(this._dio);

  Future<AuditComFindings?> getById(int id) async {
    final res = await _dio.get('$_base/$id');
    if (res.statusCode == 404) return null;
    return AuditComFindings.fromJson(res.data);
  }

  Future<List<AuditComFindings>> getPage(int page, int pageSize) async {
    final res = await _dio.get('$_base/page', queryParameters: {
      'page': page,
      'pageSize': pageSize,
    });
    final items = res.data['items'] ?? res.data['Items'] ?? [];
    return (items as List)
        .map((e) => AuditComFindings.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addOrUpdate(AuditComFindings dto) async {
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