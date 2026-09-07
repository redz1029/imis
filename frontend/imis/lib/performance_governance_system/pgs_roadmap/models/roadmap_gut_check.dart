import 'package:json_annotation/json_annotation.dart';

part 'roadmap_gut_check.g.dart';

@JsonSerializable()
class RoadmapGutCheck {
  final int id;
  final bool isDeleted;
  final String? rowVersion;
  final double ownership;
  final double alignment;
  final double contribution;
  final double measurement;
  final double adaptability;
  final double coherence;
  final double commitment;
  final double totalScore;
  RoadmapGutCheck(
    this.id,
    this.isDeleted,
    this.rowVersion,
    this.ownership,
    this.alignment,
    this.contribution,
    this.measurement,
    this.adaptability,
    this.coherence,
    this.commitment,
    this.totalScore,
  );

  factory RoadmapGutCheck.fromJson(Map<String, dynamic> json) =>
      _$RoadmapGutCheckFromJson(json);

  Map<String, dynamic> toJson() => _$RoadmapGutCheckToJson(this);
}
