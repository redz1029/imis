import 'package:imis/audit_schedules/models/audit_schedules_details.dart';
import 'package:imis/audit_schedules/models/auditable_office.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audit_schedules.g.dart';

@JsonSerializable()
class AuditSchedules {
  int id;
  bool isDeleted;
  String rowVersion;
  String auditTitle;

  @JsonKey()
  @DateTimeConverter()
  DateTime startDate;

  @JsonKey()
  @DateTimeConverter()
  DateTime endDate;

  bool isActive;

  List<Office> offices;
  List<AuditableOffice> auditableOffices;
  List<AuditScheduleDetails> auditSchduleDetails;
  AuditSchedules(
    this.id,
    this.isDeleted,
    this.rowVersion,
    this.auditTitle,
    this.startDate,
    this.endDate,
    this.isActive,
    this.offices,
    this.auditableOffices,
    this.auditSchduleDetails,
  );

  factory AuditSchedules.fromJson(Map<String, dynamic> json) =>
      _$AuditSchedulesFromJson(json);

  Map<String, dynamic> toJson() => _$AuditSchedulesToJson(this);
}
