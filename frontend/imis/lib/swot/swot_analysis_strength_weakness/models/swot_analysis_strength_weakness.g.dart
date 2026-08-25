// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swot_analysis_strength_weakness.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SwotAnalysisStrengthWeakness _$SwotAnalysisStrengthWeaknessFromJson(
  Map<String, dynamic> json,
) => SwotAnalysisStrengthWeakness(
  (json['id'] as num?)?.toInt(),
  json['internalContext'] as String?,
  rowVersion: json['rowVersion'] as String?,
  isDeleted: json['isDeleted'] as bool?,
);

Map<String, dynamic> _$SwotAnalysisStrengthWeaknessToJson(
  SwotAnalysisStrengthWeakness instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'internalContext': instance.internalContext,
};
