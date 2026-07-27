import 'package:dio/dio.dart';
import 'package:imis/standard_version/models/standard_version.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';

class StandardVersionService {
  final Dio dio;

  StandardVersionService(this.dio);

  /// GET /api/StandardVersion/paginate/{page}/{pageSize}
  Future<PageList<StandardVersion>> getStandardVersions({
    int page = 1,
    int pageSize = 10,
  }) async {
    var url = '${ApiEndpoint().standardVersion}/paginate/$page/$pageSize';

    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200) {
        final data = response.data;
        final items = data['items'] as List<dynamic>;
        return PageList<StandardVersion>(
          items.map((json) => StandardVersion.fromJson(json)).toList(),
          data['page'] ?? page,
          data['pageSize'] ?? pageSize,
          data['totalCount'] ?? 0,
          data['hasNextPage'] ?? false,
          data['hasPreviousPage'] ?? false,
        );
      }
    } catch (e) {
      rethrow;
    }
    return PageList<StandardVersion>([], page, pageSize, 0, false, false);
  }

  /// GET /api/StandardVersion/ - Get all versions (no pagination)
  Future<List<StandardVersion>> getAllStandardVersions() async {
    var url = ApiEndpoint().standardVersion;

    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data.map((json) => StandardVersion.fromJson(json)).toList();
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }

  /// GET /api/StandardVersion/filter/{name} - Filter by name
  Future<List<StandardVersion>> filterByName(String name) async {
    var url = '${ApiEndpoint().standardVersion}/filter/$name';

    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data.map((json) => StandardVersion.fromJson(json)).toList();
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }

  /// POST /api/StandardVersion - Create/Update version
  /// Backend uses SaveOrUpdateAsync which handles both create and update
  Future<void> createOrUpdateStandardVersion(
    StandardVersion standardVersion,
  ) async {
    var url = ApiEndpoint().standardVersion;

    try {
      final Map<String, dynamic> requestData = standardVersion.toJson();
      
      // Keep id field (backend DTO requires it), only remove optional fields
      if (standardVersion.id == 0) {
        requestData.remove('rowVersion');
        requestData.remove('isoStandards');
        requestData.remove('isDeleted');
      }
      
      final response = await AuthenticatedRequest.post(dio, url, data: requestData);
      
      // Check response
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to save StandardVersion: ${response.statusCode}');
      }
    } catch (e) {
      print('StandardVersionService.createOrUpdateStandardVersion error: $e');
      rethrow;
    }
  }

  /// DELETE /api/StandardVersion/{id} - Soft delete
  Future<void> deleteStandardVersion(String id) async {
    var url = '${ApiEndpoint().standardVersion}/$id';

    try {
      await AuthenticatedRequest.delete(dio, url);
    } catch (e) {
      rethrow;
    }
  }
}
