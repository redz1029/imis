import 'package:imis/audit/audit_plan/models/audit_plan_entry.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audit_plan.g.dart';

@JsonSerializable()
class AuditPlan {
  final int id;
  final bool isDeleted;
  final String? rowVersion;
  final int auditProgrammeId;
  final String planStatus;

  @DateTimeConverter()
  final DateTime startDate;

  @DateTimeConverter()
  final DateTime endDate;

  final List<AuditPlanEntry> entries;

  const AuditPlan({
    required this.id,
    required this.isDeleted,
    this.rowVersion,
    required this.auditProgrammeId,
    required this.planStatus,
    required this.startDate,
    required this.endDate,
    required this.entries,
  });

  factory AuditPlan.fromJson(Map<String, dynamic> json) =>
      _$AuditPlanFromJson(json);

  Map<String, dynamic> toJson() => _$AuditPlanToJson(this);
}
