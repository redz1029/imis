import 'package:json_annotation/json_annotation.dart';

part 'roles.g.dart';

@JsonSerializable()
class Roles {
  String id;
  String name;
  String normalizedName;
  String? concurrencyStamp;

  Roles(this.id, this.name, this.normalizedName, this.concurrencyStamp);

  factory Roles.fromJson(Map<String, dynamic> json) => _$RolesFromJson(json);
  Map<String, dynamic> toJson() => _$RolesToJson(this);
}
