import 'package:json_annotation/json_annotation.dart';
part 'isat_roadmap_deliverables.g.dart';

@JsonSerializable()
class IsatRoadmapDeliverables {
  int id;
  String deliverableDescription;
  int year;

  IsatRoadmapDeliverables(this.id, this.deliverableDescription, this.year);

  factory IsatRoadmapDeliverables.fromJson(Map<String, dynamic> json) =>
      _$IsatRoadmapDeliverablesFromJson(json);

  Map<String, dynamic> toJson() => _$IsatRoadmapDeliverablesToJson(this);
}

@JsonSerializable()
class IsatPgsDeliverables {
  int id;
  String deliverableName;

  IsatPgsDeliverables(this.id, this.deliverableName);

  factory IsatPgsDeliverables.fromJson(Map<String, dynamic> json) =>
      _$IsatPgsDeliverablesFromJson(json);

  Map<String, dynamic> toJson() => _$IsatPgsDeliverablesToJson(this);
}
