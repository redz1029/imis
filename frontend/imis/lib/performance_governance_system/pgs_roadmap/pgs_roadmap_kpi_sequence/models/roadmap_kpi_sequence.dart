import 'package:json_annotation/json_annotation.dart';

part 'roadmap_kpi_sequence.g.dart';

@JsonSerializable()
class RoadmapKpiSequence {
  int id;
  String sequenceCode;
  bool isDeleted;
  String? rowVersion;

  RoadmapKpiSequence(
    this.id,
    this.sequenceCode,
    this.isDeleted, {
    this.rowVersion,
  });

  factory RoadmapKpiSequence.fromJson(Map<String, dynamic> json) =>
      _$RoadmapKpiSequenceFromJson(json);

  Map<String, dynamic> toJson() => _$RoadmapKpiSequenceToJson(this);
}
