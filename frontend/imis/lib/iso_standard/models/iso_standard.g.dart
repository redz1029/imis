// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iso_standard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsoStandard _$IsoStandardFromJson(Map<String, dynamic> json) => IsoStandard(
  id: (json['id'] as num).toInt(),
  parentID: (json['parentID'] as num?)?.toInt(),
  versionID: (json['versionID'] as num).toInt(),
  version: json['version'] == null
      ? null
      : StandardVersion.fromJson(json['version'] as Map<String, dynamic>),
  particulars: json['particulars'] as String,
  clauseRef: json['clauseRef'] as String,
  description: json['description'] as String?,
  rowVersion: json['rowVersion'] as String?,
  isDeleted: json['isDeleted'] as bool? ?? false,
  isActive: json['isActive'] as bool? ?? true,
  children: (json['children'] as List<dynamic>?)
      ?.map((e) => IsoStandard.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$IsoStandardToJson(IsoStandard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentID': instance.parentID,
      'versionID': instance.versionID,
      'version': instance.version,
      'particulars': instance.particulars,
      'clauseRef': instance.clauseRef,
      'description': instance.description,
      'rowVersion': instance.rowVersion,
      'isDeleted': instance.isDeleted,
      'isActive': instance.isActive,
      'children': instance.children,
    };
