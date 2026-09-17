// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iso_standard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsoStandard _$IsoStandardFromJson(Map<String, dynamic> json) => IsoStandard(
  id: (json['id'] as num).toInt(),
  versionID: (json['versionID'] as num).toInt(),
  parentID: (json['parentID'] as num?)?.toInt(),
  clauseRef: json['clauseRef'] as String,
  description: json['description'] as String?,
  particulars: json['particulars'] as String,
  isActive: json['isActive'] as bool,
  children:
      (json['children'] as List<dynamic>?)
          ?.map((e) => IsoStandard.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$IsoStandardToJson(IsoStandard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'versionID': instance.versionID,
      'parentID': instance.parentID,
      'clauseRef': instance.clauseRef,
      'description': instance.description,
      'particulars': instance.particulars,
      'isActive': instance.isActive,
      'children': instance.children.map((e) => e.toJson()).toList(),
    };
