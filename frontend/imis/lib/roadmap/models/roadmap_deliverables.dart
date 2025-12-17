import 'package:json_annotation/json_annotation.dart';

part 'roadmap_deliverables.g.dart';

@JsonSerializable()
class RoadmapDeliverableItem {
  final int id;
  bool? isDeleted;
  String? rowVersion;
  final String deliverableDescription;
  final int year;
  String? kraDescription;
  bool? isEnabler;

  RoadmapDeliverableItem({
    required this.id,
    required this.deliverableDescription,
    required this.year,
    this.kraDescription,
    this.isEnabler,
    this.isDeleted,
    this.rowVersion,
  });

  factory RoadmapDeliverableItem.fromJson(Map<String, dynamic> json) =>
      _$RoadmapDeliverableItemFromJson(json);

  Map<String, dynamic> toJson() => _$RoadmapDeliverableItemToJson(this);
}

@JsonSerializable()
class DeliverableGroup {
  final int id;
  bool? isDeleted;
  String? rowVersion;
  String? kraDescription;
  List<RoadmapDeliverableItem>? items;

  DeliverableGroup({
    required this.id,
    this.kraDescription,
    this.items,
    this.isDeleted,
    this.rowVersion,
  });

  factory DeliverableGroup.fromJson(Map<String, dynamic> json) =>
      _$DeliverableGroupFromJson(json);

  Map<String, dynamic> toJson() => _$DeliverableGroupToJson(this);
}
