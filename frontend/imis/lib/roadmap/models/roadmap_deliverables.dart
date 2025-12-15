import 'package:json_annotation/json_annotation.dart';

part 'roadmap_deliverables.g.dart';

@JsonSerializable()
class RoadmapDeliverables {
  final int id;
  bool? isDeleted;
  String? rowVersion;
  final String description;
  final int year;

  RoadmapDeliverables({
    required this.id,
    required this.description,
    required this.year,
    this.isDeleted,
    this.rowVersion,
  });

  factory RoadmapDeliverables.fromJson(Map<String, dynamic> json) =>
      _$RoadmapDeliverablesFromJson(json);

  Map<String, dynamic> toJson() => _$RoadmapDeliverablesToJson(this);
}
