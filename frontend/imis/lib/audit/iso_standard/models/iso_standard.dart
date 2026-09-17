import 'package:json_annotation/json_annotation.dart';

part 'iso_standard.g.dart';

@JsonSerializable(explicitToJson: true)
class IsoStandard {
  final int id;
  final int versionID;
  final int? parentID;
  final String clauseRef;
  final String? description;
  final String particulars;
  final bool isActive;

  @JsonKey(defaultValue: <IsoStandard>[])
  final List<IsoStandard> children;

  IsoStandard({
    required this.id,
    required this.versionID,
    this.parentID,
    required this.clauseRef,
    this.description,
    required this.particulars,
    required this.isActive,
    this.children = const <IsoStandard>[],
  });

  factory IsoStandard.fromJson(Map<String, dynamic> json) =>
      _$IsoStandardFromJson(json);

  Map<String, dynamic> toJson() => _$IsoStandardToJson(this);
}