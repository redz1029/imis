import 'package:json_annotation/json_annotation.dart';
part 'auditor.g.dart';

@JsonSerializable()
class Auditor {
  int id;
  bool isDeleted;
  String name;
  bool isActive;
  bool isTeamLeader;
  bool isOfficeHead;

  Auditor(
    this.id,
    this.isDeleted,
    this.name,
    this.isActive,
    this.isTeamLeader,
    this.isOfficeHead,
  );

  factory Auditor.fromJson(Map<String, dynamic> json) =>
      _$AuditorFromJson(json);

  Map<String, dynamic> toJson() => _$AuditorToJson(this);
}
