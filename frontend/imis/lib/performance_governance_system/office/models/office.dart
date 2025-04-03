import 'package:json_annotation/json_annotation.dart';

part 'office.g.dart';

@JsonSerializable()
class Office {
  int id;
  String name;
  bool isActive;
  bool isDeleted;
  String? rowVersion;

  Office(this.id, this.name, this.isActive, this.isDeleted, {this.rowVersion});

  factory Office.fromJson(Map<String, dynamic> json) => _$OfficeFromJson(json);
  Map<String, dynamic> toJson() => _$OfficeToJson(this);
}
