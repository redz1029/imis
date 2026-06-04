import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:imis/performance_governance_system/deliverable_status_monitoring/models/pgs_deliverable_accomplishment.dart';
import 'package:imis/performance_governance_system/models/operations_review_protocol.dart';
import 'package:imis/performance_governance_system/models/pgs_deliverables.dart';
import 'package:imis/performance_governance_system/pgs_signatory_template/models/pgs_signatory.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';
import '../../utils/auth_util.dart';
import '../../utils/http_util.dart';
import '../models/performance_governance_system.dart';

class PerformanceGovernanceSystemService {
  final Dio dio;

  PerformanceGovernanceSystemService(this.dio);

  Future<PageList<PerformanceGovernanceSystem>> getPgsList({
    required String userId,
    String? roleId,
    int page = 1,
    int pageSize = 15,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<PerformanceGovernanceSystem>(
      endpoint: "${ApiEndpoint().performancegovernancesystem}/user/$userId",
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      additionalParams: {
        'userId': userId,
        if (roleId != null) 'roleId': roleId,
      },
      fromJson: (json) => PerformanceGovernanceSystem.fromJson(json),
    );
  }

  Future<int?> saveAsDraft(PerformanceGovernanceSystem pgs) async {
    final user = await AuthUtil.fetchLoggedUser();
    if (user == null || user.id == null || user.id!.isEmpty) return 401;

    final url = '${ApiEndpoint().pgsSaveAsDraft}?userId=${user.id}';
    final response = await AuthenticatedRequest.post(
      dio,
      url,
      data: pgs.toJson(),
    );
    return response.statusCode;
  }

  Future<PerformanceGovernanceSystem?> fetchSubmitUserId({
    required String pgsId,
    required String userId,
  }) async {
    try {
      final token = await AuthUtil.getAccessToken();
      if (token == null || token.isEmpty) return null;

      final response = await AuthenticatedRequest.get(
        dio,
        "${ApiEndpoint().fetchPGSUserId}/$userId?pgsId=$pgsId",
      );

      if (response.statusCode == 200) {
        return PerformanceGovernanceSystem.fromJson(response.data);
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error:");
    }
    return null;
  }

  Future<int?> submitPgs({
    required String pgsId,
    required PerformanceGovernanceSystem pgs,
  }) async {
    final user = await AuthUtil.fetchLoggedUser();
    if (user == null) return 401;

    final signatoryResponse = await AuthenticatedRequest.get(
      dio,
      "${ApiEndpoint().fetchPGSUserId}/${user.id}?pgsId=$pgsId",
    );
    if (signatoryResponse.statusCode != 200) {
      return signatoryResponse.statusCode;
    }

    final signatoryData = PerformanceGovernanceSystem.fromJson(
      signatoryResponse.data,
    );

    final updatedJson = pgs.toJson();
    updatedJson['id'] = pgsId;
    updatedJson['pgsSignatories'] =
        signatoryData.pgsSignatories?.map((s) => s.toJson()).toList();

    final url = '${ApiEndpoint().pgsSubmit}?userId=${user.id}';
    final response = await AuthenticatedRequest.put(
      dio,
      url,
      data: updatedJson,
    );
    return response.statusCode;
  }

  Future<void> deletePgs(String pgsId) async {
    final url = '${ApiEndpoint().deletePgs}/$pgsId';
    await AuthenticatedRequest.delete(dio, url);
  }

  Future<Map<String, dynamic>> fetchDeliverablesAndSignatories({
    required String pgsId,
  }) async {
    final url = "${ApiEndpoint().performancegovernancesystem}/$pgsId";
    List<PgsDeliverables> deliverables = [];
    List<PgsSignatory> signatories = [];
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200) {
        final data = response.data;
        final pgsDataList = data is List ? data : [data];
        for (var pgsJson in pgsDataList) {
          final delivs =
              (pgsJson['pgsDeliverables'] as List? ?? [])
                  .map((d) => PgsDeliverables.fromJson(d))
                  .where((d) => d.id != null)
                  .toList();
          deliverables.addAll(delivs);

          final sigsJson = pgsJson['pgsSignatories'];
          if (sigsJson is List) {
            signatories.addAll(sigsJson.map((d) => PgsSignatory.fromJson(d)));
          }
        }
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error");
    }
    return {'deliverables': deliverables, 'signatories': signatories};
  }

  Future<Map<String, dynamic>> fetchFilteredPgsWithCounts({
    required String roleId,
    required int page,
    required int pageSize,
    String? fromDate,
    String? toDate,
    String? officeId,
    String? statusFilter,
  }) async {
    try {
      final String? backendStatus =
          (statusFilter == 'Draft' || statusFilter == 'Disapproved')
              ? statusFilter
              : null;
      final params = <String, dynamic>{
        'Page': '1',
        'PageSize': '500',
        'RoleId': roleId,
        if (fromDate != null) 'FromDate': fromDate,
        if (toDate != null) 'ToDate': toDate,
        if (officeId != null) 'OfficeId': officeId,
        if (backendStatus != null) 'Status': backendStatus,
      };
      final response = await AuthenticatedRequest.get(
        dio,
        ApiEndpoint().performancegovernancesystemFilter,
        queryParameters: params,
      );
      if (response.statusCode == 200) {
        final allItems =
            (response.data['items'] as List)
                .map((item) => PerformanceGovernanceSystem.fromJson(item))
                .toList();

        final counts = computeStatusCounts(allItems);

        final filtered = filterByStatus(allItems, statusFilter ?? 'All');
        final paginated = paginateClientSide(
          filtered,
          page: page,
          pageSize: pageSize,
        );

        return {
          'items': paginated['items'],
          'page': paginated['page'],
          'totalCount': paginated['totalCount'],
          'statusCounts': counts,
        };
      }
    } catch (e) {
      debugPrint('fetchFilteredPgsWithCounts error:');
    }

    return {
      'items': <PerformanceGovernanceSystem>[],
      'page': 1,
      'totalCount': 0,
      'statusCounts': <String, int>{
        'All': 0,
        'Draft': 0,
        'For Approval': 0,
        'Approved': 0,
        'Disapproved': 0,
      },
    };
  }

  Map<String, int> computeStatusCounts(
    List<PerformanceGovernanceSystem> items,
  ) {
    int countDraft = 0;
    int countPending = 0;
    int countApproved = 0;
    int countDisapproved = 0;

    for (final pgs in items) {
      final isDraft = pgs.isDraft ?? false;
      final signatories = pgs.pgsSignatories ?? [];
      final deliverables = pgs.pgsDeliverables ?? [];

      if (deliverables.any((d) => d.isDisapproved == true)) {
        countDisapproved++;
      } else if (isDraft) {
        countDraft++;
      } else {
        final hasNext = signatories.any((s) => s.isNextStatus == true);
        if (hasNext) {
          countPending++;
        } else {
          countApproved++;
        }
      }
    }

    return {
      'All': items.length,
      'Draft': countDraft,
      'For Approval': countPending,
      'Approved': countApproved,
      'Disapproved': countDisapproved,
    };
  }

  List<PerformanceGovernanceSystem> filterByStatus(
    List<PerformanceGovernanceSystem> items,
    String statusFilter,
  ) {
    if (statusFilter == 'All') return items;
    return items.where((pgs) {
      final signatories = pgs.pgsSignatories ?? [];
      final deliverables = pgs.pgsDeliverables ?? [];

      if (deliverables.any((d) => d.isDisapproved == true)) {
        return statusFilter == 'Disapproved';
      }
      if (pgs.isDraft == true) return statusFilter == 'Draft';

      final hasNext = signatories.any((s) => s.isNextStatus == true);
      if (hasNext) return statusFilter == 'For Approval';
      return statusFilter == 'Approved';
    }).toList();
  }

  Map<String, dynamic> paginateClientSide(
    List<PerformanceGovernanceSystem> items, {
    required int page,
    required int pageSize,
  }) {
    final total = items.length;
    final start = ((page - 1) * pageSize).clamp(0, total);
    final end = (start + pageSize).clamp(0, total);
    return {
      'items': items.sublist(start, end),
      'totalCount': total,
      'page': page,
    };
  }

  Future<List<PgsDeliverableAccomplishment>> fetchIdDeliverable({
    required String pgsId,
    required String month,
    required String year,
  }) async {
    try {
      final token = await AuthUtil.getAccessToken();
      if (token == null || token.isEmpty) return [];

      final response = await AuthenticatedRequest.get(
        dio,
        "${ApiEndpoint().pgs}/$pgsId/accomplishments?month=$month&year=$year",
      );

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((e) => PgsDeliverableAccomplishment.fromJson(e))
            .toList();
      }
    } on DioException {
      debugPrint("Dio error");
    } catch (e) {
      debugPrint("Unexpected error");
    }
    return [];
  }

  Future<bool> saveOperationReviewProtocol({
    required OperationsReviewProtocol request,
    Uint8List? minutesBytes,
    String? minutesFileName,
  }) async {
    try {
      final token = await AuthUtil.getAccessToken();
      if (token == null || token.isEmpty) return false;

      final Map<String, dynamic> formMap =
          {}
            ..addAll(request.toJson())
            ..removeWhere((k, v) => v == null);

      if (minutesBytes != null && minutesFileName != null) {
        formMap['minutesAttachmentPath'] = MultipartFile.fromBytes(
          minutesBytes,
          filename: minutesFileName,
        );
      } else if (request.minutesAttachmentPath == '') {
        formMap['removeMinutes'] = true;
      }

      final isUpdate = request.id != 0;

      final response =
          isUpdate
              ? await AuthenticatedRequest.put(
                dio,
                '${ApiEndpoint().operationReviewProtocol}/${request.id}',
                data: FormData.fromMap(formMap),
              )
              : await AuthenticatedRequest.post(
                dio,
                ApiEndpoint().operationReviewProtocol,
                data: FormData.fromMap(formMap),
              );

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException {
      debugPrint('Dio error:');
      return false;
    } catch (e) {
      debugPrint('Unexpected error:');
      return false;
    }
  }

  Future<List<OperationsReviewProtocol>> fetchAllOperationReviewProtocols({
    required String pgsId,
  }) async {
    try {
      final token = await AuthUtil.getAccessToken();
      if (token == null || token.isEmpty) return [];

      final response = await AuthenticatedRequest.get(
        dio,
        "${ApiEndpoint().pgsidlist}?performanceGovernanceSystemId=$pgsId",
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> jsonList = response.data as List<dynamic>;
        return jsonList
            .map((e) => OperationsReviewProtocol.fromJson(e))
            .toList();
      }
    } on DioException {
      debugPrint("Dio error fetchAllProtocols");
    } catch (e) {
      debugPrint("Unexpected error fetchAllProtocols: $e");
    }
    return [];
  }

  Future<OperationsReviewProtocol?> fetchOperationReviewProtocolById({
    required int id,
  }) async {
    try {
      final token = await AuthUtil.getAccessToken();
      if (token == null || token.isEmpty) return null;

      final response = await AuthenticatedRequest.get(
        dio,
        "${ApiEndpoint().operationReviewProtocol}?id=$id",
      );

      if (response.statusCode == 200 && response.data != null) {
        return OperationsReviewProtocol.fromJson(response.data);
      }
    } on DioException {
      debugPrint("Dio error fetchProtocolById");
    } catch (e) {
      debugPrint("Unexpected error fetchProtocolById");
    }
    return null;
  }

  Future<List<PgsDeliverables>> fetchDeliverablesOnly({
    required String pgsId,
  }) async {
    final result = await fetchDeliverablesAndSignatories(pgsId: pgsId);
    return result['deliverables'] as List<PgsDeliverables>;
  }

  Future<void> deleteOperationReviewProtocol(String id) async {
    final url = '${ApiEndpoint.baseUrl}/$id';
    await AuthenticatedRequest.delete(dio, url);
  }
}
