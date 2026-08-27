import 'package:imis/performance_governance_system/pgs_roadmap_kpi_sequence/models/roadmap_kpi_sequence.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kpi_roadmap.g.dart';

@JsonSerializable(explicitToJson: true)
class KpiRoadmap {
  final int id;
  final bool? isDeleted;
  final String? rowVersion;
  final String? kpiDescription;
  final List<KpiRoadmapItem>? items;

  KpiRoadmap({
    required this.id,
    this.isDeleted,
    this.rowVersion,
    this.kpiDescription,
    this.items,
  });

  factory KpiRoadmap.fromJson(Map<String, dynamic> json) =>
      _$KpiRoadmapFromJson(json);

  Map<String, dynamic> toJson() => _$KpiRoadmapToJson(this);
}

@JsonSerializable()
class KpiRoadmapItem {
  final int id;
  final bool? isDeleted;
  final String? rowVersion;
  final int? kraRoadMapId;
  final String? kpiDescription;
  final String? target;
  final String? baseLine;
  final int? year;
  final RoadmapKpiSequence? kraRoadmapKpiSequence;
  final int? kraRoadmapKpiSequenceId;

  KpiRoadmapItem({
    required this.id,
    this.isDeleted,
    this.rowVersion,
    this.kraRoadMapId,
    this.kpiDescription,
    this.target,
    this.baseLine,
    this.year,
    this.kraRoadmapKpiSequence,
    this.kraRoadmapKpiSequenceId,
  });

  factory KpiRoadmapItem.fromJson(Map<String, dynamic> json) =>
      _$KpiRoadmapItemFromJson(json);

  Map<String, dynamic> toJson() => _$KpiRoadmapItemToJson(this);
}
