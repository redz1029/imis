import 'package:imis/audit/audit_schedules/models/auditable_offices.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'audit_schedule_details.dart';
import 'package:imis/auditor_team/models/auditor_team.dart';

part 'audit_schedules.g.dart';

@JsonSerializable(explicitToJson: true)
class AuditSchedules {
  int id;
  String purpose;
  String auditTitle;

  @DateTimeConverter()
  DateTime startDate;

  @DateTimeConverter()
  DateTime endDate;

  bool isActive;
  bool isDeleted;
  String? rowVersion;

  int auditPlanId;

  AuditorTeam? auditorTeams;
  List<Office>? offices;

  @JsonKey(defaultValue: <AuditableOffices>[])
  final List<AuditableOffices> auditableOffices;

  @JsonKey(defaultValue: <AuditScheduleDetails>[])
  final List<AuditScheduleDetails> auditSchduleDetails;

  AuditSchedules({
    required this.id,
    required this.purpose,
    required this.auditTitle,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.isDeleted,
    this.rowVersion,
    required this.auditPlanId,
    this.auditorTeams,
    this.offices,
    required this.auditableOffices,
    required this.auditSchduleDetails,
  });

  factory AuditSchedules.fromJson(Map<String, dynamic> json) =>
      _$AuditSchedulesFromJson(json);

  Map<String, dynamic> toJson() => _$AuditSchedulesToJson(this);
}