import 'dart:convert';
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
    if (res.statusCode == 404 || res.data == null) return null;
    dynamic data = res.data;
    if (data is String) {
      try { data = jsonDecode(data); } catch (_) { return null; }
    }
    if (data is Map) {
      return AuditSummaryFindings.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  Future<List<AuditSummaryFindings>> getPage(int page, int pageSize) async {
    final res = await _dio.get('$_base/page', queryParameters: {
      'page': page,
      'pageSize': pageSize,
    });
    if (res.statusCode != 200 || res.data == null) return [];
    dynamic data = res.data;
    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.isEmpty || trimmed == 'null') return [];
      try { data = jsonDecode(trimmed); } catch (_) { return []; }
    }
    dynamic items;
    if (data is Map) {
      items = data['items'] ?? data['Items'] ?? data['data'] ?? [];
    } else if (data is List) {
      items = data;
    }
    if (items is! List) return [];
    return items
        .whereType<Map>()
        .map((e) => AuditSummaryFindings.fromJson(Map<String, dynamic>.from(e)))
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