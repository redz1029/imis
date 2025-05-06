import 'package:json_annotation/json_annotation.dart';

part 'office.g.dart';

@JsonSerializable()
class Office {
  final int id;
  final String name;
  bool isActive;
  bool isDeleted;
  String? rowVersion;

  Office({
    required this.id,
    required this.name,
    this.isActive = true,
    this.isDeleted = false,
    this.rowVersion = "",
  });

  factory Office.fromJson(Map<String, dynamic> json) => _$OfficeFromJson(json);
  Map<String, dynamic> toJson() => _$OfficeToJson(this);
}
