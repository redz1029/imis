import 'package:dio/dio.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat_roadmap.dart';
import 'package:imis/performance_governance_system/pgs_isat/models/isat_roadmap_deliverables.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';
import '../../../utils/http_util.dart';
import '../models/isat_employee_info.dart';

class IsatServices {
  final Dio dio;

  IsatServices(this.dio);

  Future<PageList<Isat>> getIsatList({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
    required String userId,
    required String roleId,
    String? officeId,
  }) async {
    final paginationUtil = PaginationUtil(dio);

    return await paginationUtil.fetchPaginatedData(
      endpoint: '${ApiEndpoint().isat}/user/$userId/$roleId',
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      additionalParams: {
        if (officeId != null && officeId.isNotEmpty) 'officeId': officeId,
      },
      fromJson: (json) => Isat.fromJson(json),
    );
  }

  Future<Isat> getIsatbyId(int id) async {
    final url = '${ApiEndpoint().isat}/$id';

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch isat');
    }

    return Isat.fromJson(response.data);
  }

  Future<Map<String, dynamic>> getIsatRawById(int id) async {
    final url = '${ApiEndpoint().isat}/$id';

    final response = await AuthenticatedRequest.get(dio, url);

    if (response.statusCode != 200 || response.data == null) {
      throw Exception('Failed to fetch isat');
    }

    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<IsatEmployeeInfo?> fetchEmployeeInfo({required String userId}) async {
    try {
      final url = '${ApiEndpoint().isat}/employee/$userId';
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data != null) {
        return IsatEmployeeInfo.fromJson(response.data);
      }
      return null;
    } on DioException catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<List<IsatRoadmap>> fetchIsatRoadmap() async {
    try {
      final url = '${ApiEndpoint().isat}/roadmap';
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data != null) {
        final List data = response.data as List;
        return data
            .map((e) => IsatRoadmap.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (_) {
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<List<IsatRoadmapDeliverables>> fetchRoadmapDeliverables({
    required String roadmapId,
    required String year,
  }) async {
    final url = '${ApiEndpoint().isat}/roadmap/$roadmapId/deliverables/$year';
    try {
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data != null) {
        final List data = response.data as List;
        return data
            .map(
              (e) =>
                  IsatRoadmapDeliverables.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      return [];
    } on DioException catch (_) {
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<IsatPgsDeliverables>> fetchPgsDeliverables({
    required String officeId,
    required String periodId,
  }) async {
    final url = '${ApiEndpoint().isat}/pgs-deliverables/$officeId/$periodId';
    try {
      final response = await AuthenticatedRequest.get(dio, url);

      if (response.statusCode == 200 && response.data != null) {
        final List data = response.data as List;
        return data
            .map((e) => IsatPgsDeliverables.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (_) {
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> saveIsat(Isat isat) async {
    try {
      final url = ApiEndpoint().isat;
      final response = await AuthenticatedRequest.post(
        dio,
        url,
        data: isat.toJson(),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateIsat(Isat isat) async {
    try {
      final url = ApiEndpoint().isat;
      final response = await AuthenticatedRequest.put(
        dio,
        url,
        data: isat.toJson(),
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> submitIsat(
    Isat isat,
    String userId, {
    List<Map<String, dynamic>>? signatories,
  }) async {
    try {
      final url = '${ApiEndpoint().isat}/submit/$userId';
      final body = Map<String, dynamic>.from(isat.toJson());
      if (signatories != null) body['isatSignatories'] = signatories;

      final response = await AuthenticatedRequest.post(dio, url, data: body);
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }
}
