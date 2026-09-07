import 'package:imis/audit_schedules/models/audit_schedules_details.dart';
import 'package:imis/audit_schedules/models/auditable_office.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audit_schedules.g.dart';

@JsonSerializable()
class AuditSchedules {
  int id;
  String auditTitle;

  @JsonKey()
  @DateTimeConverter()
  DateTime startDate;

  @JsonKey()
  @DateTimeConverter()
  DateTime endDate;

  bool isActive;
  bool isDeleted;
  String? rowVersion;

  List<Office>? offices;

  @JsonKey(defaultValue: [])
  final List<AuditableOffice> auditableOffices;

  @JsonKey(defaultValue: [])
  final List<AuditScheduleDetails> auditSchduleDetails;

  AuditSchedules({
    required this.id,
    required this.auditTitle,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.isDeleted,
    this.rowVersion,
    this.offices,
    required this.auditableOffices,
    required this.auditSchduleDetails,
  });

  factory AuditSchedules.fromJson(Map<String, dynamic> json) =>
      _$AuditSchedulesFromJson(json);

  Map<String, dynamic> toJson() => _$AuditSchedulesToJson(this);
}
