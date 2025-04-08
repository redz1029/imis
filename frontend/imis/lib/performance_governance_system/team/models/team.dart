import 'package:imis/auditor/models/auditor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'team.g.dart';

@JsonSerializable()
class Team {
  int id;
  String name;
  bool isActive;
  bool isDeleted;

  String? rowVersion;

  Team(this.id, this.name, this.isActive, this.isDeleted, {this.rowVersion});

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
  Map<String, dynamic> toJson() => _$TeamToJson(this);
}
