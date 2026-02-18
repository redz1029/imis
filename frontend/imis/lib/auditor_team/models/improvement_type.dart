import 'package:json_annotation/json_annotation.dart';

part 'improvement_type.g.dart';

@JsonSerializable()
class ImprovementType {
  final int id;
  String name;
  bool isActive;
  bool isDeleted;
  String? rowVersion;

  ImprovementType({
    required this.id,
    required this.name,
    this.isActive = true,
    this.isDeleted = false,
    this.rowVersion = "",
  });

  factory ImprovementType.fromJson(Map<String, dynamic> json) =>
      _$ImprovementTypeFromJson(json);
  Map<String, dynamic> toJson() => _$ImprovementTypeToJson(this);
}
