import 'package:dio/dio.dart';
import 'package:imis/audit/audit_report/model/audit_scope.dart';

class AuditScopeService {
  final Dio _dio;
  // UNCONFIRMED: no AuditScopeEndPoints Carter module has been shown.
  // Verify this matches the real route before using.
  static const _base = '/auditscope';

  AuditScopeService(this._dio);

  Future<AuditScope?> getById(int id) async {
    final res = await _dio.get('$_base/$id');
    if (res.statusCode == 404) return null;
    return AuditScope.fromJson(res.data);
  }

  Future<List<AuditScope>> getPage(int page, int pageSize) async {
    final res = await _dio.get('$_base/page', queryParameters: {
      'page': page,
      'pageSize': pageSize,
    });
    final items = res.data['items'] ?? res.data['Items'] ?? [];
    return (items as List)
        .map((e) => AuditScope.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addOrUpdate(AuditScope dto) async {
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