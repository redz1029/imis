// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breakthrough_scoring.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BreakthroughScoring _$BreakthroughScoringFromJson(Map<String, dynamic> json) =>
    BreakthroughScoring(
      (json['id'] as num).toInt(),
      (json['pgsDeliverableId'] as num?)?.toInt(),
      (json['percentAccomplishment'] as num?)?.toInt(),
      (json['target'] as num?)?.toInt(),
      (json['strategic'] as num?)?.toInt(),
      (json['breakThrough'] as num?)?.toInt(),
      (json['finalScore'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$BreakthroughScoringToJson(
  BreakthroughScoring instance,
) => <String, dynamic>{
  'id': instance.id,
  'pgsDeliverableId': instance.pgsDeliverableId,
  'percentAccomplishment': instance.percentAccomplishment,
  'target': instance.target,
  'strategic': instance.strategic,
  'breakThrough': instance.breakThrough,
  'finalScore': instance.finalScore,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
};
