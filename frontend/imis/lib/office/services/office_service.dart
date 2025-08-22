import 'package:dio/dio.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/office/models/office_type.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class OfficeService {
  final Dio dio;

  OfficeService(this.dio);
  Future<PageList<Office>> getOffice({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final pagiinationUtil = PaginationUtil(dio);
    return await pagiinationUtil.fetchPaginatedData<Office>(
      endpoint: ApiEndpoint().office,
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => Office.fromJson(json),
    );
  }

  Future<void> createOrUpdateOffice(Office office) async {
    var url = ApiEndpoint().office;

    try {
      final Map<String, dynamic> requestData = office.toJson();
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: requestData,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Failed to add/update office.");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<OfficeType>> getOfficeType() async {
    var url = ApiEndpoint().officetype;

    try {
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((officeType) => OfficeType.fromJson(officeType))
            .toList();
      } else {
        throw Exception("Failed to fetch office types.");
      }
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Office>> getParentOffice() async {
    final response = await AuthenticatedRequest.get(dio, ApiEndpoint().office);
    return (response.data as List).map((e) => Office.fromJson(e)).toList();
  }

  Future<void> deleteOffice(String officeId) async {
    final url = '${ApiEndpoint().office}/$officeId';
    await AuthenticatedRequest.delete(dio, url);
  }

  String getOfficeTypeName(int id, List<Map<String, dynamic>> officeTypeList) {
    final officeType = officeTypeList.firstWhere(
      (type) => type['id'] == id,
      orElse: () => {'name': 'Unknown'},
    );
    return officeType['name'];
  }

  String getParentOfficeName(
    int? id,
    List<Map<String, dynamic>> parentOfficeList,
  ) {
    if (id == null || id == 0) return 'None';

    final parentOffice = parentOfficeList.firstWhere(
      (office) => office['id'] == id,
      orElse: () => {'name': 'Unknown'},
    );
    return parentOffice['name'];
  }
}
