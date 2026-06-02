import 'package:json_annotation/json_annotation.dart';
part 'kpi_roadmap.g.dart';

@JsonSerializable()
class KpiRoadmap {
  final int id;
  final String? kpiDescription;
  final String? target;
  final String? baseLine;

  KpiRoadmap({
    required this.id,
    this.kpiDescription,
    this.target,
    this.baseLine,
  });

  factory KpiRoadmap.fromJson(Map<String, dynamic> json) =>
      _$KpiRoadmapFromJson(json);

  Map<String, dynamic> toJson() => _$KpiRoadmapToJson(this);
}
