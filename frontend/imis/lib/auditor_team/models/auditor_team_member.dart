import 'package:json_annotation/json_annotation.dart';
part 'auditor_team_member.g.dart';

@JsonSerializable()
class AuditorTeamMember {
  final int id;
  final String name;
  final bool isActive;
  final bool isTeamLeader;
  final bool isOfficeHead;
  final String userId;
  final bool isDeleted;

  const AuditorTeamMember({
    required this.id,
    required this.name,
    required this.isActive,
    required this.isTeamLeader,
    required this.isOfficeHead,
    required this.userId,
    required this.isDeleted,
  });

  factory AuditorTeamMember.fromJson(Map<String, dynamic> json) =>
      _$AuditorTeamMemberFromJson(json);
  Map<String, dynamic> toJson() => _$AuditorTeamMemberToJson(this);
}

@JsonSerializable()
class AuditorTeamDetail {
  final int id;
  final int teamId;
  final bool isActive;
  final bool? isDeleted;
  final String? rowVersion;
  final List<AuditorTeamMember> auditors;

  const AuditorTeamDetail({
    required this.id,
    required this.teamId,
    required this.isActive,
    this.isDeleted,
    this.rowVersion,
    required this.auditors,
  });

  factory AuditorTeamDetail.fromJson(Map<String, dynamic> json) =>
      _$AuditorTeamDetailFromJson(json);
  Map<String, dynamic> toJson() => _$AuditorTeamDetailToJson(this);
}
