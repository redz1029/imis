import 'package:json_annotation/json_annotation.dart';
import 'package:imis/team/models/team.dart'; // 👈 Check if this path is valid

part 'iso_auditor.g.dart';

@JsonSerializable(explicitToJson: true)
class IsoAuditor {
  @JsonKey(defaultValue: 0)
final int id;
@JsonKey(defaultValue: 0)
final int teamId;
final Team? team;
final int? auditorId;
@JsonKey(defaultValue: 0)
final int auditPlanEntryId;

IsoAuditor({
  this.id = 0,
  this.teamId = 0,
  this.team,
  this.auditorId,
  this.auditPlanEntryId = 0,
});

  factory IsoAuditor.fromJson(Map<String, dynamic> json) =>
      _$IsoAuditorFromJson(json);

  Map<String, dynamic> toJson() => _$IsoAuditorToJson(this);
}