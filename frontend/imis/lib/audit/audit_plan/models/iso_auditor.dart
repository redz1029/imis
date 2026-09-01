import 'package:json_annotation/json_annotation.dart';
import 'package:imis/team/models/team.dart'; // 👈 Check if this path is valid

part 'iso_auditor.g.dart';

@JsonSerializable(explicitToJson: true)
class IsoAuditor {
  final int id;
  final int teamId;
  final Team? team;
  final int? auditorId;
  final int? auditPlanEntryId;

  IsoAuditor({
    required this.id,
    required this.teamId,
    this.team,
    this.auditorId,
    this.auditPlanEntryId,
  });

  factory IsoAuditor.fromJson(Map<String, dynamic> json) =>
      _$IsoAuditorFromJson(json);

  Map<String, dynamic> toJson() => _$IsoAuditorToJson(this);
}