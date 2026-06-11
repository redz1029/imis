import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'strategy_review_period.g.dart';

@JsonSerializable()
class StrategyReviewPeriod {
  int id;

  @JsonKey()
  @DateTimeConverter()
  DateTime startDate;

  @JsonKey()
  @DateTimeConverter()
  DateTime endDate;

  String? quarter;
  bool isDeleted;
  String? rowVersion;

  StrategyReviewPeriod(
    this.id,
    this.startDate,
    this.endDate,
    this.isDeleted, {
    this.rowVersion,
    this.quarter,
  });

  factory StrategyReviewPeriod.fromJson(Map<String, dynamic> json) =>
      _$StrategyReviewPeriodFromJson(json);

  Map<String, dynamic> toJson() => _$StrategyReviewPeriodToJson(this);
}
