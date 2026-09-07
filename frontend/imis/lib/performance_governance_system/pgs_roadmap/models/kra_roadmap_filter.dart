import 'package:json_annotation/json_annotation.dart';
part 'kra_roadmap_filter.g.dart';

@JsonSerializable()
class KraRoadmapFilter {
  int? id;
  int kraId;
  int? kraRoadMapId;
  String kraDescription;
  int year;
  String? deliverableDescription;
  bool isDirect;

  KraRoadmapFilter({
    this.id,
    required this.kraId,
    this.kraRoadMapId,
    required this.kraDescription,
    required this.year,
    this.deliverableDescription,
    required this.isDirect,
  });

  factory KraRoadmapFilter.fromJson(Map<String, dynamic> json) =>
      _$KraRoadmapFilterFromJson(json);

  Map<String, dynamic> toJson() => _$KraRoadmapFilterToJson(this);
}
