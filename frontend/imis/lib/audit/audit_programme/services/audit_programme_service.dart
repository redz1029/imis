import 'dart:typed_data';
import 'package:dio/dio.dart';

import 'package:imis/office/models/office.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/iso_standard/models/iso_standard.dart';

import 'package:imis/audit/audit_programme/models/audit_programme.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

class AuditProgrammeService {
  final Dio dio;

  List<Office> _offices = [];
  List<Office> get offices => _offices;

  AuditProgrammeService(this.dio);

  // ===========================================================================
  // LOOKUP METHODS (Dropdown Data)
  // ===========================================================================

  /// Fetch all Offices for dropdown options
  Future<List<Office>> getOffices() async {
    final url = ApiEndpoint().office;
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data;
        _offices = list
            .map((e) => Office.fromJson(e as Map<String, dynamic>))
            .toList();
        return _offices;
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch all ISO Standards / Clauses for dropdown options
  Future<List<IsoStandard>> getIsoStandards() async {
    final url = ApiEndpoint().isoStandard;
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data;
        return list
            .map((e) => IsoStandard.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch all Teams for dropdown options
  Future<List<Team>> getTeams() async {
    final url = ApiEndpoint().team;
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data;
        return list
            .map((e) => Team.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // ===========================================================================
  // AUDIT PROGRAMME CRUD METHODS
  // ===========================================================================

  /// Fetch paginated Audit Programmes from `/auditProgramme/page`
  Future<PageList<AuditProgramme>> getAuditProgrammes({
    int page = 1,
    int pageSize = 10,
    String? searchQuery,
  }) async {
    final paginationUtil = PaginationUtil(dio);
    return await paginationUtil.fetchPaginatedData<AuditProgramme>(
      endpoint: '${ApiEndpoint().auditProgramme}/page',
      page: page,
      pageSize: pageSize,
      searchQuery: searchQuery,
      fromJson: (json) => AuditProgramme.fromJson(json),
    );
  }

  /// Get all Audit Programmes without pagination from `/auditProgramme`
  Future<List<AuditProgramme>> getAllAuditProgrammes() async {
    final url = ApiEndpoint().auditProgramme;
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data;
        return list
            .map((e) => AuditProgramme.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Get Audit Programme by ID from `/auditProgramme/{id}`
  Future<AuditProgramme?> getAuditProgrammeById(int id) async {
    final url = '${ApiEndpoint().auditProgramme}/$id';
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (response.statusCode == 200 && response.data != null) {
        return AuditProgramme.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// Save (POST) or Update (PUT) an Audit Programme
  Future<AuditProgramme> addOrUpdateAuditProgramme(
      AuditProgramme programme) async {
    final bool isUpdate = programme.id > 0;
    final url = isUpdate
        ? '${ApiEndpoint().auditProgramme}/${programme.id}'
        : ApiEndpoint().auditProgramme;

    try {
      final Map<String, dynamic> requestData = programme.toJson();

      final response = isUpdate
          ? await AuthenticatedRequest.put(dio, url, data: requestData)
          : await AuthenticatedRequest.post(dio, url, data: requestData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuditProgramme.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception(
          isUpdate
              ? 'Failed to update Audit Programme'
              : 'Failed to create Audit Programme',
        );
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 400) {
        final data = e.response?.data;
        if (data is Map<String, dynamic>) {
          if (data.containsKey('Errors') && data['Errors'] is List) {
            final List errors = data['Errors'];
            throw Exception(errors.join('\n'));
          } else if (data.containsKey('errors') && data['errors'] is Map) {
            final Map errorsMap = data['errors'];
            final List<String> messages = [];
            errorsMap.forEach((_, value) {
              if (value is List) messages.addAll(value.map((e) => e.toString()));
            });
            throw Exception(messages.join('\n'));
          } else if (data.containsKey('message')) {
            throw Exception(data['message'].toString());
          }
        } else if (data is String) {
          throw Exception(data);
        }
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  /// Soft Delete an Audit Programme by ID from `/auditProgramme/{id}`
  Future<bool> deleteAuditProgramme(int id) async {
    final url = '${ApiEndpoint().auditProgramme}/$id';
    try {
      final response = await AuthenticatedRequest.delete(dio, url);
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      rethrow;
    }
  }

  /// Download PDF Report by ID from `/auditProgramme/PdF/{id}`
  Future<Uint8List> getPdfReport(int id) async {
    final url = '${ApiEndpoint().auditProgramme}/PdF/$id';
    try {
      final response = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200 && response.data != null) {
        return Uint8List.fromList(response.data!);
      } else {
        throw Exception('Failed to download PDF report.');
      }
    } catch (e) {
      rethrow;
    }
  }
}