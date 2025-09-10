import 'package:json_annotation/json_annotation.dart';

part 'auditor_offices.g.dart';

@JsonSerializable()
class AuditorOffices {
  int id;
  int auditorId;
  int officeId;
  int pgsPeriodId;
  bool? isDeleted;
  String? rowVersion;

  AuditorOffices(
    this.id,
    this.auditorId,
    this.officeId,
    this.pgsPeriodId, {
    this.isDeleted,
    this.rowVersion,
  });

  factory AuditorOffices.fromJson(Map<String, dynamic> json) =>
      _$AuditorOfficesFromJson(json);
  Map<String, dynamic> toJson() => _$AuditorOfficesToJson(this);
}
