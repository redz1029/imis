import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'audit_schedules_details.g.dart';

@JsonSerializable()
class AuditScheduleDetails {
  int id;
  bool isDeleted;
  String rowVersion;
  int auditScheduleId;

  @JsonKey()
  @DateTimeConverter()
  DateTime? startDateTime;

  @JsonKey()
  @DateTimeConverter()
  DateTime? endDateTime;

  int teamId;
  String? teamName;
  int officeId;
  String? officeName;

  AuditScheduleDetails({
    this.id = 0,
    this.isDeleted = false,
    this.rowVersion = "",
    this.auditScheduleId = 0,
    required this.startDateTime,
    required this.endDateTime,
    this.teamId = 0,
    required this.teamName,
    required this.officeId,
    required this.officeName,
  });

  // JSON serialization
  factory AuditScheduleDetails.fromJson(Map<String, dynamic> json) =>
      _$AuditScheduleDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$AuditScheduleDetailsToJson(this);
}
