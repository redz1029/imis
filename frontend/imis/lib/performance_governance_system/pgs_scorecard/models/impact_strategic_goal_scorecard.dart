import 'package:imis/utils/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'impact_strategic_goal_scorecard.g.dart';

@JsonSerializable()
class ImpactStrategicGoalScoreCard {
  int id;
  int impactStrategicGoalScoreCardPeriodId;
  ImpactStrategicGoalScoreCardPeriodInfo? impactStrategicGoalScoreCardPeriod;
  List<ImpactScoreCard>? impactScoreCard;
  List<ImpactStrategicScoreCard>? impactStrategicScoreCard;
  final bool? isDeleted;
  final String? rowVersion;

  ImpactStrategicGoalScoreCard(
    this.id,
    this.impactStrategicGoalScoreCardPeriodId,
    this.impactStrategicGoalScoreCardPeriod,
    this.impactScoreCard,
    this.impactStrategicScoreCard, {
    this.isDeleted = false,
    this.rowVersion,
  });

  factory ImpactStrategicGoalScoreCard.fromJson(Map<String, dynamic> json) =>
      _$ImpactStrategicGoalScoreCardFromJson(json);

  Map<String, dynamic> toJson() => _$ImpactStrategicGoalScoreCardToJson(this);
}

@JsonSerializable()
class ImpactStrategicGoalScoreCardPeriodInfo {
  int id;

  @JsonKey()
  @DateTimeConverter()
  DateTime startDate;

  @JsonKey()
  @DateTimeConverter()
  DateTime endDate;

  String? period;
  bool? isActive;
  final bool? isDeleted;
  final String? rowVersion;

  ImpactStrategicGoalScoreCardPeriodInfo(
    this.id,
    this.startDate,
    this.endDate,
    this.period,
    this.isActive, {
    this.isDeleted = false,
    this.rowVersion,
  });

  factory ImpactStrategicGoalScoreCardPeriodInfo.fromJson(
    Map<String, dynamic> json,
  ) => _$ImpactStrategicGoalScoreCardPeriodInfoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ImpactStrategicGoalScoreCardPeriodInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ImpactScoreCard {
  int id;
  String impactDescription;
  int? impactStrategicGoalScoreCardId;
  List<ImpactScoreCardIndicator> impactScoreCardIndicator;
  final bool? isDeleted;
  final String? rowVersion;

  ImpactScoreCard(
    this.id,
    this.impactDescription,
    this.impactStrategicGoalScoreCardId,
    this.impactScoreCardIndicator, {
    this.isDeleted = false,
    this.rowVersion,
  });

  factory ImpactScoreCard.fromJson(Map<String, dynamic> json) =>
      _$ImpactScoreCardFromJson(json);

  Map<String, dynamic> toJson() => _$ImpactScoreCardToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ImpactScoreCardIndicator {
  int id;
  String indicatorDescription;
  int? impactScoreCardId;
  List<ImpactScoreCardTarget> impactScoreCardTarget;
  final bool? isDeleted;
  final String? rowVersion;

  ImpactScoreCardIndicator(
    this.id,
    this.indicatorDescription,
    this.impactScoreCardId,
    this.impactScoreCardTarget, {
    this.isDeleted = false,
    this.rowVersion,
  });

  factory ImpactScoreCardIndicator.fromJson(Map<String, dynamic> json) =>
      _$ImpactScoreCardIndicatorFromJson(json);

  Map<String, dynamic> toJson() => _$ImpactScoreCardIndicatorToJson(this);
}

@JsonSerializable()
class ImpactScoreCardTarget {
  int id;
  int year;
  String? target;
  int? impactScoreCardIndicatorId;
  final bool? isDeleted;
  final String? rowVersion;

  ImpactScoreCardTarget(
    this.id,
    this.year,
    this.target,
    this.impactScoreCardIndicatorId, {
    this.isDeleted = false,
    this.rowVersion,
  });

  factory ImpactScoreCardTarget.fromJson(Map<String, dynamic> json) =>
      _$ImpactScoreCardTargetFromJson(json);

  Map<String, dynamic> toJson() => _$ImpactScoreCardTargetToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ImpactStrategicScoreCard {
  int id;
  String goalDescription;
  int? impactStrategicGoalScoreCardId;
  List<ImpactStrategicScoreCardMeasure> impactStrategicScoreCardMeasure;
  final bool? isDeleted;
  final String? rowVersion;

  ImpactStrategicScoreCard(
    this.id,
    this.goalDescription,
    this.impactStrategicGoalScoreCardId,
    this.impactStrategicScoreCardMeasure, {
    this.isDeleted = false,
    this.rowVersion,
  });

  factory ImpactStrategicScoreCard.fromJson(Map<String, dynamic> json) =>
      _$ImpactStrategicScoreCardFromJson(json);

  Map<String, dynamic> toJson() => _$ImpactStrategicScoreCardToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ImpactStrategicScoreCardMeasure {
  int id;
  String measureDescription;
  int? impactStrategicScoreCardId;
  List<ImpactStrategicScoreCardTarget> impactStrategicScoreCardTarget;
  final bool? isDeleted;
  final String? rowVersion;

  ImpactStrategicScoreCardMeasure(
    this.id,
    this.measureDescription,
    this.impactStrategicScoreCardId,
    this.impactStrategicScoreCardTarget, {
    this.isDeleted = false,
    this.rowVersion,
  });

  factory ImpactStrategicScoreCardMeasure.fromJson(Map<String, dynamic> json) =>
      _$ImpactStrategicScoreCardMeasureFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ImpactStrategicScoreCardMeasureToJson(this);
}

@JsonSerializable()
class ImpactStrategicScoreCardTarget {
  int id;
  int year;
  String? target;
  int? impactStrategicScoreCardMeasureId;
  final bool? isDeleted;
  final String? rowVersion;

  ImpactStrategicScoreCardTarget(
    this.id,
    this.year,
    this.target,
    this.impactStrategicScoreCardMeasureId, {
    this.isDeleted = false,
    this.rowVersion,
  });

  factory ImpactStrategicScoreCardTarget.fromJson(Map<String, dynamic> json) =>
      _$ImpactStrategicScoreCardTargetFromJson(json);

  Map<String, dynamic> toJson() => _$ImpactStrategicScoreCardTargetToJson(this);
}
