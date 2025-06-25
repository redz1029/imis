import 'package:json_annotation/json_annotation.dart';

part 'office_type.g.dart';

@JsonSerializable()
class OfficeType {
  final int id;
  String name;
  bool isActive;
  bool isDeleted;
  String? rowVersion;

  OfficeType({
    required this.id,
    required this.name,
    this.isActive = true,
    this.isDeleted = false,
    this.rowVersion = "",
  });

  factory OfficeType.fromJson(Map<String, dynamic> json) =>
      _$OfficeTypeFromJson(json);
  Map<String, dynamic> toJson() => _$OfficeTypeToJson(this);
}
