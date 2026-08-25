// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swot_analysis_opportunities_threats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwotAnalysisOpportunitiesThreats _$SwotAnalysisOpportunitiesThreatsFromJson(
  Map<String, dynamic> json,
) => SwotAnalysisOpportunitiesThreats(
  (json['id'] as num?)?.toInt(),
  json['externalContext'] as String?,
  rowVersion: json['rowVersion'] as String?,
  isDeleted: json['isDeleted'] as bool?,
);

Map<String, dynamic> _$SwotAnalysisOpportunitiesThreatsToJson(
  SwotAnalysisOpportunitiesThreats instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'externalContext': instance.externalContext,
};
