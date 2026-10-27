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

  Future<void> createOrUpdatePolicy(
    Procedures p, {
    Uint8List? attachmentBytes,
    String? attachmentName,
  }) async {
    final url = ApiEndpoint().policyAndProcedure;

    final fields = <String, dynamic>{
      if (p.id != null) 'id': p.id,
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

    debugPrint('>>> POST $url fields=${fields.keys.toList()}');
    try {
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: formData,
      );

      debugPrint('>>> RESPONSE ${response.statusCode}');
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to add/update policy.');
      }
    } on DioException catch (e) {
      throw Exception(
        'Save failed (${e.response?.statusCode}): ${e.response?.data ?? e.message}',
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
    } on DioException catch (e) {
      throw Exception(
        'Load failed (${e.response?.statusCode}): ${e.response?.data ?? e.message}',
      );
    }
  }

  Future<void> delete(int id) async {
    final url = '${ApiEndpoint().policyAndProcedure}/$id';
    try {
      final response = await AuthenticatedRequest.delete(dio, url);
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete procedure.');
      }
    } on DioException catch (e) {
      throw Exception(
        'Delete failed (${e.response?.statusCode}): ${e.response?.data ?? e.message}',
      );
    }
  }
}
