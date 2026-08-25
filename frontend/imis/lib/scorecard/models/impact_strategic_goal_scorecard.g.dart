// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'impact_strategic_goal_scorecard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImpactStrategicGoalScoreCard _$ImpactStrategicGoalScoreCardFromJson(
  Map<String, dynamic> json,
) => ImpactStrategicGoalScoreCard(
  (json['id'] as num).toInt(),
  (json['impactStrategicGoalScoreCardPeriodId'] as num).toInt(),
  json['impactStrategicGoalScoreCardPeriod'] == null
      ? null
      : ImpactStrategicGoalScoreCardPeriodInfo.fromJson(
        json['impactStrategicGoalScoreCardPeriod'] as Map<String, dynamic>,
      ),
  (json['impactScoreCard'] as List<dynamic>?)
      ?.map((e) => ImpactScoreCard.fromJson(e as Map<String, dynamic>))
      .toList(),
  (json['impactStrategicScoreCard'] as List<dynamic>?)
      ?.map((e) => ImpactStrategicScoreCard.fromJson(e as Map<String, dynamic>))
      .toList(),
  isDeleted: json['isDeleted'] as bool? ?? false,
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$ImpactStrategicGoalScoreCardToJson(
  ImpactStrategicGoalScoreCard instance,
) => <String, dynamic>{
  'id': instance.id,
  'impactStrategicGoalScoreCardPeriodId':
      instance.impactStrategicGoalScoreCardPeriodId,
  'impactStrategicGoalScoreCardPeriod':
      instance.impactStrategicGoalScoreCardPeriod,
  'impactScoreCard': instance.impactScoreCard,
  'impactStrategicScoreCard': instance.impactStrategicScoreCard,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
};

ImpactStrategicGoalScoreCardPeriodInfo
_$ImpactStrategicGoalScoreCardPeriodInfoFromJson(Map<String, dynamic> json) =>
    ImpactStrategicGoalScoreCardPeriodInfo(
      (json['id'] as num).toInt(),
      const DateTimeConverter().fromJson(json['startDate'] as String),
      const DateTimeConverter().fromJson(json['endDate'] as String),
      json['period'] as String?,
      json['isActive'] as bool?,
      isDeleted: json['isDeleted'] as bool? ?? false,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$ImpactStrategicGoalScoreCardPeriodInfoToJson(
  ImpactStrategicGoalScoreCardPeriodInfo instance,
) => <String, dynamic>{
  'id': instance.id,
  'startDate': const DateTimeConverter().toJson(instance.startDate),
  'endDate': const DateTimeConverter().toJson(instance.endDate),
  'period': instance.period,
  'isActive': instance.isActive,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
};

ImpactScoreCard _$ImpactScoreCardFromJson(Map<String, dynamic> json) =>
    ImpactScoreCard(
      (json['id'] as num).toInt(),
      json['impactDescription'] as String,
      (json['impactStrategicGoalScoreCardId'] as num?)?.toInt(),
      (json['impactScoreCardIndicator'] as List<dynamic>)
          .map(
            (e) => ImpactScoreCardIndicator.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      isDeleted: json['isDeleted'] as bool? ?? false,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$ImpactScoreCardToJson(ImpactScoreCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'impactDescription': instance.impactDescription,
      'impactStrategicGoalScoreCardId': instance.impactStrategicGoalScoreCardId,
      'impactScoreCardIndicator':
          instance.impactScoreCardIndicator.map((e) => e.toJson()).toList(),
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
    };

ImpactScoreCardIndicator _$ImpactScoreCardIndicatorFromJson(
  Map<String, dynamic> json,
) => ImpactScoreCardIndicator(
  (json['id'] as num).toInt(),
  json['indicatorDescription'] as String,
  (json['impactScoreCardId'] as num?)?.toInt(),
  (json['impactScoreCardTarget'] as List<dynamic>)
      .map((e) => ImpactScoreCardTarget.fromJson(e as Map<String, dynamic>))
      .toList(),
  isDeleted: json['isDeleted'] as bool? ?? false,
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$ImpactScoreCardIndicatorToJson(
  ImpactScoreCardIndicator instance,
) => <String, dynamic>{
  'id': instance.id,
  'indicatorDescription': instance.indicatorDescription,
  'impactScoreCardId': instance.impactScoreCardId,
  'impactScoreCardTarget':
      instance.impactScoreCardTarget.map((e) => e.toJson()).toList(),
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
};

ImpactScoreCardTarget _$ImpactScoreCardTargetFromJson(
  Map<String, dynamic> json,
) => ImpactScoreCardTarget(
  (json['id'] as num).toInt(),
  (json['year'] as num).toInt(),
  json['target'] as String?,
  (json['impactScoreCardIndicatorId'] as num?)?.toInt(),
  isDeleted: json['isDeleted'] as bool? ?? false,
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$ImpactScoreCardTargetToJson(
  ImpactScoreCardTarget instance,
) => <String, dynamic>{
  'id': instance.id,
  'year': instance.year,
  'target': instance.target,
  'impactScoreCardIndicatorId': instance.impactScoreCardIndicatorId,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
};

ImpactStrategicScoreCard _$ImpactStrategicScoreCardFromJson(
  Map<String, dynamic> json,
) => ImpactStrategicScoreCard(
  (json['id'] as num).toInt(),
  json['goalDescription'] as String,
  (json['impactStrategicGoalScoreCardId'] as num?)?.toInt(),
  (json['impactStrategicScoreCardMeasure'] as List<dynamic>)
      .map(
        (e) =>
            ImpactStrategicScoreCardMeasure.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  isDeleted: json['isDeleted'] as bool? ?? false,
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$ImpactStrategicScoreCardToJson(
  ImpactStrategicScoreCard instance,
) => <String, dynamic>{
  'id': instance.id,
  'goalDescription': instance.goalDescription,
  'impactStrategicGoalScoreCardId': instance.impactStrategicGoalScoreCardId,
  'impactStrategicScoreCardMeasure':
      instance.impactStrategicScoreCardMeasure.map((e) => e.toJson()).toList(),
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
};

ImpactStrategicScoreCardMeasure _$ImpactStrategicScoreCardMeasureFromJson(
  Map<String, dynamic> json,
) => ImpactStrategicScoreCardMeasure(
  (json['id'] as num).toInt(),
  json['measureDescription'] as String,
  (json['impactStrategicScoreCardId'] as num?)?.toInt(),
  (json['impactStrategicScoreCardTarget'] as List<dynamic>)
      .map(
        (e) =>
            ImpactStrategicScoreCardTarget.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  isDeleted: json['isDeleted'] as bool? ?? false,
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$ImpactStrategicScoreCardMeasureToJson(
  ImpactStrategicScoreCardMeasure instance,
) => <String, dynamic>{
  'id': instance.id,
  'measureDescription': instance.measureDescription,
  'impactStrategicScoreCardId': instance.impactStrategicScoreCardId,
  'impactStrategicScoreCardTarget':
      instance.impactStrategicScoreCardTarget.map((e) => e.toJson()).toList(),
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
};

ImpactStrategicScoreCardTarget _$ImpactStrategicScoreCardTargetFromJson(
  Map<String, dynamic> json,
) => ImpactStrategicScoreCardTarget(
  (json['id'] as num).toInt(),
  (json['year'] as num).toInt(),
  json['target'] as String?,
  (json['impactStrategicScoreCardMeasureId'] as num?)?.toInt(),
  isDeleted: json['isDeleted'] as bool? ?? false,
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$ImpactStrategicScoreCardTargetToJson(
  ImpactStrategicScoreCardTarget instance,
) => <String, dynamic>{
  'id': instance.id,
  'year': instance.year,
  'target': instance.target,
  'impactStrategicScoreCardMeasureId':
      instance.impactStrategicScoreCardMeasureId,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
};
