import 'package:imis/utils/date_time_converter.dart';

import 'package:json_annotation/json_annotation.dart';

part 'impact_strategic_goal_scorecard_period.g.dart';

@JsonSerializable()
class ImpactStrategicGoalScorecardPeriod {
  int id;
  bool isDeleted;

  @JsonKey()
  @DateTimeConverter()
  DateTime startDate;

  @JsonKey()
  @DateTimeConverter()
  DateTime endDate;

  String? rowVersion;
  String? remarks;
  bool? isActive;

  ImpactStrategicGoalScorecardPeriod(
    this.id,
    this.isDeleted,
    this.startDate,
    this.endDate,
    this.remarks, {
    this.rowVersion,
    this.isActive,
  });

  factory ImpactStrategicGoalScorecardPeriod.fromJson(
    Map<String, dynamic> json,
  ) => _$ImpactStrategicGoalScorecardPeriodFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ImpactStrategicGoalScorecardPeriodToJson(this);
}
