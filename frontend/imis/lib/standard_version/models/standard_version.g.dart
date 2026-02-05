// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standard_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StandardVersion _$StandardVersionFromJson(Map<String, dynamic> json) =>
    StandardVersion(
      id: (json['id'] as num).toInt(),
      versionName: json['versionName'] as String,
      isActive: json['isActive'] as bool,
      rowVersion: json['rowVersion'] as String?,
      isDeleted: json['isDeleted'] as bool?,
    );

Map<String, dynamic> _$StandardVersionToJson(StandardVersion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'versionName': instance.versionName,
      'isActive': instance.isActive,
      'rowVersion': instance.rowVersion,
      'isDeleted': instance.isDeleted,
    };
