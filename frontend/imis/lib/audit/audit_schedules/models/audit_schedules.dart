
import 'package:imis/audit/iqa_signatory/model/iqa_signatory.dart';
import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audit_schedules.g.dart';

@JsonSerializable(explicitToJson: true)
class AuditSchedules {
  @JsonKey(defaultValue: 0)
  final int id;

  @JsonKey(defaultValue: '')
  final String purpose;

  @JsonKey(defaultValue: '')
  final String activity;

  @JsonKey(defaultValue: true)
  final bool isActive;

  final String? rowVersion;

  @DateTimeConverter()
  final DateTime startDate;

  @DateTimeConverter()
  final DateTime endDate;

  @JsonKey(defaultValue: 0)
  final int auditPlanId;

  @JsonKey(defaultValue: 0)
  final int auditPlanEntryId;

  final int? teamId;

  final String? statusCode;
  final String? statusName;

  @JsonKey(
    fromJson: _signatoriesFromJson,
    includeToJson: false,
    defaultValue: [],
  )
  final List<IQASignatory> signatories;

  const AuditSchedules({
    this.id = 0,
    this.purpose = '',
    this.activity = '',
    this.isActive = true,
    this.rowVersion,
    required this.startDate,
    required this.endDate,
    this.auditPlanId = 0,
    this.auditPlanEntryId = 0,
    this.teamId,
    this.statusCode,
    this.statusName,
    this.signatories = const [],
  });

  factory AuditSchedules.fromJson(Map<String, dynamic> json) =>
      _$AuditSchedulesFromJson(json);

  Map<String, dynamic> toJson() => _$AuditSchedulesToJson(this);

  String get effectiveStatusName => statusName ?? 'Draft';

  static List<IQASignatory> _signatoriesFromJson(Object? json) =>
      IQASignatory.listFromJson(json);
}