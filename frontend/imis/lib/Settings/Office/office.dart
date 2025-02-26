import 'package:json_annotation/json_annotation.dart';

part 'office.g.dart';

@JsonSerializable()
class Office {
  final int id;
  final String name;
  final bool isActive;

  const Office(this.id, this.name, this.isActive); // Ginawang `const`

  factory Office.fromJson(Map<String, dynamic> json) => _$OfficeFromJson(json);
  Map<String, dynamic> toJson() => _$OfficeToJson(this);
}
