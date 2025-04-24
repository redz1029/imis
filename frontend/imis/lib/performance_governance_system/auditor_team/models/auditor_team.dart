import 'package:imis/auditor/models/auditor.dart';

import 'package:json_annotation/json_annotation.dart';
part 'auditor_team.g.dart';

@JsonSerializable()
class AuditorTeam {
  int teamId;

  @JsonKey()
  List<Auditor> auditors;

  bool isActive;

  AuditorTeam(this.teamId, this.auditors, this.isActive);

  factory AuditorTeam.fromJson(Map<String, dynamic> json) =>
      _$AuditorTeamFromJson(json);
  Map<String, dynamic> toJson() => _$AuditorTeamToJson(this);
}
