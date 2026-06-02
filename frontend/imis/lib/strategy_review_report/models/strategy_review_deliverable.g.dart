// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strategy_review_deliverable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StrategyReviewDeliverableItem _$StrategyReviewDeliverableItemFromJson(
  Map<String, dynamic> json,
) => StrategyReviewDeliverableItem(
  json['startDate'] as String,
  json['endDate'] as String,
  (json['deliverables'] as List<dynamic>)
      .map((e) => StrategyReviewDeliverable.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StrategyReviewDeliverableItemToJson(
  StrategyReviewDeliverableItem instance,
) => <String, dynamic>{
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'deliverables': instance.deliverables,
};

StrategyReviewDeliverable _$StrategyReviewDeliverableFromJson(
  Map<String, dynamic> json,
) => StrategyReviewDeliverable(
  (json['id'] as num).toInt(),
  kraDescription: json['kraDescription'] as String?,
  deliverableDescription: json['deliverableDescription'] as String?,
  year: (json['year'] as num?)?.toInt(),
  isEnabler: json['isEnabler'] as bool?,
  kraRoadMapId: (json['kraRoadMapId'] as num?)?.toInt(),
  isDeleted: json['isDeleted'] as bool?,
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$StrategyReviewDeliverableToJson(
  StrategyReviewDeliverable instance,
) => <String, dynamic>{
  'kraDescription': instance.kraDescription,
  'deliverableDescription': instance.deliverableDescription,
  'year': instance.year,
  'isEnabler': instance.isEnabler,
  'kraRoadMapId': instance.kraRoadMapId,
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
};
