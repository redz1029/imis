import 'package:json_annotation/json_annotation.dart';
part 'strategy_review_kpi.g.dart';

@JsonSerializable()
class StrategyReviewKpiItem {
  final String startDate;
  final String endDate;
  final List<StrategyReviewKpi> kpiDeliverable;

  StrategyReviewKpiItem(this.startDate, this.endDate, this.kpiDeliverable);

  factory StrategyReviewKpiItem.fromJson(Map<String, dynamic> json) =>
      _$StrategyReviewKpiItemFromJson(json);

  Map<String, dynamic> toJson() => _$StrategyReviewKpiItemToJson(this);
}

@JsonSerializable()
class StrategyReviewKpi {
  final String? kpiDescription;
  final String? target;
  final String? baseLine;
  final int? kraRoadMapId;
  final int id;
  final bool? isDeleted;
  final String? rowVersion;

  StrategyReviewKpi(
    this.id, {
    this.kpiDescription,
    this.target,
    this.baseLine,
    this.kraRoadMapId,
    this.isDeleted,
    this.rowVersion,
  });

  factory StrategyReviewKpi.fromJson(Map<String, dynamic> json) =>
      _$StrategyReviewKpiFromJson(json);

  Map<String, dynamic> toJson() => _$StrategyReviewKpiToJson(this);
}
