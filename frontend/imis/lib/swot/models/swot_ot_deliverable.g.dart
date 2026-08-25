// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swot_ot_deliverable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwotOtDeliverable _$SwotOtDeliverableFromJson(Map<String, dynamic> json) =>
    SwotOtDeliverable(
      id: (json['id'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      rowVersion: json['rowVersion'] as String?,
      swotAnalysisId: (json['swotAnalysisId'] as num?)?.toInt(),
      externalContextId: (json['externalContextId'] as num?)?.toInt(),
      externalContext: json['externalContext'] as String?,
      opportunities: json['opportunities'] as String?,
      threats: json['threats'] as String?,
    );

Map<String, dynamic> _$SwotOtDeliverableToJson(SwotOtDeliverable instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
      'swotAnalysisId': instance.swotAnalysisId,
      'externalContextId': instance.externalContextId,
      'externalContext': instance.externalContext,
      'opportunities': instance.opportunities,
      'threats': instance.threats,
    };
