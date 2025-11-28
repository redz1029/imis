import 'package:json_annotation/json_annotation.dart';

part 'roles.g.dart';

@JsonSerializable()
class Roles {
  String id;
  String name;
  String normalizedName;
  String? concurrencyStamp;

  Roles(this.id, this.name, this.normalizedName, this.concurrencyStamp);

  factory Roles.fromJson(Map<String, dynamic> json) {
    return Roles(
      json['id']?.toString() ?? '',
      json['name']?.toString() ?? '',
      json['normalizedName']?.toString() ?? '',
      json['concurrencyStamp']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => _$RolesToJson(this);
}
