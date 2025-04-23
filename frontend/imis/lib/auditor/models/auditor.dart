import 'package:json_annotation/json_annotation.dart';
part 'auditor.g.dart';

@JsonSerializable()
class Auditor {
  int? id;
  bool isDeleted;
  String? rowVersion;
  String? name;
  bool isActive;
  bool isTeamLeader;
  bool isOfficeHead;

  Auditor({
    required this.id,
    this.isDeleted = false,
    this.rowVersion,
    required this.name,
    this.isActive = true,
    this.isTeamLeader = false,
    this.isOfficeHead = false,
  });

  factory Auditor.fromJson(Map<String, dynamic> json) =>
      _$AuditorFromJson(json);

  Map<String, dynamic> toJson() => _$AuditorToJson(this);
}
