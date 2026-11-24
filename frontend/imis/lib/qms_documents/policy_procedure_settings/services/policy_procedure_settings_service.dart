import 'package:dio/dio.dart';
import 'package:imis/qms_documents/policy_procedure_settings/models/policy_procedure.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class PolicyProcedureService {
  final Dio dio;

  PolicyProcedureService(this.dio);

  Future<PageList<PolicyProcedure>> getPolicyProcedureSetting({
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData(
      endpoint: '${ApiEndpoint().policyAndProcedureSectionNumbering}/page',
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => PolicyProcedure.fromJson(json),
    );
  }

  Future<void> createOrUpdatePolicyProcedureSettings(
    PolicyProcedure policy,
  ) async {
    final url = ApiEndpoint().policyAndProcedureSectionNumbering;
    final Map<String, dynamic> requestData = policy.toJson();
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: requestData,
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to create or update policy and procedure');
    }
  }

  Future<List<PolicyProcedure>> getAllPolicyProcedures() async {
    final response = await AuthenticatedRequest.get(
      dio,
      ApiEndpoint().policyAndProcedureSectionNumbering,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load policy and procedures');
    }
    return (response.data as List)
        .map((e) => PolicyProcedure.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deletePolicyProcedure(String id) async {
    final url = '${ApiEndpoint().policyAndProcedureSectionNumbering}/$id';
    await AuthenticatedRequest.delete(dio, url);
  }
}
