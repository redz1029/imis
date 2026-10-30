import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:imis/office/models/office.dart';
import 'package:imis/team/models/team.dart';
import 'package:imis/ISO/IQA/iso_standard/models/iso_standard.dart';

import 'package:imis/ISO/IQA/audit_programme/models/audit_programme.dart';
import 'package:imis/utils/api_endpoint.dart';
import 'package:imis/utils/http_util.dart';
import 'package:imis/utils/page_list.dart';
import 'package:imis/utils/pagination_util.dart';

/// Team -> home-offices map returned by `/auditProgramme/team-office-map`.
/// Lets the form detect self-audits instantly, with no round trip per change.
class TeamOfficeConflictMap {
  /// TeamId -> OfficeIds that at least one of its members belongs to.
  final Map<int, Set<int>> teamOfficeIds;

  /// OfficeId -> office name.
  final Map<int, String> officeNames;

  /// TeamId -> team name.
  final Map<int, String> teamNames;

  TeamOfficeConflictMap({
    required this.teamOfficeIds,
    required this.officeNames,
    required this.teamNames,
  });

  factory TeamOfficeConflictMap.empty() => TeamOfficeConflictMap(
    teamOfficeIds: const {},
    officeNames: const {},
    teamNames: const {},
  );

  factory TeamOfficeConflictMap.fromJson(Map<String, dynamic> json) {
    final rawTeams = json['teamOfficeIds'] ?? json['TeamOfficeIds'] ?? {};
    final rawOffices = json['officeNames'] ?? json['OfficeNames'] ?? {};
    final rawTeamNames = json['teamNames'] ?? json['TeamNames'] ?? {};

    return TeamOfficeConflictMap(
      teamOfficeIds: (rawTeams as Map).map(
        (k, v) => MapEntry(
          int.parse(k.toString()),
          (v as List).map((e) => int.parse(e.toString())).toSet(),
        ),
      ),
      officeNames: (rawOffices as Map).map(
        (k, v) => MapEntry(int.parse(k.toString()), v.toString()),
      ),
      teamNames: (rawTeamNames as Map).map(
        (k, v) => MapEntry(int.parse(k.toString()), v.toString()),
      ),
    );
  }

  /// True when [teamId] has a member whose home office is [officeId].
  bool isSelfAudit({int? teamId, int? officeId}) {
    if (teamId == null || officeId == null) return false;
    return teamOfficeIds[teamId]?.contains(officeId) ?? false;
  }

  String teamName(int teamId) => teamNames[teamId] ?? 'Team $teamId';
  String officeName(int officeId) => officeNames[officeId] ?? 'Office $officeId';

  String conflictMessage({required int teamId, required int officeId}) =>
      'Self-audit detected: Members of ${teamName(teamId)} belong to '
      '${officeName(officeId)}. Please assign a different audit team.';
}

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

  /// Fetch all Teams for dropdown options.
  ///
  /// A user without the "View Team" permission gets a 403, which used to come
  /// back as an empty list and left the form's team dropdown blank with no
  /// explanation. With [strict] that case throws a message the form can show.
  Future<List<Team>> getTeams({bool strict = false}) async {
    final url = ApiEndpoint().team;
    try {
      final response = await AuthenticatedRequest.get(dio, url);
      if (strict &&
          (response.statusCode == 401 || response.statusCode == 403)) {
        throw Exception(
          'You do not have permission to view teams. Ask an administrator to '
          'turn on "View Team" for you in Settings > User Roles.',
        );
      }
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

  /// Team -> home-offices map, used for inline self-audit detection.
  /// One request; the result is cached in memory by the caller.
  Future<TeamOfficeConflictMap> getTeamOfficeConflictMap() async {
    final url = '${ApiEndpoint().auditProgramme}/team-office-map';
    final response = await AuthenticatedRequest.get(dio, url);
    if (response.statusCode == 200 && response.data != null) {
      return TeamOfficeConflictMap.fromJson(
        response.data as Map<String, dynamic>,
      );
    }
    return TeamOfficeConflictMap.empty();
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
      // The timestamp makes every load a fresh request, so a copy the server
      // cached before a save can never be served in place of the saved list.
      final response = await AuthenticatedRequest.get(
        dio,
        url,
        queryParameters: {'_': DateTime.now().millisecondsSinceEpoch},
      );
      if (response.statusCode == 200 && response.data != null) {
        final List list = response.data;
        final programmes = <AuditProgramme>[];
        final parseErrors = <String>[];

        for (final item in list) {
          try {
            programmes.add(
              AuditProgramme.fromJson(item as Map<String, dynamic>),
            );
          } catch (e) {
            parseErrors.add(e.toString());
          }
        }

        if (parseErrors.isNotEmpty) {
          debugPrint(
            'Skipped ${parseErrors.length} audit programme(s) that failed '
            'to parse: ${parseErrors.join(' | ')}',
          );
          // Every item failed — surface the real reason instead of a
          // silently empty list.
          if (programmes.isEmpty) {
            throw Exception(parseErrors.first);
          }
        }

        return programmes;
      }
      throw Exception(
        'Failed to load audit programmes (status ${response.statusCode}).',
      );
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

  /// Extracts the {error} message a (bool Success, string? Error) tuple
  /// endpoint returns on failure, matching this codebase's shared convention.
  String _extractErrorMessage(Response response, String fallback) {
    final data = response.data;
    if (data is Map && data['error'] != null) return data['error'].toString();
    return fallback;
  }

  /// Moves a Draft/Disapproved programme to Pending via
  /// `PUT /auditProgramme/{id}/submit`.
  Future<void> submitAuditProgramme(
    int id, {
    String? userId,
    String? comments,
  }) async {
    final url = '${ApiEndpoint().auditProgramme}/$id/submit';
    final response = await AuthenticatedRequest.put(
      dio,
      url,
      data: {
        if (userId != null) 'userId': userId,
        if (comments != null) 'comments': comments,
      },
    );
    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(response, 'Failed to submit audit programme.'),
      );
    }
  }

  /// Approves, notes, or rejects a Pending programme via
  /// `PUT /auditProgramme/{id}/decide`.
  Future<void> decideAuditProgramme(
    int id, {
    required String approverId,
    String? action,
    bool? approve,
    String? comments,
  }) async {
    final url = '${ApiEndpoint().auditProgramme}/$id/decide';
    final response = await AuthenticatedRequest.put(
      dio,
      url,
      data: {
        'approverId': approverId,
        'action': action ?? ((approve ?? false) ? 'Approve' : 'Reject'),
        'approve': approve ?? (action?.toLowerCase() != 'reject'),
        'comments': comments,
      },
    );
    if (response.statusCode != 200) {
      throw Exception(
        _extractErrorMessage(response, 'Failed to decide on audit programme.'),
      );
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