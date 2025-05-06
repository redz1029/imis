import 'package:json_annotation/json_annotation.dart';
part 'auditable_office.g.dart';

@JsonSerializable()
class AuditableOffice {
  final int? auditScheduleId;
  final int? officeId;

  AuditableOffice({required this.auditScheduleId, required this.officeId});

  factory AuditableOffice.fromJson(Map<String, dynamic> json) =>
      _$AuditableOfficeFromJson(json);

  Map<String, dynamic> toJson() => _$AuditableOfficeToJson(this);
}
