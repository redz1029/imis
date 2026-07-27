import 'package:dio/dio.dart';
import 'package:imis/iso_standard/models/iso_standard.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class IsoStandardService {
  final Dio dio;

  IsoStandardService(this.dio);

  Future<PageList<IsoStandard>> getIsoStandards({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<IsoStandard>(
      endpoint: ApiEndpoint().isoStandard,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => IsoStandard.fromJson(json),
    );
  }

  Future<void> createOrUpdateIsoStandard(IsoStandard isoStandard) async {
    var url = ApiEndpoint().isoStandard;

    try {
      final Map<String, dynamic> requestData = isoStandard.toJson();

      // Remove the nested version object - backend only needs versionID
      requestData.remove('version');

      // Keep id field (backend DTO requires it), only remove optional fields
      if (isoStandard.id == 0) {
        requestData.remove('rowVersion');
      }

      // Backend expects List<IsoStandardDto>
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: [requestData],
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Failed to save ISO Standard.");
      }
    } catch (e) {
      rethrow;
    }
  }

  /// FR-08: Bulk create ISO Standards with atomic transaction
  /// Backend should handle this as a single transaction
  Future<void> bulkCreateIsoStandards(List<IsoStandard> isoStandards) async {
    var url = ApiEndpoint().isoStandard;
    try {
      final List<Map<String, dynamic>> requestData = isoStandards.map((iso) {
        final json = iso.toJson();
        // Remove nested version object - backend only needs versionID
        json.remove('version');
        if (iso.id == 0) {
          json.remove('rowVersion');
        }
        return json;
      }).toList();

      // Backend expects List<IsoStandardDto> directly
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: requestData,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Failed to bulk create ISO Standards.");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteIsoStandard(String id) async {
    var url = '${ApiEndpoint().isoStandard}/$id';

    try {
      final response = await AuthenticatedRequest.delete(dio, url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception("Failed to delete ISO Standard.");
      }
    } catch (e) {
      rethrow;
    }
  }
}
