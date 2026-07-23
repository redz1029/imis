import 'package:json_annotation/json_annotation.dart';
part 'strategy_review_deliverable.g.dart';

@JsonSerializable()
class StrategyReviewDeliverableItem {
  final String startDate;
  final String endDate;
  final List<StrategyReviewDeliverable> deliverables;

  StrategyReviewDeliverableItem(
    this.startDate,
    this.endDate,
    this.deliverables,
  );

  factory StrategyReviewDeliverableItem.fromJson(Map<String, dynamic> json) =>
      _$StrategyReviewDeliverableItemFromJson(json);

  Map<String, dynamic> toJson() => _$StrategyReviewDeliverableItemToJson(this);
}

@JsonSerializable()
class StrategyReviewDeliverable {
  final String? kraDescription;
  final String? deliverableDescription;
  final int? year;
  final String? keyResultArea;
  final String? deliverable;
  final bool? isEnabler;
  final int? kraRoadMapId;
  final int id;
  final bool? isDeleted;
  final String? rowVersion;

  StrategyReviewDeliverable(
    this.id, {
    this.kraDescription,
    this.deliverableDescription,
    this.year,
    this.keyResultArea,
    this.deliverable,
    this.isEnabler,
    this.kraRoadMapId,
    this.isDeleted,
    this.rowVersion,
  });

  factory StrategyReviewDeliverable.fromJson(Map<String, dynamic> json) =>
      _$StrategyReviewDeliverableFromJson(json);

  Map<String, dynamic> toJson() => _$StrategyReviewDeliverableToJson(this);
}
