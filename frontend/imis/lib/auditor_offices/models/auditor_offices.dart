import 'package:json_annotation/json_annotation.dart';

part 'auditor_offices.g.dart';

@JsonSerializable()
class AuditorOffices {
  final int id;
  final int auditorId;
  final int officeId;
  final int pgsPeriodId;
  final bool? isOfficeHead;
  final bool? isDeleted;
  final String? rowVersion;

  AuditorOffices({
    required this.id,
    required this.auditorId,
    required this.officeId,
    required this.pgsPeriodId,
    this.isOfficeHead,
    this.isDeleted,
    this.rowVersion,
  });

  factory AuditorOffices.fromJson(Map<String, dynamic> json) =>
      _$AuditorOfficesFromJson(json);
  Map<String, dynamic> toJson() => _$AuditorOfficesToJson(this);
}
