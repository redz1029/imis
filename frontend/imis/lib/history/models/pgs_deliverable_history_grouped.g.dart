// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgs_deliverable_history_grouped.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PgsDeliverableHistoryGrouped _$PgsDeliverableHistoryGroupedFromJson(
  Map<String, dynamic> json,
) => PgsDeliverableHistoryGrouped(
  (json['pgsDeliverableId'] as num).toInt(),
  (json['scoreHistory'] as List<dynamic>?)
      ?.map(
        (e) => PgsDeliverableHistoryGrouped.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$PgsDeliverableHistoryGroupedToJson(
  PgsDeliverableHistoryGrouped instance,
) => <String, dynamic>{
  'pgsDeliverableId': instance.pgsDeliverableId,
  'scoreHistory': instance.scoreHistory,
};
