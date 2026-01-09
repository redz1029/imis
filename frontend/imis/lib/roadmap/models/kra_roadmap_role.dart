import 'package:json_annotation/json_annotation.dart';

part 'kra_roadmap_role.g.dart';

@JsonSerializable()
class KraRoadmapRole {
  int? id;
  int kraId;
  String roleId;
  String kraName;
  String? rowVersion;
  bool? isDeleted;

  KraRoadmapRole({
    this.id,
    this.rowVersion,
    this.isDeleted,
    required this.kraId,
    required this.roleId,
    required this.kraName,
  });

  factory KraRoadmapRole.fromJson(Map<String, dynamic> json) =>
      _$KraRoadmapRoleFromJson(json);

  Map<String, dynamic> toJson() => _$KraRoadmapRoleToJson(this);
}
