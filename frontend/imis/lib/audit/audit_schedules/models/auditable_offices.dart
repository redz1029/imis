import 'package:json_annotation/json_annotation.dart';

part 'auditable_offices.g.dart';

@JsonSerializable()
class AuditableOffices {
  final int id;
  final int auditScheduleId;
  final int officeId;
  final bool isDeleted;
  final String? rowVersion;

  AuditableOffices({
    required this.id,
    required this.auditScheduleId,
    required this.officeId,
    required this.isDeleted,
    this.rowVersion,
  });

  factory AuditableOffices.fromJson(Map<String, dynamic> json) =>
      _$AuditableOfficesFromJson(json);

  Map<String, dynamic> toJson() => _$AuditableOfficesToJson(this);
}