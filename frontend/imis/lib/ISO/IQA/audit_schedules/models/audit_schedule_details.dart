import 'package:json_annotation/json_annotation.dart';

part 'audit_schedule_details.g.dart';

@JsonSerializable()
class AuditScheduleDetails {
  int id;
  int auditPlanEntryId;
  int auditScheduleId;
  bool isDeleted;
  String? rowVersion;

  AuditScheduleDetails({
    required this.id,
    required this.auditPlanEntryId,
    required this.auditScheduleId,
    required this.isDeleted,
    this.rowVersion,
  });

  factory AuditScheduleDetails.fromJson(Map<String, dynamic> json) =>
      _$AuditScheduleDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$AuditScheduleDetailsToJson(this);
}