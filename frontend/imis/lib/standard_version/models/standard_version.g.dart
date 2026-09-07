// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standard_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StandardVersion _$StandardVersionFromJson(Map<String, dynamic> json) =>
    StandardVersion(
      id: (json['id'] as num).toInt(),
      versionName: json['versionName'] as String,
      isoStandards: json['isoStandards'] as List<dynamic>?,
      rowVersion: json['rowVersion'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$StandardVersionToJson(StandardVersion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'versionName': instance.versionName,
      'isoStandards': instance.isoStandards,
      'rowVersion': instance.rowVersion,
      'isDeleted': instance.isDeleted,
      'isActive': instance.isActive,
    };
