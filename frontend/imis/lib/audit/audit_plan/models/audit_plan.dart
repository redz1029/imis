import 'package:imis/audit/audit_plan/models/audit_plan_entry.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audit_plan.g.dart';

@JsonSerializable(explicitToJson: true)
class AuditPlan {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: false)
  final bool isDeleted;

  final String? rowVersion;

  @JsonKey(defaultValue: 0)
  final int auditProgrammeId;

  @JsonKey(defaultValue: 'Draft')
  final String planStatus;

  @DateTimeConverter()
  final DateTime startDate;

  @DateTimeConverter()
  final DateTime endDate;

  @JsonKey(fromJson: _entriesFromJson, defaultValue: [])
  final List<AuditPlanEntry> entries;

  const AuditPlan({
    this.id = 0,
    this.isDeleted = false,
    this.rowVersion,
    this.auditProgrammeId = 0,
    this.planStatus = 'Draft',
    required this.startDate,
    required this.endDate,
    this.entries = const [],
  });

  factory AuditPlan.fromJson(Map<String, dynamic> json) =>
      _$AuditPlanFromJson(json);

  get preparer => null;

  Map<String, dynamic> toJson() => _$AuditPlanToJson(this);

  static List<AuditPlanEntry> _entriesFromJson(Object? json) {
    if (json is List) {
      return json.map((e) {
        if (e is AuditPlanEntry) return e;
        if (e is Map<String, dynamic>) return AuditPlanEntry.fromJson(e);
        if (e is Map) return AuditPlanEntry.fromJson(Map<String, dynamic>.from(e));
        return AuditPlanEntry.fromJson(const {});
      }).toList();
    }
    return [];
  }
}