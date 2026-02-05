// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iso_standard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsoStandard _$IsoStandardFromJson(Map<String, dynamic> json) => IsoStandard(
  id: (json['id'] as num).toInt(),
  versionID: (json['versionID'] as num).toInt(),
  clauseRef: json['clauseRef'] as String,
  description: json['description'] as String,
  rowVersion: json['rowVersion'] as String?,
  version: StandardVersion.fromJson(json['version'] as Map<String, dynamic>),
  isDeleted: json['isDeleted'] as bool? ?? false,
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$IsoStandardToJson(IsoStandard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'versionID': instance.versionID,
      'clauseRef': instance.clauseRef,
      'description': instance.description,
      'rowVersion': instance.rowVersion,
      'version': instance.version,
      'isDeleted': instance.isDeleted,
      'isActive': instance.isActive,
    };
