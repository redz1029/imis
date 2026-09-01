import 'package:imis/audit/audit_plan/models/audit_plan_entry.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audit_plan.g.dart';

@JsonSerializable(explicitToJson: true)
class AuditPlan {
  int id;
  bool isDeleted;

  @JsonKey(includeIfNull: false)
  String? rowVersion;

  // Set default to 0 instead of nullable int? to match non-nullable C# 'int AuditProgrammeId'
  int auditProgrammeId;

  String planStatus;

  @DateTimeConverter()
  DateTime startDate;

  @DateTimeConverter()
  DateTime endDate;

  List<AuditPlanEntry> entries;

  AuditPlan({
    this.id = 0,
    this.isDeleted = false,
    String? rowVersion,
    this.auditProgrammeId = 0,
    this.planStatus = "Draft",
    DateTime? startDate,
    DateTime? endDate,
    List<AuditPlanEntry>? entries,
  })  : rowVersion = (rowVersion != null && rowVersion.isNotEmpty) ? rowVersion : null,
        startDate = startDate ?? DateTime.now(),
        endDate = endDate ?? DateTime.now(),
        entries = entries ?? [];

  factory AuditPlan.fromJson(Map<String, dynamic> json) =>
      _$AuditPlanFromJson(json);

  Map<String, dynamic> toJson() => _$AuditPlanToJson(this);
}