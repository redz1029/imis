// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swot_sw_deliverable_service_head.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwotSwDeliverableServiceHead _$SwotSwDeliverableServiceHeadFromJson(
  Map<String, dynamic> json,
) => SwotSwDeliverableServiceHead(
  id: (json['id'] as num?)?.toInt(),
  isDeleted: json['isDeleted'] as bool?,
  rowVersion: json['rowVersion'] as String?,
  swotAnalysisId: (json['swotAnalysisId'] as num?)?.toInt(),
  internalContextId: (json['internalContextId'] as num?)?.toInt(),
  internalContext: json['internalContext'] as String?,
  strength: json['strength'] as String?,
  weaknesses: json['weaknesses'] as String?,
);

Map<String, dynamic> _$SwotSwDeliverableServiceHeadToJson(
  SwotSwDeliverableServiceHead instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'swotAnalysisId': instance.swotAnalysisId,
  'internalContextId': instance.internalContextId,
  'internalContext': instance.internalContext,
  'strength': instance.strength,
  'weaknesses': instance.weaknesses,
};
