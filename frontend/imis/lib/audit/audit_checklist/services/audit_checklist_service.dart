import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/audit_checklist.dart';

class AuditChecklistService {
  // TODO: replace with your real base URL / API client wiring.
  final String baseUrl;
  final http.Client _client;

  AuditChecklistService({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  Uri _uri(String path) => Uri.parse('$baseUrl/auditchecklist$path');

  /// Fetches the checklist for an audit plan entry, generating it
  /// server-side from the entry's ISO standards on first request.
  Future<List<AuditChecklist>> getOrGenerateForAuditPlanEntry(
      int auditPlanEntryId) async {
    final response = await _client.get(_uri('/planentry/$auditPlanEntryId'));
    _throwIfError(response);
    final list = jsonDecode(response.body) as List;
    return list
        .map((e) => AuditChecklist.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AuditChecklist?> getById(int id) async {
    final response = await _client.get(_uri('/$id'));
    if (response.statusCode == 404) return null;
    _throwIfError(response);
    return AuditChecklist.fromJson(jsonDecode(response.body));
  }

  Future<AuditChecklist> save(AuditChecklist checklist) async {
    final response = await _client.post(
      _uri('/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(checklist.toJson()),
    );
    _throwIfError(response);
    return AuditChecklist.fromJson(jsonDecode(response.body));
  }

  Future<bool> softDelete(int id) async {
    final response = await _client.delete(_uri('/$id'));
    if (response.statusCode == 404) return false;
    _throwIfError(response);
    return true;
  }

  void _throwIfError(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'AuditChecklistService error ${response.statusCode}: ${response.body}');
    }
  }
}