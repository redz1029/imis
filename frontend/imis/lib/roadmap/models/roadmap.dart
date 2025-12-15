import 'package:imis/performance_governance_system/key_result_area/models/key_result_area.dart';
import 'package:imis/roadmap/kra_period_roadmap/models/kra_roadmap_period.dart';
import 'package:imis/roadmap/models/kpi_roadmap.dart';
import 'package:imis/roadmap/models/roadmap_deliverables.dart';
import 'package:json_annotation/json_annotation.dart';

part 'roadmap.g.dart';

@JsonSerializable()
class Roadmap {
  int? id;
  bool? isDeleted;
  String? rowVersion;
  int? kraId;
  KeyResultArea? kra;
  int? kraRoadMapPeriodId;
  KraRoadmapPeriod? kraRoadMapPeriod;
  String? kraDescription;
  bool? isEnabler;
  List<RoadmapDeliverables>? deliverables;
  List<KpiRoadmap>? kpis;

  Roadmap(
    this.id,
    this.kraId,
    this.kra,
    this.kraRoadMapPeriodId,
    this.kraRoadMapPeriod,
    this.kraDescription,
    this.isEnabler,
    this.deliverables,
    this.kpis, {
    this.rowVersion,
    this.isDeleted,
  });

  factory Roadmap.fromJson(Map<String, dynamic> json) =>
      _$RoadmapFromJson(json);

  Map<String, dynamic> toJson() => _$RoadmapToJson(this);
}
