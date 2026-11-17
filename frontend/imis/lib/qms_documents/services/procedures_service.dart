import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:imis/qms_documents/models/procedures.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class ProceduresService {
  final Dio dio;

  ProceduresService(this.dio);

  Future<PageList<Procedures>> getProceduresList({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);

    return await paginationUtil.fetchPaginatedData<Procedures>(
      endpoint: '${ApiEndpoint().policyAndProcedure}/page',
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => Procedures.fromJson(json),
    );
  }

  void _flatten(String prefix, dynamic value, Map<String, dynamic> out) {
    if (value == null) return;
    if (value is Map) {
      value.forEach((k, v) => _flatten('$prefix.$k', v, out));
    } else if (value is List) {
      for (int i = 0; i < value.length; i++) {
        _flatten('$prefix[$i]', value[i], out);
      }
    } else {
      out[prefix] = value;
    }
  }

  Future<Procedures> createOrUpdatePolicy(
    Procedures p, {
    Uint8List? attachmentBytes,
    String? attachmentName,
  }) async {
    final isUpdate = p.id != null && p.id != 0;
    final baseUrl = ApiEndpoint().policyAndProcedure;
    final url = isUpdate ? '$baseUrl/${p.id}' : baseUrl;

    final fields = <String, dynamic>{
      if (isUpdate) 'id': p.id,
      if (p.rowVersion != null && p.rowVersion!.isNotEmpty)
        'rowVersion': p.rowVersion,
      if (p.title != null) 'title': p.title,
      if (p.processOwner != null) 'processOwner': p.processOwner,
      if (p.regulatoryStandard != null)
        'regulatoryStandard': p.regulatoryStandard,
      if (p.effectiveDate != null)
        'effectiveDate': p.effectiveDate!.toUtc().toIso8601String(),
      if (p.sectionId != null) 'sectionId': p.sectionId,
      if (p.documentCode != null) 'documentCode': p.documentCode,
      if (p.revision != null) 'revision': p.revision,
      if (p.content != null) 'content': p.content,
      'isMasterCopy': p.isMasterCopy ?? false,
      'isControlledCopy': p.isControlledCopy ?? false,
      'removeAttachment': p.removeAttachment ?? false,
    };

    final sigs = p.papSignatories ?? const [];
    for (int i = 0; i < sigs.length; i++) {
      _flatten('papSignatories[$i]', sigs[i].toJson(), fields);
    }

    final formData = FormData.fromMap(fields);

    if (attachmentBytes != null) {
      formData.files.add(
        MapEntry(
          'minutesAttachmentPath',
          MultipartFile.fromBytes(
            attachmentBytes,
            filename: attachmentName ?? 'attachment',
          ),
        ),
      );
    }

    try {
      final response =
          isUpdate
              ? await AuthenticatedRequest.put(dio, url, data: formData)
              : await AuthenticatedRequest.post(dio, url, data: formData);

      if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode != 204) {
        throw Exception('Failed to add/update policy.');
      }

      final data = response.data;
      if (data is Map<String, dynamic>) return Procedures.fromJson(data);
      return p;
    } on DioException catch (e) {
      throw Exception(
        'Save failed (${e.response?.statusCode}): ${e.response?.data ?? e.message}',
      );
    }
  }

  Future<void> submit(String userId, Procedures procedure) async {
    final url = '${ApiEndpoint().policyAndProcedure}/submit';

    try {
      final response = await AuthenticatedRequest.put(
        dio,
        url,
        queryParameters: {'userId': userId},
        data: procedure.toJson(),
      );

      final code = response.statusCode ?? 0;
      if (code < 200 || code >= 300) {
        throw Exception('Failed to submit policy. (status $code)');
      }
    } on DioException catch (e) {
      throw Exception(
        'Submit failed (${e.response?.statusCode}): ${e.response?.data ?? e.message}',
      );
    }
  }

  Future<Procedures> getById(int id) async {
    final url = '${ApiEndpoint().policyAndProcedure}/$id';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode != 200) {
        throw Exception('Failed to load procedure.');
      }
      return Procedures.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      throw Exception();
    }
  }

  Future<void> delete(int id) async {
    final url = '${ApiEndpoint().policyAndProcedure}/$id';
    try {
      final response = await AuthenticatedRequest.delete(dio, url);
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete procedure.');
      }
    } on DioException {
      throw Exception();
    }
  }
}
